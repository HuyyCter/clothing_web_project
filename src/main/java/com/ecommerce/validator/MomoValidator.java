package com.ecommerce.validator;

/**
 * Validate tham số riêng của luồng MoMo (if/else thủ công, theo code-standards.md).
 * Form đặt hàng (địa chỉ, ghi chú, phương thức) được validate ở {@link CheckoutValidator}.
 */
public class MomoValidator {

    /** Mã đơn MoMo do hệ thống sinh, dùng regex của MoMo để chặn tham số rác trên URL. */
    private static final String MOMO_ORDER_ID_REGEX = "^[0-9a-zA-Z]([-_.]*[0-9a-zA-Z]+)*$";

    public static String validateMomoOrderId(String momoOrderId) {
        if (momoOrderId == null || momoOrderId.trim().isEmpty() || momoOrderId.length() > 200
                || !momoOrderId.matches(MOMO_ORDER_ID_REGEX)) {
            return "Mã giao dịch MoMo không hợp lệ.";
        }
        return null;
    }
}
