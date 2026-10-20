package com.ecommerce.controller;

import com.ecommerce.dto.OtpSessionData;
import com.ecommerce.model.User;
import com.ecommerce.model.UserRole;
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
        String action = request.getParameter("action");
        if ("cancelOtp".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("registerOtpData");
            }
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        // GET /register -> forward về register.jsp
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        // 1. Xử lý xác thực mã OTP đăng ký
        if ("verifyOtp".equalsIgnoreCase(action)) {
            handleVerifyOtp(request, response, session);
            return;
        }

        // 2. Xử lý gửi lại mã OTP đăng ký
        if ("resendOtp".equalsIgnoreCase(action)) {
            handleResendOtp(request, response, session);
            return;
        }

        // 3. Xử lý submit form đăng ký ban đầu -> sinh OTP và gửi email
        handleRegisterInit(request, response, session);
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        OtpSessionData otpData = (OtpSessionData) session.getAttribute("registerOtpData");
        if (otpData == null) {
            request.setAttribute("errorMessage", "Phiên xác thực đã kết thúc. Vui lòng tiến hành đăng ký lại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        String otpCode = request.getParameter("otpCode");
        String verifyError = otpData.verify(otpCode);
        if (verifyError != null) {
            request.setAttribute("errorMessage", verifyError);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // OTP hợp lệ -> Lưu tài khoản vào cơ sở dữ liệu
        Map<String, String> payload = otpData.getPayload();
        String fullName = payload.get("fullName");
        String email = payload.get("email");
        String phone = payload.get("phone");
        String passwordHash = payload.get("passwordHash");

        EntityManager em = null;
        try {
            em = JpaUtil.getEntityManager().createEntityManager();
            UserRepository userRepo = new UserRepository(em);

            if (userRepo.findByEmail(email).isPresent()) {
                request.setAttribute("errorMessage", "Email này vừa được người khác đăng ký.");
                session.removeAttribute("registerOtpData");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPasswordHash(passwordHash);
            user.setRole(UserRole.CUSTOMER);

            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();

            // Gửi email chào mừng đăng ký thành công kèm link website
            try {
                String websiteUrl = MailUtil.getAppBaseUrl(request) + "/index.jsp";
                MailUtil.sendWelcomeEmail(user.getEmail(), user.getFullName(), websiteUrl);
            } catch (Throwable t) {
                System.err.println("[RegisterServlet] Không thể gửi welcome email: " + t.getMessage());
            }

            // Xóa session OTP sau khi đăng ký thành công
            session.removeAttribute("registerOtpData");

            // Tự động đăng nhập
            session.setAttribute("userId", user.getId());
            session.setAttribute("role", user.getRole() != null ? user.getRole().name() : UserRole.CUSTOMER.name());
            session.setAttribute("user", user);
            session.setAttribute("logoName", user.getFullName() != null ? user.getFullName() : user.getEmail());

            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } catch (Throwable ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tạo tài khoản: " + ex.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private void handleResendOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        OtpSessionData otpData = (OtpSessionData) session.getAttribute("registerOtpData");
        if (otpData == null) {
            request.setAttribute("errorMessage", "Phiên xác thực đã kết thúc. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!otpData.canResend()) {
            long remainingCooldown = otpData.getResendCooldownRemainingSeconds();
            request.setAttribute("errorMessage", "Vui lòng đợi thêm " + remainingCooldown + " giây trước khi gửi lại mã OTP.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        otpData.refreshCode();
        boolean sent = MailUtil.sendOtpEmail(otpData.getTargetEmail(), otpData.getCode(), "xác thực đăng ký tài khoản Fashion Shop");
        if (sent) {
            request.setAttribute("successMessage", "Mã OTP mới đã được gửi đến email " + otpData.getTargetEmail() + ". Vui lòng kiểm tra hộp thư.");
        } else {
            request.setAttribute("errorMessage", "Không thể gửi email OTP. Vui lòng kiểm tra kết nối mạng hoặc thử lại sau ít phút.");
        }
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private void handleRegisterInit(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String agree = request.getParameter("agree");

        String errorMessage = null;

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
        } else if (!PASSWORD_PATTERN.matcher(password).matches()) {
            errorMessage = "Mật khẩu phải có ít nhất 8 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 số.";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Mật khẩu và xác nhận mật khẩu không khớp.";
        } else {
            // Kiểm tra trùng lặp email / sđt trong database
            EntityManager em = null;
            try {
                em = JpaUtil.getEntityManager().createEntityManager();
                UserRepository userRepo = new UserRepository(em);

                if (userRepo.findByEmail(email.trim()).isPresent()) {
                    errorMessage = "Email đã được đăng ký.";
                } else if (userRepo.findByPhone(phone.trim()).isPresent()) {
                    errorMessage = "Số điện thoại đã được đăng ký.";
                } else {
                    // Chuẩn bị dữ liệu và sinh mã OTP
                    String passwordHash = PasswordUtil.hashPassword(password);
                    Map<String, String> payload = new HashMap<>();
                    payload.put("fullName", fullName.trim());
                    payload.put("email", email.trim());
                    payload.put("phone", phone.trim());
                    payload.put("passwordHash", passwordHash);

                    OtpSessionData otpData = OtpSessionData.create(email.trim(), "Xác thực đăng ký tài khoản", payload);
                    boolean sent = MailUtil.sendOtpEmail(email.trim(), otpData.getCode(), "xác thực đăng ký tài khoản Fashion Shop");

                    if (!sent) {
                        errorMessage = "Không thể gửi email chứa mã OTP đến " + email.trim() + ". Vui lòng kiểm tra lại địa chỉ email.";
                    } else {
                        session.setAttribute("registerOtpData", otpData);
                        request.setAttribute("successMessage", "Mã xác thực OTP gồm 6 chữ số đã được gửi tới email " + email.trim() + ".");
                        request.getRequestDispatcher("/register.jsp").forward(request, response);
                        return;
                    }
                }
            } catch (Throwable ex) {
                ex.printStackTrace();
                errorMessage = "Lỗi hệ thống: " + ex.getMessage();
            } finally {
                if (em != null && em.isOpen()) {
                    em.close();
                }
            }
        }

        // Có lỗi -> forward về register.jsp với error message
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}