package com.ecommerce.dto;

import java.math.BigDecimal;

public class ProductDTO {

    private int id;
    private String name;
    private String description;
    private String categoryName;
    private String primaryImageUrl;
    private BigDecimal minPrice;

    public ProductDTO() {
    }

    public static ProductDTO fromEntity(Product product) {
        ProductDTO dto = new ProductDTO();
        dto.id = product.getId();
        dto.name = product.getName();
        dto.description = product.getDescription();
        dto.isActive = product.isActive();
        if (product.getCategory() != null) {
            dto.categoryId = product.getCategory().getId();
            dto.categoryName = product.getCategory().getName();
        }
        return dto;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

<<<<<<< HEAD
    public boolean isActive() {
        return isActive;
=======
    public String getPrimaryImageUrl() {
        return primaryImageUrl;
>>>>>>> f80bffa7c3c4d07a431413993b96a30cb065da4b
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }
}