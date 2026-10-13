<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Danh muc — Fashion Shop Admin</title>
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
                    <div class="admin-sidebar__logo-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                            stroke="white" stroke-width="2">
                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                            <line x1="3" y1="6" x2="21" y2="6" />
                            <path d="M16 10a4 4 0 0 1-8 0" />
                        </svg></div>
                    <div>
                        <div class="admin-sidebar__brand-name">Fashion.</div><span
                            class="admin-sidebar__brand-sub">Admin Panel</span>
                    </div>
                </div>
                <nav class="admin-sidebar__nav">
                    <div class="admin-sidebar__section-label">Tổng quan</div>
                    <a href="AdminDashboardServlet" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="7" height="7" />
                            <rect x="14" y="3" width="7" height="7" />
                            <rect x="14" y="14" width="7" height="7" />
                            <rect x="3" y="14" width="7" height="7" />
                        </svg>Dashboard</a>
                    <a href="/admin/stats" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="20" x2="18" y2="10" />
                            <line x1="12" y1="20" x2="12" y2="4" />
                            <line x1="6" y1="20" x2="6" y2="14" />
                        </svg>Thống kê</a>
                    <div class="admin-sidebar__section-label">Quản lý</div>
                    <a href="AdminCategoryServlet" class="admin-nav__item admin-nav__item--active"><svg
                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                        </svg>Danh mục</a>
                    <a href="AdminProductServlet" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <rect x="2" y="7" width="20" height="14" rx="2" />
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                        </svg>Sản phẩm</a>
                    <a href="AdminOrderServlet" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                        </svg>Đơn hàng</a>
                    <a href="AdminVoucherServlet" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z" />
                        </svg>Voucher</a>
                </nav>
                <div class="admin-sidebar__footer">
                    <div class="admin-sidebar__user">
                        <div class="admin-sidebar__avatar">A</div>
                        <div class="admin-sidebar__user-info">
                            <div class="admin-sidebar__user-name">Admin</div>
                            <div class="admin-sidebar__user-role">Quản trị viên</div>
                        </div>
                        <a href="/logout" class="admin-sidebar__logout"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                                <polyline points="16 17 21 12 16 7" />
                                <line x1="21" y1="12" x2="9" y2="12" />
                            </svg></a>
                    </div>
                </div>
            </aside>
            <main class="admin-main">
                <div class="admin-topbar">
                    <div class="admin-topbar__breadcrumb">
                        <a href="/admin/dashboard">Admin</a>
                        <span class="admin-topbar__breadcrumb-sep">/</span>
                        <span class="admin-topbar__breadcrumb-current">Danh mục</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">Danh mục sản phẩm</h1>
                            <p class="admin-page-header__subtitle">Quan ly danh muc cha va danh muc con (toi da 2 cap).
                            </p>
                        </div>
                        <div class="admin-page-header__actions">
                            <a href="/admin/categories/new" class="btn btn--primary">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm danh mục
                            </a>
                        </div>
                    </div>

                    <div class="admin-panel">
                        <div class="admin-filter-bar">
                            <form method="get" action="/admin/categories" style="display:flex;gap:8px;width:100%;">
                                <div class="admin-search">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="11" cy="11" r="8" />
                                        <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                    </svg>
                                    <input type="text" name="q" placeholder="Tim kiem danh muc..." value="">
                                </div>
                                <select name="type" class="admin-select">
                                    <option value="">Tat ca cap</option>
                                    <option value="parent">Danh muc cha</option>
                                    <option value="child">Danh muc con</option>
                                </select>
                                <button type="submit" class="btn btn--secondary">Lọc</button>
                            </form>
                        </div>
                        <div class="admin-table-wrap">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Ten danh muc</th>
                                        <th>Danh muc cha</th>
                                        <th>So san pham</th>
                                        <th>Thao tac</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><span class="admin-table__id">#1</span></td>
                                        <td>
                                            <div class="admin-table__name">Ao</div>
                                            <div class="admin-table__meta" style="color:var(--primary-text);">Danh muc
                                                cha</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">
                                            —
                                        </td>
                                        <td style="font-weight:500;">24</td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/categories/1/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/categories/1/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa danh muc nay?')">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <polyline points="3 6 5 6 21 6" />
                                                            <path
                                                                d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#2</span></td>
                                        <td>
                                            <div class="admin-table__name">Ao thun</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">
                                            Ao
                                        </td>
                                        <td style="font-weight:500;">12</td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/categories/2/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/categories/2/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa danh muc nay?')">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <polyline points="3 6 5 6 21 6" />
                                                            <path
                                                                d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#3</span></td>
                                        <td>
                                            <div class="admin-table__name">Quan</div>
                                            <div class="admin-table__meta" style="color:var(--primary-text);">Danh muc
                                                cha</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">
                                            —
                                        </td>
                                        <td style="font-weight:500;">16</td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/categories/3/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/categories/3/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa danh muc nay?')">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <polyline points="3 6 5 6 21 6" />
                                                            <path
                                                                d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#4</span></td>
                                        <td>
                                            <div class="admin-table__name">Quan jeans</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">
                                            Quan
                                        </td>
                                        <td style="font-weight:500;">6</td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/categories/4/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/categories/4/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa danh muc nay?')">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <polyline points="3 6 5 6 21 6" />
                                                            <path
                                                                d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#5</span></td>
                                        <td>
                                            <div class="admin-table__name">Phu kien</div>
                                            <div class="admin-table__meta" style="color:var(--primary-text);">Danh muc
                                                cha</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">
                                            —
                                        </td>
                                        <td style="font-weight:500;">8</td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/categories/5/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/categories/5/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa danh muc nay?')">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <polyline points="3 6 5 6 21 6" />
                                                            <path
                                                                d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="admin-pagination">
                            <span class="admin-pagination__info">Hien thi 5 danh muc</span>
                            <div class="admin-pagination__pages">
                                <a href="?page=1" class="admin-pagination__btn admin-pagination__btn--active">1</a>
                                <a href="?page=2" class="admin-pagination__btn">2</a>
                                <a href="?page=3" class="admin-pagination__btn">3</a>
                                <a href="?page=2" class="admin-pagination__btn">&#8594;</a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>

    </html>