<%-- File: forgot-password.jsp Mô tả: Giao diện quên mật khẩu & đặt lại mật khẩu qua OTP email Author: Hermes Agent --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" dir="ltr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty sessionScope.forgotPasswordOtpData}">Đặt lại mật khẩu - Fashion Shop</c:when><c:otherwise>Quên mật khẩu - Fashion Shop</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>

<body>

    <div class="auth-page">
        <div class="auth-card">
            <c:choose>
                <%-- ========================================================= --%>
                <%-- BƯỚC 2: NHẬP MÃ OTP VÀ THIẾT LẬP MẬT KHẨU MỚI            --%>
                <%-- ========================================================= --%>
                <c:when test="${not empty sessionScope.forgotPasswordOtpData}">
                    <h2>Đặt lại mật khẩu</h2>
                    <p class="otp-desc-lead">
                        Mã xác thực OTP gồm 6 chữ số đã được gửi đến email:<br>
                        <strong class="otp-target-email"><c:out value="${sessionScope.forgotPasswordOtpData.targetEmail}" /></strong>
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
                            Lần thử: <strong><c:out value="${sessionScope.forgotPasswordOtpData.attemptsLeft}" />/3</strong>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="resetPasswordForm">
                        <input type="hidden" name="action" value="verifyAndReset">

                        <div class="form-group">
                            <label for="otpCode" class="form-label">Mã xác thực OTP</label>
                            <input type="text" id="otpCode" name="otpCode" class="form-input otp-input-box" 
                                   placeholder="000000" maxlength="6" pattern="[0-9]{6}" required autocomplete="one-time-code" autofocus>
                        </div>

                        <div class="form-group">
                            <label for="newPassword" class="form-label">Mật khẩu mới</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-input"
                                placeholder="Tạo mật khẩu mới" required>
                            <div class="auth-form-note">
                                Ít nhất 8 ký tự, có 1 chữ hoa, 1 chữ thường và 1 số.
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                                placeholder="Nhập lại mật khẩu mới" required>
                        </div>

                        <button type="submit" class="submit-btn" id="verifyBtn">Xác nhận đổi mật khẩu</button>
                    </form>

                    <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="resend-form">
                        <input type="hidden" name="action" value="resendOtp">
                        <button type="submit" class="resend-btn" id="resendOtpBtn">
                            Gửi lại mã OTP mới
                        </button>
                    </form>

                    <div class="auth-card__footer-links">
                        <a href="${pageContext.request.contextPath}/forgot-password?action=cancel" class="form-link auth-card__link-muted">
                            ← Thay đổi địa chỉ email
                        </a>
                        <a href="${pageContext.request.contextPath}/login" class="form-link auth-card__link-subtle">
                            Quay lại đăng nhập
                        </a>
                    </div>

                    <script>
                        (function() {
                            var remainingSeconds = <c:out value="${sessionScope.forgotPasswordOtpData.remainingSeconds}" default="120" />;
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

                            var resendCooldown = <c:out value="${sessionScope.forgotPasswordOtpData.resendCooldownRemainingSeconds}" default="30" />;
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
                <%-- BƯỚC 1: NHẬP EMAIL ĐỂ NHẬN MÃ OTP                        --%>
                <%-- ========================================================= --%>
                <c:otherwise>
                    <h2>Quên mật khẩu</h2>
                    <p>Nhập địa chỉ email đăng ký để nhận mã OTP đặt lại mật khẩu</p>

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

                    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                        <input type="hidden" name="action" value="requestOtp">

                        <div class="form-group">
                            <label for="email" class="form-label">Địa chỉ Email</label>
                            <input type="email" id="email" name="email" class="form-input"
                                placeholder="example@email.com" value="<c:out value='${param.email}' />" required autofocus>
                        </div>

                        <button type="submit" class="submit-btn">Gửi mã xác thực OTP</button>
                    </form>

                    <div class="auth-card__footer-links">
                        <a href="${pageContext.request.contextPath}/login" class="form-link">
                            ← Quay lại đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="form-link auth-card__link-muted">
                            Về trang chủ
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>
