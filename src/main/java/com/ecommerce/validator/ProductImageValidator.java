package com.ecommerce.validator;

import com.ecommerce.dto.ProductImageDTO;

public class ProductImageValidator {
    private static final int COLOR_MAX_LENGTH = 100;

    public static String validate(ProductImageDTO dto) {
        int productId = dto.getProductId();
        String imageUrl = (dto.getImageUrl() != null) ? dto.getImageUrl().trim() : "";
        String color = (dto.getColor() != null) ? dto.getColor().trim() : "";

        if (productId <= 0) {
            return "Ảnh phải thuộc về 1 sản phẩm.";
        }

        if (imageUrl.isEmpty()) {
            return "URL của ảnh không được để trống.";
        }

        if (color.isEmpty()) {
            return "Color của ảnh không được để trống.";
        }
        if (color.length() > COLOR_MAX_LENGTH) {
            return "Color của ảnh không được vượt quá " + COLOR_MAX_LENGTH + " ký tự.";
        }

        return null;
    }
}
