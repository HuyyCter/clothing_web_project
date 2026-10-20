<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Đơn hàng — Fashion Shop Admin</title>
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
                                <span class="admin-topbar__breadcrumb-current">Đơn hàng</span>
                            </div>
                        </div>
                        <div class="admin-content">
                            <div class="admin-page-header">
                                <div>
                                    <h1 class="admin-page-header__title">Quản lý đơn hàng</h1>
                                    <p class="admin-page-header__subtitle">Xem và cập nhật trạng thái đơn hàng theo đúng
                                        quy trình.</p>
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
                                                <th>Mã đơn</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày đặt</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="order" items="${orders}">
                                                <tr>
                                                    <td>
                                                        <span class="admin-table__id">#
                                                            <c:out value="${order.id}" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.status == 'PENDING'}">
                                                                <span class="badge badge--pending">Chờ xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'CONFIRMED'}">
                                                                <span class="badge badge--confirmed">Đã xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'SHIPPING'}">
                                                                <span class="badge badge--shipping">Đang giao</span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'DELIVERED'}">
                                                                <span class="badge badge--delivered">Đã giao</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge--cancelled">Đã hủy</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td
                                                        style="color:var(--text-muted);font-size:12px;white-space:nowrap;">
                                                        <c:out value="${order.formattedCreatedAt}" />
                                                    </td>
                                                    <td>
                                                        <div class="admin-table__actions">
                                                            <c:if test="${order.status == 'PENDING'}">
                                                                <form method="post" action="AdminOrderServlet"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="action"
                                                                        value="updateStatus">
                                                                    <input type="hidden" name="id" value="${order.id}">
                                                                    <input type="hidden" name="status"
                                                                        value="CONFIRMED">
                                                                    <button type="submit"
                                                                        class="btn btn--secondary btn--sm">Xác
                                                                        nhận</button>
                                                                </form>
                                                            </c:if>
                                                            <c:if test="${order.status == 'CONFIRMED'}">
                                                                <form method="post" action="AdminOrderServlet"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="action"
                                                                        value="updateStatus">
                                                                    <input type="hidden" name="id" value="${order.id}">
                                                                    <input type="hidden" name="status" value="SHIPPING">
                                                                    <button type="submit"
                                                                        class="btn btn--secondary btn--sm">Giao
                                                                        hàng</button>
                                                                </form>
                                                            </c:if>
                                                            <c:if test="${order.status == 'SHIPPING'}">
                                                                <form method="post" action="AdminOrderServlet"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="action"
                                                                        value="updateStatus">
                                                                    <input type="hidden" name="id" value="${order.id}">
                                                                    <input type="hidden" name="status"
                                                                        value="DELIVERED">
                                                                    <button type="submit"
                                                                        class="btn btn--secondary btn--sm">Đã
                                                                        giao</button>
                                                                </form>
                                                            </c:if>
                                                            <c:if
                                                                test="${order.status == 'PENDING' or order.status == 'CONFIRMED'}">
                                                                <form method="post" action="AdminOrderServlet"
                                                                    style="display:inline;">
                                                                    <input type="hidden" name="action"
                                                                        value="updateStatus">
                                                                    <input type="hidden" name="id" value="${order.id}">
                                                                    <input type="hidden" name="status"
                                                                        value="CANCELLED">
                                                                    <button type="submit"
                                                                        class="btn btn--secondary btn--sm"
                                                                        onclick="return confirm('Xác nhận hủy đơn hàng này?')">Hủy
                                                                        đơn</button>
                                                                </form>
                                                            </c:if>
                                                            <c:if
                                                                test="${order.status == 'DELIVERED' or order.status == 'CANCELLED'}">
                                                                <span
                                                                    style="color:var(--text-muted);font-size:13px;">—</span>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty orders}">
                                                <tr>
                                                    <td colspan="4"
                                                        style="text-align:center;color:var(--text-muted);padding:32px 0;">
                                                        Chưa có đơn hàng nào.
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