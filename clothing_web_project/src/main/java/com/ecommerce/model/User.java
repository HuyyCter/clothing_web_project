package com.ecommerce.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(name = "full_name")
	private String fullName;
	
	@Column(unique = true)
	private String email;
	
	@Column(name = "password_hash")
	private String passwordHash;
	
	@Column(name = "phone")
	private String phone;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "role")
	private UserRole role;
	
	@Column(name = "created_at", updatable = false)
	private LocalDateTime createdAt;
	
	// 1 User - N Address (Association)
	@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Address> addresses = new ArrayList<>();
	
	// 1 User - 1 Cart (Association)
	@OneToOne(mappedBy = "user")
	private Cart cart;
	
	public User() {
    }

    public User(String fullName, String email, String passwordHash, String phone, UserRole role) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.role = role != null ? role : UserRole.CUSTOMER;
    }

    @PrePersist
    private void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
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
 
    public String getFullName() {
        return fullName;
    }
 
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
 
    public String getEmail() {
        return email;
    }
 
    public void setEmail(String email) {
        this.email = email;
    }
 
    public String getPasswordHash() {
        return passwordHash;
    }
 
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
 
    public String getPhone() {
        return phone;
    }
 
    public void setPhone(String phone) {
        this.phone = phone;
    }
 
    public UserRole getRole() {
        return role;
    }
 
    public void setRole(UserRole role) {
        this.role = role;
    }
 
    public List<Address> getAddresses() {
        return addresses;
    }
 
    public void setAddresses(List<Address> addresses) {
        this.addresses = addresses;
    }
 
    public Cart getCart() {
        return cart;
    }
 
    public void setCart(Cart cart) {
        this.cart = cart;
    }
    
    // ==========================================
    // METHODS
    // ==========================================
    public boolean isAdmin() {
    	return UserRole.ADMIN.equals(this.role);
    }
    
    public boolean isCustomer() {
    	return UserRole.CUSTOMER.equals(this.role);
    }
    
    public void addAddress(Address address) {
    	if (address != null) {
    		this.addresses.add(address);
    		address.setUser(this);
    	}
    }
    
    public void removeAddress(Address address) {
    	if (address != null) {
            this.addresses.remove(address);
            address.setUser(null);
        }
    }
}
