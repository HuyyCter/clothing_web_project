package com.ecommerce.validator;

import com.ecommerce.dto.ProductDTO;

public class ProductValidator {
    private static final int NAME_MAX_LENGTH = 255;

    public static String validate(ProductDTO dto) {
        String name = (dto.getName() != null) ? dto.getName().trim() : "";
        int categoryId = dto.getCategoryId();

        if (name.isEmpty()) {
            return "Tên sản phẩm không được để trống.";
        }
        if (name.length() > NAME_MAX_LENGTH) {
            return "Tên sản phẩm không được vượt quá " + NAME_MAX_LENGTH + " ký tự.";
        }

        if (categoryId <= 0) {
            return "Vui lòng chọn danh mục cho sản phẩm.";
        }

        return null;
    }
}
