package com.ecommerce.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import com.ecommerce.dto.VoucherDTO;
import com.ecommerce.repository.VoucherDB;
import com.ecommerce.util.*;
import com.ecommerce.exception.*;
import jakarta.persistence.*;

@Entity
@Table(name = "vouchers")
public class Voucher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "code", unique = true, nullable = false, length = 50)
    private String code;

    @Column(name = "discount_percent", nullable = false)
    private int discountPercent;

    @Column(name = "min_order_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal minOrderAmount = BigDecimal.ZERO;

    @Column(name = "max_discount_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal maxDiscountAmount = BigDecimal.ZERO;

    @Column(name = "start_at", nullable = false)
    private LocalDateTime startAt;

    @Column(name = "end_at", nullable = false)
    private LocalDateTime endAt;

    @Column(name = "usage_limit", nullable = false)
    private int usageLimit;

    @Column(name = "used_count", nullable = false)
    private int usedCount = 0;

    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public Voucher() {}

    public Voucher(String code, int discountPercent, BigDecimal minOrderAmount, BigDecimal maxDiscountAmount, LocalDateTime startAt,
            LocalDateTime endAt, int usageLimit) {
        this.code = code;
        this.discountPercent = discountPercent;
        this.minOrderAmount = minOrderAmount;
        this.maxDiscountAmount = maxDiscountAmount;
        this.startAt = startAt;
        this.endAt = endAt;
        this.usageLimit = usageLimit;
        this.usedCount = 0;
        this.isActive = true;
    }

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public BigDecimal getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(BigDecimal minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public BigDecimal getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public LocalDateTime getStartAt() {
        return startAt;
    }

    public void setStartAt(LocalDateTime startAt) {
        this.startAt = startAt;
    }

    public LocalDateTime getEndAt() {
        return endAt;
    }

    public void setEndAt(LocalDateTime endAt) {
        this.endAt = endAt;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // ==========================================
    // METHODS
    // ==========================================
    public static VoucherDTO create(VoucherDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        String code = normalizeCode(dto.getCode());
        int discountPercent = dto.getDiscountPercent();
        BigDecimal minOrderAmount = dto.getMinOrderAmount();
        BigDecimal maxDiscountAmount = dto.getMaxDiscountAmount();
        LocalDateTime startAt = dto.getStartAt();
        LocalDateTime endAt = dto.getEndAt();
        int usageLimit = dto.getUsageLimit();

        try {
            trans.begin();

            if (VoucherDB.isCodeExists(em, code)) {
                throw new BusinessException("Mã voucher " + code + " đã tồn tại.");
            }
            Voucher voucher = new Voucher(code, discountPercent, minOrderAmount, maxDiscountAmount, startAt, endAt, usageLimit);
            VoucherDB.insert(em, voucher);

            trans.commit();
            return VoucherDTO.fromEntity(voucher);
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static VoucherDTO update(int id, VoucherDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        String code = normalizeCode(dto.getCode());
        int discountPercent = dto.getDiscountPercent();
        BigDecimal minOrderAmount = dto.getMinOrderAmount();
        BigDecimal maxDiscountAmount = dto.getMaxDiscountAmount();
        LocalDateTime startAt = dto.getStartAt();
        LocalDateTime endAt = dto.getEndAt();
        int usageLimit = dto.getUsageLimit();

        try {
            trans.begin();

            if (!VoucherDB.isVoucherIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy voucher có id = " + id);
            }
            if (VoucherDB.isCodeExcludingIdExists(em, code, id)) {
                throw new BusinessException("Mã voucher " + code + " đã tồn tại.");
            }

            Voucher voucher = VoucherDB.findById(em, id);
            voucher.setCode(code);
            voucher.setDiscountPercent(discountPercent);
            voucher.setMinOrderAmount(minOrderAmount);
            voucher.setMaxDiscountAmount(maxDiscountAmount);
            voucher.setStartAt(startAt);
            voucher.setEndAt(endAt);
            voucher.setUsageLimit(usageLimit);
            VoucherDB.update(em, voucher);

            trans.commit();
            return VoucherDTO.fromEntity(voucher);
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static void delete(int id) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            if (!VoucherDB.isVoucherIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy voucher có id = " + id);
            }

            Voucher voucher = VoucherDB.findById(em, id);
            VoucherDB.delete(em, voucher);

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static VoucherDTO getById(int id) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            Voucher voucher = VoucherDB.findById(em, id);
            if (voucher == null) {
                throw new NotFoundException("Không tìm thấy voucher có id = " + id);
            }
            return VoucherDTO.fromEntity(voucher);
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    public static List<VoucherDTO> getAll() {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            List<VoucherDTO> vouchers = new ArrayList<>();
            for (Voucher voucher : VoucherDB.findAll(em)) {
                vouchers.add(VoucherDTO.fromEntity(voucher));
            }
            return vouchers;
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    public static VoucherDTO toggleActive(int id) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            if (!VoucherDB.isVoucherIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy voucher có id = " + id);
            }

            Voucher voucher = VoucherDB.findById(em, id);
            voucher.setActive(!voucher.isActive());
            VoucherDB.update(em, voucher);

            trans.commit();
            return VoucherDTO.fromEntity(voucher);
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy thông tin VoucherDTO theo mã code.
     */
    public static VoucherDTO getByCode(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) {
            return null;
        }
        Voucher voucher = VoucherDB.findByCode(em, code.trim().toUpperCase());
        return voucher != null ? VoucherDTO.fromEntity(voucher) : null;
    }

    public static VoucherDTO getByCode(String code) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        try {
            return getByCode(em, code);
        } finally {
            em.close();
        }
    }

    /**
     * Kiểm tra tính hợp lệ và tính số tiền giảm giá trên một thực thể Voucher.
     * Áp dụng toàn bộ 5 business rule từ spec.
     *
     * @param orderValue Giá trị đơn hàng / subtotal
     * @return Số tiền được giảm giá (làm tròn số nguyên đồng, RoundingMode.HALF_UP)
     */
    public BigDecimal calculateDiscount(BigDecimal orderValue) {
        if (orderValue == null || orderValue.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("Giá trị đơn hàng không hợp lệ để áp dụng voucher.");
        }

        // 1. Kiểm tra cờ isActive
        if (!this.isActive) {
            throw new BusinessException("Mã voucher '" + this.code + "' hiện đã bị vô hiệu hóa.");
        }

        LocalDateTime now = LocalDateTime.now();

        // 2. Kiểm tra thời hạn áp dụng (startAt - endAt)
        if (this.startAt != null && now.isBefore(this.startAt)) {
            throw new BusinessException("Chưa đến thời gian áp dụng mã voucher '" + this.code + "'.");
        }
        if (this.endAt != null && now.isAfter(this.endAt)) {
            throw new BusinessException("Mã voucher '" + this.code + "' đã hết hạn sử dụng.");
        }

        // 3. Kiểm tra giới hạn lượt dùng
        if (this.usageLimit > 0 && this.usedCount >= this.usageLimit) {
            throw new BusinessException("Mã voucher '" + this.code + "' đã hết lượt sử dụng.");
        }

        // 4. Kiểm tra đơn hàng tối thiểu
        BigDecimal minOrder = (this.minOrderAmount != null) ? this.minOrderAmount : BigDecimal.ZERO;
        if (orderValue.compareTo(minOrder) < 0) {
            throw new BusinessException("Đơn hàng chưa đạt giá trị tối thiểu " + minOrder.toBigInteger() + "đ để áp dụng voucher này.");
        }

        // 5. Tính số tiền giảm: orderValue * discountPercent / 100
        // Tiền VND làm tròn số nguyên RoundingMode.HALF_UP
        BigDecimal percent = BigDecimal.valueOf(this.discountPercent);
        BigDecimal discount = orderValue.multiply(percent).divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP);

        // Giới hạn bởi maxDiscountAmount nếu có
        if (this.maxDiscountAmount != null && this.maxDiscountAmount.compareTo(BigDecimal.ZERO) > 0) {
            discount = discount.min(this.maxDiscountAmount);
        }

        return discount;
    }

    /**
     * Kiểm tra toàn bộ điều kiện áp voucher và tính số tiền giảm giá.
     * Tham gia vào transaction của EntityManager truyền vào (phục vụ Order checkout của Module E hoặc Cart).
     *
     * @param em EntityManager từ caller
     * @param code Mã voucher (không phân biệt hoa/thường)
     * @param orderValue Tổng tiền hàng (subtotal)
     * @return Số tiền được giảm giá (làm tròn số nguyên đồng, RoundingMode.HALF_UP)
     */
    public static BigDecimal validateAndCalculate(EntityManager em, String code, BigDecimal orderValue) {
        if (code == null || code.trim().isEmpty()) {
            throw new BusinessException("Mã voucher không được để trống.");
        }

        String normalizedCode = code.trim().toUpperCase();
        Voucher voucher = VoucherDB.findByCode(em, normalizedCode);

        // Kiểm tra tồn tại
        if (voucher == null) {
            throw new NotFoundException("Mã voucher '" + normalizedCode + "' không tồn tại.");
        }

        return voucher.calculateDiscount(orderValue);
    }

    /**
     * Overload tự mở EntityManager và transaction cho Controller / UI của Module D.
     */
    public static BigDecimal validateAndCalculate(String code, BigDecimal orderValue) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        try {
            return validateAndCalculate(em, code, orderValue);
        } finally {
            em.close();
        }
    }

    // ==========================================
    // OVERLOAD METHODS CHO MODULE E (ORDER CHECKOUT)
    // ==========================================

    /**
     * Ghi nhận sử dụng voucher trong transaction đặt hàng của Module E.
     * Sử dụng pessimistic lock để tránh race condition số lượt dùng.
     *
     * @param em EntityManager từ transaction của Order
     * @param code Mã voucher
     * @param orderValue Giá trị đơn hàng để tái kiểm tra tính hợp lệ
     * @return Số tiền giảm giá được áp dụng
     */
    public static BigDecimal redeem(EntityManager em, String code, BigDecimal orderValue) {
        if (code == null || code.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }

        String normalizedCode = code.trim().toUpperCase();
        Voucher voucher = VoucherDB.findByCodeWithLock(em, normalizedCode);
        if (voucher == null) {
            throw new NotFoundException("Mã voucher '" + normalizedCode + "' không tồn tại.");
        }

        BigDecimal discount = voucher.calculateDiscount(orderValue);
        voucher.setUsedCount(voucher.getUsedCount() + 1);
        VoucherDB.update(em, voucher);

        return discount;
    }

    /**
     * Hoàn lại lượt dùng của voucher khi đơn hàng bị hủy trong transaction của Module E.
     *
     * @param em EntityManager từ transaction của Order
     * @param code Mã voucher
     */
    public static void release(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) {
            return;
        }

        String normalizedCode = code.trim().toUpperCase();
        Voucher voucher = VoucherDB.findByCodeWithLock(em, normalizedCode);
        if (voucher != null) {
            voucher.setUsedCount(Math.max(0, voucher.getUsedCount() - 1));
            VoucherDB.update(em, voucher);
        }
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================
    private static String normalizeCode(String rawCode) {
        String code = rawCode.trim().toUpperCase();
        if (code.isEmpty()) {
            throw new BusinessException("Mã voucher không được để trống.");
        }
        return code;
    }
}
