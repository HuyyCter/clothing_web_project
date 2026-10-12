
package com.ecommerce.repository;

import com.ecommerce.model.Product;
import com.ecommerce.model.WishlistItem;

import jakarta.persistence.EntityManager;

import java.util.List;

public class WishlistRepository {

    public boolean exists(
            EntityManager entityManager,
            Integer userId,
            Integer productId) {

        Long count = entityManager.createQuery(
                "SELECT COUNT(w) FROM WishlistItem w " +
                "WHERE w.userId = :userId " +
                "AND w.product.id = :productId",
                Long.class
        )
        .setParameter("userId", userId)
        .setParameter("productId", productId)
        .getSingleResult();

        return count > 0;
    }

    public void add(
            EntityManager entityManager,
            Integer userId,
            Integer productId) {

        if (exists(entityManager, userId, productId)) {
            return;
        }

        Product product = entityManager.find(
                Product.class,
                productId
        );

        if (product == null) {
            throw new IllegalArgumentException(
                    "Không tìm thấy sản phẩm."
            );
        }

        WishlistItem item = new WishlistItem();
        item.setUserId(userId);
        item.setProduct(product);

        entityManager.persist(item);
    }

    public void remove(
            EntityManager entityManager,
            Integer userId,
            Integer productId) {

        List<WishlistItem> items = entityManager.createQuery(
                "SELECT w FROM WishlistItem w " +
                "WHERE w.userId = :userId " +
                "AND w.product.id = :productId",
                WishlistItem.class
        )
        .setParameter("userId", userId)
        .setParameter("productId", productId)
        .getResultList();

        for (WishlistItem item : items) {
            entityManager.remove(item);
        }
    }

    public List<WishlistItem> findByUserId(
            EntityManager entityManager,
            Integer userId) {

        return entityManager.createQuery(
                "SELECT w FROM WishlistItem w " +
                "JOIN FETCH w.product " +
                "WHERE w.userId = :userId " +
                "ORDER BY w.createdAt DESC",
                WishlistItem.class
        )
        .setParameter("userId", userId)
        .getResultList();
    }
}
