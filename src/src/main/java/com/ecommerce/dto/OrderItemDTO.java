package com.ecommerce.dto;

import com.ecommerce.model.OrderItem;
import com.ecommerce.model.Product;
import com.ecommerce.model.ProductImage;
import com.ecommerce.model.ProductVariant;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class OrderItemDTO {
    private int id;
    private int productVariantId;
    private String productName;
    private String size;
    private String color;
    private String sku;
    private String imageUrl;
    private int quantity;
    private BigDecimal unitPrice = BigDecimal.ZERO;
    private BigDecimal subtotal = BigDecimal.ZERO;

    public OrderItemDTO() {
    }

    public OrderItemDTO(OrderItem item) {
        if (item != null) {
            this.id = item.getId();
            this.quantity = item.getQuantity();
            this.unitPrice = item.getPrice() != null ? item.getPrice() : BigDecimal.ZERO;
            this.subtotal = this.unitPrice.multiply(BigDecimal.valueOf(this.quantity));

            ProductVariant variant = item.getProductVariant();
            if (variant != null) {
                this.productVariantId = variant.getId();
                this.size = variant.getSize();
                this.color = variant.getColor();
                this.sku = variant.getSku();

                Product product = variant.getProduct();
                if (product != null) {
                    this.productName = product.getName();
                    if (product.getImages() != null && !product.getImages().isEmpty()) {
                        String matchedImg = null;
                        for (ProductImage img : product.getImages()) {
                            if (this.color != null && this.color.equalsIgnoreCase(img.getColor())) {
                                matchedImg = img.getImageUrl();
                                break;
                            }
                        }
                        this.imageUrl = (matchedImg != null) ? matchedImg : product.getImages().get(0).getImageUrl();
                    }
                }
            }
        }
    }

    public static String formatMoney(BigDecimal amount) {
        if (amount == null) return "0đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.getDefault());
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###đ", symbols);
        return df.format(amount);
    }

    public String getFormattedUnitPrice() {
        return formatMoney(this.unitPrice);
    }

    public String getFormattedSubtotal() {
        return formatMoney(this.subtotal);
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

    public int getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
}
