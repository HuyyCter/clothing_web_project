package com.ecommerce.repository;

import java.math.BigDecimal;
import java.util.*;
import com.ecommerce.model.Product;
import jakarta.persistence.*;

public class ProductDB {
    public static void insert(EntityManager em, Product product) {
        em.persist(product);
    }

    public static void update(EntityManager em, Product product) {
        em.merge(product);
    }

    public static void delete(EntityManager em, Product product) {
        em.remove(em.merge(product));
    }

    public static Product findById(EntityManager em, int id) {
        return em.find(Product.class, id);
    }

    public static List<Product> findAll(EntityManager em) {
        String queryString = "SELECT p FROM Product p JOIN p.category ORDER BY p.id";
        TypedQuery<Product> query = em.createQuery(queryString, Product.class);
        return query.getResultList();
    }

    public static boolean isProductIdExists(EntityManager em, int id) {
        String queryString = "SELECT COUNT(p) FROM Product p WHERE p.id = :id";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }

    public static Long countAll(EntityManager em) {
        String queryString = "SELECT COUNT(p) FROM Product p";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        return query.getSingleResult();
    }

    public static boolean isCategoryInUse(EntityManager em, int categoryId) {
        String queryString = "SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("categoryId", categoryId);
        return query.getSingleResult() > 0;
    }

    public static Map<Integer, String> findFirstImageUrls(EntityManager em, List<Product> products) {
        Map<Integer, String> imageUrls = new HashMap<>();

        // Không có sản phẩm thì không cần truy vấn
        if (products == null || products.isEmpty()) {
            return imageUrls;
        }

        List<Integer> productIds = products.stream().map(Product::getId).toList();

        String queryString = "SELECT i.product.id, i.imageUrl FROM ProductImage i " + "WHERE i.product.id IN :productIds "
                + "AND i.id = (SELECT MIN(i2.id) FROM ProductImage i2 WHERE i2.product.id = i.product.id)";
        TypedQuery<Object[]> query = em.createQuery(queryString, Object[].class);
        query.setParameter("productIds", productIds);

        for (Object[] row : query.getResultList()) {
            imageUrls.put((Integer)row[0], (String)row[1]);
        }

        return imageUrls;
    }


    // ==================== Phúc Nguyên ====================
    public static List<Product> findAll(EntityManager em) {
        String queryString = "SELECT p FROM Product p";
        return em.createQuery(queryString, Product.class).getResultList();
    }

    public static List<Product> findByCategoryId(EntityManager em, int categoryId) {
        String queryString = "SELECT p FROM Product p WHERE p.category.id = :categoryId";
        TypedQuery<Product> query = em.createQuery(queryString, Product.class);
        query.setParameter("categoryId", categoryId);
        return query.getResultList();
    }

    public static Map<Integer, BigDecimal> findMinVariantPrices(EntityManager em, List<Product> products) {
        Map<Integer, BigDecimal> minPrices = new HashMap<>();

        // Không có sản phẩm thì không cần truy vấn
        if (products == null || products.isEmpty()) {
            return minPrices;
        }

        List<Integer> productIds = products.stream().map(Product::getId).toList();

        String queryString = "SELECT v.product.id, MIN(v.price) " + "FROM ProductVariant v " + "WHERE v.product.id IN :productIds "
                + "GROUP BY v.product.id";
        TypedQuery<Object[]> query = em.createQuery(queryString, Object[].class);
        query.setParameter("productIds", productIds);

        for (Object[] row : query.getResultList()) {
            Integer productId = (Integer)row[0];
            BigDecimal minPrice = (BigDecimal)row[1];
            minPrices.put(productId, minPrice);
        }

        return minPrices;
    }

    public static List<Product> findPage(EntityManager em, String search, Integer categoryId, String sort, int page, int pageSize) {
        String queryString = "SELECT p FROM Product p LEFT JOIN ProductVariant v ON v.product = p WHERE 1 = 1 ";

        if (search != null && !search.isBlank()) {
            queryString += "AND LOWER(p.name) LIKE LOWER(:search) ";
        }

        if (categoryId != null) {
            queryString += "AND p.category.id = :categoryId ";
        }

        queryString += "GROUP BY p ";

        if ("asc".equals(sort)) {
            queryString += "ORDER BY MIN(v.price) ASC NULLS LAST, p.id DESC ";
        } else if ("desc".equals(sort)) {
            queryString += "ORDER BY MIN(v.price) DESC NULLS LAST, p.id DESC ";
        } else {
            queryString += "ORDER BY p.id DESC ";
        }

        TypedQuery<Product> query = em.createQuery(queryString, Product.class);

        if (search != null && !search.isBlank()) {
            query.setParameter("search", "%" + search.trim() + "%");
        }

        if (categoryId != null) {
            query.setParameter("categoryId", categoryId);
        }

        query.setFirstResult((page - 1) * pageSize);
        query.setMaxResults(pageSize);
        return query.getResultList();
    }

    public static long count(EntityManager em, String search, Integer categoryId) {
        String queryString = "SELECT COUNT(p) FROM Product p WHERE 1 = 1 ";

        if (search != null && !search.isBlank()) {
            queryString += "AND LOWER(p.name) LIKE LOWER(:search) ";
        }

        if (categoryId != null) {
            queryString += "AND p.category.id = :categoryId ";
        }

        TypedQuery<Long> query = em.createQuery(queryString, Long.class);

        if (search != null && !search.isBlank()) {
            query.setParameter("search", "%" + search.trim() + "%");
        }

        if (categoryId != null) {
            query.setParameter("categoryId", categoryId);
        }

        return query.getSingleResult();
    }
}
