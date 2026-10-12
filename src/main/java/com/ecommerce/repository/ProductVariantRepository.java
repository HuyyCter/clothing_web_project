package com.ecommerce.repository;

import com.ecommerce.model.ProductVariant;
import jakarta.persistence.EntityManager;
import java.util.List;

public class ProductVariantRepository {

    public List<ProductVariant> findAll(EntityManager entityManager) {

        String jpql = """
                SELECT pv
                FROM ProductVariant pv
                ORDER BY pv.id DESC
                """;

        return entityManager
                .createQuery(jpql, ProductVariant.class)
                .getResultList();
    }
}