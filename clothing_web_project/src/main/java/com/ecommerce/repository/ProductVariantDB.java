package com.ecommerce.repository;

import java.math.BigDecimal;
import java.util.List;
import com.ecommerce.model.ProductVariant;
import com.ecommerce.model.ProductVariantStatus;
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

    public static boolean isVariantExists(EntityManager em, int productId, String size, String color) {
        String queryString = "SELECT COUNT(pv) FROM ProductVariant pv WHERE pv.product.id = :productId AND pv.size = :size AND pv.color = :color";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("productId", productId);
        query.setParameter("size", size);
        query.setParameter("color", color);
        return query.getSingleResult() > 0;
    }

    public static int updateVariantInfo(EntityManager em, int productId, String size, String color, String sku, BigDecimal price) {
        String queryString = "UPDATE ProductVariant pv SET pv.sku = :sku, pv.price = :price "
                + "WHERE pv.product.id = :productId AND pv.size = :size AND pv.color = :color";
        Query query = em.createQuery(queryString);
        query.setParameter("productId", productId);
        query.setParameter("size", size);
        query.setParameter("color", color);
        query.setParameter("sku", sku);
        query.setParameter("price", price);
        return query.executeUpdate();
    }

    public static int updateStatusByVariant(EntityManager em, int productId, String size, String color, ProductVariantStatus from,
            ProductVariantStatus to) {
        String queryString = "UPDATE ProductVariant pv SET pv.status = :to "
                + "WHERE pv.product.id = :productId AND pv.size = :size AND pv.color = :color AND pv.status = :from";
        Query query = em.createQuery(queryString);
        query.setParameter("productId", productId);
        query.setParameter("size", size);
        query.setParameter("color", color);
        query.setParameter("from", from);
        query.setParameter("to", to);
        return query.executeUpdate();
    }

    public static ProductVariant findFirstByVariant(EntityManager em, int productId, String size, String color) {
        String queryString =
                "SELECT pv FROM ProductVariant pv WHERE pv.product.id = :productId AND pv.size = :size AND pv.color = :color ORDER BY pv.id";
        TypedQuery<ProductVariant> query = em.createQuery(queryString, ProductVariant.class);
        query.setParameter("productId", productId);
        query.setParameter("size", size);
        query.setParameter("color", color);
        query.setMaxResults(1);
        List<ProductVariant> result = query.getResultList();
        return result.isEmpty() ? null : result.get(0);
    }

    public static Long countVariantByStatus(EntityManager em, int productId, String size, String color, ProductVariantStatus status) {
        String queryString =
                "SELECT COUNT(pv) FROM ProductVariant pv WHERE pv.product.id = :productId AND pv.size = :size AND pv.color = :color AND pv.status = :status";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("productId", productId);
        query.setParameter("size", size);
        query.setParameter("color", color);
        query.setParameter("status", status);
        return query.getSingleResult();
    }

    // ==================== Phúc Nguyên ====================
    public static List<ProductVariant> findAll(EntityManager em) {
        String queryString = "SELECT pv FROM ProductVariant pv ORDER BY pv.id DESC";
        return em.createQuery(queryString, ProductVariant.class).getResultList();
    }
}
