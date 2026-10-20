package com.ecommerce.repository;

import com.ecommerce.model.MomoTransaction;
import com.ecommerce.model.Payment;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.TypedQuery;

import java.util.List;

/**
 * DAO cho bảng momo_transactions. Chỉ chứa query, không mở transaction,
 * không business logic (transaction do Model MomoTransaction quản lý).
 */
public class MomoTransactionDB {

    public static void insert(EntityManager em, MomoTransaction tx) {
        em.persist(tx);
    }

    public static void update(EntityManager em, MomoTransaction tx) {
        em.merge(tx);
    }

    /** Ghi bản ghi Payment (method = MOMO) sau khi đơn hàng được tạo. */
    public static void insertPayment(EntityManager em, Payment payment) {
        em.persist(payment);
    }

    public static MomoTransaction findByMomoOrderId(EntityManager em, String momoOrderId) {
        TypedQuery<MomoTransaction> q = em.createQuery(
                "SELECT t FROM MomoTransaction t WHERE t.momoOrderId = :oid", MomoTransaction.class);
        q.setParameter("oid", momoOrderId);
        List<MomoTransaction> list = q.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * Tìm và khóa dòng giao dịch (SELECT ... FOR UPDATE) để IPN và redirect
     * đến cùng lúc không xử lý trùng 1 giao dịch.
     */
    public static MomoTransaction findByMomoOrderIdForUpdate(EntityManager em, String momoOrderId) {
        TypedQuery<MomoTransaction> q = em.createQuery(
                "SELECT t FROM MomoTransaction t WHERE t.momoOrderId = :oid", MomoTransaction.class);
        q.setParameter("oid", momoOrderId);
        q.setLockMode(LockModeType.PESSIMISTIC_WRITE);
        List<MomoTransaction> list = q.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }
}
