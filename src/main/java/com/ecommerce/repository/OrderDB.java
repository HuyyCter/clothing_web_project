package com.ecommerce.repository;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderStatus;
import jakarta.persistence.EntityManager;
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
}
