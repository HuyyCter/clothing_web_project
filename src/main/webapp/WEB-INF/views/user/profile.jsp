<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân — Fashion Shop</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${ctx}/assets/css/customer.css">
</head>
<body data-context-path="${ctx}">

    <!-- NAVBAR CHUNG -->
    <header class="navbar">
        <div class="navbar__inner">
            <a href="${ctx}/" class="navbar__logo">Fashion<span>.</span></a>

            <form class="navbar__search" action="${ctx}/products" method="get">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8" />
                    <line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
                <input type="text" name="q" placeholder="Tìm kiếm sản phẩm..." value="">
            </form>

            <nav class="navbar__actions">
                <a href="${ctx}/wishlist/toggle" class="navbar__icon-btn" title="Wishlist">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                    </svg>
                </a>
                <a href="${ctx}/cart" class="navbar__icon-btn" title="Giỏ hàng">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                        <line x1="3" y1="6" x2="21" y2="6" />
                        <path d="M16 10a4 4 0 0 1-8 0" />
                    </svg>
                </a>
                <div class="navbar__divider"></div>
                <div class="navbar__user-dropdown" id="userDropdown">
                    <button type="button" class="navbar__user-link navbar__user-dropdown-toggle" id="userDropdownBtn" aria-expanded="false" title="Tài khoản">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                            <circle cx="12" cy="7" r="4" />
                        </svg>
                        <span id="logoText"><c:out value="${not empty userDTO.fullName ? userDTO.fullName : sessionScope.logoName}" /></span>
                    </button>
                    <div class="navbar__user-menu" id="userMenuPanel">
                        <a href="${ctx}/profile">Hồ sơ</a>
                        <a href="${ctx}/logout" class="navbar__logout-link">Đăng xuất</a>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <!-- MAIN PROFILE CONTENT -->
    <main class="profile-page">
        <div class="profile-container">

            <!-- Breadcrumb -->
            <nav class="profile-breadcrumb">
                <a href="${ctx}/">Trang chủ</a>
                <span>/</span>
                <span>Tài khoản</span>
                <span>/</span>
                <span style="color: var(--text-primary); font-weight: 500;">Hồ sơ</span>
            </nav>

            <!-- Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="profile-alert profile-alert--error" role="alert">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="12" />
                        <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                    <span><c:out value="${errorMessage}" /></span>
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="profile-alert profile-alert--success" role="status">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                        <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                    <span><c:out value="${successMessage}" /></span>
                </div>
            </c:if>

            <div class="profile-layout">
                <!-- SIDEBAR -->
                <aside class="profile-sidebar">
                    <div class="profile-user-summary">
                        <div class="profile-avatar">
                            <c:out value="${not empty userDTO.avatarInitial ? userDTO.avatarInitial : 'U'}" />
                        </div>
                        <div class="profile-user-name">
                            <c:out value="${userDTO.fullName}" default="Khách hàng" />
                        </div>
                        <div class="profile-user-email">
                            <c:out value="${userDTO.email}" default="" />
                        </div>
                        <span class="profile-role-badge">
                            <c:choose>
                                <c:when test="${userDTO.role eq 'ADMIN'}">Quản trị viên</c:when>
                                <c:otherwise>Khách hàng</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <nav class="profile-nav" role="tablist">
                        <button type="button" class="profile-nav__btn ${empty activeTab or activeTab eq 'profile' ? 'is-active' : ''}" data-target="tab-profile">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                <circle cx="12" cy="7" r="4" />
                            </svg>
                            Thông tin cá nhân
                        </button>
                        <button type="button" class="profile-nav__btn ${activeTab eq 'password' ? 'is-active' : ''}" data-target="tab-password">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                            </svg>
                            Đổi mật khẩu
                        </button>
                        <button type="button" class="profile-nav__btn ${activeTab eq 'address' ? 'is-active' : ''}" data-target="tab-address">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                <circle cx="12" cy="10" r="3" />
                            </svg>
                            Sổ địa chỉ
                        </button>
                    </nav>

                    <a href="${ctx}/logout" class="profile-sidebar__logout">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                            <polyline points="16 17 21 12 16 7" />
                            <line x1="21" y1="12" x2="9" y2="12" />
                        </svg>
                        Đăng xuất tài khoản
                    </a>
                </aside>

                <!-- MAIN TAB CONTENT -->
                <section class="profile-content">
                    
                    <!-- TAB 1: THÔNG TIN CÁ NHÂN -->
                    <div id="tab-profile" class="tab-panel ${empty activeTab or activeTab eq 'profile' ? 'is-active' : ''}">
                        <h2 class="profile-section-title">Thông Tin Cá Nhân</h2>
                        <p class="profile-section-desc">Xem thông tin tài khoản và cập nhật họ và tên của bạn.</p>

                        <form action="${ctx}/profile" method="post">
                            <input type="hidden" name="action" value="updateName">

                            <div class="profile-form-group">
                                <label for="fullName" class="profile-label">
                                    Họ và tên
                                    <span class="profile-label-badge" style="color: var(--primary-bg);">Có thể thay đổi</span>
                                </label>
                                <input type="text" id="fullName" name="fullName" class="profile-input" 
                                       value="<c:out value='${userDTO.fullName}' />" required maxlength="255">
                                <div class="profile-helper">Tên hiển thị trên đơn hàng và thanh điều hướng.</div>
                            </div>

                            <div class="profile-form-group">
                                <label for="email" class="profile-label">
                                    Địa chỉ Email
                                    <span class="profile-label-badge">Cố định</span>
                                </label>
                                <input type="email" id="email" class="profile-input" 
                                       value="<c:out value='${userDTO.email}' />" readonly disabled>
                                <div class="profile-helper">Email đăng nhập tài khoản cố định và không thể thay đổi.</div>
                            </div>

                            <div class="profile-form-group">
                                <label for="phone" class="profile-label">
                                    Số điện thoại
                                    <span class="profile-label-badge">Tài khoản</span>
                                </label>
                                <input type="text" id="phone" class="profile-input" 
                                       value="<c:out value='${not empty userDTO.phone ? userDTO.phone : \"Chưa cập nhật\"}' />" readonly disabled>
                                <div class="profile-helper">Số điện thoại liên hệ gắn với tài khoản của bạn.</div>
                            </div>

                            <button type="submit" class="profile-btn-primary">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                    <polyline points="17 21 17 13 7 13 7 21" />
                                    <polyline points="7 3 7 8 15 8" />
                                </svg>
                                Lưu thay đổi họ tên
                            </button>
                        </form>
                    </div>

                    <!-- TAB 2: ĐỔI MẬT KHẨU -->
                    <div id="tab-password" class="tab-panel ${activeTab eq 'password' ? 'is-active' : ''}">
                        <h2 class="profile-section-title">Đổi Mật Khẩu</h2>
                        <p class="profile-section-desc">Để bảo mật tài khoản, vui lòng nhập lại mật khẩu cũ để xác nhận trước khi cập nhật mật khẩu mới.</p>

                        <form action="${ctx}/profile" method="post">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="profile-form-group">
                                <label for="currentPassword" class="profile-label">Mật khẩu hiện tại</label>
                                <div class="profile-password-wrapper">
                                    <input type="password" id="currentPassword" name="currentPassword" class="profile-input" 
                                           placeholder="Nhập mật khẩu đang sử dụng" required>
                                    <button type="button" class="profile-toggle-password" title="Hiện/Ẩn mật khẩu">
                                        <svg class="eye-show" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                            <circle cx="12" cy="12" r="3" />
                                        </svg>
                                        <svg class="eye-hide" style="display:none;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                            <line x1="1" y1="1" x2="23" y2="23" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <div class="profile-form-group">
                                <label for="newPassword" class="profile-label">Mật khẩu mới</label>
                                <div class="profile-password-wrapper">
                                    <input type="password" id="newPassword" name="newPassword" class="profile-input" 
                                           placeholder="Tạo mật khẩu mới" required>
                                    <button type="button" class="profile-toggle-password" title="Hiện/Ẩn mật khẩu">
                                        <svg class="eye-show" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                            <circle cx="12" cy="12" r="3" />
                                        </svg>
                                        <svg class="eye-hide" style="display:none;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                            <line x1="1" y1="1" x2="23" y2="23" />
                                        </svg>
                                    </button>
                                </div>
                                <div class="profile-helper">Mật khẩu phải có ít nhất 8 ký tự, bao gồm ít nhất 1 chữ hoa, 1 chữ thường và 1 số.</div>
                            </div>

                            <div class="profile-form-group">
                                <label for="confirmPassword" class="profile-label">Nhắc lại mật khẩu mới</label>
                                <div class="profile-password-wrapper">
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="profile-input" 
                                           placeholder="Nhập lại mật khẩu mới" required>
                                    <button type="button" class="profile-toggle-password" title="Hiện/Ẩn mật khẩu">
                                        <svg class="eye-show" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                            <circle cx="12" cy="12" r="3" />
                                        </svg>
                                        <svg class="eye-hide" style="display:none;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24" />
                                            <line x1="1" y1="1" x2="23" y2="23" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="profile-btn-primary">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                </svg>
                                Cập nhật mật khẩu
                            </button>
                        </form>
                    </div>

                    <!-- TAB 3: SỔ ĐỊA CHỈ -->
                    <div id="tab-address" class="tab-panel ${activeTab eq 'address' ? 'is-active' : ''}">
                        <h2 class="profile-section-title">Sổ Địa Chỉ Giao Hàng</h2>
                        <p class="profile-section-desc">Quản lý danh sách địa chỉ nhận hàng của bạn.</p>

                        <!-- Danh sách địa chỉ hiện có -->
                        <c:choose>
                            <c:when test="${empty addresses}">
                                <div class="address-empty">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                        <circle cx="12" cy="10" r="3" />
                                    </svg>
                                    <div class="address-empty__title">Hiện tại chưa có địa chỉ nào</div>
                                    <div class="address-empty__text">Bạn chưa thêm địa chỉ nhận hàng nào. Vui lòng nhập địa chỉ bên dưới để tạo mới.</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="address-list">
                                    <c:forEach var="addr" items="${addresses}">
                                        <div class="address-card ${addr.isDefault ? 'is-default' : ''}">
                                            <div class="address-card__header">
                                                <span class="address-card__name"><c:out value="${addr.recipientName}" /></span>
                                                <span class="address-card__phone"><c:out value="${addr.phone}" /></span>
                                                <c:if test="${addr.isDefault}">
                                                    <span class="address-card__badge">Mặc định</span>
                                                </c:if>
                                            </div>
                                            <div class="address-card__body">
                                                <c:out value="${addr.fullAddress}" />
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Form thêm địa chỉ mới (tạo trước view) -->
                        <div class="address-form-box">
                            <h3 class="address-form-box__title">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10" />
                                    <line x1="12" y1="8" x2="12" y2="16" />
                                    <line x1="8" y1="12" x2="16" y2="12" />
                                </svg>
                                Thêm địa chỉ mới
                            </h3>

                            <form action="${ctx}/profile" method="post">
                                <input type="hidden" name="action" value="addAddress">

                                <div class="form-grid-2">
                                    <div class="profile-form-group">
                                        <label for="recipientName" class="profile-label">Họ và tên người nhận</label>
                                        <input type="text" id="recipientName" name="recipientName" class="profile-input" 
                                               placeholder="Ví dụ: Nguyễn Văn A" required>
                                    </div>

                                    <div class="profile-form-group">
                                        <label for="addressPhone" class="profile-label">Số điện thoại nhận hàng</label>
                                        <input type="tel" id="addressPhone" name="phone" class="profile-input" 
                                               placeholder="Ví dụ: 0912345678" required>
                                    </div>
                                </div>

                                <div class="form-grid-3">
                                    <div class="profile-form-group">
                                        <label for="city" class="profile-label">Tỉnh / Thành phố</label>
                                        <input type="text" id="city" name="city" class="profile-input" 
                                               placeholder="Ví dụ: Hà Nội" required>
                                    </div>

                                    <div class="profile-form-group">
                                        <label for="district" class="profile-label">Quận / Huyện</label>
                                        <input type="text" id="district" name="district" class="profile-input" 
                                               placeholder="Ví dụ: Cầu Giấy">
                                    </div>

                                    <div class="profile-form-group">
                                        <label for="ward" class="profile-label">Phường / Xã</label>
                                        <input type="text" id="ward" name="ward" class="profile-input" 
                                               placeholder="Ví dụ: Dịch Vọng Hậu">
                                    </div>
                                </div>

                                <div class="profile-form-group">
                                    <label for="street" class="profile-label">Địa chỉ cụ thể (Số nhà, tên đường, tòa nhà)</label>
                                    <input type="text" id="street" name="street" class="profile-input" 
                                           placeholder="Ví dụ: Số 12 ngõ 45 đường Xuân Thủy" required>
                                </div>

                                <label class="checkbox-container">
                                    <input type="checkbox" name="isDefault" value="true">
                                    Đặt làm địa chỉ nhận hàng mặc định
                                </label>

                                <button type="submit" class="profile-btn-primary">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                        <polyline points="17 21 17 13 7 13 7 21" />
                                        <polyline points="7 3 7 8 15 8" />
                                    </svg>
                                    Lưu địa chỉ
                                </button>
                            </form>
                        </div>
                    </div>

                </section>
            </div>
        </div>
    </main>

    <!-- FOOTER CHUNG -->
    <footer class="footer">
        <div class="footer__inner">
            <div class="footer__grid">
                <div>
                    <div class="footer__logo">Fashion<span>.</span></div>
                    <div class="footer__tagline">Phong cách tối giản, chất lượng vượt trội. Trải nghiệm mua sắm tiện lợi và tin cậy.</div>
                </div>
                <div>
                    <div class="footer__col-title">Tài khoản</div>
                    <div class="footer__links">
                        <a href="${ctx}/profile" class="footer__link">Hồ sơ cá nhân</a>
                        <a href="${ctx}/cart" class="footer__link">Giỏ hàng</a>
                        <a href="${ctx}/logout" class="footer__link">Đăng xuất</a>
                    </div>
                </div>
                <div>
                    <div class="footer__col-title">Hỗ trợ khách hàng</div>
                    <div class="footer__links">
                        <span class="footer__link">Chính sách giao hàng</span>
                        <span class="footer__link">Đổi trả & hoàn tiền</span>
                        <span class="footer__link">Chính sách bảo mật</span>
                    </div>
                </div>
            </div>
            <div class="footer__bottom">
                &copy; 2026 Fashion Shop. Mọi quyền được bảo lưu.
            </div>
        </div>
    </footer>

    <!-- JAVASCRIPT: TAB NAVIGATION & PASSWORD TOGGLE -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Tab switching
            const navButtons = document.querySelectorAll('.profile-nav__btn');
            const tabPanels = document.querySelectorAll('.tab-panel');

            navButtons.forEach(btn => {
                btn.addEventListener('click', function () {
                    const targetId = this.getAttribute('data-target');

                    navButtons.forEach(b => b.classList.remove('is-active'));
                    tabPanels.forEach(p => p.classList.remove('is-active'));

                    this.classList.add('is-active');
                    const targetPanel = document.getElementById(targetId);
                    if (targetPanel) {
                        targetPanel.classList.add('is-active');
                    }
                });
            });

            // Password eye toggle
            const toggleButtons = document.querySelectorAll('.profile-toggle-password');
            toggleButtons.forEach(btn => {
                btn.addEventListener('click', function () {
                    const wrapper = this.closest('.profile-password-wrapper');
                    const input = wrapper.querySelector('input');
                    const eyeShow = this.querySelector('.eye-show');
                    const eyeHide = this.querySelector('.eye-hide');

                    if (input.type === 'password') {
                        input.type = 'text';
                        eyeShow.style.display = 'none';
                        eyeHide.style.display = 'block';
                    } else {
                        input.type = 'password';
                        eyeShow.style.display = 'block';
                        eyeHide.style.display = 'none';
                    }
                });
            });
        });
    </script>
</body>
</html>
