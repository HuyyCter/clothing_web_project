package com.ecommerce.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import com.ecommerce.dto.CartDTO;
import com.ecommerce.dto.CartItemDTO;
import com.ecommerce.dto.CategoryDTO;
import com.ecommerce.dto.CheckoutRequestDTO;
import com.ecommerce.dto.OrderDTO;
import com.ecommerce.dto.PaidCheckoutDTO;
import com.ecommerce.dto.PaidCheckoutItemDTO;
import com.ecommerce.dto.ShippingAddressOptionDTO;
import com.ecommerce.exception.UnauthorizedException;
import com.ecommerce.repository.ProductVariantDB;
import java.math.BigDecimal;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.exception.NotFoundException;
import com.ecommerce.repository.CategoryDB;
import com.ecommerce.repository.OrderDB;
import com.ecommerce.util.JpaUtil;

@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // 1 Order - N OrderItem (Composition)
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private OrderStatus status;

    @Column(name = "total_amount", precision = 12, scale = 2)
    private java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;

    @Column(name = "shipping_recipient_name")
    private String shippingRecipientName;

    @Column(name = "shipping_phone")
    private String shippingPhone;

    @Column(name = "shipping_address_line")
    private String shippingAddressLine;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "note")
    private String note;

    /** Mã voucher đã dùng cho đơn (để hoàn lượt dùng khi hủy đơn). */
    @Column(name = "voucher_code", length = 50)
    private String voucherCode;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public Order() {}

    public Order(User user) {
        this.user = user;
        this.status = OrderStatus.PENDING;
        this.createdAt = LocalDateTime.now();
    }

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
    // GETTERS & SETTERS
    // ==========================================
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public java.math.BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(java.math.BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingRecipientName() {
        return shippingRecipientName;
    }

    public void setShippingRecipientName(String shippingRecipientName) {
        this.shippingRecipientName = shippingRecipientName;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public String getShippingAddressLine() {
        return shippingAddressLine;
    }

    public void setShippingAddressLine(String shippingAddressLine) {
        this.shippingAddressLine = shippingAddressLine;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // ==========================================
    // METHODS
    // ==========================================
    public static void updateStatus(int orderId, OrderStatus newStatus) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            Order order = OrderDB.findById(em, orderId);
            if (order == null) {
                throw new NotFoundException("Không tìm thấy đơn hàng có id = " + orderId);
            }
            if (newStatus == null || !canSwitchStatusTo(order, newStatus)) {
                throw new BusinessException("Không thể chuyển trạng thái đơn hàng từ " + order.getStatus() + " sang " + newStatus);
            }

            order.setStatus(newStatus);

            if (newStatus == OrderStatus.CANCELLED) {
                // Invariant 3: hủy đơn thì hoàn lại đúng số lượng tồn kho đã trừ, trong cùng transaction
                restoreStock(em, order);
            }

            OrderDB.update(em, order);

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static List<OrderDTO> getAll() {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            List<OrderDTO> orders = new ArrayList<>();
            for (Order order : OrderDB.findAll(em)) {
                orders.add(new OrderDTO(order));
            }
            return orders;
        } finally {
            em.close();
        }
    }


    // ==========================================
    // MODULE E: ĐẶT HÀNG (Nguyễn Phạm Thanh Tín)
    // ==========================================

    /**
     * Đặt hàng COD: đơn tạo ngay với trạng thái "Chờ xác nhận" (PENDING).
     * Trong 1 transaction: đọc giỏ hàng → khóa + trừ tồn kho → ghi nhận voucher → tạo Order + Payment → làm trống giỏ.
     */
    public static OrderDTO placeCodOrder(int userId, CheckoutRequestDTO request) {
        if (userId <= 0) {
            throw new UnauthorizedException("Vui lòng đăng nhập để đặt hàng.");
        }
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();

            CartDTO cart = Cart.getForCheckout(em, (long) userId);
            String[] shipping = resolveShipping(em, userId, request);
            List<PaidCheckoutItemDTO> items = new ArrayList<>();
            for (CartItemDTO it : cart.getItems()) {
                items.add(PaidCheckoutItemDTO.fromCartItem(it));
            }
            // Voucher chỉ được dùng khi Cart xác nhận còn hợp lệ (không có voucherWarning)
            String voucherCode = (cart.getVoucherCode() != null && cart.getVoucherWarning() == null) ? cart.getVoucherCode() : null;

            Order order = createOrder(em, userId, items, voucherCode, shipping, request.getNote(),
                    PaymentMethod.COD, OrderStatus.PENDING, null);

            OrderDB.insertPayment(em, new Payment(order.getId(), PaymentMethod.COD));
            Cart.clear(em, (long) userId);

            OrderDTO dto = new OrderDTO(order);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Tạo đơn cho thanh toán online đã thành công (MoMo) — được đăng ký làm {@link PaidOrderCreator}.
     * Chạy trong transaction của {@code em} do MomoTransaction mở. Đơn khởi tạo "Đã xác nhận" (CONFIRMED).
     */
    public static int createPaidOrder(EntityManager em, PaidCheckoutDTO checkout) {
        String[] shipping = { checkout.getShippingRecipientName(), checkout.getShippingPhone(), checkout.getShippingAddress() };
        Order order = createOrder(em, checkout.getUserId(), checkout.getItems(), checkout.getVoucherCode(), shipping,
                checkout.getNote(), checkout.getPaymentMethod(), OrderStatus.CONFIRMED, checkout.getTotalAmount());
        Cart.clear(em, (long) checkout.getUserId());
        return order.getId();
    }

    /** Khách tự hủy đơn của mình (chỉ từ PENDING / CONFIRMED), hoàn kho + hoàn lượt voucher trong cùng transaction. */
    public static void cancelByCustomer(int orderId, int userId) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Order order = OrderDB.findByIdAndUserId(em, orderId, userId);
            if (order == null) {
                throw new NotFoundException("Không tìm thấy đơn hàng hoặc bạn không có quyền hủy đơn hàng này.");
            }
            if (!canSwitchStatusTo(order, OrderStatus.CANCELLED)) {
                throw new BusinessException("Đơn hàng đang ở trạng thái không thể hủy.");
            }
            order.setStatus(OrderStatus.CANCELLED);
            restoreStock(em, order);
            OrderDB.update(em, order);
            trans.commit();
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /** Địa chỉ đã lưu của user cho trang Checkout (DTO, không lộ Entity ra JSP). */
    public static List<ShippingAddressOptionDTO> getAddressOptions(int userId) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        try {
            List<ShippingAddressOptionDTO> result = new ArrayList<>();
            for (Address a : OrderDB.findAddressesOfUser(em, userId)) {
                result.add(ShippingAddressOptionDTO.fromEntity(a));
            }
            return result;
        } finally {
            em.close();
        }
    }

    /**
     * Snapshot thông tin giao hàng (invariant 7): từ địa chỉ đã lưu (kiểm tra đúng chủ sở hữu) hoặc từ form nhập tay.
     * @return {tên người nhận, số điện thoại, địa chỉ}
     */
    public static String[] resolveShipping(EntityManager em, int userId, CheckoutRequestDTO req) {
        if (req.getAddressId() != null) {
            Address a = em.find(Address.class, req.getAddressId());
            if (a == null || a.getUser() == null || a.getUser().getId() != userId) {
                throw new NotFoundException("Không tìm thấy địa chỉ giao hàng đã chọn.");
            }
            return new String[] { cut(a.getRecipientName(), 100), cut(a.getPhone(), 20),
                    cut(ShippingAddressOptionDTO.joinAddress(a.getStreet(), a.getWard(), a.getDistrict(), a.getCity()), 255) };
        }
        return new String[] { cut(req.getRecipientName().trim(), 100), cut(req.getPhone().trim(), 20),
                cut(req.getShippingAddress().trim(), 255) };
    }

    /**
     * Tạo Order + OrderItem và trừ tồn kho. Mỗi ProductVariant là 1 đơn vị hàng, nên "trừ kho" = chuyển đúng
     * {@code quantity} dòng AVAILABLE cùng sản phẩm/size/màu sang SOLD, có khóa PESSIMISTIC_WRITE (invariant 1).
     *
     * @param paidAmount số tiền đã thanh toán online (null với COD) — phải khớp tổng tiền tính lại
     */
    private static Order createOrder(EntityManager em, int userId, List<PaidCheckoutItemDTO> items, String voucherCode,
            String[] shipping, String note, PaymentMethod method, OrderStatus status, BigDecimal paidAmount) {
        if (items == null || items.isEmpty()) {
            throw new BusinessException("Giỏ hàng của bạn đang trống, không thể tiến hành đặt hàng.");
        }
        User user = em.find(User.class, userId);
        if (user == null) {
            throw new UnauthorizedException("Tài khoản không tồn tại, vui lòng đăng nhập lại.");
        }

        Order order = new Order(user);
        order.setStatus(status);
        order.setShippingRecipientName(shipping[0]);
        order.setShippingPhone(shipping[1]);
        order.setShippingAddressLine(shipping[2]);
        order.setNote((note != null && !note.trim().isEmpty()) ? cut(note.trim(), 255) : null);
        order.setPaymentMethod(method.name());

        BigDecimal subtotal = BigDecimal.ZERO;
        for (PaidCheckoutItemDTO item : items) {
            int quantity = item.getQuantity();
            ProductVariant ref = (item.getProductVariantId() != null)
                    ? ProductVariantDB.findById(em, item.getProductVariantId().intValue()) : null;
            if (ref == null || ref.getProduct() == null || quantity <= 0) {
                throw new BusinessException("Sản phẩm '" + item.getProductName() + "' không còn tồn tại trên hệ thống.");
            }
            Product product = ref.getProduct();
            if (!product.isActive()) {
                throw new BusinessException("Sản phẩm '" + product.getName() + "' đã ngừng kinh doanh.");
            }

            List<ProductVariant> units = OrderDB.lockAvailableUnits(em, product.getId(), ref.getSize(), ref.getColor(), quantity);
            if (units.size() < quantity) {
                throw new BusinessException("Sản phẩm '" + product.getName() + "' (" + ref.getSize() + " / " + ref.getColor()
                        + ") chỉ còn " + units.size() + " sản phẩm, không đủ " + quantity + " sản phẩm bạn đặt.");
            }
            for (ProductVariant unit : units) {
                unit.setStatus(ProductVariantStatus.SOLD);
            }

            // Giá snapshot tại thời điểm đặt hàng (với MoMo: giá lúc khách bấm thanh toán)
            BigDecimal unitPrice = (item.getUnitPrice() != null) ? item.getUnitPrice() : ref.getPrice();
            OrderItem orderItem = new OrderItem(units.get(0), quantity, unitPrice);
            orderItem.setOrder(order);
            order.getItems().add(orderItem);
            subtotal = subtotal.add(unitPrice.multiply(BigDecimal.valueOf(quantity)));
        }

        BigDecimal discount = BigDecimal.ZERO;
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            discount = Voucher.redeem(em, voucherCode, subtotal); // khóa voucher + tăng usedCount
            order.setVoucherCode(voucherCode.trim().toUpperCase());
        }
        BigDecimal total = subtotal.subtract(discount).max(BigDecimal.ZERO);
        if (paidAmount != null && total.compareTo(paidAmount) != 0) {
            throw new BusinessException("Tổng tiền đơn hàng (" + total.toBigInteger() + "đ) khác số tiền đã thanh toán ("
                    + paidAmount.toBigInteger() + "đ).");
        }
        order.setTotalAmount(total);

        OrderDB.insert(em, order);
        em.flush(); // lấy id cho Payment
        return order;
    }

    /**
     * Hoàn kho khi hủy đơn (invariant 3): chuyển lại đúng số đơn vị SOLD sang AVAILABLE.
     * Nếu loại hàng đó đang bị Admin ngừng bán thì trả về DISCONTINUED (DISCONTINUED ưu tiên hơn AVAILABLE).
     */
    private static void restoreStock(EntityManager em, Order order) {
        for (OrderItem item : order.getItems()) {
            ProductVariant ref = item.getProductVariant();
            if (ref == null || ref.getProduct() == null) {
                continue;
            }
            int productId = ref.getProduct().getId();
            boolean discontinued = ProductVariantDB.countVariantByStatus(em, productId, ref.getSize(), ref.getColor(),
                    ProductVariantStatus.DISCONTINUED) > 0;
            for (ProductVariant unit : OrderDB.lockSoldUnits(em, productId, ref.getSize(), ref.getColor(), item.getQuantity())) {
                unit.setStatus(discontinued ? ProductVariantStatus.DISCONTINUED : ProductVariantStatus.AVAILABLE);
            }
        }
        if (order.getVoucherCode() != null) {
            Voucher.release(em, order.getVoucherCode());
        }
    }

    private static String cut(String s, int max) {
        return (s == null || s.length() <= max) ? s : s.substring(0, max);
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================

    // PENDING -> CONFIRMED -> SHIPPING -> DELIVERED (CANCELLED)
    private static boolean canSwitchStatusTo(Order order, OrderStatus status) {
        boolean canSwitch = false;
        switch (order.getStatus()) {
            case PENDING:
                canSwitch = (status == OrderStatus.CONFIRMED || status == OrderStatus.CANCELLED);
                break;
            case CONFIRMED:
                canSwitch = (status == OrderStatus.SHIPPING || status == OrderStatus.CANCELLED);
                break;
            case SHIPPING:
                canSwitch = status == OrderStatus.DELIVERED;
                break;
            default:
                break;
        }
        return canSwitch;
    }
}
