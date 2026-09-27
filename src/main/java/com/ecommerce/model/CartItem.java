package com.ecommerce.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "cart_items")
public class CartItem {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

	// N CartItem - 1 Cart (Composition)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cart_id")
    private Cart cart;

    // N CartItem - 1 ProductVariant (Association)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_variant_id")
    private ProductVariant productVariant;

    @Column(name = "quantity")
    private int quantity;

    public CartItem() {
    }

    public CartItem(Cart cart, ProductVariant productVariant, int quantity) {
        this.cart = cart;
        this.productVariant = productVariant;
        this.quantity = quantity;
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

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public ProductVariant getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariant productVariant) {
        this.productVariant = productVariant;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    // ==========================================
    // METHODS
    // ==========================================
    public BigDecimal getSubtotal() {
    	if (productVariant == null || productVariant.getPrice() == null) {
    		return BigDecimal.ZERO;
    	}
    	return productVariant.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
    
    public void increaseQuantity(int amount) {
    	if (amount > 0) {
    		this.quantity += amount;
    	}
    }
    
    public void decreaseQuantity(int amount) {
    	if (amount > 0) {
    		this.quantity = Math.max(0, this.quantity - amount);
    	}
    }
}
