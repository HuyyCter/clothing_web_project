package com.ecommerce.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.ecommerce.model.Voucher;

public class VoucherDTO {
    private int id;
    private String code;
    private int discountPercent;
    private BigDecimal minOrderAmount;
    private BigDecimal maxDiscountAmount;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private int usageLimit;
    private int usedCount;
    private boolean active;
    private LocalDateTime createdAt;

    public VoucherDTO() {}

    public static VoucherDTO fromEntity(Voucher voucher) {
        VoucherDTO dto = new VoucherDTO();
        dto.id = voucher.getId();
        dto.code = voucher.getCode();
        dto.discountPercent = voucher.getDiscountPercent();
        dto.minOrderAmount = voucher.getMinOrderAmount();
        dto.maxDiscountAmount = voucher.getMaxDiscountAmount();
        dto.startAt = voucher.getStartAt();
        dto.endAt = voucher.getEndAt();
        dto.usageLimit = voucher.getUsageLimit();
        dto.usedCount = voucher.getUsedCount();
        dto.active = voucher.isActive();
        dto.createdAt = voucher.getCreatedAt();
        return dto;
    }

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
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
