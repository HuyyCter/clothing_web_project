<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Sản phẩm — Fashion Shop Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-product.css">
            </head>

            <body>
                <div class="admin-shell">
                    <aside class="admin-sidebar">
                        <div class="admin-sidebar__brand">
                            <div class="admin-sidebar__logo-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white"
                                    stroke-width="2">
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
                                    <path
                                        d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
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
                        <div class="admin-topbar">
                            <div class="admin-topbar__breadcrumb">
                                <a href="AdminDashboardServlet">Admin</a>
                                <span class="admin-topbar__breadcrumb-sep">/</span>
                                <span class="admin-topbar__breadcrumb-current">Sản phẩm</span>
                            </div>
                        </div>
                        <div class="admin-content">
                            <div class="admin-page-header">
                                <div>
                                    <h1 class="admin-page-header__title">Sản phẩm</h1>
                                    <p class="admin-page-header__subtitle">Quản lý sản phẩm, kho hàng và hình ảnh của
                                        cửa hàng.</p>
                                </div>
                                <div class="admin-page-header__actions">
                                    <a href="AdminProductServlet?action=new" class="btn btn--primary">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <line x1="12" y1="5" x2="12" y2="19" />
                                            <line x1="5" y1="12" x2="19" y2="12" />
                                        </svg>
                                        Thêm sản phẩm
                                    </a>
                                </div>
                            </div>

                            <c:if test="${not empty successMessage}">
                                <div role="status"
                                    style="background:var(--success-bg-subtle);color:var(--success-text);border:var(--border-width-1) solid var(--success-border);border-radius:var(--radius-md);padding:12px 16px;margin-bottom:16px;font-size:14px;">
                                    <c:out value="${successMessage}" />
                                </div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div role="alert"
                                    style="background:var(--error-bg-subtle);color:var(--error-text);border:var(--border-width-1) solid var(--error-border);border-radius:var(--radius-md);padding:12px 16px;margin-bottom:16px;font-size:14px;">
                                    <c:out value="${error}" />
                                </div>
                            </c:if>

                            <div class="admin-panel">
                                <div class="admin-table-wrap">
                                    <table class="admin-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên sản phẩm</th>
                                                <th>Danh mục</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="product" items="${products}">
                                                <tr>
                                                    <td>
                                                        <span class="admin-table__id">#
                                                            <c:out value="${product.id}" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="admin-table__name">
                                                            <c:out value="${product.name}" />
                                                        </div>
                                                    </td>
                                                    <td style="color:var(--text-muted);font-size:13px;">
                                                        <c:out value="${product.categoryName}" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.active}">
                                                                <span class="admin-badge admin-badge--success">Đang hiển
                                                                    thị</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="admin-badge admin-badge--neutral">Đã
                                                                    ẩn</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="admin-table__actions">
                                                            <a href="AdminProductServlet?action=edit&amp;id=${product.id}"
                                                                class="btn-icon" title="Sửa">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                    <path
                                                                        d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                                </svg>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty products}">
                                                <tr>
                                                    <td colspan="5"
                                                        style="text-align:center;color:var(--text-muted);padding:32px 0;">
                                                        Chưa có sản phẩm nào.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <c:if test="${totalPages > 1}">
                                <nav class="admin-pager" aria-label="Phân trang">
                                    <c:if test="${currentPage > 1}">
                                        <a href="AdminProductServlet?page=${currentPage - 1}"
                                            class="admin-pager__item">&lsaquo;</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <a href="AdminProductServlet?page=${p}"
                                            class="admin-pager__item${p == currentPage ? ' admin-pager__item--active' : ''}">${p}</a>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="AdminProductServlet?page=${currentPage + 1}"
                                            class="admin-pager__item">&rsaquo;</a>
                                    </c:if>
                                </nav>
                            </c:if>
                        </div>
                    </main>
                </div>
            </body>

            </html>