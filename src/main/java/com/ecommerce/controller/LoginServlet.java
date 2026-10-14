package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.model.UserRole;
import com.ecommerce.repository.UserRepository;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.util.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setAttribute("logoName", "Guest");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        if (email == null || email.isBlank()) {
            email = request.getParameter("identifier");
        }
        String password = request.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ Email và Mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager().createEntityManager();
            UserRepository userRepo = new UserRepository(em);
            Optional<User> userOpt = userRepo.findByEmail(email.trim());

            if (userOpt.isPresent()) {
                User user = userOpt.get();
                if (PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", user.getId());
                    session.setAttribute("role", user.getRole() != null ? user.getRole().name() : UserRole.CUSTOMER.name());
                    session.setAttribute("user", user);
                    session.setAttribute("logoName", user.getFullName() != null ? user.getFullName() : user.getEmail());

                    if (user.getRole() == UserRole.ADMIN) {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    }
                    return;
                }
            }

            request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (Throwable ex) {
            request.setAttribute("errorMessage", "Lỗi xác thực hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
