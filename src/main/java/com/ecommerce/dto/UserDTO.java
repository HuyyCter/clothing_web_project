package com.ecommerce.dto;

import com.ecommerce.model.User;
import com.ecommerce.model.UserRole;
import java.util.ArrayList;
import java.util.List;

public class UserDTO {
    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String role;
    private List<AddressDTO> addresses = new ArrayList<>();

    public UserDTO() {}

    public UserDTO(User user) {
        if (user != null) {
            this.id = user.getId();
            this.fullName = user.getFullName();
            this.email = user.getEmail();
            this.phone = user.getPhone();
            this.role = (user.getRole() != null) ? user.getRole().name() : UserRole.CUSTOMER.name();
        }
    }

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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public List<AddressDTO> getAddresses() {
        return addresses;
    }

    public void setAddresses(List<AddressDTO> addresses) {
        this.addresses = addresses;
    }

    public String getAvatarInitial() {
        if (fullName != null && !fullName.trim().isEmpty()) {
            return fullName.trim().substring(0, 1).toUpperCase();
        }
        return "U";
    }
}
