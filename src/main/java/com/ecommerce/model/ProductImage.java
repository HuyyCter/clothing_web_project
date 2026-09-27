package com.ecommerce.model;

import jakarta.persistence.*;

@Entity
@Table(name = "product_images")
public class ProductImage {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "color")
    private String color;

    @Column(name = "is_primary")
    private boolean isPrimary = false;

    public ProductImage() {
    }

    public ProductImage(Product product, String imageUrl, String color, boolean isPrimary) {
        this.product = product;
        this.imageUrl = imageUrl;
        this.color = color;
        this.isPrimary = isPrimary;
    }

    // ==========================================
    // GETTERS & SETTERS
    // ==========================================
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
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

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }
}
