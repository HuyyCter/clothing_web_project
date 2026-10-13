package com.ecommerce.dto;

import com.ecommerce.model.Category;

public class CategoryDTO {
    private int id;
    private String name;
    private String description;
    private String slug;

    public CategoryDTO() {}

    public static CategoryDTO fromEntity(Category category) {
        CategoryDTO dto = new CategoryDTO();
        dto.id = category.getId();
        dto.name = category.getName();
        dto.description = category.getDescription();
        dto.slug = category.getSlug();
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

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }
}
