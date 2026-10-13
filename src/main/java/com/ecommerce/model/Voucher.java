package com.ecommerce.model;

import java.math.BigDecimal;
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
