package com.ecommerce.dto;

import java.time.LocalDateTime;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderStatus;

public class OrderDTO {
    private int id;
    private int userId;
    private OrderStatus status;
    private LocalDateTime createdAt;

    public OrderDTO() {}

    public static OrderDTO fromEntity(Order order) {
        OrderDTO dto = new OrderDTO();
        dto.id = order.getId();
        dto.userId = (order.getUser() != null) ? order.getUser().getId() : 0;
        dto.status = order.getStatus();
        dto.createdAt = order.getCreatedAt();
        return dto;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
