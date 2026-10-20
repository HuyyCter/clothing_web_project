package com.ecommerce.validator;

import com.ecommerce.dto.CheckoutRequestDTO;

/**
 * Validate form Checkout (if/else thủ công, theo code-standards.md).
 * Trả về thông báo lỗi, hoặc null nếu hợp lệ.
 */
public class CheckoutValidator {

    private static final String PHONE_REGEX = "^0\\d{9}$";

    public static String validate(CheckoutRequestDTO dto) {
        if (dto == null) {
            return "Dữ liệu đặt hàng không hợp lệ.";
        }
        if (!"COD".equals(dto.getPaymentMethod()) && !"MOMO".equals(dto.getPaymentMethod())) {
            return "Vui lòng chọn phương thức thanh toán (COD hoặc MoMo).";
        }
        if (dto.getNote() != null && dto.getNote().trim().length() > 255) {
            return "Ghi chú không được vượt quá 255 ký tự.";
        }
        if (dto.getAddressId() != null) {
            return dto.getAddressId() > 0 ? null : "Địa chỉ giao hàng không hợp lệ.";
        }
        // Không chọn địa chỉ đã lưu → bắt buộc nhập tay
        if (isBlank(dto.getRecipientName())) {
            return "Vui lòng chọn địa chỉ giao hàng hoặc nhập tên người nhận.";
        }
        if (dto.getRecipientName().trim().length() > 100) {
            return "Tên người nhận không được vượt quá 100 ký tự.";
        }
        if (isBlank(dto.getPhone()) || !dto.getPhone().trim().matches(PHONE_REGEX)) {
            return "Số điện thoại người nhận phải gồm 10 chữ số và bắt đầu bằng 0.";
        }
        if (isBlank(dto.getShippingAddress())) {
            return "Vui lòng nhập địa chỉ giao hàng.";
        }
        if (dto.getShippingAddress().trim().length() > 255) {
            return "Địa chỉ giao hàng không được vượt quá 255 ký tự.";
        }
        return null;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
