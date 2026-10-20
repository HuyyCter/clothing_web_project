package com.ecommerce.repository;

import java.util.List;
import java.util.Optional;

import com.ecommerce.model.User;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class UserDB {

    // ===== CRUD =====

    public static User save(EntityManager em, User user) {
        if (user == null) {
            throw new IllegalArgumentException("User không được là null khi lưu.");
        }
        if (user.getId() == 0) {
            em.persist(user);
            return user;
        } else {
            return em.merge(user);
        }
    }

    public static void delete(EntityManager em, User user) {
        if (user == null) {
            return;
        }
        User managedUser = em.contains(user) ? user : em.merge(user);
        em.remove(managedUser);
    }

    public static Optional<User> findById(EntityManager em, int id) {
        User user = em.find(User.class, id);
        return Optional.ofNullable(user);
    }

    // ===== Query: tìm theo trường =====

    public static Optional<User> findByEmail(EntityManager em, String email) {
        if (email == null || email.isBlank()) {
            return Optional.empty();
        }

        String queryString = "SELECT u FROM User u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:email))";
        TypedQuery<User> query = em.createQuery(queryString, User.class);
        query.setParameter("email", email);

        List<User> results = query.getResultList();
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    public static Optional<User> findByPhone(EntityManager em, String phone) {
        if (phone == null || phone.isBlank()) {
            return Optional.empty();
        }

        String queryString = "SELECT u FROM User u WHERE TRIM(u.phone) = TRIM(:phone)";
        TypedQuery<User> query = em.createQuery(queryString, User.class);
        query.setParameter("phone", phone);

        List<User> results = query.getResultList();
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    public static Optional<User> findByEmailOrPhone(EntityManager em, String identifier) {
        if (identifier == null || identifier.isBlank()) {
            return Optional.empty();
        }
        String queryString = "SELECT u FROM User u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:id)) OR TRIM(u.phone) = TRIM(:id)";
        TypedQuery<User> query = em.createQuery(queryString, User.class);
        query.setParameter("id", identifier.trim());

        List<User> results = query.getResultList();
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    // ===== Query: danh sách =====

    public static List<User> findAll(EntityManager em, int offset, int limit) {
        String queryString = "SELECT u FROM User u ORDER BY u.id DESC";
        TypedQuery<User> query = em.createQuery(queryString, User.class);

        if (offset >= 0) {
            query.setFirstResult(offset);
        }
        if (limit > 0) {
            query.setMaxResults(limit);
        }
        return query.getResultList();
    }

    // ===== Query: đếm / kiểm tra tồn tại =====

    public static long count(EntityManager em) {
        String queryString = "SELECT COUNT(u) FROM User u";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        Long count = query.getSingleResult();
        return count != null ? count : 0L;
    }

    public static boolean existsByEmail(EntityManager em, String email) {
        if (email == null || email.isBlank()) {
            return false;
        }

        String queryString = "SELECT COUNT(u) FROM User u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:email))";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("email", email);
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }

    public static boolean existsByPhone(EntityManager em, String phone) {
        if (phone == null || phone.isBlank()) {
            return false;
        }

        String queryString = "SELECT COUNT(u) FROM User u WHERE TRIM(u.phone) = TRIM(:phone)";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("phone", phone);
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }
}
