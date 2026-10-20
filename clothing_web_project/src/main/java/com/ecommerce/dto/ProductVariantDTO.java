package com.ecommerce.dto;

import java.math.BigDecimal;
import com.ecommerce.model.ProductVariantStatus;
import com.ecommerce.model.ProductVariant;

public class ProductVariantDTO {
    private int id;
    private int productId;
    private String size;
    private String color;
    private String sku;
    private BigDecimal price;
    private ProductVariantStatus status;
    private int quantity;

    public ProductVariantDTO() {}

    public static ProductVariantDTO fromEntity(ProductVariant productVariant) {
        ProductVariantDTO dto = new ProductVariantDTO();
        dto.id = productVariant.getId();
        dto.size = productVariant.getSize();
        dto.color = productVariant.getColor();
        dto.sku = productVariant.getSku();
        dto.price = productVariant.getPrice();
        dto.status = productVariant.getStatus();
        if (productVariant.getProduct() != null) {
            dto.productId = productVariant.getProduct().getId();
        }
        return dto;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public ProductVariantStatus getStatus() {
        return status;
    }

    public void setStatus(ProductVariantStatus status) {
        this.status = status;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
