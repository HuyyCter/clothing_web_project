package com.ecommerce.dto;

import com.ecommerce.model.Address;

public class AddressDTO {
    private int id;
    private String recipientName;
    private String phone;
    private String street;
    private String ward;
    private String district;
    private String city;
    private boolean isDefault;
    private String fullAddress;

    public AddressDTO() {}

    public AddressDTO(Address address) {
        if (address != null) {
            this.id = address.getId();
            this.recipientName = address.getRecipientName();
            this.phone = address.getPhone();
            this.street = address.getStreet();
            this.ward = address.getWard();
            this.district = address.getDistrict();
            this.city = address.getCity();
            this.isDefault = address.isDefault();
            this.fullAddress = address.getFullAddress();
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public boolean getIsDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }
}
