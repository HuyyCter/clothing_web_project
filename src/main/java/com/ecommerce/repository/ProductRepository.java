package com.ecommerce.repository;

import com.ecommerce.model.Product;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
public class ProductRepository {

    public List<Product> findAll(EntityManager entityManager) {

        return entityManager
                .createQuery(
                        "SELECT p FROM Product p",
                        Product.class
                )
                .getResultList();
    }
    public List<Product> findByCategoryId(
            EntityManager entityManager,
            int categoryId) {

        return entityManager
                .createQuery(
                    "SELECT p FROM Product p WHERE p.category.id = :categoryId",
                    Product.class
                )
                .setParameter("categoryId", categoryId)
                .getResultList();
    }



	public Map<Integer, BigDecimal> findMinVariantPrices(
	        EntityManager entityManager,
	        List<Product> products) {
	
	    Map<Integer, BigDecimal> minPrices = new HashMap<>();
	
	    // Không có sản phẩm thì không cần truy vấn
	    if (products == null || products.isEmpty()) {
	        return minPrices;
	    }
	
	    List<Integer> productIds = products.stream()
	            .map(Product::getId)
	            .toList();
	
	    List<Object[]> results = entityManager.createQuery(
	            "SELECT v.product.id, MIN(v.price) " +
	            "FROM ProductVariant v " +
	            "WHERE v.product.id IN :productIds " +
	            "GROUP BY v.product.id",
	            Object[].class
	    )
	    .setParameter("productIds", productIds)
	    .getResultList();
	
	    for (Object[] row : results) {
	        Integer productId = (Integer) row[0];
	        BigDecimal minPrice = (BigDecimal) row[1];
	
	        minPrices.put(productId, minPrice);
	    }
	
	    return minPrices;
	}


    public List<Product> findPage(
	        EntityManager entityManager,
	        String search,
	        Integer categoryId,
	        String sort,
	        int page,
	        int pageSize) {

	    String jpql =
	            "SELECT p " +
	            "FROM Product p " +
	            "LEFT JOIN p.variants v " +
	            "WHERE 1 = 1 ";
	
	    if (search != null && !search.isBlank()) {
	        jpql += "AND LOWER(p.name) LIKE LOWER(:search) ";
	    }
	
	    if (categoryId != null) {
	        jpql += "AND p.category.id = :categoryId ";
	    }
	
	    jpql += "GROUP BY p ";
	
	    if ("asc".equals(sort)) {
	        jpql += "ORDER BY MIN(v.price) ASC NULLS LAST, p.id DESC ";
	    } else if ("desc".equals(sort)) {
	        jpql += "ORDER BY MIN(v.price) DESC NULLS LAST, p.id DESC ";
	    } else {
	        jpql += "ORDER BY p.id DESC ";
	    }
	
	    TypedQuery<Product> query =
	            entityManager.createQuery(jpql, Product.class);
	
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

    public long count(
            EntityManager entityManager,
            String search,
            Integer categoryId) {

        String jpql =
                "SELECT COUNT(p) " +
                "FROM Product p " +
                "WHERE 1 = 1 ";

        if (search != null && !search.isBlank()) {
            jpql += "AND LOWER(p.name) LIKE LOWER(:search) ";
        }

        if (categoryId != null) {
            jpql += "AND p.category.id = :categoryId ";
        }

        TypedQuery<Long> query =
                entityManager.createQuery(jpql, Long.class);

        if (search != null && !search.isBlank()) {
            query.setParameter(
                    "search",
                    "%" + search.trim() + "%"
            );
        }

        if (categoryId != null) {
            query.setParameter("categoryId", categoryId);
        }

        return query.getSingleResult();
    }
}