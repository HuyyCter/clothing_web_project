package com.ecommerce.repository;

import java.util.List;
import com.ecommerce.model.Order;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class OrderDB {
    public static void update(EntityManager em, Order order) {
        em.merge(order);
    }

    public static Order findById(EntityManager em, int id) {
        return em.find(Order.class, id);
    }

    public static List<Order> findAll(EntityManager em) {
        String queryString = "SELECT o FROM Order o ORDER BY o.id";
        TypedQuery<Order> query = em.createQuery(queryString, Order.class);
        return query.getResultList();
    }
}
