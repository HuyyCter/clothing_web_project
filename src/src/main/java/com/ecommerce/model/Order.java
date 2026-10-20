package com.ecommerce.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import com.ecommerce.dto.CategoryDTO;
import com.ecommerce.dto.OrderDTO;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.exception.NotFoundException;
import com.ecommerce.repository.CategoryDB;
import com.ecommerce.repository.OrderDB;
import com.ecommerce.util.JpaUtil;

@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // 1 Order - N OrderItem (Composition)
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private OrderStatus status;

    @Column(name = "total_amount", precision = 12, scale = 2)
    private java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;

    @Column(name = "shipping_recipient_name")
    private String shippingRecipientName;

    @Column(name = "shipping_phone")
    private String shippingPhone;

    @Column(name = "shipping_address_line")
    private String shippingAddressLine;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "note")
    private String note;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public Order() {}

    public Order(User user) {
        this.user = user;
        this.status = OrderStatus.PENDING;
        this.createdAt = LocalDateTime.now();
    }

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public java.math.BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(java.math.BigDecimal totalAmount) {
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

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // ==========================================
    // METHODS
    // ==========================================
    public static void updateStatus(int orderId, OrderStatus newStatus) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            Order order = OrderDB.findById(em, orderId);
            if (order == null) {
                throw new NotFoundException("Không tìm thấy đơn hàng có id = " + orderId);
            }
            if (newStatus == null || !canSwitchStatusTo(order, newStatus)) {
                throw new BusinessException("Không thể chuyển trạng thái đơn hàng từ " + order.getStatus() + " sang " + newStatus);
            }

            order.setStatus(newStatus);

            if (newStatus == OrderStatus.CANCELLED) {
                // TODO: chỉnh lại các ProductVariantStatus trong ProductVariant từ SOLD thành AVAILABEL
            }

            OrderDB.update(em, order);

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static List<OrderDTO> getAll() {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            List<OrderDTO> orders = new ArrayList<>();
            for (Order order : OrderDB.findAll(em)) {
                orders.add(new OrderDTO(order));
            }
            return orders;
        } finally {
            em.close();
        }
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================

    // PENDING -> CONFIRMED -> SHIPPING -> DELIVERED (CANCELLED)
    private static boolean canSwitchStatusTo(Order order, OrderStatus status) {
        boolean canSwitch = false;
        switch (order.getStatus()) {
            case PENDING:
                canSwitch = (status == OrderStatus.CONFIRMED || status == OrderStatus.CANCELLED);
                break;
            case CONFIRMED:
                canSwitch = (status == OrderStatus.SHIPPING || status == OrderStatus.CANCELLED);
                break;
            case SHIPPING:
                canSwitch = status == OrderStatus.DELIVERED;
                break;
            default:
                break;
        }
        return canSwitch;
    }
}
