<%--
  File: register.jsp
  Mô tả: Giao diện đăng ký cho MVC2 clothing web project
  Author: Hermes Agent
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" dir="ltr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Clothing Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>
<body>

    <!-- Page Container -->
    <div class="auth-page">
        <div class="auth-card">
            <h2>Tạo tài khoản mới</h2>

            <p>Đăng ký để nhận trải nghiệm mua sắm riêng tư</p>

            <!-- Register Form -->
            <form action="/register" method="POST">
                <div class="form-group">
                    <label for="fullname" class="form-label">Tên đầy đủ</label>
                    <input type="text" id="fullname" name="fullName" class="form-input" placeholder="Ví dụ: Nguyễn Văn A" required>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="example@email.com" required>
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="09xxxxxxxx" required>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Tạo mật khẩu" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Nhắc lại mật khẩu</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Nhắc lại mật khẩu" required>
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
            <div style="text-align: center; margin-top: 1.5rem; display: flex; flex-direction: column; gap: 0.5rem;">
                <a href="${pageContext.request.contextPath}/login" class="form-link">
                    Đã có tài khoản? Đăng nhập
                </a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="form-link" style="color: #64748b; font-size: 0.875rem;">
                    ← Quay lại trang chủ
                </a>
            </div>
        </div>
    </div>

</body>
</html>