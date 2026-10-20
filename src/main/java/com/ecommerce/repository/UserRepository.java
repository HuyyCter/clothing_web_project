package com.ecommerce.repository;

import com.ecommerce.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class UserRepository {

    private final EntityManager em;

    public UserRepository() {
        this.em = null;
    }

    public UserRepository(EntityManager em) {
        this.em = em;
    }

    private EntityManager getEffectiveEntityManager(EntityManager externalEm) {
        if (externalEm != null) {
            return externalEm;
        }
        if (this.em != null) {
            return this.em;
        }
        throw new IllegalStateException("EntityManager chưa được cung cấp cho UserRepository.");
    }

    public Optional<User> findById(int id) {
        return findById(null, id);
    }

    public Optional<User> findById(EntityManager em, int id) {
        EntityManager activeEm = getEffectiveEntityManager(em);
        User user = activeEm.find(User.class, id);
        return Optional.ofNullable(user);
    }

    public Optional<User> findByEmail(String email) {
        return findByEmail(null, email);
    }

    public Optional<User> findByEmail(EntityManager em, String email) {
        if (email == null || email.isBlank()) {
            return Optional.empty();
        }
        EntityManager activeEm = getEffectiveEntityManager(em);
        String jpql = "SELECT u FROM User u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:email))";
        TypedQuery<User> query = activeEm.createQuery(jpql, User.class);
        query.setParameter("email", email);

        List<User> results = query.getResultList();
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    public Optional<User> findByPhone(String phone) {
        return findByPhone(null, phone);
    }

    public Optional<User> findByPhone(EntityManager em, String phone) {
        if (phone == null || phone.isBlank()) {
            return Optional.empty();
        }
        EntityManager activeEm = getEffectiveEntityManager(em);
        String jpql = "SELECT u FROM User u WHERE TRIM(u.phone) = TRIM(:phone)";
        TypedQuery<User> query = activeEm.createQuery(jpql, User.class);
        query.setParameter("phone", phone);

        List<User> results = query.getResultList();
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    public Optional<User> findByEmailOrPhone(String identifier) {
        return findByEmailOrPhone(null, identifier);
    }

    public Optional<User> findByEmailOrPhone(EntityManager em, String identifier) {
        if (identifier == null || identifier.isBlank()) {
            return Optional.empty();
        }
        EntityManager activeEm = getEffectiveEntityManager(em);
        String jpql = "SELECT u FROM User u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:id)) OR TRIM(u.phone) = TRIM(:id)";
        TypedQuery<User> query = activeEm.createQuery(jpql, User.class);
        query.setParameter("id", identifier.trim());

        List<User> results = query.getResultList();
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    public boolean existsByEmail(String email) {
        return existsByEmail(null, email);
    }

    public boolean existsByEmail(EntityManager em, String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        EntityManager activeEm = getEffectiveEntityManager(em);
        String jpql = "SELECT COUNT(u) FROM User u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:email))";
        Long count = activeEm.createQuery(jpql, Long.class).setParameter("email", email).getSingleResult();
        return count != null && count > 0;
    }

    public boolean existsByPhone(String phone) {
        return existsByPhone(null, phone);
    }

    public boolean existsByPhone(EntityManager em, String phone) {
        if (phone == null || phone.isBlank()) {
            return false;
        }
        EntityManager activeEm = getEffectiveEntityManager(em);
        String jpql = "SELECT COUNT(u) FROM User u WHERE TRIM(u.phone) = TRIM(:phone)";
        Long count = activeEm.createQuery(jpql, Long.class).setParameter("phone", phone).getSingleResult();
        return count != null && count > 0;
    }

    public User save(User user) {
        return save(null, user);
    }

    public User save(EntityManager em, User user) {
        if (user == null) {
            throw new IllegalArgumentException("User không được là null khi lưu.");
        }
        EntityManager activeEm = getEffectiveEntityManager(em);
        if (user.getId() == 0) {
            activeEm.persist(user);
            return user;
        } else {
            return activeEm.merge(user);
        }
    }

    public void delete(User user) {
        delete(null, user);
    }

    public void delete(EntityManager em, User user) {
        if (user == null) {
            return;
        }
        EntityManager activeEm = getEffectiveEntityManager(em);
        User managedUser = activeEm.contains(user) ? user : activeEm.merge(user);
        activeEm.remove(managedUser);
    }

    public List<User> findAll(int offset, int limit) {
        return findAll(null, offset, limit);
    }

    public List<User> findAll(EntityManager em, int offset, int limit) {
        EntityManager activeEm = getEffectiveEntityManager(em);
        String jpql = "SELECT u FROM User u ORDER BY u.id DESC";
        TypedQuery<User> query = activeEm.createQuery(jpql, User.class);
        if (offset >= 0) {
            query.setFirstResult(offset);
        }
        if (limit > 0) {
            query.setMaxResults(limit);
        }
        return query.getResultList();
    }

    public long count() {
        return count(null);
    }

    public long count(EntityManager em) {
        EntityManager activeEm = getEffectiveEntityManager(em);
        String jpql = "SELECT COUNT(u) FROM User u";
        Long count = activeEm.createQuery(jpql, Long.class).getSingleResult();
        return count != null ? count : 0L;
    }
}
