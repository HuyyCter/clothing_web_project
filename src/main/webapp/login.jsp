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
                                <label for="email" class="form-label">Email</label>
                                <input type="email" id="email" name="email" class="form-input"
                                    placeholder="example@email.com" required>
                            </div>

                            <div class="form-group">
                                <label for="password" class="form-label">Mật khẩu</label>
                                <input type="password" id="password" name="password" class="form-input"
                                    placeholder="Nhập mật khẩu của bạn" required>
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

            </body>

            </html>