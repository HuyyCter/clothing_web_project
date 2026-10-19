package com.ecommerce.dto;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.OrderStatus;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class OrderDTO {
    private int id;
    private String orderCode;
    private OrderStatus status;
    private String statusName;
    private String statusBadgeClass;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private String shippingRecipientName;
    private String shippingPhone;
    private String shippingAddressLine;
    private String paymentMethod;
    private String note;
    private LocalDateTime createdAt;
    private String formattedCreatedAt;
    private List<OrderItemDTO> items = new ArrayList<>();
    private int totalQuantity = 0;
    private boolean canCancel = false;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public OrderDTO() {
    }

    public OrderDTO(Order order) {
        if (order != null) {
            this.id = order.getId();
            this.orderCode = String.format("#%05d", order.getId());
            this.status = order.getStatus();
            resolveStatusInfo(order.getStatus());

            this.totalAmount = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
            this.shippingRecipientName = order.getShippingRecipientName();
            this.shippingPhone = order.getShippingPhone();
            this.shippingAddressLine = order.getShippingAddressLine();
            this.paymentMethod = order.getPaymentMethod() != null ? order.getPaymentMethod().toUpperCase() : "COD";
            this.note = order.getNote();
            this.createdAt = order.getCreatedAt();
            if (this.createdAt != null) {
                this.formattedCreatedAt = this.createdAt.format(DATE_FORMATTER);
            }

            if (order.getItems() != null) {
                BigDecimal calculatedTotal = BigDecimal.ZERO;
                for (OrderItem item : order.getItems()) {
                    OrderItemDTO itemDTO = new OrderItemDTO(item);
                    this.items.add(itemDTO);
                    this.totalQuantity += itemDTO.getQuantity();
                    calculatedTotal = calculatedTotal.add(itemDTO.getSubtotal());
                }
                // Nếu totalAmount của Order chưa được lưu hoặc bằng 0, tính tổng từ các items
                if (this.totalAmount.compareTo(BigDecimal.ZERO) == 0 && calculatedTotal.compareTo(BigDecimal.ZERO) > 0) {
                    this.totalAmount = calculatedTotal;
                }
            }

            // Theo Invariant 2: Hủy chỉ được phép thực hiện từ "Chờ xác nhận" (PENDING) hoặc "Đã xác nhận" (CONFIRMED)
            this.canCancel = (this.status == OrderStatus.PENDING || this.status == OrderStatus.CONFIRMED);
        }
    }

    private void resolveStatusInfo(OrderStatus status) {
        if (status == null) {
            this.statusName = "Chưa xác định";
            this.statusBadgeClass = "order-status--pending";
            return;
        }

        switch (status) {
            case PENDING:
                this.statusName = "Chờ xác nhận";
                this.statusBadgeClass = "order-status--pending";
                break;
            case CONFIRMED:
                this.statusName = "Đã xác nhận";
                this.statusBadgeClass = "order-status--confirmed";
                break;
            case SHIPPING:
                this.statusName = "Đang giao hàng";
                this.statusBadgeClass = "order-status--shipping";
                break;
            case DELIVERED:
                this.statusName = "Giao thành công";
                this.statusBadgeClass = "order-status--delivered";
                break;
            case CANCELLED:
                this.statusName = "Đã hủy";
                this.statusBadgeClass = "order-status--cancelled";
                break;
            default:
                this.statusName = status.name();
                this.statusBadgeClass = "order-status--pending";
                break;
        }
    }

    public static String formatMoney(BigDecimal amount) {
        if (amount == null) return "0đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.getDefault());
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###đ", symbols);
        return df.format(amount);
    }

    public String getFormattedTotalAmount() {
        return formatMoney(this.totalAmount);
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

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
        resolveStatusInfo(status);
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public String getStatusBadgeClass() {
        return statusBadgeClass;
    }

    public void setStatusBadgeClass(String statusBadgeClass) {
        this.statusBadgeClass = statusBadgeClass;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingRecipientName() {
        return shippingRecipientName;
    }

    public void setShippingRecipientName(String shippingRecipientName) {
        this.shippingRecipientName = shippingRecipientName;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public String getShippingAddressLine() {
        return shippingAddressLine;
    }

    public void setShippingAddressLine(String shippingAddressLine) {
        this.shippingAddressLine = shippingAddressLine;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedCreatedAt() {
        return formattedCreatedAt;
    }

    public void setFormattedCreatedAt(String formattedCreatedAt) {
        this.formattedCreatedAt = formattedCreatedAt;
    }

    public List<OrderItemDTO> getItems() {
        return items;
    }

    public void setItems(List<OrderItemDTO> items) {
        this.items = (items != null) ? items : new ArrayList<>();
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public boolean isCanCancel() {
        return canCancel;
    }

    public void setCanCancel(boolean canCancel) {
        this.canCancel = canCancel;
    }
}
