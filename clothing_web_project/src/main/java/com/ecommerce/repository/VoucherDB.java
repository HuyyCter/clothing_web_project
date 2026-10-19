package com.ecommerce.repository;

import java.util.List;
import com.ecommerce.model.Voucher;
import jakarta.persistence.*;

public class VoucherDB {
    public static void insert(EntityManager em, Voucher voucher) {
        em.persist(voucher);
    }

    public static void update(EntityManager em, Voucher voucher) {
        em.merge(voucher);
    }

    public static void delete(EntityManager em, Voucher voucher) {
        em.remove(em.merge(voucher));
    }

    public static Voucher findById(EntityManager em, int id) {
        return em.find(Voucher.class, id);
    }

    public static List<Voucher> findAll(EntityManager em) {
        String queryString = "SELECT v FROM Voucher v ORDER BY v.createdAt DESC, v.id DESC";
        TypedQuery<Voucher> query = em.createQuery(queryString, Voucher.class);
        return query.getResultList();
    }

    public static boolean isVoucherIdExists(EntityManager em, int id) {
        String queryString = "SELECT COUNT(v) FROM Voucher v WHERE v.id = :id";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }

    public static boolean isCodeExists(EntityManager em, String code) {
        String queryString = "SELECT COUNT(v) FROM Voucher v WHERE v.code = :code";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("code", code);
        return query.getSingleResult() > 0;
    }

    public static boolean isCodeExcludingIdExists(EntityManager em, String code, int id) {
        String queryString = "SELECT COUNT(v) FROM Voucher v WHERE v.code = :code AND v.id <> :id";
        TypedQuery<Long> query = em.createQuery(queryString, Long.class);
        query.setParameter("code", code);
        query.setParameter("id", id);
        return query.getSingleResult() > 0;
    }

    public static Voucher findByCode(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) {
            return null;
        }
        String queryString = "SELECT v FROM Voucher v WHERE UPPER(v.code) = :code";
        TypedQuery<Voucher> query = em.createQuery(queryString, Voucher.class);
        query.setParameter("code", code.trim().toUpperCase());
        List<Voucher> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    public static Voucher findByCodeWithLock(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) {
            return null;
        }
        String queryString = "SELECT v FROM Voucher v WHERE UPPER(v.code) = :code";
        TypedQuery<Voucher> query = em.createQuery(queryString, Voucher.class);
        query.setParameter("code", code.trim().toUpperCase());
        query.setLockMode(LockModeType.PESSIMISTIC_WRITE);
        List<Voucher> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }
}
