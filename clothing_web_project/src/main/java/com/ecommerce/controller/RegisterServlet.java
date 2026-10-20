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
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Regex: Ít nhất 8 ký tự, có chữ hoa, chữ thường, số
    private static final Pattern PASSWORD_PATTERN =
        Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET /register -> forward về register.jsp
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String errorMessage = null;
        String agree = request.getParameter("agree");

        // 1. Kiểm tra bắt buộc
        if (fullName == null || fullName.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập tên đầy đủ.";
        } else if (email == null || email.trim().isBlank()) {
            errorMessage = "Vui lòng nhập email.";
        } else if (phone == null || phone.trim().isBlank()) {
            errorMessage = "Vui lòng nhập số điện thoại.";
        } else if (password == null || password.isBlank()) {
            errorMessage = "Vui lòng nhập mật khẩu.";
        } else if (confirmPassword == null || confirmPassword.isBlank()) {
            errorMessage = "Vui lòng xác nhận mật khẩu.";
        } else if (agree == null || agree.isEmpty()) {
            errorMessage = "Vui lòng đồng ý với điều khoản và chính sách.";
        } else {
            // 2. Kiểm tra độ mạnh mật khẩu
            if (!PASSWORD_PATTERN.matcher(password).matches()) {
                errorMessage = "Mật khẩu phải có ít nhất 8 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 số.";
            } else {
                // 3. Kiểm tra password match
                if (!password.equals(confirmPassword)) {
                    errorMessage = "Mật khẩu và xác nhận mật khẩu không khớp.";
                } else {
                    // 4. Kiểm tra email đã tồn tại
                    EntityManager em = null;
                    try {
                        em = JpaUtil.getEntityManager().createEntityManager();
                        UserRepository userRepo = new UserRepository(em);

                        if (userRepo.findByEmail(email.trim()).isPresent()) {
                            errorMessage = "Email đã được đăng ký.";
                        } else if (userRepo.findByPhone(phone.trim()).isPresent()) {
                            errorMessage = "Số điện thoại đã được đăng ký.";
                        } else {
                            // 5. Hash password và tạo user
                            String passwordHash = PasswordUtil.hashPassword(password);
                            User user = new User();
                            user.setFullName(fullName.trim());
                            user.setEmail(email.trim());
                            user.setPhone(phone.trim());
                            user.setPasswordHash(passwordHash);
                            user.setRole(UserRole.CUSTOMER); // Role mặc định

                            em.getTransaction().begin();
                            em.persist(user);
                            em.getTransaction().commit();

                            // 6. Đăng ký tự động (tạo session như LoginServlet)
                            HttpSession session = request.getSession();
                            session.setAttribute("userId", user.getId());
                            session.setAttribute("role", user.getRole() != null ? user.getRole().name() : UserRole.CUSTOMER.name());
                            session.setAttribute("user", user);
                            session.setAttribute("logoName", user.getFullName() != null ? user.getFullName() : user.getEmail());

                            // Chuyển hướng về index.jsp (trang chủ)
                            response.sendRedirect(request.getContextPath() + "/index.jsp");
                            return;
                        }
                    } catch (Throwable ex) {
                        if (em != null && em.getTransaction().isActive()) {
                            em.getTransaction().rollback();
                        }
                        ex.printStackTrace();
                        errorMessage = "Lỗi hệ thống: " + ex.getMessage();
                    } finally {
                        if (em != null && em.isOpen()) {
                            em.close();
                        }
                    }
                }
            }
        }

        // Có lỗi -> forward về register.jsp với error message
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}