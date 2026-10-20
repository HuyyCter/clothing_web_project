package com.ecommerce.dto;

import com.ecommerce.model.PaymentMethod;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Toàn bộ dữ liệu cần để Module Order tạo đơn hàng SAU KHI cổng thanh toán
 * online (MoMo) đã xác nhận trả tiền thành công. Được truyền vào
 * {@link com.ecommerce.model.PaidOrderCreator#createPaidOrder}.
 */
public class PaidCheckoutDTO {
    private int userId;
    private List<PaidCheckoutItemDTO> items = new ArrayList<>();
    private BigDecimal subtotal = BigDecimal.ZERO;
    private String voucherCode;
    private BigDecimal discountAmount = BigDecimal.ZERO;
    private BigDecimal totalAmount = BigDecimal.ZERO;

    // Snapshot thông tin giao hàng (invariant 7 trong architecture.md)
    private String shippingRecipientName;
    private String shippingPhone;
    private String shippingAddress;
    private String note;

    private PaymentMethod paymentMethod;
    private String transactionCode;   // transId do MoMo cấp
    private String gatewayOrderId;    // orderId mình gửi sang MoMo
    private LocalDateTime paidAt;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public List<PaidCheckoutItemDTO> getItems() { return items; }
    public void setItems(List<PaidCheckoutItemDTO> items) { this.items = items; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    public String getVoucherCode() { return voucherCode; }
    public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getShippingRecipientName() { return shippingRecipientName; }
    public void setShippingRecipientName(String shippingRecipientName) { this.shippingRecipientName = shippingRecipientName; }
    public String getShippingPhone() { return shippingPhone; }
    public void setShippingPhone(String shippingPhone) { this.shippingPhone = shippingPhone; }
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getTransactionCode() { return transactionCode; }
    public void setTransactionCode(String transactionCode) { this.transactionCode = transactionCode; }
    public String getGatewayOrderId() { return gatewayOrderId; }
    public void setGatewayOrderId(String gatewayOrderId) { this.gatewayOrderId = gatewayOrderId; }
    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }
}
