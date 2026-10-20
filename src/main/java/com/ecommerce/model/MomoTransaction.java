package com.ecommerce.model;

import com.ecommerce.config.MomoConfig;
import com.ecommerce.dto.CartDTO;
import com.ecommerce.dto.CartItemDTO;
import com.ecommerce.dto.MomoCheckoutRequestDTO;
import com.ecommerce.dto.MomoTransactionDTO;
import com.ecommerce.dto.PaidCheckoutDTO;
import com.ecommerce.dto.PaidCheckoutItemDTO;
import com.ecommerce.dto.ShippingAddressOptionDTO;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.exception.NotFoundException;
import com.ecommerce.exception.UnauthorizedException;
import com.ecommerce.repository.MomoTransactionDB;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.util.MomoUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 1 lần khách thanh toán qua MoMo (Rich Domain Model: Entity + business logic).
 *
 * Luồng (khớp spec "đơn online chỉ tạo sau khi cổng thanh toán xác nhận"):
 * <ol>
 *   <li>{@link #initiate}: chụp snapshot giỏ hàng + địa chỉ, lưu PENDING, gọi MoMo lấy payUrl.</li>
 *   <li>Khách trả tiền trên trang MoMo.</li>
 *   <li>MoMo gọi IPN và/hoặc redirect trình duyệt về → {@link #handleGatewayCallback}
 *       kiểm chữ ký, cập nhật SUCCESS/FAILED (idempotent, có khóa dòng).</li>
 *   <li>Nếu SUCCESS: gọi {@link PaidOrderCreator} (module Order) để tạo đơn CONFIRMED,
 *       rồi ghi bản ghi {@link Payment} (method = MOMO, transactionCode = transId).</li>
 *   <li>Nếu IPN không tới được (chạy localhost), {@link #getResult} tự đối soát bằng query API.</li>
 * </ol>
 */
@Entity
@Table(name = "momo_transactions")
public class MomoTransaction {

    private static final Logger LOG = Logger.getLogger(MomoTransaction.class.getName());
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final SecureRandom RANDOM = new SecureRandom();

    /** Giới hạn số tiền của MoMo cho 1 giao dịch (VND). */
    public static final long MIN_AMOUNT = 1_000L;
    public static final long MAX_AMOUNT = 50_000_000L;

    /** resultCode thành công (9000 = đã authorize, với thanh toán 1 bước coi như thành công). */
    private static final Set<Integer> SUCCESS_CODES = Set.of(0, 9000);
    /** resultCode đang xử lý — chưa có kết quả cuối cùng. */
    private static final Set<Integer> PROCESSING_CODES = Set.of(1000, 7000, 7002);

    private static volatile PaidOrderCreator orderCreator;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    /** orderId gửi sang MoMo (duy nhất). */
    @Column(name = "momo_order_id", nullable = false, unique = true, length = 64)
    private String momoOrderId;

    @Column(name = "request_id", nullable = false, length = 64)
    private String requestId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    @Column(name = "subtotal", nullable = false, precision = 15, scale = 2)
    private BigDecimal subtotal;

    @Column(name = "discount_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal discountAmount = BigDecimal.ZERO;

    @Column(name = "voucher_code", length = 50)
    private String voucherCode;

    /** Snapshot các dòng giỏ hàng tại thời điểm thanh toán (JSON). */
    @Column(name = "items_json", nullable = false, columnDefinition = "TEXT")
    private String itemsJson;

    @Column(name = "shipping_recipient_name", length = 100)
    private String shippingRecipientName;

    @Column(name = "shipping_phone", length = 20)
    private String shippingPhone;

    @Column(name = "shipping_address", length = 255)
    private String shippingAddress;

    @Column(name = "note", length = 255)
    private String note;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private MomoTransactionStatus status = MomoTransactionStatus.PENDING;

    @Column(name = "result_code")
    private Integer resultCode;

    @Column(name = "message", length = 500)
    private String message;

    /** Mã giao dịch phía MoMo (transId). */
    @Column(name = "trans_id", length = 50)
    private String transId;

    @Column(name = "pay_type", length = 30)
    private String payType;

    @Column(name = "pay_url", length = 1000)
    private String payUrl;

    /** id Order được tạo sau khi thanh toán thành công (null nếu chưa tạo). */
    @Column(name = "order_id")
    private Integer orderId;

    /** Lỗi khi tạo Order sau thanh toán (vd hết hàng) → Admin cần hoàn tiền thủ công. */
    @Column(name = "order_error", length = 1000)
    private String orderError;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "paid_at")
    private LocalDateTime paidAt;

    public MomoTransaction() {}

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // ==========================================
    // ĐĂNG KÝ HOOK TẠO ĐƠN (module Order gọi 1 lần)
    // ==========================================

    public static void registerOrderCreator(PaidOrderCreator creator) {
        orderCreator = creator;
    }

    public static boolean hasOrderCreator() {
        return orderCreator != null;
    }

    // ==========================================
    // BUSINESS METHODS
    // ==========================================

    /** Địa chỉ đã lưu của user, phục vụ trang xác nhận thanh toán. */
    public static List<ShippingAddressOptionDTO> getAddressOptions(int userId) {
        validateUserId(userId);
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        try {
            List<ShippingAddressOptionDTO> result = new ArrayList<>();
            for (Address a : MomoTransactionDB.findAddressesOfUser(em, userId)) {
                result.add(ShippingAddressOptionDTO.fromEntity(a));
            }
            return result;
        } finally {
            em.close();
        }
    }

    /**
     * Bắt đầu thanh toán MoMo cho giỏ hàng hiện tại của user.
     *
     * @return payUrl — Controller redirect trình duyệt của khách sang URL này
     */
    public static String initiate(int userId, MomoCheckoutRequestDTO request) {
        validateUserId(userId);
        MomoConfig.get(); // báo lỗi cấu hình sớm, trước khi ghi DB

        // ---- Bước 1: snapshot giỏ hàng + địa chỉ, lưu giao dịch PENDING ----
        MomoTransaction t;
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();

            CartDTO cart = Cart.getForCheckout(em, (long) userId);
            long amount = toVnd(cart.getTotalAmount());
            if (amount < MIN_AMOUNT) {
                throw new BusinessException("MoMo chỉ nhận thanh toán từ " + MIN_AMOUNT + "đ trở lên.");
            }
            if (amount > MAX_AMOUNT) {
                throw new BusinessException("MoMo chỉ nhận thanh toán tối đa " + MAX_AMOUNT + "đ cho 1 giao dịch.");
            }

            t = new MomoTransaction();
            t.momoOrderId = generateMomoOrderId(userId);
            t.requestId = UUID.randomUUID().toString();
            t.user = em.getReference(User.class, userId);
            t.amount = BigDecimal.valueOf(amount);
            t.subtotal = nz(cart.getSubtotal());
            // Voucher chỉ được ghi nhận khi đang hợp lệ (Cart đã tự kiểm và đặt voucherWarning nếu không)
            if (cart.getVoucherCode() != null && cart.getVoucherWarning() == null) {
                t.voucherCode = cart.getVoucherCode();
                t.discountAmount = nz(cart.getDiscountAmount());
            }
            t.itemsJson = writeItems(cart.getItems());
            snapshotShipping(em, t, userId, request);
            t.status = MomoTransactionStatus.PENDING;

            MomoTransactionDB.insert(em, t);
            trans.commit();
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }

        // ---- Bước 2: gọi MoMo (ngoài transaction để không giữ connection DB khi chờ mạng) ----
        String orderInfo = "Thanh toan don hang Fashion Shop " + t.momoOrderId;
        Map<String, Object> response;
        try {
            response = MomoUtil.createPayment(t.momoOrderId, t.requestId, t.amount.longValue(), orderInfo, "");
        } catch (BusinessException e) {
            recordCreateResponse(t.momoOrderId, null, e.getMessage(), null);
            throw e;
        }

        Integer code = toInteger(response.get("resultCode"));
        String msg = response.get("message") != null ? String.valueOf(response.get("message")) : null;
        String payUrl = response.get("payUrl") != null ? String.valueOf(response.get("payUrl")) : null;

        if (code == null || code != 0 || payUrl == null || payUrl.isEmpty()) {
            recordCreateResponse(t.momoOrderId, code, msg, null);
            throw new BusinessException("MoMo không tạo được giao dịch: " + (msg != null ? msg : "không rõ lỗi")
                    + (code != null ? " (mã " + code + ")" : ""));
        }

        recordCreateResponse(t.momoOrderId, null, null, payUrl);
        return payUrl;
    }

    /**
     * Xử lý kết quả MoMo gửi về (IPN hoặc tham số redirect). Kiểm chữ ký trước khi tin.
     * Idempotent: gọi nhiều lần với cùng giao dịch chỉ xử lý 1 lần.
     *
     * @return false nếu chữ ký/partnerCode không hợp lệ (dữ liệu bị giả mạo hoặc sai cấu hình)
     */
    public static boolean handleGatewayCallback(Map<String, String> params) {
        if (!MomoUtil.verifyResultSignature(params)) {
            LOG.warning("[MoMo] Sai chữ ký callback cho orderId=" + params.get("orderId"));
            return false;
        }
        if (!MomoConfig.get().getPartnerCode().equals(params.get("partnerCode"))) {
            LOG.warning("[MoMo] partnerCode không khớp: " + params.get("partnerCode"));
            return false;
        }
        String momoOrderId = params.get("orderId");
        Long amount = toLong(params.get("amount"));
        Integer code = toInteger(params.get("resultCode"));
        if (momoOrderId == null || amount == null || code == null) {
            return false;
        }
        applyResult(momoOrderId, amount, code, params.get("transId"), params.get("payType"), params.get("message"));
        createOrderIfNeeded(momoOrderId);
        return true;
    }

    /**
     * Lấy kết quả giao dịch cho trang "Kết quả thanh toán" (có kiểm tra quyền sở hữu).
     * Nếu vẫn PENDING thì chủ động hỏi MoMo (query API) — cần khi IPN không tới được localhost.
     */
    public static MomoTransactionDTO getResult(int userId, String momoOrderId) {
        validateUserId(userId);
        MomoTransactionDTO dto = loadOwned(userId, momoOrderId);

        if (dto.isPending()) {
            syncWithGateway(momoOrderId);
            createOrderIfNeeded(momoOrderId);
            dto = loadOwned(userId, momoOrderId);
        } else if (dto.isSuccess() && dto.getOrderId() == null && dto.getOrderError() == null && hasOrderCreator()) {
            // Lần trước chưa tạo được đơn (vd module Order chưa đăng ký hook) → thử lại
            createOrderIfNeeded(momoOrderId);
            dto = loadOwned(userId, momoOrderId);
        }
        return dto;
    }

    // ==========================================
    // PRIVATE: cập nhật trạng thái
    // ==========================================

    private static void syncWithGateway(String momoOrderId) {
        Map<String, Object> resp;
        try {
            resp = MomoUtil.queryPayment(momoOrderId);
        } catch (BusinessException e) {
            LOG.log(Level.WARNING, "[MoMo] Không query được giao dịch " + momoOrderId + ": " + e.getMessage());
            return; // giữ PENDING, khách có thể tải lại trang
        }
        if (!MomoConfig.get().getPartnerCode().equals(String.valueOf(resp.get("partnerCode")))
                || !momoOrderId.equals(String.valueOf(resp.get("orderId")))) {
            return;
        }
        Integer code = toInteger(resp.get("resultCode"));
        Long amount = toLong(resp.get("amount"));
        if (code == null || amount == null) {
            return;
        }
        applyResult(momoOrderId, amount, code,
                resp.get("transId") != null ? String.valueOf(resp.get("transId")) : null,
                resp.get("payType") != null ? String.valueOf(resp.get("payType")) : null,
                resp.get("message") != null ? String.valueOf(resp.get("message")) : null);
    }

    /** Ghi kết quả cuối cùng (SUCCESS/FAILED) vào giao dịch, có khóa dòng để tránh xử lý trùng. */
    private static void applyResult(String momoOrderId, long amount, int code, String transId, String payType,
            String message) {
        if (!SUCCESS_CODES.contains(code) && !isFinalFailure(code)) {
            return; // đang xử lý / lỗi tạm thời → chưa đổi trạng thái
        }
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            MomoTransaction t = MomoTransactionDB.findByMomoOrderIdForUpdate(em, momoOrderId);
            if (t == null) {
                LOG.warning("[MoMo] Không tìm thấy giao dịch " + momoOrderId);
                trans.commit();
                return;
            }
            if (t.status != MomoTransactionStatus.PENDING) {
                trans.commit(); // đã xử lý trước đó (IPN và redirect cùng về) → bỏ qua
                return;
            }

            t.resultCode = code;
            t.message = truncate(message, 500);
            t.transId = truncate(transId, 50);
            t.payType = truncate(payType, 30);

            if (amount != t.amount.longValue()) {
                t.status = MomoTransactionStatus.FAILED;
                t.message = truncate("Số tiền MoMo báo về (" + amount + "đ) không khớp số tiền giao dịch ("
                        + t.amount.longValue() + "đ) — cần đối soát/hoàn tiền.", 500);
                LOG.severe("[MoMo] " + momoOrderId + ": " + t.message);
            } else if (SUCCESS_CODES.contains(code)) {
                t.status = MomoTransactionStatus.SUCCESS;
                t.paidAt = LocalDateTime.now();
            } else {
                t.status = MomoTransactionStatus.FAILED;
            }
            MomoTransactionDB.update(em, t);
            trans.commit();
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Sau khi SUCCESS: nhờ module Order tạo đơn, rồi ghi bản ghi Payment.
     * Lỗi tạo đơn KHÔNG làm mất trạng thái SUCCESS — chỉ ghi vào orderError.
     */
    private static void createOrderIfNeeded(String momoOrderId) {
        PaidOrderCreator creator = orderCreator;
        if (creator == null) {
            return;
        }
        String failure = null;
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            MomoTransaction t = MomoTransactionDB.findByMomoOrderIdForUpdate(em, momoOrderId);
            // orderError != null: đã thử và thất bại (vd hết hàng) → không tự thử lại, chờ Admin xử lý
            if (t == null || t.status != MomoTransactionStatus.SUCCESS || t.orderId != null || t.orderError != null) {
                trans.commit();
                return;
            }

            int newOrderId = creator.createPaidOrder(em, t.toPaidCheckout());

            Payment payment = new Payment(newOrderId, PaymentMethod.MOMO);
            payment.setTransactionCode(t.transId);
            payment.setPaidAt(t.paidAt);
            MomoTransactionDB.insertPayment(em, payment);

            t.orderId = newOrderId;
            t.orderError = null;
            MomoTransactionDB.update(em, t);
            trans.commit();
        } catch (RuntimeException e) {
            // Rollback để không tạo đơn dở dang; ghi lỗi ở transaction riêng bên dưới
            if (trans.isActive()) trans.rollback();
            failure = e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName();
            LOG.log(Level.SEVERE, "[MoMo] Đã thu tiền nhưng không tạo được đơn cho " + momoOrderId, e);
        } finally {
            em.close();
        }
        if (failure != null) {
            recordOrderError(momoOrderId, failure);
        }
    }

    private static void recordOrderError(String momoOrderId, String error) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            MomoTransaction t = MomoTransactionDB.findByMomoOrderIdForUpdate(em, momoOrderId);
            if (t != null) {
                t.orderError = truncate(error, 1000);
                MomoTransactionDB.update(em, t);
            }
            trans.commit();
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Ghi kết quả gọi API create: có payUrl → lưu lại (vẫn PENDING);
     * không có payUrl → chuyển FAILED (MoMo từ chối / lỗi mạng).
     */
    private static void recordCreateResponse(String momoOrderId, Integer code, String message, String payUrl) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            MomoTransaction t = MomoTransactionDB.findByMomoOrderIdForUpdate(em, momoOrderId);
            if (t != null && t.status == MomoTransactionStatus.PENDING) {
                if (payUrl != null) {
                    t.payUrl = truncate(payUrl, 1000);
                } else {
                    t.status = MomoTransactionStatus.FAILED;
                    t.resultCode = code;
                    t.message = truncate(message, 500);
                }
                MomoTransactionDB.update(em, t);
            }
            trans.commit();
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================

    private static MomoTransactionDTO loadOwned(int userId, String momoOrderId) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        try {
            MomoTransaction t = MomoTransactionDB.findByMomoOrderId(em, momoOrderId);
            if (t == null || t.user == null || t.user.getId() != userId) {
                // Không phân biệt "không tồn tại" và "không phải của bạn" để tránh dò mã
                throw new NotFoundException("Không tìm thấy giao dịch MoMo " + momoOrderId + ".");
            }
            return t.toDTO();
        } finally {
            em.close();
        }
    }

    private static void snapshotShipping(EntityManager em, MomoTransaction t, int userId, MomoCheckoutRequestDTO req) {
        if (req.getAddressId() != null) {
            Address a = em.find(Address.class, req.getAddressId());
            if (a == null || a.getUser() == null || a.getUser().getId() != userId) {
                throw new NotFoundException("Không tìm thấy địa chỉ giao hàng đã chọn.");
            }
            t.shippingRecipientName = truncate(a.getRecipientName(), 100);
            t.shippingPhone = truncate(a.getPhone(), 20);
            t.shippingAddress = truncate(ShippingAddressOptionDTO.joinAddress(
                    a.getStreet(), a.getWard(), a.getDistrict(), a.getCity()), 255);
        } else {
            t.shippingRecipientName = truncate(req.getRecipientName().trim(), 100);
            t.shippingPhone = truncate(req.getPhone().trim(), 20);
            t.shippingAddress = truncate(req.getShippingAddress().trim(), 255);
        }
        t.note = (req.getNote() != null && !req.getNote().trim().isEmpty()) ? truncate(req.getNote().trim(), 255) : null;
    }

    private PaidCheckoutDTO toPaidCheckout() {
        PaidCheckoutDTO dto = new PaidCheckoutDTO();
        dto.setUserId(user.getId());
        dto.setItems(readItems(itemsJson));
        dto.setSubtotal(subtotal);
        dto.setVoucherCode(voucherCode);
        dto.setDiscountAmount(discountAmount);
        dto.setTotalAmount(amount);
        dto.setShippingRecipientName(shippingRecipientName);
        dto.setShippingPhone(shippingPhone);
        dto.setShippingAddress(shippingAddress);
        dto.setNote(note);
        dto.setPaymentMethod(PaymentMethod.MOMO);
        dto.setTransactionCode(transId);
        dto.setGatewayOrderId(momoOrderId);
        dto.setPaidAt(paidAt);
        return dto;
    }

    private MomoTransactionDTO toDTO() {
        MomoTransactionDTO dto = new MomoTransactionDTO();
        dto.setMomoOrderId(momoOrderId);
        dto.setAmount(amount);
        dto.setStatus(status);
        dto.setResultCode(resultCode);
        dto.setMessage(message);
        dto.setTransId(transId);
        dto.setPayType(payType);
        dto.setOrderId(orderId);
        dto.setOrderError(orderError);
        dto.setCreatedAt(createdAt);
        dto.setPaidAt(paidAt);
        return dto;
    }

    /** Mã giao dịch gửi MoMo: FS + thời gian + U + userId + 4 ký tự ngẫu nhiên (khớp regex của MoMo). */
    private static String generateMomoOrderId(int userId) {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder rnd = new StringBuilder();
        for (int i = 0; i < 4; i++) {
            rnd.append(chars.charAt(RANDOM.nextInt(chars.length())));
        }
        return "FS" + System.currentTimeMillis() + "U" + userId + rnd;
    }

    private static boolean isFinalFailure(int code) {
        if (SUCCESS_CODES.contains(code) || PROCESSING_CODES.contains(code)) {
            return false;
        }
        // Mã 10–47: lỗi hệ thống / lỗi phía merchant khi gọi API → không phải kết quả thanh toán cuối cùng
        return code >= 1000 || code == 98 || code == 99;
    }

    private static String writeItems(List<CartItemDTO> items) {
        List<PaidCheckoutItemDTO> list = new ArrayList<>();
        for (CartItemDTO it : items) {
            list.add(PaidCheckoutItemDTO.fromCartItem(it));
        }
        try {
            return MAPPER.writeValueAsString(list);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("Không lưu được snapshot giỏ hàng", e);
        }
    }

    private static List<PaidCheckoutItemDTO> readItems(String json) {
        try {
            return MAPPER.readValue(json, new TypeReference<List<PaidCheckoutItemDTO>>() {});
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("Snapshot giỏ hàng bị hỏng", e);
        }
    }

    private static long toVnd(BigDecimal value) {
        return nz(value).setScale(0, RoundingMode.HALF_UP).longValueExact();
    }

    private static BigDecimal nz(BigDecimal v) {
        return v != null ? v : BigDecimal.ZERO;
    }

    private static Integer toInteger(Object v) {
        if (v == null) return null;
        if (v instanceof Number) return ((Number) v).intValue();
        try {
            return Integer.parseInt(String.valueOf(v).trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static Long toLong(Object v) {
        if (v == null) return null;
        if (v instanceof Number) return ((Number) v).longValue();
        try {
            return Long.parseLong(String.valueOf(v).trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static String truncate(String s, int max) {
        return (s == null || s.length() <= max) ? s : s.substring(0, max);
    }

    private static void validateUserId(int userId) {
        if (userId <= 0) {
            throw new UnauthorizedException("Vui lòng đăng nhập để thanh toán.");
        }
    }

    // ==========================================
    // GETTERS (chỉ đọc — trạng thái chỉ đổi qua business method)
    // ==========================================
    public int getId() { return id; }
    public String getMomoOrderId() { return momoOrderId; }
    public String getRequestId() { return requestId; }
    public User getUser() { return user; }
    public BigDecimal getAmount() { return amount; }
    public BigDecimal getSubtotal() { return subtotal; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public String getVoucherCode() { return voucherCode; }
    public String getItemsJson() { return itemsJson; }
    public String getShippingRecipientName() { return shippingRecipientName; }
    public String getShippingPhone() { return shippingPhone; }
    public String getShippingAddress() { return shippingAddress; }
    public String getNote() { return note; }
    public MomoTransactionStatus getStatus() { return status; }
    public Integer getResultCode() { return resultCode; }
    public String getMessage() { return message; }
    public String getTransId() { return transId; }
    public String getPayType() { return payType; }
    public String getPayUrl() { return payUrl; }
    public Integer getOrderId() { return orderId; }
    public String getOrderError() { return orderError; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public LocalDateTime getPaidAt() { return paidAt; }
}
