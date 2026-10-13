package com.ecommerce.repository;

import java.util.List;
import com.ecommerce.model.Category;
import jakarta.persistence.*;

public class CategoryDB {
    public static void insert(EntityManager em, Category category) {
        em.persist(category);
    }

    public static void update(EntityManager em, Category category) {
        em.merge(category);
    }

    public static void delete(EntityManager em, Category category) {
        em.remove(em.merge(category));
    }

    public static Category findById(EntityManager em, int id) {
        return em.find(Category.class, id);
    }

    public static List<Category> findAll(EntityManager em) {
        String queryString = "SELECT c FROM Category c ORDER BY c.id";
        TypedQuery<Category> query = em.createQuery(queryString, Category.class);
        return query.getResultList();
    }

    public static boolean isCategoryIdExists(EntityManager em, int id) {
        String queryString = "SELECT COUNT(c) FROM Category c WHERE c.id = :id";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }

    public static boolean isSlugExists(EntityManager em, String slug) {
        String queryString = "SELECT COUNT(c) FROM Category c WHERE c.slug = :slug";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("slug", slug);
        return query.getSingleResult() > 0;
    }

    public static boolean isSlugExcludingIdExists(EntityManager em, String slug, int id) {
        String queryString = "SELECT COUNT(c) FROM Category c WHERE c.slug = :slug AND c.id <> :id";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("slug", slug);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }
}
