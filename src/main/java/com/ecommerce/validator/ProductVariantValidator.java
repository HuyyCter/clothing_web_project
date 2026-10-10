package com.ecommerce.validator;

import java.math.BigDecimal;
import com.ecommerce.dto.ProductVariantDTO;

public class ProductVariantValidator {

    public static String validate(ProductVariantDTO dto) {
        int productId = dto.getProductId();
        String size = (dto.getSize() != null) ? dto.getSize().trim() : "";
        String color = (dto.getColor() != null) ? dto.getColor().trim() : "";
        String sku = (dto.getSku() != null) ? dto.getSku().trim() : "";
        BigDecimal price = dto.getPrice();

        if (productId <= 0) {
            return "Biến thể phải thuộc về 1 sản phẩm.";
        }


        return "";
    }
}
