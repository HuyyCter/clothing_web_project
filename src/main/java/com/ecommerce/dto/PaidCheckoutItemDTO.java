package com.ecommerce.dto;

import java.math.BigDecimal;

/**
 * 1 dòng sản phẩm được "chụp" (snapshot) từ giỏ hàng tại thời điểm khách bấm
 * thanh toán MoMo. Module Order dùng để tạo OrderItem sau khi thanh toán thành công.
 */
public class PaidCheckoutItemDTO {
    private Long productVariantId;
    private String productName;
    private String variantName;
    private String sku;
    private int quantity;
    private BigDecimal unitPrice;

    public PaidCheckoutItemDTO() {}

    public static PaidCheckoutItemDTO fromCartItem(CartItemDTO item) {
        PaidCheckoutItemDTO dto = new PaidCheckoutItemDTO();
        dto.productVariantId = item.getProductVariantId();
        dto.productName = item.getProductName();
        dto.variantName = item.getVariantName();
        dto.sku = item.getSku();
        dto.quantity = item.getQuantity();
        dto.unitPrice = item.getUnitPrice();
        return dto;
    }

    public Long getProductVariantId() { return productVariantId; }
    public void setProductVariantId(Long productVariantId) { this.productVariantId = productVariantId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getVariantName() { return variantName; }
    public void setVariantName(String variantName) { this.variantName = variantName; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}
