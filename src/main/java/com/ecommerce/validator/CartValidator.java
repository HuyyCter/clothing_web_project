package com.ecommerce.validator;

public class CartValidator {

    public static String validateQuantity(Integer quantity) {
        if (quantity == null || quantity <= 0) {
            return "Số lượng sản phẩm phải lớn hơn 0.";
        }
        if (quantity > 99) {
            return "Số lượng sản phẩm mua không được vượt quá 99.";
        }
        return null;
    }

    public static String validateVariantId(Long variantId) {
        if (variantId == null || variantId <= 0) {
            return "Mã biến thể sản phẩm không hợp lệ.";
        }
        return null;
    }

    public static String validateVoucherCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            return "Vui lòng nhập mã voucher.";
        }
        if (code.trim().length() > 50) {
            return "Mã voucher không được vượt quá 50 ký tự.";
        }
        return null;
    }
}
