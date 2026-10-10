package com.ecommerce.dto;

import com.ecommerce.model.ProductImage;

public class ProductImageDTO {
    private int id;
    private int productId;
    private String imageUrl;
    private String color;

    public ProductImageDTO() {}

    public ProductImageDTO fromEntity(ProductImage productImage) {
        ProductImageDTO dto = new ProductImageDTO();
        dto.id = productImage.getId();
        dto.imageUrl = productImage.getImageUrl();
        dto.color = productImage.getColor();
        if (productImage.getProduct() != null) {
            dto.productId = productImage.getProduct().getId();
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}
