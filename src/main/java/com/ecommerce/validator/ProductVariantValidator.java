package com.ecommerce.validator;

import java.math.BigDecimal;
import com.ecommerce.dto.ProductVariantDTO;

public class ProductVariantValidator {
    private static final int TEXT_MAX_LENGTH = 255;

    public static String validate(ProductVariantDTO dto, boolean isRequiredQuantity) {
        int productId = dto.getProductId();
        String size = (dto.getSize() != null) ? dto.getSize().trim() : "";
        String color = (dto.getColor() != null) ? dto.getColor().trim() : "";
        String sku = (dto.getSku() != null) ? dto.getSku().trim() : "";
        BigDecimal price = (dto.getPrice() != null) ? dto.getPrice() : BigDecimal.ZERO;
        int quantity = dto.getQuantity();

        if (productId <= 0) {
            return "Biến thể phải thuộc về 1 sản phẩm.";
        }

        if (size.isEmpty()) {
            return "Size không được để trống.";
        }
        if (size.length() > TEXT_MAX_LENGTH) {
            return "Size không được vượt quá " + TEXT_MAX_LENGTH + " ký tự.";
        }

        if (color.isEmpty()) {
            return "Color không được để trống.";
        }
        if (color.length() > TEXT_MAX_LENGTH) {
            return "Color không được vượt quá " + TEXT_MAX_LENGTH + " ký tự.";
        }

        if (sku.isEmpty()) {
            return "SKU không được để trống.";
        }
        if (sku.length() > TEXT_MAX_LENGTH) {
            return "SKU không được vượt quá " + TEXT_MAX_LENGTH + " ký tự.";
        }

        if (price.compareTo(BigDecimal.ZERO) <= 0) {
            return "Price không được để trống và phải lớn hơn 0.";
        }

        if (isRequiredQuantity && quantity < 1) {
            return "Số lượng nhập phải lớn hơn 0.";
        }

        return null;
    }
}
