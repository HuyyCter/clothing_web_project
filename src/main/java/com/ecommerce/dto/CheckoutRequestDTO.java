package com.ecommerce.dto;

/**
 * Dữ liệu form Checkout (trang /checkout).
 * Khách chọn 1 địa chỉ đã lưu (addressId) HOẶC nhập tay thông tin người nhận,
 * và chọn phương thức thanh toán (COD hoặc MOMO).
 */
public class CheckoutRequestDTO {
    private Integer addressId;
    private String recipientName;
    private String phone;
    private String shippingAddress;
    private String note;
    private String paymentMethod = "COD";

    public Integer getAddressId() { return addressId; }
    public void setAddressId(Integer addressId) { this.addressId = addressId; }
    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
}
