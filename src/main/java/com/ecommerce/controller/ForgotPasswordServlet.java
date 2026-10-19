package com.ecommerce.controller;

import com.ecommerce.dto.OtpSessionData;
import com.ecommerce.model.User;
import com.ecommerce.repository.UserRepository;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.util.MailUtil;
import com.ecommerce.util.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("cancel".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("forgotPasswordOtpData");
            }
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if ("verifyAndReset".equalsIgnoreCase(action)) {
            handleVerifyAndReset(request, response, session);
            return;
        }

        if ("resendOtp".equalsIgnoreCase(action)) {
            handleResendOtp(request, response, session);
            return;
        }

        // Mặc định: Gửi yêu cầu OTP qua Email
        handleRequestOtp(request, response, session);
    }

    private void handleRequestOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isBlank()) {
            request.setAttribute("errorMessage", "Vui lòng nhập địa chỉ email của bạn.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager().createEntityManager();
            UserRepository userRepo = new UserRepository(em);
            Optional<User> userOpt = userRepo.findByEmail(email.trim());

            if (userOpt.isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy tài khoản nào gắn với địa chỉ email: " + email.trim());
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            User user = userOpt.get();
            Map<String, String> payload = new HashMap<>();
            payload.put("userId", String.valueOf(user.getId()));
            payload.put("email", user.getEmail());

            OtpSessionData otpData = OtpSessionData.create(user.getEmail(), "Đặt lại mật khẩu", payload);
            boolean sent = MailUtil.sendOtpEmail(user.getEmail(), otpData.getCode(), "xác thực yêu cầu đặt lại mật khẩu tài khoản Fashion Shop");

            if (!sent) {
                request.setAttribute("errorMessage", "Không thể gửi email OTP đến " + user.getEmail() + ". Vui lòng thử lại sau.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            session.setAttribute("forgotPasswordOtpData", otpData);
            request.setAttribute("successMessage", "Mã xác thực OTP gồm 6 chữ số đã được gửi đến email: " + user.getEmail() + ".");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } catch (Throwable ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private void handleVerifyAndReset(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        OtpSessionData otpData = (OtpSessionData) session.getAttribute("forgotPasswordOtpData");
        if (otpData == null) {
            request.setAttribute("errorMessage", "Phiên xác thực đã hết hạn hoặc bị hủy. Vui lòng yêu cầu lại.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        String otpCode = request.getParameter("otpCode");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.isBlank()) {
            request.setAttribute("errorMessage", "Vui lòng nhập mật khẩu mới.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 8 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 số.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        String verifyError = otpData.verify(otpCode);
        if (verifyError != null) {
            request.setAttribute("errorMessage", verifyError);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        // Hợp lệ -> Đổi mật khẩu trong cơ sở dữ liệu
        int userId = Integer.parseInt(otpData.getPayload().get("userId"));
        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager().createEntityManager();
            em.getTransaction().begin();
            User user = em.find(User.class, userId);
            if (user != null) {
                user.setPasswordHash(PasswordUtil.hashPassword(newPassword));
                em.merge(user);
            }
            em.getTransaction().commit();

            session.removeAttribute("forgotPasswordOtpData");
            session.setAttribute("loginSuccessMessage", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập bằng mật khẩu mới.");
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (Throwable ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cập nhật mật khẩu: " + ex.getMessage());
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private void handleResendOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        OtpSessionData otpData = (OtpSessionData) session.getAttribute("forgotPasswordOtpData");
        if (otpData == null) {
            request.setAttribute("errorMessage", "Phiên xác thực đã kết thúc. Vui lòng nhập lại email.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        if (!otpData.canResend()) {
            long remaining = otpData.getResendCooldownRemainingSeconds();
            request.setAttribute("errorMessage", "Vui lòng đợi thêm " + remaining + " giây trước khi gửi lại mã OTP.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        otpData.refreshCode();
        boolean sent = MailUtil.sendOtpEmail(otpData.getTargetEmail(), otpData.getCode(), "xác thực yêu cầu đặt lại mật khẩu tài khoản Fashion Shop");
        if (sent) {
            request.setAttribute("successMessage", "Mã OTP mới đã được gửi đến email " + otpData.getTargetEmail() + ". Vui lòng kiểm tra hộp thư.");
        } else {
            request.setAttribute("errorMessage", "Không thể gửi email OTP. Vui lòng thử lại sau ít phút.");
        }
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
}
