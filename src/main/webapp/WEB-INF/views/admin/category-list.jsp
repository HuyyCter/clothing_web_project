<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Danh mục — Fashion Shop Admin</title>
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
                    <a href="${pageContext.request.contextPath}/admin-home.jsp" class="admin-sidebar__brand" style="text-decoration:none;">
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
                    </a>
                    <nav class="admin-sidebar__nav">
                        <div class="admin-sidebar__section-label">Tổng quan</div>
                        <a href="${pageContext.request.contextPath}/admin-home.jsp" class="admin-nav__item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="7" height="7" />
                            <rect x="14" y="3" width="7" height="7" />
                            <rect x="14" y="14" width="7" height="7" />
                            <rect x="3" y="14" width="7" height="7" />
                        </svg>
                        Trang chủ Admin
                    </a>
                    <a href="AdminDashboardServlet" class="admin-nav__item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="20" x2="18" y2="10" />
                            <line x1="12" y1="20" x2="12" y2="4" />
                            <line x1="6" y1="20" x2="6" y2="14" />
                        </svg>
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="admin-nav__item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                            <line x1="3" y1="6" x2="21" y2="6" />
                            <path d="M16 10a4 4 0 0 1-8 0" />
                        </svg>
                        Xem trang bán hàng
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
                            <a href="${pageContext.request.contextPath}/logout" class="admin-sidebar__logout">
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
                    <div class="admin-topbar">
                        <div class="admin-topbar__breadcrumb">
                            <a href="AdminDashboardServlet">Admin</a>
                            <span class="admin-topbar__breadcrumb-sep">/</span>
                            <span class="admin-topbar__breadcrumb-current">Danh mục</span>
                        </div>
                    </div>
                    <div class="admin-content">
                        <div class="admin-page-header">
                            <div>
                                <h1 class="admin-page-header__title">Danh mục sản phẩm</h1>
                                <p class="admin-page-header__subtitle">Quản lý các danh mục sản phẩm của cửa hàng.</p>
                            </div>
                            <div class="admin-page-header__actions">
                                <a href="AdminCategoryServlet?action=new" class="btn btn--primary">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="12" y1="5" x2="12" y2="19" />
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                    </svg>
                                    Thêm danh mục
                                </a>
                            </div>
                        </div>

                        <c:if test="${not empty successMessage}">
                            <div role="status"
                                style="background:var(--success-bg-subtle);color:var(--success-text);border:var(--border-width-1) solid var(--success-border);border-radius:var(--radius-md);padding:12px 16px;margin-bottom:16px;font-size:14px;">
                                <c:out value="${successMessage}" />
                            </div>
                        </c:if>

                        <div class="admin-panel">
                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên danh mục</th>
                                            <th>Slug</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="category" items="${categories}">
                                            <tr>
                                                <td>
                                                    <span class="admin-table__id">#
                                                        <c:out value="${category.id}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="admin-table__name">
                                                        <c:out value="${category.name}" />
                                                    </div>
                                                    <c:if test="${not empty category.description}">
                                                        <div class="admin-table__meta">
                                                            <c:out value="${category.description}" />
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td style="color:var(--text-muted);font-size:13px;">
                                                    <c:out value="${category.slug}" />
                                                </td>
                                                <td>
                                                    <div class="admin-table__actions">
                                                        <a href="AdminCategoryServlet?action=edit&amp;id=${category.id}"
                                                            class="btn-icon" title="Sửa">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                                stroke-width="2">
                                                                <path
                                                                    d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                <path
                                                                    d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                            </svg>
                                                        </a>
                                                        <form method="post" action="AdminCategoryServlet"
                                                            style="display:inline;">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${category.id}">
                                                            <button type="submit" class="btn-icon btn-icon--danger"
                                                                title="Xóa"
                                                                onclick="return confirm('Xác nhận xóa danh mục này?')">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <polyline points="3 6 5 6 21 6" />
                                                                    <path
                                                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                                </svg>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty categories}">
                                            <tr>
                                                <td colspan="4"
                                                    style="text-align:center;color:var(--text-muted);padding:32px 0;">
                                                    Chưa có danh mục nào.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </body>

        </html>