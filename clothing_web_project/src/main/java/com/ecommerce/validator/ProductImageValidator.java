package com.ecommerce.validator;

import com.ecommerce.dto.ProductImageDTO;

public class ProductImageValidator {
    private static final int COLOR_MAX_LENGTH = 255;
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;

    public static String validate(ProductImageDTO dto) {
        int productId = dto.getProductId();
        String imageUrl = (dto.getImageUrl() != null) ? dto.getImageUrl().trim() : "";
        String color = (dto.getColor() != null) ? dto.getColor().trim() : "";

        String error = validateTarget(productId, color);
        if (error != null) {
            return error;
        }

        if (imageUrl.isEmpty()) {
            return "URL của ảnh không được để trống.";
        }

        return null;
    }

    public static String validateTarget(int productId, String color) {
        if (productId <= 0) {
            return "Ảnh phải thuộc về một sản phẩm";
        }

        if (color.isEmpty()) {
            return "Màu của ảnh không được để trống";
        }
        if (color.length() > COLOR_MAX_LENGTH) {
            return "Màu của ảnh không được vượt quá " + COLOR_MAX_LENGTH + " ký tự";
        }

        return null;
    }

    public static String validateFile(String contentType, long size) {
        if (size <= 0) {
            return "Vui lòng chọn file ảnh";
        }
        if (size > MAX_FILE_SIZE) {
            return "Ảnh không được vượt quá 5MB";
        }
        if (!"image/jpeg".equals(contentType) && !"image/png".equals(contentType) && !"image/webp".equals(contentType)) {
            return "Chỉ chấp nhận ảnh JPG, PNG hoặc WEBP";
        }
        return null;
    }
}
