package com.ecommerce.repository;

import java.util.List;
import com.ecommerce.model.ProductVariant;
import jakarta.persistence.*;

public class ProductVariantDB {
    public static void insert(EntityManager em, ProductVariant productVariant) {
        em.persist(productVariant);
    }

    public static void update(EntityManager em, ProductVariant productVariant) {
        em.merge(productVariant);
    }

    public static void delete(EntityManager em, ProductVariant productVariant) {
        em.remove(em.merge(productVariant));
    }

    public static ProductVariant findById(EntityManager em, int id) {
        return em.find(ProductVariant.class, id);
    }

    public static List<ProductVariant> findByProductId(EntityManager em, int productId) {
        String queryString = "SELECT pv FROM ProductVariant pv WHERE pv.product.id = :productId ORDER BY pv.id";
        TypedQuery<ProductVariant> query = em.createQuery(queryString, ProductVariant.class);
        query.setParameter("productId", productId);
        return query.getResultList();
    }

    public static boolean isSkuExists(EntityManager em, String sku) {
        String queryString = "SELECT COUNT(pv) FROM ProductVariant pv WHERE pv.sku = :sku";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("sku", sku);
        return query.getSingleResult() > 0;
    }

    public static boolean isSkuExcludingIdExists(EntityManager em, String sku, int id) {
        String queryString = "SELECT COUNT(pv) FROM ProductVariant pv WHERE pv.sku = :sku AND pv.id <> :id";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("sku", sku);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }
}
