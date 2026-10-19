package com.ecommerce.repository;

import com.ecommerce.model.Cart;
import com.ecommerce.model.CartItem;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class CartDB {

    public static Cart findByUserId(EntityManager em, Long userId) {
        if (userId == null) {
            return null;
        }
        String queryString = "SELECT DISTINCT c FROM Cart c LEFT JOIN FETCH c.items i LEFT JOIN FETCH i.productVariant pv LEFT JOIN FETCH pv.product WHERE c.user.id = :userId";
        TypedQuery<Cart> query = em.createQuery(queryString, Cart.class);
        query.setParameter("userId", userId.intValue());
        List<Cart> list = query.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    public static Cart findById(EntityManager em, Long id) {
        if (id == null) {
            return null;
        }
        String queryString = "SELECT DISTINCT c FROM Cart c LEFT JOIN FETCH c.items i LEFT JOIN FETCH i.productVariant pv LEFT JOIN FETCH pv.product WHERE c.id = :id";
        TypedQuery<Cart> query = em.createQuery(queryString, Cart.class);
        query.setParameter("id", id.intValue());
        List<Cart> list = query.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    public static void insert(EntityManager em, Cart cart) {
        em.persist(cart);
    }

    public static void update(EntityManager em, Cart cart) {
        em.merge(cart);
    }

    public static void delete(EntityManager em, Cart cart) {
        em.remove(em.merge(cart));
    }

    public static CartItem findItemById(EntityManager em, Long itemId) {
        if (itemId == null) {
            return null;
        }
        return em.find(CartItem.class, itemId.intValue());
    }

    public static void deleteItem(EntityManager em, CartItem item) {
        if (item != null) {
            em.remove(em.merge(item));
        }
    }
}
