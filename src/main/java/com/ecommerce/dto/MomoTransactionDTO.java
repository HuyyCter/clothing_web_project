package com.ecommerce.dto;

import com.ecommerce.model.MomoTransactionStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/** Thông tin giao dịch MoMo hiển thị cho khách trên trang kết quả. */
public class MomoTransactionDTO {
    private String momoOrderId;
    private BigDecimal amount;
    private MomoTransactionStatus status;
    private Integer resultCode;
    private String message;
    private String transId;
    private String payType;
    private Integer orderId;
    private String orderError;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;

    public String getMomoOrderId() { return momoOrderId; }
    public void setMomoOrderId(String momoOrderId) { this.momoOrderId = momoOrderId; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public MomoTransactionStatus getStatus() { return status; }
    public void setStatus(MomoTransactionStatus status) { this.status = status; }
    public Integer getResultCode() { return resultCode; }
    public void setResultCode(Integer resultCode) { this.resultCode = resultCode; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getTransId() { return transId; }
    public void setTransId(String transId) { this.transId = transId; }
    public String getPayType() { return payType; }
    public void setPayType(String payType) { this.payType = payType; }
    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }
    public String getOrderError() { return orderError; }
    public void setOrderError(String orderError) { this.orderError = orderError; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");

    // Tiện cho JSTL (fmt:formatDate không đọc được LocalDateTime)
    public String getPaidAtText() { return paidAt != null ? paidAt.format(FMT) : ""; }
    public String getCreatedAtText() { return createdAt != null ? createdAt.format(FMT) : ""; }
    public boolean isSuccess() { return status == MomoTransactionStatus.SUCCESS; }
    public boolean isPending() { return status == MomoTransactionStatus.PENDING; }
    public boolean isFailed() { return status == MomoTransactionStatus.FAILED; }
}
