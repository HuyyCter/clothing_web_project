package com.ecommerce.model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;

@Entity
@Table(name = "carts")
public class Cart {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
	
	// 1 Cart - 1 User (Association)
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", unique = true)
    private User user;

    // 1 Cart - N CartItem (Composition) 
    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CartItem> items = new ArrayList<>();

    public Cart() {
    }

    public Cart(User user) {
        this.user = user;
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
        if (items != null) {
            for (CartItem item : items) {
                item.setCart(this);
            }
        }
    }
    
    // ==========================================
    // METHODS
    // ==========================================
    public void addItem(ProductVariant variant, int quantity) {
    	if (variant == null || quantity <= 0) {
    		return;
    	}
    	
    	for (CartItem item : items) {
    		if (item.getProductVariant() != null && item.getProductVariant().getId() == variant.getId()) {
    			item.setQuantity(item.getQuantity() + quantity);
    			return;
    		}
    	}
    	
    	CartItem newItem = new CartItem();
    	newItem.setCart(this);
    	newItem.setProductVariant(variant);
    	newItem.setQuantity(quantity);
    	this.items.add(newItem);
    }
}
