package com.ecommerce.validator;

import com.ecommerce.dto.CategoryDTO;

public class CategoryValidator {
    private static final int NAME_MAX_LENGTH = 255;

    public static String validate(CategoryDTO dto) {
        String name = (dto.getName() != null) ? dto.getName().trim() : "";

        if (name.isEmpty()) {
            return "Tên danh mục không được để trống.";
        }
        if (name.length() > NAME_MAX_LENGTH) {
            return "Tên danh mục tối đa " + NAME_MAX_LENGTH + " kí tự.";
        }

        return null;
    }
}
