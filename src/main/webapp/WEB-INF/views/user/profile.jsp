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
                <span class="profile-breadcrumb__current">Hồ sơ</span>
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
                        <button type="button" class="profile-nav__btn ${activeTab eq 'orders' ? 'is-active' : ''}" data-target="tab-orders">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                                <line x1="3" y1="6" x2="21" y2="6" />
                                <path d="M16 10a4 4 0 0 1-8 0" />
                            </svg>
                            Đơn hàng của tôi
                            <c:if test="${not empty orders}">
                                <span class="profile-badge-count"><c:out value="${orders.size()}" /></span>
                            </c:if>
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
                                <label for="fullName" class="profile-label">Họ và tên</label>
                                <input type="text" id="fullName" name="fullName" class="profile-input" 
                                       value="<c:out value='${userDTO.fullName}' />" required maxlength="255">
                                <div class="profile-helper">Tên hiển thị trên đơn hàng và thanh điều hướng.</div>
                            </div>

                            <div class="profile-form-group">
                                <label for="email" class="profile-label">Địa chỉ Email</label>
                                <div class="phone-display-group">
                                    <input type="email" id="email" class="profile-input" 
                                           value="<c:out value='${userDTO.email}' />" readonly>
                                    <button type="button" class="btn-change-phone" id="openEmailModalBtn" title="Thay đổi địa chỉ email">
                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                                            <polyline points="22,6 12,13 2,6" />
                                        </svg>
                                        Đổi Email
                                    </button>
                                </div>
                                <div class="profile-helper">Email dùng để đăng nhập và nhận mã OTP xác thực bảo mật tài khoản.</div>
                            </div>

                            <div class="profile-form-group">
                                <label for="phone" class="profile-label">Số điện thoại</label>
                                <div class="phone-display-group">
                                    <input type="text" id="phone" class="profile-input" 
                                           value="<c:out value='${not empty userDTO.phone ? userDTO.phone : \"Chưa cập nhật\"}' />" readonly>
                                    <button type="button" class="btn-change-phone" id="openPhoneModalBtn" title="Thay đổi số điện thoại">
                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                        </svg>
                                        Đổi SĐT
                                    </button>
                                </div>
                                <div class="profile-helper">Số điện thoại dùng để đăng nhập vào hệ thống và liên hệ giao hàng.</div>
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
                                        <svg class="eye-hide" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                                        <svg class="eye-hide" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                                        <svg class="eye-hide" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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

                                            <!-- Các nút thao tác Address CRUD -->
                                            <div class="address-card__actions">
                                                <c:if test="${not addr.isDefault}">
                                                    <form action="${ctx}/profile" method="post" class="profile-form-inline">
                                                        <input type="hidden" name="action" value="setDefaultAddress">
                                                        <input type="hidden" name="addressId" value="${addr.id}">
                                                        <button type="submit" class="address-btn address-btn--default">
                                                            ✓ Đặt làm mặc định
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <button type="button" class="address-btn address-btn--edit" 
                                                        data-id="${addr.id}"
                                                        data-name="<c:out value='${addr.recipientName}' />"
                                                        data-phone="<c:out value='${addr.phone}' />"
                                                        data-city="<c:out value='${addr.city}' />"
                                                        data-district="<c:out value='${addr.district}' />"
                                                        data-ward="<c:out value='${addr.ward}' />"
                                                        data-street="<c:out value='${addr.street}' />"
                                                        data-default="${addr.isDefault}">
                                                    ✎ Chỉnh sửa
                                                </button>

                                                <form action="${ctx}/profile" method="post" class="profile-form-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
                                                    <input type="hidden" name="action" value="deleteAddress">
                                                    <input type="hidden" name="addressId" value="${addr.id}">
                                                    <button type="submit" class="address-btn address-btn--delete">
                                                        ✕ Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Form thêm địa chỉ mới -->
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

                    <!-- TAB 4: DANH SÁCH ĐƠN HÀNG -->
                    <div id="tab-orders" class="tab-panel ${activeTab eq 'orders' ? 'is-active' : ''}">
                        <div class="profile-orders-header">
                            <div>
                                <h2 class="profile-section-title">Đơn Hàng Của Tôi</h2>
                                <p class="profile-section-desc">Theo dõi tình trạng đơn hàng và xem lại lịch sử các sản phẩm bạn đã đặt.</p>
                            </div>
                            <c:if test="${not empty orders}">
                                <div class="order-quick-summary">
                                    Tổng cộng: <strong>${orders.size()} đơn hàng</strong>
                                </div>
                            </c:if>
                        </div>

                        <c:choose>
                            <c:when test="${empty orders}">
                                <div class="profile-empty-orders">
                                    <div class="profile-empty-orders__icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                                            <line x1="3" y1="6" x2="21" y2="6" />
                                            <path d="M16 10a4 4 0 0 1-8 0" />
                                        </svg>
                                    </div>
                                    <h3 class="profile-empty-orders__title">Bạn chưa có đơn hàng nào</h3>
                                    <p class="profile-empty-orders__desc">Hãy khám phá bộ sưu tập trang phục thời trang mới nhất và chọn cho mình phong cách ưng ý nhé!</p>
                                    <a href="${ctx}/" class="profile-btn-primary profile-btn-shopping">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="9" cy="21" r="1" />
                                            <circle cx="20" cy="21" r="1" />
                                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" />
                                        </svg>
                                        Khám phá sản phẩm ngay
                                    </a>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <!-- Filter Status Pills -->
                                <div class="order-filter-pills" role="tablist">
                                    <button type="button" class="order-pill is-active" data-filter="ALL">Tất cả (${orders.size()})</button>
                                    <button type="button" class="order-pill" data-filter="PENDING">Chờ xác nhận</button>
                                    <button type="button" class="order-pill" data-filter="CONFIRMED">Đã xác nhận</button>
                                    <button type="button" class="order-pill" data-filter="SHIPPING">Đang giao</button>
                                    <button type="button" class="order-pill" data-filter="DELIVERED">Đã giao</button>
                                    <button type="button" class="order-pill" data-filter="CANCELLED">Đã hủy</button>
                                </div>

                                <div class="order-list">
                                    <c:forEach var="order" items="${orders}">
                                        <div class="order-card" data-order-status="${order.status}">
                                            <!-- HEADER THẺ ĐƠN HÀNG -->
                                            <div class="order-card__header">
                                                <div class="order-card__meta-left">
                                                    <span class="order-code"><c:out value="${order.orderCode}" /></span>
                                                    <span class="order-card__divider">&bull;</span>
                                                    <span class="order-date">
                                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                                                            <line x1="16" y1="2" x2="16" y2="6" />
                                                            <line x1="8" y1="2" x2="8" y2="6" />
                                                            <line x1="3" y1="10" x2="21" y2="10" />
                                                        </svg>
                                                        <c:out value="${order.formattedCreatedAt}" default="N/A" />
                                                    </span>
                                                </div>
                                                <div class="order-card__meta-right">
                                                    <span class="order-status-badge ${order.statusBadgeClass}">
                                                        <span class="order-status-dot"></span>
                                                        <c:out value="${order.statusName}" />
                                                    </span>
                                                </div>
                                            </div>

                                            <!-- DANH SÁCH MẶT HÀNG TRONG ĐƠN -->
                                            <div class="order-card__items">
                                                <c:choose>
                                                    <c:when test="${not empty order.items}">
                                                        <c:forEach var="item" items="${order.items}">
                                                            <div class="order-item-row">
                                                                <div class="order-item-row__img">
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.imageUrl}">
                                                                            <img src="${item.imageUrl}" alt="<c:out value='${item.productName}' />" loading="lazy">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                                                                <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                                                                                <line x1="3" y1="6" x2="21" y2="6" />
                                                                                <path d="M16 10a4 4 0 0 1-8 0" />
                                                                            </svg>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>

                                                                <div class="order-item-row__info">
                                                                    <div class="order-item-row__name">
                                                                        <c:out value="${item.productName}" default="Sản phẩm thời trang" />
                                                                    </div>
                                                                    <div class="order-item-row__variant">
                                                                        <span>Phân loại: <strong><c:out value="${not empty item.color ? item.color : 'Tiêu chuẩn'}" /></strong> / <strong><c:out value="${not empty item.size ? item.size : 'Freesize'}" /></strong></span>
                                                                        <c:if test="${not empty item.sku}">
                                                                            <span class="order-item-row__sku">SKU: <c:out value="${item.sku}" /></span>
                                                                        </c:if>
                                                                    </div>
                                                                </div>

                                                                <div class="order-item-row__pricing">
                                                                    <div class="order-item-row__unit">
                                                                        <c:out value="${item.formattedUnitPrice}" /> &times; <c:out value="${item.quantity}" />
                                                                    </div>
                                                                    <div class="order-item-row__subtotal">
                                                                        <c:out value="${item.formattedSubtotal}" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="order-item-row--empty">
                                                            <em>Thông tin chi tiết sản phẩm đang được cập nhật.</em>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- THÔNG TIN GIAO HÀNG & THANH TOÁN -->
                                            <div class="order-card__shipping-panel">
                                                <div class="order-shipping-grid">
                                                    <div class="order-shipping-col">
                                                        <div class="order-shipping-label">Người nhận & SĐT:</div>
                                                        <div class="order-shipping-val">
                                                            <strong><c:out value="${not empty order.shippingRecipientName ? order.shippingRecipientName : userDTO.fullName}" /></strong>
                                                            <c:if test="${not empty order.shippingPhone}">
                                                                &bull; <c:out value="${order.shippingPhone}" />
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div class="order-shipping-col">
                                                        <div class="order-shipping-label">Địa chỉ giao:</div>
                                                        <div class="order-shipping-val">
                                                            <c:out value="${not empty order.shippingAddressLine ? order.shippingAddressLine : 'Giao hàng theo thỏa thuận'}" />
                                                        </div>
                                                    </div>
                                                    <div class="order-shipping-col">
                                                        <div class="order-shipping-label">Phương thức:</div>
                                                        <div class="order-shipping-val">
                                                            <span class="order-payment-tag"><c:out value="${order.paymentMethod}" /></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- FOOTER THẺ ĐƠN HÀNG: TỔNG TIỀN VÀ THAO TÁC -->
                                            <div class="order-card__footer">
                                                <div class="order-card__total-box">
                                                    <span class="order-card__total-label">Thành tiền (${order.totalQuantity} món):</span>
                                                    <span class="order-card__total-amount"><c:out value="${order.formattedTotalAmount}" /></span>
                                                </div>

                                                <div class="order-card__action-buttons">
                                                    <c:if test="${order.canCancel}">
                                                        <form action="${ctx}/profile" method="post" class="profile-form-inline" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng ${order.orderCode} không?');">
                                                            <input type="hidden" name="action" value="cancelOrder">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <button type="submit" class="order-btn order-btn--cancel">
                                                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <line x1="15" y1="9" x2="9" y2="15" />
                                                                    <line x1="9" y1="9" x2="15" y2="15" />
                                                                </svg>
                                                                Hủy đơn hàng
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    
                                                    <c:if test="${order.status eq 'DELIVERED'}">
                                                        <span class="order-success-note">
                                                            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                                <polyline points="22 4 12 14.01 9 11.01" />
                                                            </svg>
                                                            Đã hoàn tất
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </section>
            </div>
        </div>
    </main>

    <!-- MODAL CHỈNH SỬA ĐỊA CHỈ -->
    <div id="editAddressModal" class="profile-modal" aria-hidden="true">
        <div class="profile-modal__content">
            <div class="profile-modal__header">
                <h3 class="profile-modal__title">Chỉnh Sửa Địa Chỉ Nhận Hàng</h3>
                <button type="button" class="profile-modal__close" id="closeEditModalBtn" aria-label="Đóng">&times;</button>
            </div>

            <form action="${ctx}/profile" method="post">
                <input type="hidden" name="action" value="editAddress">
                <input type="hidden" name="addressId" id="editAddressId">

                <div class="form-grid-2">
                    <div class="profile-form-group">
                        <label for="editRecipientName" class="profile-label">Họ và tên người nhận</label>
                        <input type="text" id="editRecipientName" name="recipientName" class="profile-input" required>
                    </div>

                    <div class="profile-form-group">
                        <label for="editPhone" class="profile-label">Số điện thoại nhận hàng</label>
                        <input type="tel" id="editPhone" name="phone" class="profile-input" required>
                    </div>
                </div>

                <div class="form-grid-3">
                    <div class="profile-form-group">
                        <label for="editCity" class="profile-label">Tỉnh / Thành phố</label>
                        <input type="text" id="editCity" name="city" class="profile-input" required>
                    </div>

                    <div class="profile-form-group">
                        <label for="editDistrict" class="profile-label">Quận / Huyện</label>
                        <input type="text" id="editDistrict" name="district" class="profile-input">
                    </div>

                    <div class="profile-form-group">
                        <label for="editWard" class="profile-label">Phường / Xã</label>
                        <input type="text" id="editWard" name="ward" class="profile-input">
                    </div>
                </div>

                <div class="profile-form-group">
                    <label for="editStreet" class="profile-label">Địa chỉ cụ thể (Số nhà, tên đường, tòa nhà)</label>
                    <input type="text" id="editStreet" name="street" class="profile-input" required>
                </div>

                <label class="checkbox-container">
                    <input type="checkbox" name="isDefault" id="editIsDefault" value="true">
                    Đặt làm địa chỉ nhận hàng mặc định
                </label>

                <div class="profile-modal__footer">
                    <button type="button" class="btn-secondary" id="cancelEditModalBtn">Hủy</button>
                    <button type="submit" class="profile-btn-primary">Cập nhật địa chỉ</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL THAY ĐỔI EMAIL -->
    <div id="changeEmailModal" class="profile-modal ${openEmailModal or not empty sessionScope.changeEmailOtpData ? 'is-open' : ''}" aria-hidden="${openEmailModal or not empty sessionScope.changeEmailOtpData ? 'false' : 'true'}">
        <div class="profile-modal__content">
            <div class="profile-modal__header">
                <h3 class="profile-modal__title">Thay Đổi Địa Chỉ Email</h3>
                <button type="button" class="profile-modal__close" id="closeEmailModalBtn" aria-label="Đóng">&times;</button>
            </div>

            <c:if test="${not empty changeEmailError}">
                <div class="modal-error-box">
                    <c:out value="${changeEmailError}" />
                </div>
            </c:if>

            <c:if test="${not empty changeEmailSuccess}">
                <div class="modal-info-box">
                    <c:out value="${changeEmailSuccess}" />
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.changeEmailOtpData}">
                    <!-- BƯỚC 2: NHẬP OTP XÁC NHẬN ĐỔI EMAIL -->
                    <div class="profile-modal-notice">
                        Mã OTP gồm 6 chữ số đã được gửi đến email mới: <strong><c:out value="${sessionScope.changeEmailOtpData.targetEmail}" /></strong>. Vui lòng nhập mã để hoàn tất.
                    </div>

                    <div class="modal-otp-meta">
                        <div>Hiệu lực còn: <span id="emailOtpCountdown" class="modal-otp-timer">--:--</span></div>
                        <div class="modal-otp-attempts">Lần thử: <strong><c:out value="${sessionScope.changeEmailOtpData.attemptsLeft}" />/3</strong></div>
                    </div>

                    <form action="${ctx}/profile" method="post" id="confirmEmailOtpForm">
                        <input type="hidden" name="action" value="confirmChangeEmail">

                        <div class="profile-form-group">
                            <label for="emailOtpCode" class="profile-label">Mã OTP (6 chữ số)</label>
                            <input type="text" id="emailOtpCode" name="otpCode" class="profile-input modal-otp-input" 
                                   placeholder="000000" maxlength="6" pattern="[0-9]{6}" required autofocus>
                        </div>

                        <div class="profile-modal__footer">
                            <a href="${ctx}/profile?action=cancelChangeEmailOtp" class="btn-secondary profile-modal-btn-cancel">Hủy</a>
                            <button type="submit" class="profile-btn-primary" id="btnConfirmEmailOtp">Xác nhận đổi Email</button>
                        </div>
                    </form>

                    <form action="${ctx}/profile" method="post">
                        <input type="hidden" name="action" value="resendChangeEmailOtp">
                        <button type="submit" class="modal-otp-resend-btn" id="resendEmailOtpBtn">Gửi lại mã OTP mới</button>
                    </form>
                </c:when>

                <c:otherwise>
                    <!-- BƯỚC 1: NHẬP MẬT KHẨU HIỆN TẠI VÀ EMAIL MỚI -->
                    <form action="${ctx}/profile" method="post" id="requestEmailForm">
                        <input type="hidden" name="action" value="requestChangeEmail">

                        <div class="profile-form-group">
                            <label class="profile-label">Email hiện tại</label>
                            <input type="email" class="profile-input" value="<c:out value='${userDTO.email}' />" readonly disabled>
                        </div>

                        <div class="profile-form-group">
                            <label for="currentPasswordForEmail" class="profile-label">Mật khẩu hiện tại <span class="profile-required-mark">*</span></label>
                            <input type="password" id="currentPasswordForEmail" name="currentPassword" class="profile-input" placeholder="Nhập mật khẩu hiện tại của bạn" required>
                        </div>

                        <div class="profile-form-group">
                            <label for="newEmail" class="profile-label">Địa chỉ Email mới <span class="profile-required-mark">*</span></label>
                            <input type="email" id="newEmail" name="newEmail" class="profile-input" placeholder="example@domain.com" required>
                            <div class="profile-helper">Hệ thống sẽ gửi mã OTP gồm 6 chữ số đến email mới này để xác thực.</div>
                        </div>

                        <div class="profile-modal__footer">
                            <button type="button" class="btn-secondary" id="cancelEmailModalBtn">Hủy</button>
                            <button type="submit" class="profile-btn-primary">Gửi mã OTP xác nhận</button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- MODAL THAY ĐỔI SỐ ĐIỆN THOẠI -->
    <div id="changePhoneModal" class="profile-modal ${openPhoneModal or not empty sessionScope.changePhoneOtpData ? 'is-open' : ''}" aria-hidden="${openPhoneModal or not empty sessionScope.changePhoneOtpData ? 'false' : 'true'}">
        <div class="profile-modal__content">
            <div class="profile-modal__header">
                <h3 class="profile-modal__title">Thay Đổi Số Điện Thoại</h3>
                <button type="button" class="profile-modal__close" id="closePhoneModalBtn" aria-label="Đóng">&times;</button>
            </div>

            <c:if test="${not empty changePhoneError}">
                <div class="modal-error-box">
                    <c:out value="${changePhoneError}" />
                </div>
            </c:if>

            <c:if test="${not empty changePhoneSuccess}">
                <div class="modal-info-box">
                    <c:out value="${changePhoneSuccess}" />
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.changePhoneOtpData}">
                    <!-- BƯỚC 2: NHẬP OTP XÁC NHẬN ĐỔI SĐT (GỬI VỀ EMAIL CỦA TÀI KHOẢN) -->
                    <div class="profile-modal-notice">
                        Mã OTP đã được gửi về email tài khoản: <strong><c:out value="${userDTO.email}" /></strong> để xác nhận thay đổi số điện thoại thành: <strong><c:out value="${sessionScope.changePhoneOtpData.payload['newPhone']}" /></strong>.
                    </div>

                    <div class="modal-otp-meta">
                        <div>Hiệu lực còn: <span id="phoneOtpCountdown" class="modal-otp-timer">--:--</span></div>
                        <div class="modal-otp-attempts">Lần thử: <strong><c:out value="${sessionScope.changePhoneOtpData.attemptsLeft}" />/3</strong></div>
                    </div>

                    <form action="${ctx}/profile" method="post" id="confirmPhoneOtpForm">
                        <input type="hidden" name="action" value="confirmChangePhone">

                        <div class="profile-form-group">
                            <label for="phoneOtpCode" class="profile-label">Mã OTP (6 chữ số)</label>
                            <input type="text" id="phoneOtpCode" name="otpCode" class="profile-input modal-otp-input" 
                                   placeholder="000000" maxlength="6" pattern="[0-9]{6}" required autofocus>
                        </div>

                        <div class="profile-modal__footer">
                            <a href="${ctx}/profile?action=cancelChangePhoneOtp" class="btn-secondary profile-modal-btn-cancel">Hủy</a>
                            <button type="submit" class="profile-btn-primary" id="btnConfirmPhoneOtp">Xác nhận đổi SĐT</button>
                        </div>
                    </form>

                    <form action="${ctx}/profile" method="post">
                        <input type="hidden" name="action" value="resendChangePhoneOtp">
                        <button type="submit" class="modal-otp-resend-btn" id="resendPhoneOtpBtn">Gửi lại mã OTP mới</button>
                    </form>
                </c:when>

                <c:otherwise>
                    <!-- BƯỚC 1: NHẬP SỐ ĐIỆN THOẠI MỚI -->
                    <form action="${ctx}/profile" method="post" id="changePhoneForm">
                        <input type="hidden" name="action" value="requestChangePhone">

                        <div class="profile-form-group">
                            <label class="profile-label">Số điện thoại hiện tại</label>
                            <input type="text" class="profile-input" value="<c:out value='${not empty userDTO.phone ? userDTO.phone : \"Chưa có SĐT\"}' />" readonly disabled>
                        </div>

                        <div class="profile-form-group">
                            <label for="modalNewPhone" class="profile-label">
                                Số điện thoại mới
                                <span class="profile-required-mark">*</span>
                            </label>
                            <input type="tel" id="modalNewPhone" name="newPhone" class="profile-input" placeholder="Ví dụ: 0912345678" required maxlength="15">
                            <div class="profile-helper">Nhập 10 chữ số (bắt đầu bằng 03, 05, 07, 08, 09 hoặc +84...).</div>
                        </div>

                        <div class="profile-modal-notice-box">
                            <div class="profile-modal-notice-title">Xác thực bảo mật qua Email</div>
                            Hệ thống không gửi tin nhắn SMS. Mã xác thực OTP sẽ được gửi về hộp thư Email của bạn (<strong class="profile-modal-notice-target"><c:out value="${userDTO.email}" /></strong>) để xác nhận.
                        </div>

                        <div class="profile-modal__footer">
                            <button type="button" class="btn-secondary" id="cancelPhoneModalBtn">Hủy</button>
                            <button type="submit" class="profile-btn-primary">Gửi mã xác nhận</button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

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

    <!-- JAVASCRIPT: TAB NAVIGATION, PASSWORD TOGGLE & EDIT MODAL -->
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

            // Edit Address Modal
            const editModal = document.getElementById('editAddressModal');
            const closeEditModalBtn = document.getElementById('closeEditModalBtn');
            const cancelEditModalBtn = document.getElementById('cancelEditModalBtn');
            const editButtons = document.querySelectorAll('.address-btn--edit');

            function openEditModal(btn) {
                document.getElementById('editAddressId').value = btn.getAttribute('data-id');
                document.getElementById('editRecipientName').value = btn.getAttribute('data-name') || '';
                document.getElementById('editPhone').value = btn.getAttribute('data-phone') || '';
                document.getElementById('editCity').value = btn.getAttribute('data-city') || '';
                document.getElementById('editDistrict').value = btn.getAttribute('data-district') || '';
                document.getElementById('editWard').value = btn.getAttribute('data-ward') || '';
                document.getElementById('editStreet').value = btn.getAttribute('data-street') || '';
                document.getElementById('editIsDefault').checked = btn.getAttribute('data-default') === 'true';

                editModal.classList.add('is-open');
                editModal.setAttribute('aria-hidden', 'false');
            }

            function closeEditModal() {
                editModal.classList.remove('is-open');
                editModal.setAttribute('aria-hidden', 'true');
            }

            editButtons.forEach(btn => {
                btn.addEventListener('click', function () {
                    openEditModal(this);
                });
            });

            if (closeEditModalBtn) {
                closeEditModalBtn.addEventListener('click', closeEditModal);
            }
            if (cancelEditModalBtn) {
                cancelEditModalBtn.addEventListener('click', closeEditModal);
            }

            // Click outside modal content to close
            window.addEventListener('click', function (e) {
                if (e.target === editModal) {
                    closeEditModal();
                }
            });

            // Order Status Pill Filtering
            const orderPills = document.querySelectorAll('.order-pill');
            const orderCards = document.querySelectorAll('.order-card');

            orderPills.forEach(pill => {
                pill.addEventListener('click', function () {
                    const filter = this.getAttribute('data-filter');

                    orderPills.forEach(p => p.classList.remove('is-active'));
                    this.classList.add('is-active');

                    orderCards.forEach(card => {
                        const status = card.getAttribute('data-order-status');
                        if (filter === 'ALL' || status === filter) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    });
                });
            });

            // Change Email Modal
            const emailModal = document.getElementById('changeEmailModal');
            const openEmailModalBtn = document.getElementById('openEmailModalBtn');
            const closeEmailModalBtn = document.getElementById('closeEmailModalBtn');
            const cancelEmailModalBtn = document.getElementById('cancelEmailModalBtn');

            function openEmailModal() {
                if (emailModal) {
                    emailModal.classList.add('is-open');
                    emailModal.setAttribute('aria-hidden', 'false');
                }
            }

            function closeEmailModal() {
                if (emailModal) {
                    emailModal.classList.remove('is-open');
                    emailModal.setAttribute('aria-hidden', 'true');
                }
            }

            if (openEmailModalBtn) openEmailModalBtn.addEventListener('click', openEmailModal);
            if (closeEmailModalBtn) closeEmailModalBtn.addEventListener('click', closeEmailModal);
            if (cancelEmailModalBtn) cancelEmailModalBtn.addEventListener('click', closeEmailModal);

            // Change Phone Modal
            const phoneModal = document.getElementById('changePhoneModal');
            const openPhoneModalBtn = document.getElementById('openPhoneModalBtn');
            const closePhoneModalBtn = document.getElementById('closePhoneModalBtn');
            const cancelPhoneModalBtn = document.getElementById('cancelPhoneModalBtn');

            function openPhoneModal() {
                if (phoneModal) {
                    phoneModal.classList.add('is-open');
                    phoneModal.setAttribute('aria-hidden', 'false');
                }
            }

            function closePhoneModal() {
                if (phoneModal) {
                    phoneModal.classList.remove('is-open');
                    phoneModal.setAttribute('aria-hidden', 'true');
                }
            }

            if (openPhoneModalBtn) openPhoneModalBtn.addEventListener('click', openPhoneModal);
            if (closePhoneModalBtn) closePhoneModalBtn.addEventListener('click', closePhoneModal);
            if (cancelPhoneModalBtn) cancelPhoneModalBtn.addEventListener('click', closePhoneModal);

            // Click outside modal content to close
            window.addEventListener('click', function (e) {
                if (e.target === emailModal) {
                    closeEmailModal();
                }
                if (e.target === phoneModal) {
                    closePhoneModal();
                }
            });

            // Countdown Timer for Email OTP
            <c:if test="${not empty sessionScope.changeEmailOtpData}">
            (function() {
                var remaining = <c:out value="${sessionScope.changeEmailOtpData.remainingSeconds}" default="120" />;
                var timerEl = document.getElementById('emailOtpCountdown');
                var submitBtn = document.getElementById('btnConfirmEmailOtp');
                function tick() {
                    if (!timerEl) return;
                    if (remaining <= 0) {
                        timerEl.textContent = 'Hết hạn';
                        timerEl.style.color = '#b91c1c';
                        if (submitBtn) submitBtn.disabled = true;
                        return;
                    }
                    var m = Math.floor(remaining / 60);
                    var s = remaining % 60;
                    timerEl.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
                    remaining--;
                    setTimeout(tick, 1000);
                }
                tick();

                var resendCooldown = <c:out value="${sessionScope.changeEmailOtpData.resendCooldownRemainingSeconds}" default="30" />;
                var resendBtn = document.getElementById('resendEmailOtpBtn');
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
            </c:if>

            // Countdown Timer for Phone OTP
            <c:if test="${not empty sessionScope.changePhoneOtpData}">
            (function() {
                var remaining = <c:out value="${sessionScope.changePhoneOtpData.remainingSeconds}" default="120" />;
                var timerEl = document.getElementById('phoneOtpCountdown');
                var submitBtn = document.getElementById('btnConfirmPhoneOtp');
                function tick() {
                    if (!timerEl) return;
                    if (remaining <= 0) {
                        timerEl.textContent = 'Hết hạn';
                        timerEl.style.color = '#b91c1c';
                        if (submitBtn) submitBtn.disabled = true;
                        return;
                    }
                    var m = Math.floor(remaining / 60);
                    var s = remaining % 60;
                    timerEl.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
                    remaining--;
                    setTimeout(tick, 1000);
                }
                tick();

                var resendCooldown = <c:out value="${sessionScope.changePhoneOtpData.resendCooldownRemainingSeconds}" default="30" />;
                var resendBtn = document.getElementById('resendPhoneOtpBtn');
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
            </c:if>
        });
    </script>
</body>
</html>
