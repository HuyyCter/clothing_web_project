package com.ecommerce.validator;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.ecommerce.dto.VoucherDTO;

public class VoucherValidator {
    private static final int MAX_CODE_LENGTH = 50;

    public static String validate(VoucherDTO dto) {
        String code = (dto.getCode() != null) ? dto.getCode().trim() : "";
        int discountPercent = dto.getDiscountPercent();
        BigDecimal minOrderAmount = dto.getMinOrderAmount();
        BigDecimal maxDiscountAmount = dto.getMaxDiscountAmount();
        LocalDateTime startAt = dto.getStartAt();
        LocalDateTime endAt = dto.getEndAt();
        int usageLimit = dto.getUsageLimit();

        // Code
        if (code.isEmpty()) {
            return "Mã voucher không được để trống.";
        }
        if (code.length() > MAX_CODE_LENGTH) {
            return "Mã voucher không được vượt quá " + MAX_CODE_LENGTH + " ký tự.";
        }

        // Discount percent
        if (discountPercent < 1 || discountPercent > 100) {
            return "% giảm giá phải từ 1 đến 100.";
        }

        // minOrderAmount
        if (minOrderAmount == null || minOrderAmount.compareTo(BigDecimal.ZERO) < 0) {
            return "Đơn hàng tối thiểu phải lớn hơn 0.";
        }

        // maxDiscountAmount
        if (maxDiscountAmount == null || maxDiscountAmount.compareTo(BigDecimal.ZERO) < 0) {
            return "Mức giảm tối đa phải lớn hơn 0";
        }

        // start - end date
        if (startAt == null) {
            return "Ngày bắt đầu không được để trống.";
        }
        if (endAt == null) {
            return "Ngày kết thúc không được để trống.";
        }
        if (startAt.isAfter(endAt)) {
            return "Ngày kết thúc phải sau ngày bắt đầu.";
        }

        // usageLimit
        if (usageLimit <= 0) {
            return "Giới hạn lượt dùng phải lớn hơn 0.";
        }

        return null;
    }
}
