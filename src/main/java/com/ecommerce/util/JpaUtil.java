package com.ecommerce.util;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtil {
	private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("ClothingWebPU");
	
	public static EntityManagerFactory getEntityManager() {
		return emf;
	}
}
