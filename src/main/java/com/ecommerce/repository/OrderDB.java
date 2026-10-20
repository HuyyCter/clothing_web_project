package com.ecommerce.repository;

import com.ecommerce.model.Address;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderStatus;
import com.ecommerce.model.Payment;
import com.ecommerce.model.ProductVariant;
import com.ecommerce.model.ProductVariantStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class OrderDB {

    public static List<Order> findByUserId(EntityManager em, int userId) {
        String queryString = "SELECT DISTINCT o FROM Order o " + "LEFT JOIN FETCH o.items i " + "LEFT JOIN FETCH i.productVariant pv "
                + "LEFT JOIN FETCH pv.product p " + "WHERE o.user.id = :userId " + "ORDER BY o.createdAt DESC, o.id DESC";
        TypedQuery<Order> query = em.createQuery(queryString, Order.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    public static Order findByIdAndUserId(EntityManager em, int orderId, int userId) {
        String queryString = "SELECT DISTINCT o FROM Order o " + "LEFT JOIN FETCH o.items i " + "LEFT JOIN FETCH i.productVariant pv "
                + "LEFT JOIN FETCH pv.product p " + "WHERE o.id = :orderId AND o.user.id = :userId";
        TypedQuery<Order> query = em.createQuery(queryString, Order.class);
        query.setParameter("orderId", orderId);
        query.setParameter("userId", userId);
        List<Order> list = query.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    public static Order findById(EntityManager em, int orderId) {
        String queryString = "SELECT DISTINCT o FROM Order o " + "LEFT JOIN FETCH o.items i " + "LEFT JOIN FETCH i.productVariant pv "
                + "LEFT JOIN FETCH pv.product p " + "WHERE o.id = :orderId";
        TypedQuery<Order> query = em.createQuery(queryString, Order.class);
        query.setParameter("orderId", orderId);
        List<Order> list = query.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    public static void insert(EntityManager em, Order order) {
        em.persist(order);
    }

    public static void update(EntityManager em, Order order) {
        em.merge(order);
    }

    // ================ Nguyễn Quang Huy ================
    public static List<Order> findAll(EntityManager em) {
        String queryString = "SELECT o FROM Order o ORDER BY o.id";
        TypedQuery<Order> query = em.createQuery(queryString, Order.class);
        return query.getResultList();
    }

    // ================ Nguyễn Phạm Thanh Tín (Module E: đặt hàng) ================

    /**
     * Khóa (SELECT ... FOR UPDATE) tối đa {@code limit} đơn vị hàng còn AVAILABLE cùng sản phẩm + size + màu.
     * Lấy id lớn trước để đơn vị id nhỏ nhất (trang sản phẩm thường bỏ vào giỏ) còn AVAILABLE lâu nhất.
     */
    public static List<ProductVariant> lockAvailableUnits(EntityManager em, int productId, String size, String color, int limit) {
        return lockUnits(em, productId, size, color, ProductVariantStatus.AVAILABLE, limit);
    }

    /** Khóa tối đa {@code limit} đơn vị đã bán (SOLD) cùng loại — dùng khi hủy đơn để hoàn kho. */
    public static List<ProductVariant> lockSoldUnits(EntityManager em, int productId, String size, String color, int limit) {
        return lockUnits(em, productId, size, color, ProductVariantStatus.SOLD, limit);
    }

    private static List<ProductVariant> lockUnits(EntityManager em, int productId, String size, String color,
            ProductVariantStatus status, int limit) {
        String queryString = "SELECT pv FROM ProductVariant pv WHERE pv.product.id = :productId AND pv.size = :size "
                + "AND pv.color = :color AND pv.status = :status ORDER BY pv.id DESC";
        TypedQuery<ProductVariant> query = em.createQuery(queryString, ProductVariant.class);
        query.setParameter("productId", productId);
        query.setParameter("size", size);
        query.setParameter("color", color);
        query.setParameter("status", status);
        query.setLockMode(LockModeType.PESSIMISTIC_WRITE);
        query.setMaxResults(limit);
        return query.getResultList();
    }

    /** Địa chỉ đã lưu của user (chỉ đọc), mặc định lên đầu — cho trang Checkout. */
    public static List<Address> findAddressesOfUser(EntityManager em, int userId) {
        TypedQuery<Address> query = em.createQuery(
                "SELECT a FROM Address a WHERE a.user.id = :uid ORDER BY a.isDefault DESC, a.id ASC", Address.class);
        query.setParameter("uid", userId);
        return query.getResultList();
    }

    public static void insertPayment(EntityManager em, Payment payment) {
        em.persist(payment);
    }
}
