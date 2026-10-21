package com.ecommerce.repository;

import java.util.List;
import com.ecommerce.model.ProductImage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class ProductImageDB {
    public static void insert(EntityManager em, ProductImage productImage) {
        em.persist(productImage);
    }

    public static void update(EntityManager em, ProductImage productImage) {
        em.merge(productImage);
    }

    public static void delete(EntityManager em, ProductImage productImage) {
        em.remove(em.merge(productImage));
    }

    public static ProductImage findById(EntityManager em, int id) {
        return em.find(ProductImage.class, id);
    }

    public static List<ProductImage> findByProductId(EntityManager em, int productId) {
        String queryString = "SELECT pi FROM ProductImage pi WHERE pi.product.id = :productId ORDER BY pi.id";
        TypedQuery<ProductImage> query = em.createQuery(queryString, ProductImage.class);
        query.setParameter("productId", productId);
        return query.getResultList();
    }
    public static ProductImage findByProductIdAndColor(
            EntityManager em, int productId, String color) {

        String queryString =
                "SELECT pi FROM ProductImage pi " +
                "WHERE pi.product.id = :productId " +
                "AND LOWER(pi.color) = LOWER(:color) " +
                "ORDER BY pi.id";

        TypedQuery<ProductImage> query =
                em.createQuery(queryString, ProductImage.class);

        query.setParameter("productId", productId);
        query.setParameter("color", color);
        query.setMaxResults(1);

        List<ProductImage> result = query.getResultList();

        return result.isEmpty() ? null : result.get(0);
    }
    public static boolean isProductImageIdExists(EntityManager em, int id) {
        String queryString = "SELECT COUNT(pi) FROM ProductImage pi WHERE pi.id = :id";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }
}
