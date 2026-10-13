package com.ecommerce.config;

import com.ecommerce.model.User;
import com.ecommerce.model.UserRole;
import com.ecommerce.repository.UserRepository;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.util.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Optional;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Khởi tạo ứng dụng: Kiểm tra kết nối JPA và dữ liệu khởi tạo...");
        EntityManager em = null;
        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            UserRepository userRepo = new UserRepository(em);

            // 1. Kiểm tra / Tự động tạo tài khoản Admin
            String adminEmail = "admin@clothingstore.com";
            Optional<User> adminOpt = userRepo.findByEmail(adminEmail);
            if (adminOpt.isEmpty()) {
                User admin = new User(
                    "Quản Trị Viên",
                    adminEmail,
                    PasswordUtil.hashPassword("admin123"),
                    "0901234567",
                    UserRole.ADMIN
                );
                userRepo.save(admin);
                System.out.println("[AppContextListener] Đã tự động seed tài khoản Admin: " + adminEmail);
            }

            // 2. Kiểm tra / Tự động tạo tài khoản Customer
            String userEmail = "user@clothingstore.com";
            Optional<User> userOpt = userRepo.findByEmail(userEmail);
            if (userOpt.isEmpty()) {
                User customer = new User(
                    "Khách Hàng Mẫu",
                    userEmail,
                    PasswordUtil.hashPassword("user123"),
                    "0987654321",
                    UserRole.CUSTOMER
                );
                userRepo.save(customer);
                System.out.println("[AppContextListener] Đã tự động seed tài khoản User: " + userEmail);
            }

            em.getTransaction().commit();
            System.out.println("[AppContextListener] Khởi tạo database và dữ liệu seed hoàn tất.");
        } catch (Throwable t) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("[AppContextListener] Không thể seed dữ liệu khởi tạo: " + t.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Giải phóng tài nguyên JpaUtil...");
        try {
            JpaUtil.shutdown();
        } catch (Throwable t) {
            System.err.println("[AppContextListener] Lỗi khi giải phóng JpaUtil: " + t.getMessage());
        }
    }
}
