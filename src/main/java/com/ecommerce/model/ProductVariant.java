package com.ecommerce.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "product_variants")
public class ProductVariant {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "size")
    private String size;

    @Column(name = "color")
    private String color;

    @Column(name = "sku", unique = true)
    private String sku;

    @Column(name = "price", precision = 12, scale = 2)
    private BigDecimal price;

    public ProductVariant() {
    }

    public ProductVariant(Product product, String size, String color, String sku, BigDecimal price) {
        this.product = product;
        this.size = size;
        this.color = color;
        this.sku = sku;
        this.price = price;
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
}
