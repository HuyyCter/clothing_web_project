package com.ecommerce.repository;

import java.util.List;

import com.ecommerce.model.Product;
import com.ecommerce.model.WishlistItem;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class WishlistDB {

    public static boolean exists(EntityManager em, Integer userId, Integer productId) {
        String queryString = "SELECT COUNT(w) FROM WishlistItem w WHERE w.userId = :userId AND w.product.id = :productId";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("userId", userId);
        query.setParameter("productId", productId);
        return query.getSingleResult() > 0;
    }

    public static void add(EntityManager em, Integer userId, Integer productId) {
        if (exists(em, userId, productId)) {
            return;
        }

        Product product = em.find(Product.class, productId);

        if (product == null) {
            throw new IllegalArgumentException("Không tìm thấy sản phẩm.");
        }

        WishlistItem item = new WishlistItem();
        item.setUserId(userId);
        item.setProduct(product);

        em.persist(item);
    }

    public static void remove(EntityManager em, Integer userId, Integer productId) {
        String queryString = "SELECT w FROM WishlistItem w WHERE w.userId = :userId AND w.product.id = :productId";
        TypedQuery<WishlistItem> query = em.createQuery(queryString, WishlistItem.class);
        query.setParameter("userId", userId);
        query.setParameter("productId", productId);

        for (WishlistItem item : query.getResultList()) {
            em.remove(item);
        }
    }

    public static List<WishlistItem> findByUserId(EntityManager em, Integer userId) {
        String queryString = "SELECT w FROM WishlistItem w JOIN FETCH w.product WHERE w.userId = :userId ORDER BY w.createdAt DESC";
        TypedQuery<WishlistItem> query = em.createQuery(queryString, WishlistItem.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }
}
