package com.ecommerce.repository;

import java.util.List;
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

    public static List<Product> findAll(EntityManager em, int offset, int limit) {
        String queryString = "SELECT p FROM Product p JOIN p.category ORDER BY p.id";
        TypedQuery<Product> query = em.createQuery(queryString, Product.class);
        query.setFirstResult(offset);
        query.setMaxResults(limit);
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
}
