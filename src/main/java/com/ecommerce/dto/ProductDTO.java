package com.ecommerce.dto;

import java.util.*;
import com.ecommerce.model.Product;

public class ProductDTO {
    private int id;
    private String name;
    private String description;
    private int categoryId;
    private String categoryName;
    private boolean isActive;
    private List<ProductVariantDTO> variants = new ArrayList<>();
    private List<ProductImageDTO> images = new ArrayList<>();

    public ProductDTO() {}

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

        // if (product.getVariants() != null) {
        // dto.variants = product.getVariants().stream().map(ProductVariantDTO::fromEntity).toList();
        // }

        // if (product.getImages() != null) {
        // dto.images = product.getImages().stream().map(ProductImageDTO::fromEntity).toList();
        // }
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

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public boolean isActive() {
        return isActive;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public List<ProductVariantDTO> getVariants() {
        return variants;
    }

    public void setVariants(List<ProductVariantDTO> variants) {
        this.variants = variants;
    }

    public List<ProductImageDTO> getImages() {
        return images;
    }

    public void setImages(List<ProductImageDTO> images) {
        this.images = images;
    }
}
