package com.ecommerce.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.HashMap;
import java.util.Map;

public class JpaUtil {
    private static final EntityManagerFactory emf;

    static {
        try {
            Map<String, Object> overrides = new HashMap<>();

            // Đọc cấu hình từ biến môi trường (ưu tiên khi deploy demo/cloud/docker)
            String dbUrl = getEnvOrProperty("DB_URL", "jakarta.persistence.jdbc.url");
            String dbUser = getEnvOrProperty("DB_USER", "jakarta.persistence.jdbc.user");
            String dbPassword = getEnvOrProperty("DB_PASSWORD", "jakarta.persistence.jdbc.password");

            if (dbUrl != null && !dbUrl.isBlank()) {
                overrides.put("jakarta.persistence.jdbc.url", dbUrl);
            }
            if (dbUser != null && !dbUser.isBlank()) {
                overrides.put("jakarta.persistence.jdbc.user", dbUser);
            }
            if (dbPassword != null) {
                overrides.put("jakarta.persistence.jdbc.password", dbPassword);
            }

            emf = Persistence.createEntityManagerFactory("ClothingWebPU", overrides);
        } catch (Throwable ex) {
            System.err.println("Lỗi khởi tạo EntityManagerFactory: " + ex.getMessage());
            throw new ExceptionInInitializerError(ex);
        }
    }

    private static String getEnvOrProperty(String envKey, String sysPropKey) {
        String val = System.getenv(envKey);
        if (val != null && !val.isBlank()) {
            return val;
        }
        return System.getProperty(sysPropKey);
    }

    public static EntityManagerFactory getEntityManagerFactory() {
        return emf;
    }

    public static EntityManagerFactory getEntityManager() {
        return emf;
    }

    public static EntityManager createEntityManager() {
        return emf.createEntityManager();
    }

    public static void shutdown() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}

