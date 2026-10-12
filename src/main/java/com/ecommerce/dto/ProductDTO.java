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

    public ProductDTO(
            int id,
            String name,
            String description,
            String categoryName,
            String primaryImageUrl,
            BigDecimal minPrice) {

        this.id = id;
        this.name = name;
        this.description = description;
        this.categoryName = categoryName;
        this.primaryImageUrl = primaryImageUrl;
        this.minPrice = minPrice;
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

    public String getPrimaryImageUrl() {
        return primaryImageUrl;
    }

    public void setPrimaryImageUrl(String primaryImageUrl) {
        this.primaryImageUrl = primaryImageUrl;
    }

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }
}