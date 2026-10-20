package com.ecommerce.validator;

import com.ecommerce.dto.MomoCheckoutRequestDTO;

/**
 * Validate form thanh toán MoMo (if/else thủ công, theo code-standards.md).
 * Trả về thông báo lỗi, hoặc null nếu hợp lệ.
 */
public class MomoValidator {

    private static final String PHONE_REGEX = "^0\\d{9}$";
    /** Mã đơn MoMo do hệ thống sinh, dùng regex của MoMo để chặn tham số rác trên URL. */
    private static final String MOMO_ORDER_ID_REGEX = "^[0-9a-zA-Z]([-_.]*[0-9a-zA-Z]+)*$";

    public static String validateCheckout(MomoCheckoutRequestDTO dto) {
        if (dto == null) {
            return "Dữ liệu thanh toán không hợp lệ.";
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

    public static String validateMomoOrderId(String momoOrderId) {
        if (isBlank(momoOrderId) || momoOrderId.length() > 200 || !momoOrderId.matches(MOMO_ORDER_ID_REGEX)) {
            return "Mã giao dịch MoMo không hợp lệ.";
        }
        return null;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
