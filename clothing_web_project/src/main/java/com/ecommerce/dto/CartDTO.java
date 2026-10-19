package com.ecommerce.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CartDTO {
    private Long id;
    private Long userId;
    private List<CartItemDTO> items = new ArrayList<>();
    private int totalQuantity = 0;
    private BigDecimal subtotal = BigDecimal.ZERO;
    private String voucherCode;
    private BigDecimal discountAmount = BigDecimal.ZERO;
    private BigDecimal totalAmount = BigDecimal.ZERO;

    // Cảnh báo nếu voucher hết hạn / đơn không đủ minOrder hoặc sản phẩm thay đổi
    private String voucherWarning;
    private List<String> warnings = new ArrayList<>();
    private boolean canCheckout = true;

    public CartDTO() {}

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public List<CartItemDTO> getItems() {
        return items;
    }

    public void setItems(List<CartItemDTO> items) {
        this.items = (items != null) ? items : new ArrayList<>();
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = (subtotal != null) ? subtotal : BigDecimal.ZERO;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = (discountAmount != null) ? discountAmount : BigDecimal.ZERO;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = (totalAmount != null) ? totalAmount : BigDecimal.ZERO;
    }

    public String getVoucherWarning() {
        return voucherWarning;
    }

    public void setVoucherWarning(String voucherWarning) {
        this.voucherWarning = voucherWarning;
    }

    public List<String> getWarnings() {
        return warnings;
    }

    public void setWarnings(List<String> warnings) {
        this.warnings = (warnings != null) ? warnings : new ArrayList<>();
    }

    public boolean isCanCheckout() {
        return canCheckout;
    }

    public void setCanCheckout(boolean canCheckout) {
        this.canCheckout = canCheckout;
    }

    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
}
