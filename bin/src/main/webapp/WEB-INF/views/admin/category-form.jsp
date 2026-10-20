<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Biểu mẫu danh mục — Fashion Shop Admin</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        </head>

        <body>
            <div class="admin-shell">
                <aside class="admin-sidebar">
                    <div class="admin-sidebar__brand">
                        <div class="admin-sidebar__logo-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                                <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                                <line x1="3" y1="6" x2="21" y2="6" />
                                <path d="M16 10a4 4 0 0 1-8 0" />
                            </svg>
                        </div>
                        <div>
                            <div class="admin-sidebar__brand-name">Fashion.</div>
                            <span class="admin-sidebar__brand-sub">Admin Panel</span>
                        </div>
                    </div>
                    <nav class="admin-sidebar__nav">
                        <div class="admin-sidebar__section-label">Tổng quan</div>
                        <a href="AdminDashboardServlet" class="admin-nav__item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="7" height="7" />
                                <rect x="14" y="3" width="7" height="7" />
                                <rect x="14" y="14" width="7" height="7" />
                                <rect x="3" y="14" width="7" height="7" />
                            </svg>
                            Dashboard
                        </a>
                        <div class="admin-sidebar__section-label">Quản lý</div>
                        <a href="AdminCategoryServlet" class="admin-nav__item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                            </svg>
                            Danh mục
                        </a>
                        <a href="AdminProductServlet" class="admin-nav__item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="2" y="7" width="20" height="14" rx="2" />
                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                            </svg>
                            Sản phẩm
                        </a>
                        <a href="AdminOrderServlet" class="admin-nav__item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                <polyline points="14 2 14 8 20 8" />
                            </svg>
                            Đơn hàng
                        </a>
                        <a href="AdminVoucherServlet" class="admin-nav__item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path
                                    d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z" />
                            </svg>
                            Voucher
                        </a>
                    </nav>
                    <div class="admin-sidebar__footer">
                        <div class="admin-sidebar__user">
                            <div class="admin-sidebar__avatar">A</div>
                            <div class="admin-sidebar__user-info">
                                <div class="admin-sidebar__user-name">Admin</div>
                                <div class="admin-sidebar__user-role">Quản trị viên</div>
                            </div>
                            <a href="/logout" class="admin-sidebar__logout">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                                    <polyline points="16 17 21 12 16 7" />
                                    <line x1="21" y1="12" x2="9" y2="12" />
                                </svg>
                            </a>
                        </div>
                    </div>
                </aside>
                <main class="admin-main">
                    <c:set var="isEdit" value="${category.id > 0}" />
                    <div class="admin-topbar">
                        <div class="admin-topbar__breadcrumb">
                            <a href="AdminDashboardServlet">Admin</a>
                            <span class="admin-topbar__breadcrumb-sep">/</span>
                            <a href="AdminCategoryServlet">Danh mục</a>
                            <span class="admin-topbar__breadcrumb-sep">/</span>
                            <span class="admin-topbar__breadcrumb-current">
                                <c:choose>
                                    <c:when test="${isEdit}">Chỉnh sửa</c:when>
                                    <c:otherwise>Thêm mới</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="admin-content">
                        <div class="admin-page-header">
                            <div>
                                <h1 class="admin-page-header__title">
                                    <c:choose>
                                        <c:when test="${isEdit}">Chỉnh sửa danh mục</c:when>
                                        <c:otherwise>Thêm danh mục mới</c:otherwise>
                                    </c:choose>
                                </h1>
                                <p class="admin-page-header__subtitle">Slug sẽ được tự sinh từ tên danh mục.</p>
                            </div>
                        </div>

                        <c:if test="${not empty error}">
                            <div role="alert"
                                style="background:var(--error-bg-subtle);color:var(--error-text);border:var(--border-width-1) solid var(--error-border);border-radius:var(--radius-md);padding:12px 16px;margin-bottom:16px;font-size:14px;">
                                <c:out value="${error}" />
                            </div>
                        </c:if>

                        <form method="post" action="AdminCategoryServlet">
                            <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
                            <c:if test="${isEdit}">
                                <input type="hidden" name="id" value="${category.id}">
                            </c:if>
                            <div class="admin-form-panel">
                                <div class="admin-form-panel__header">
                                    <span class="admin-form-panel__title">Thông tin danh mục</span>
                                </div>
                                <div class="admin-form-panel__body">
                                    <div class="admin-form-grid admin-form-grid--1col">
                                        <div class="admin-form-group">
                                            <label for="name" class="admin-form-label admin-form-label--required">
                                                Tên danh mục
                                            </label>
                                            <input type="text" id="name" name="name" class="admin-form-input"
                                                placeholder="Nhập tên danh mục..." maxlength="255"
                                                value="<c:out value='${category.name}' />" required>
                                        </div>
                                        <div class="admin-form-group">
                                            <label for="description" class="admin-form-label">Mô tả</label>
                                            <textarea id="description" name="description" class="admin-form-input"
                                                rows="4"
                                                placeholder="Mô tả ngắn về danh mục (không bắt buộc)..."><c:out value="${category.description}" /></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="admin-form-actions">
                                    <a href="AdminCategoryServlet" class="btn btn--secondary">Hủy</a>
                                    <button type="submit" class="btn btn--primary">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                            <polyline points="17 21 17 13 7 13 7 21" />
                                            <polyline points="7 3 7 8 15 8" />
                                        </svg>
                                        <c:choose>
                                            <c:when test="${isEdit}">Lưu thay đổi</c:when>
                                            <c:otherwise>Tạo danh mục</c:otherwise>
                                        </c:choose>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </body>

        </html>