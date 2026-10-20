<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Dashboard — Fashion Shop Admin</title>
            <meta name="description" content="Admin dashboard tổng quan doanh thu và đơn hàng.">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        </head>

        <body>
            <div class="admin-shell">

                <!-- SIDEBAR -->
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

                <!-- MAIN -->
                <main class="admin-main">
                    <div class="admin-topbar">
                        <div class="admin-topbar__breadcrumb">
                            <span class="admin-topbar__breadcrumb-current">Dashboard</span>
                        </div>
                    </div>

                    <div class="admin-content">
                        <div class="admin-page-header">
                            <div>
                                <h1 class="admin-page-header__title">Tổng quan</h1>
                                <p class="admin-page-header__subtitle">Chào mừng trở lại — đây là tóm tắt hoạt động của
                                    shop.</p>
                            </div>
                        </div>

                        <!-- Stat Cards -->
                        <div class="admin-stat-grid">
                            <div class="admin-stat-card">
                                <div class="admin-stat-card__icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                        <polyline points="14 2 14 8 20 8" />
                                    </svg>
                                </div>
                                <div class="admin-stat-card__label">Tổng đơn hàng</div>
                                <div class="admin-stat-card__value">128</div>
                                <div class="admin-stat-card__sub">12 đơn chờ xử lý</div>
                            </div>
                            <div class="admin-stat-card">
                                <div class="admin-stat-card__icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="12" y1="1" x2="12" y2="23" />
                                        <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
                                    </svg>
                                </div>
                                <div class="admin-stat-card__label">Doanh thu</div>
                                <div class="admin-stat-card__value">45.890.000đ</div>
                                <div class="admin-stat-card__sub">Từ đơn đã giao</div>
                            </div>
                            <div class="admin-stat-card">
                                <div class="admin-stat-card__icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="2" y="7" width="20" height="14" rx="2" />
                                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                    </svg>
                                </div>
                                <div class="admin-stat-card__label">Sản phẩm</div>
                                <div class="admin-stat-card__value">
                                    <c:out value="${activeProductCount}" />
                                </div>
                                <div class="admin-stat-card__sub">Đang kinh doanh</div>
                            </div>
                            <div class="admin-stat-card">
                                <div class="admin-stat-card__icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                        <circle cx="12" cy="7" r="4" />
                                    </svg>
                                </div>
                                <div class="admin-stat-card__label">Khách hàng</div>
                                <div class="admin-stat-card__value">
                                    <c:out value="${customerCount}" />
                                </div>
                                <div class="admin-stat-card__sub">Tài khoản đã đăng ký</div>
                            </div>
                        </div>

                        <!-- Recent Orders + Latest Products -->
                        <div style="display:grid;grid-template-columns:1fr 380px;gap:20px;align-items:start;">

                            <!-- Recent Orders -->
                            <div class="admin-panel">
                                <div class="admin-panel__header">
                                    <span class="admin-panel__title">Đơn hàng gần đây</span>
                                    <a href="${pageContext.request.contextPath}/AdminOrderServlet" class="btn btn--secondary btn--sm">Xem tất cả</a>
                                </div>
                                <div class="admin-table-wrap">
                                    <table class="admin-table">
                                        <thead>
                                            <tr>
                                                <th>Mã đơn</th>
                                                <th>Khách hàng</th>
                                                <th>Tổng tiền</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày đặt</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><a href="${pageContext.request.contextPath}/AdminOrderServlet" class="admin-table__id"
                                                        style="color:var(--primary-text);text-decoration:none;">#1024</a>
                                                </td>
                                                <td>Nguyễn Văn An</td>
                                                <td>890.000đ</td>
                                                <td>
                                                    <span class="badge badge--pending">Chờ xác nhận</span>
                                                </td>
                                                <td style="color:var(--text-muted);font-size:12px;">30/09/2026 09:15
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="${pageContext.request.contextPath}/AdminOrderServlet" class="admin-table__id"
                                                        style="color:var(--primary-text);text-decoration:none;">#1023</a>
                                                </td>
                                                <td>Trần Thị Bình</td>
                                                <td>1.250.000đ</td>
                                                <td>
                                                    <span class="badge badge--confirmed">Đã xác nhận</span>
                                                </td>
                                                <td style="color:var(--text-muted);font-size:12px;">29/09/2026 16:40
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="${pageContext.request.contextPath}/AdminOrderServlet" class="admin-table__id"
                                                        style="color:var(--primary-text);text-decoration:none;">#1022</a>
                                                </td>
                                                <td>Lê Minh Cường</td>
                                                <td>529.000đ</td>
                                                <td>
                                                    <span class="badge badge--shipping">Đang giao</span>
                                                </td>
                                                <td style="color:var(--text-muted);font-size:12px;">29/09/2026 11:05
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="${pageContext.request.contextPath}/AdminOrderServlet" class="admin-table__id"
                                                        style="color:var(--primary-text);text-decoration:none;">#1021</a>
                                                </td>
                                                <td>Phạm Thu Hà</td>
                                                <td>2.140.000đ</td>
                                                <td>
                                                    <span class="badge badge--delivered">Đã giao</span>
                                                </td>
                                                <td style="color:var(--text-muted);font-size:12px;">28/09/2026 14:30
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><a href="${pageContext.request.contextPath}/AdminOrderServlet" class="admin-table__id"
                                                        style="color:var(--primary-text);text-decoration:none;">#1020</a>
                                                </td>
                                                <td>Hoàng Đức Long</td>
                                                <td>459.000đ</td>
                                                <td>
                                                    <span class="badge badge--cancelled">Đã hủy</span>
                                                </td>
                                                <td style="color:var(--text-muted);font-size:12px;">27/09/2026 20:22
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Latest Products -->
                            <div class="admin-panel">
                                <div class="admin-panel__header">
                                    <span class="admin-panel__title">Sản phẩm mới thêm</span>
                                    <a href="AdminProductServlet" class="btn btn--secondary btn--sm">Xem tất cả</a>
                                </div>
                                <div class="admin-table-wrap">
                                    <table class="admin-table">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Sản phẩm</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="product" items="${latestProducts}" varStatus="loop">
                                                <tr>
                                                    <td style="color:var(--text-muted);font-size:12px;">${loop.count}
                                                    </td>
                                                    <td>
                                                        <div class="admin-table__name">
                                                            <c:out value="${product.name}" />
                                                        </div>
                                                        <div class="admin-table__meta">
                                                            <c:out value="${product.categoryName}" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.active}">
                                                                <span class="badge badge--delivered">Đang bán</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge--cancelled">Đã ẩn</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty latestProducts}">
                                                <tr>
                                                    <td colspan="3"
                                                        style="text-align:center;color:var(--text-muted);padding:32px 0;">
                                                        Chưa có sản phẩm nào.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </body>

        </html>