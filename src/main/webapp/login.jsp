<%-- File: login.jsp Mô tả: Giao diện đăng nhập cho MVC2 clothing web project Author: Hermes Agent --%>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html lang="vi" dir="ltr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng nhập - Clothing Store</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
            </head>

            <body>

                <!-- Page Container -->
                <div class="auth-page">
                    <div class="auth-card">
                        <h2>Chào bạn</h2>

                        <p>Vui lòng đăng nhập để tiếp tục (Hiện tại: <strong>
                                <c:out value="${not empty sessionScope.logoName ? sessionScope.logoName : 'Guest'}" />
                            </strong>)</p>

                        <c:if test="${not empty requestScope.errorMessage}">
                            <div
                                style="color: #b91c1c; background-color: #fef2f2; border: 1px solid #fecaca; padding: 10px 14px; border-radius: 6px; margin-bottom: 1rem; font-size: 0.9rem;">
                                <c:out value="${requestScope.errorMessage}" />
                            </div>
                        </c:if>

                        <!-- Login Form -->
                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="form-group">
                                <label for="email" class="form-label">Email hoặc Số điện thoại</label>
                                <input type="text" id="email" name="email" class="form-input"
                                    placeholder="example@email.com hoặc 09xxxxxxxx" required>
                            </div>

                            <div class="form-group">
                                <label for="password" class="form-label">Mật khẩu</label>
                                <div class="password-wrapper">
                                    <input type="password" id="password" name="password" class="form-input"
                                        placeholder="Nhập mật khẩu của bạn" required>
                                    <button type="button" class="toggle-password" id="togglePasswordBtn" aria-label="Hiện/Ẩn mật khẩu" title="Hiện/Ẩn mật khẩu">
                                        <svg class="eye-icon eye-show" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                            <circle cx="12" cy="12" r="3" />
                                        </svg>
                                        <svg class="eye-icon eye-hide" style="display:none;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                            <line x1="1" y1="1" x2="23" y2="23" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <div class="checkbox-group">
                                <input type="checkbox" id="remember" name="remember" class="checkbox-input">
                                <label for="remember" class="checkbox-text">Ghi nhớ tôi</label>
                            </div>

                            <button type="submit" class="submit-btn">Đăng nhập</button>
                        </form>


                        <!-- Links -->
                        <div
                            style="text-align: center; margin-top: 1.5rem; display: flex; flex-direction: column; gap: 0.5rem;">
                            <a href="${pageContext.request.contextPath}/register.jsp" class="form-link">
                                Chưa có tài khoản? Đăng ký
                            </a>
                            <a href="${pageContext.request.contextPath}/index.jsp" class="form-link"
                                style="color: #64748b; font-size: 0.875rem;">
                                ← Quay lại trang chủ
                            </a>
                        </div>
                    </div>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        var toggleBtn = document.getElementById('togglePasswordBtn');
                        var passwordInput = document.getElementById('password');
                        if (toggleBtn && passwordInput) {
                            var eyeShow = toggleBtn.querySelector('.eye-show');
                            var eyeHide = toggleBtn.querySelector('.eye-hide');

                            toggleBtn.addEventListener('click', function () {
                                var isPassword = passwordInput.getAttribute('type') === 'password';
                                passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
                                if (isPassword) {
                                eyeShow.style.display = 'none';
                                eyeHide.style.display = 'block';
                            } else {
                                eyeShow.style.display = 'block';
                                eyeHide.style.display = 'none';
                            }
                        });
                    }
                });
                </script>
            </body>

            </html>