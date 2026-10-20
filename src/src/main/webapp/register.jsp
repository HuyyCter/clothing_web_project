<%-- File: register.jsp Mô tả: Giao diện đăng ký & xác thực OTP cho MVC2 clothing web project Author: Hermes Agent --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" dir="ltr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty sessionScope.registerOtpData}">Xác thực OTP - Clothing Store</c:when><c:otherwise>Đăng ký - Clothing Store</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>

<body>

    <!-- Page Container -->
    <div class="auth-page">
        <div class="auth-card">
            
            <c:choose>
                <%-- ========================================================= --%>
                <%-- BƯỚC 2: GIAO DIỆN XÁC THỰC MÃ OTP ĐĂNG KÝ                --%>
                <%-- ========================================================= --%>
                <c:when test="${not empty sessionScope.registerOtpData}">
                    <h2>Xác thực tài khoản</h2>
                    <p class="otp-desc-lead">
                        Mã xác thực OTP gồm 6 chữ số đã được gửi tới email:<br>
                        <strong class="otp-target-email"><c:out value="${sessionScope.registerOtpData.targetEmail}" /></strong>
                    </p>

                    <c:if test="${not empty requestScope.errorMessage}">
                        <div class="alert-error">
                            <c:out value="${requestScope.errorMessage}" />
                        </div>
                    </c:if>

                    <c:if test="${not empty requestScope.successMessage}">
                        <div class="alert-success">
                            <c:out value="${requestScope.successMessage}" />
                        </div>
                    </c:if>

                    <div class="otp-meta-panel">
                        <div>
                            <span>Hiệu lực còn: </span>
                            <span id="countdownDisplay" class="otp-timer">--:--</span>
                        </div>
                        <div class="otp-attempts">
                            Lần thử: <strong><c:out value="${sessionScope.registerOtpData.attemptsLeft}" />/3</strong>
                        </div>
                    </div>

                    <!-- Form Xác thực OTP -->
                    <form action="${pageContext.request.contextPath}/register" method="post" id="verifyOtpForm">
                        <input type="hidden" name="action" value="verifyOtp">

                        <div class="form-group">
                            <label for="otpCode" class="form-label">Mã xác thực OTP</label>
                            <input type="text" id="otpCode" name="otpCode" class="form-input otp-input-box" 
                                   placeholder="000000" maxlength="6" pattern="[0-9]{6}" required autocomplete="one-time-code" autofocus>
                            <div class="otp-guide-text">
                                Vui lòng kiểm tra kỹ cả thư mục Quảng cáo/Spam nếu chưa nhận được mã.
                            </div>
                        </div>

                        <button type="submit" class="submit-btn" id="verifyBtn">Xác nhận đăng ký</button>
                    </form>

                    <!-- Form Gửi lại mã OTP -->
                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <input type="hidden" name="action" value="resendOtp">
                        <button type="submit" class="resend-btn" id="resendOtpBtn">
                            Gửi lại mã OTP mới
                        </button>
                    </form>

                    <div class="auth-card__footer-links">
                        <a href="${pageContext.request.contextPath}/register?action=cancelOtp" class="form-link auth-card__link-muted">
                            ← Thay đổi thông tin đăng ký
                        </a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="form-link auth-card__link-subtle">
                            Về trang chủ
                        </a>
                    </div>

                    <script>
                        (function() {
                            var remainingSeconds = <c:out value="${sessionScope.registerOtpData.remainingSeconds}" default="120" />;
                            var countdownEl = document.getElementById('countdownDisplay');
                            var verifyBtn = document.getElementById('verifyBtn');

                            function updateDisplay() {
                                if (remainingSeconds <= 0) {
                                    countdownEl.textContent = "Hết hạn";
                                    countdownEl.style.color = "#b91c1c";
                                    if (verifyBtn) verifyBtn.disabled = true;
                                    return;
                                }
                                var minutes = Math.floor(remainingSeconds / 60);
                                var seconds = remainingSeconds % 60;
                                countdownEl.textContent = (minutes < 10 ? '0' : '') + minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                                remainingSeconds--;
                                setTimeout(updateDisplay, 1000);
                            }

                            updateDisplay();

                            // Cooldown 30s cho nút gửi lại mã OTP
                            var resendCooldown = <c:out value="${sessionScope.registerOtpData.resendCooldownRemainingSeconds}" default="30" />;
                            var resendBtn = document.getElementById('resendOtpBtn');
                            function updateResendCooldown() {
                                if (!resendBtn) return;
                                if (resendCooldown <= 0) {
                                    resendBtn.disabled = false;
                                    resendBtn.textContent = "Gửi lại mã OTP mới";
                                    resendBtn.style.opacity = "1";
                                    resendBtn.style.cursor = "pointer";
                                    return;
                                }
                                resendBtn.disabled = true;
                                resendBtn.textContent = "Gửi lại mã OTP mới (" + resendCooldown + "s)";
                                resendBtn.style.opacity = "0.6";
                                resendBtn.style.cursor = "not-allowed";
                                resendCooldown--;
                                setTimeout(updateResendCooldown, 1000);
                            }

                            updateResendCooldown();
                        })();
                    </script>
                </c:when>

                <%-- ========================================================= --%>
                <%-- BƯỚC 1: FORM ĐĂNG KÝ TÀI KHOẢN BAN ĐẦU                   --%>
                <%-- ========================================================= --%>
                <c:otherwise>
                    <h2>Tạo tài khoản mới</h2>
                    <p>Đăng ký để nhận trải nghiệm mua sắm riêng tư</p>

                    <c:if test="${not empty requestScope.errorMessage}">
                        <div class="alert-error">
                            <c:out value="${requestScope.errorMessage}" />
                        </div>
                    </c:if>

                    <c:if test="${not empty requestScope.successMessage}">
                        <div class="alert-success">
                            <c:out value="${requestScope.successMessage}" />
                        </div>
                    </c:if>

                    <!-- Register Form -->
                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="form-group">
                            <label for="fullname" class="form-label">Tên đầy đủ</label>
                            <input type="text" id="fullname" name="fullName" class="form-input"
                                placeholder="Ví dụ: Nguyễn Văn A" value="<c:out value='${param.fullName}' />" required>
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" id="email" name="email" class="form-input"
                                placeholder="example@email.com" value="<c:out value='${param.email}' />" required>
                        </div>

                        <div class="form-group">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" class="form-input" placeholder="09xxxxxxxx"
                                value="<c:out value='${param.phone}' />" required>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" id="password" name="password" class="form-input"
                                placeholder="Tạo mật khẩu" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword" class="form-label">Nhắc lại mật khẩu</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                                placeholder="Nhắc lại mật khẩu" required>
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="agree" name="agree" class="checkbox-input" required>
                            <label for="agree" class="checkbox-text">
                                Tôi đồng ý với điều khoản và chính sách
                            </label>
                        </div>

                        <button type="submit" class="submit-btn">Đăng ký</button>
                    </form>

                    <!-- Login link -->
                    <div class="auth-card__footer-links">
                        <a href="${pageContext.request.contextPath}/login" class="form-link">
                            Đã có tài khoản? Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="form-link auth-card__link-muted">
                            ← Quay lại trang chủ
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>

</body>
</html>