package com.ecommerce.dto;

import com.ecommerce.model.Address;

/**
 * Địa chỉ đã lưu của khách, rút gọn để hiển thị lựa chọn trên trang xác nhận MoMo.
 * Không để lộ Entity Address ra JSP (invariant 5).
 */
public class ShippingAddressOptionDTO {
    private int id;
    private String recipientName;
    private String phone;
    private String fullAddress;
    private boolean isDefault;

    public static ShippingAddressOptionDTO fromEntity(Address a) {
        ShippingAddressOptionDTO dto = new ShippingAddressOptionDTO();
        dto.id = a.getId();
        dto.recipientName = a.getRecipientName();
        dto.phone = a.getPhone();
        dto.fullAddress = joinAddress(a.getStreet(), a.getWard(), a.getDistrict(), a.getCity());
        dto.isDefault = a.isDefault();
        return dto;
    }

    public static String joinAddress(String... parts) {
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p != null && !p.trim().isEmpty()) {
                if (sb.length() > 0) sb.append(", ");
                sb.append(p.trim());
            }
        }
        return sb.toString();
    }

    public int getId() { return id; }
    public String getRecipientName() { return recipientName; }
    public String getPhone() { return phone; }
    public String getFullAddress() { return fullAddress; }
    public boolean isDefaultAddress() { return isDefault; }
}
