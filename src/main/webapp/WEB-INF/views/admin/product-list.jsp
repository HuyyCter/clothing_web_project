<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>San pham — Fashion Shop Admin</title>
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
                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z" />
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
                        <a href="/admin/dashboard">Admin</a>
                        <span class="admin-topbar__breadcrumb-sep">/</span>
                        <span class="admin-topbar__breadcrumb-current">San pham</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">San pham</h1>
                            <p class="admin-page-header__subtitle">Quan ly toan bo san pham va bien the (size, mau, ton
                                kho).</p>
                        </div>
                        <div class="admin-page-header__actions">
                            <a href="/admin/products/new" class="btn btn--primary">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Them san pham
                            </a>
                        </div>
                    </div>

                    <div class="admin-panel">
                        <div class="admin-filter-bar">
                            <form method="get" action="/admin/products"
                                style="display:flex;gap:8px;flex:1;flex-wrap:wrap;">
                                <div class="admin-search" style="flex:1;min-width:180px;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="11" cy="11" r="8" />
                                        <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                    </svg>
                                    <input type="text" name="q" placeholder="Tim theo ten san pham..." value="">
                                </div>
                                <select name="categoryId" class="admin-select">
                                    <option value="">Tat ca danh muc</option>
                                    <option value="1">Ao</option>
                                    <option value="2">Quan</option>
                                    <option value="3">Phu kien</option>
                                </select>
                                <select name="sort" class="admin-select">
                                    <option value="">Mac dinh</option>
                                    <option value="newest">Moi nhat</option>
                                    <option value="price_asc">Gia tang</option>
                                    <option value="price_desc">Gia giam</option>
                                </select>
                                <button type="submit" class="btn btn--secondary">Loc</button>
                            </form>
                        </div>
                        <div class="admin-table-wrap">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Anh</th>
                                        <th>San pham</th>
                                        <th>Danh muc</th>
                                        <th>Bien the</th>
                                        <th>Gia (tu)</th>
                                        <th>Thao tac</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="admin-table__img-placeholder">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" />
                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                    <polyline points="21 15 16 10 5 21" />
                                                </svg>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="admin-table__name">Ao thun cotton basic</div>
                                            <div class="admin-table__meta admin-table__id">#1</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">Ao thun</td>
                                        <td style="font-size:13px;">6 bien the</td>
                                        <td>
                                            <span class="price">249.000d</span>
                                        </td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/products/1/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/products/1/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa san pham nay? Hanh dong nay khong the hoan tac.')">
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
                                        <td>
                                            <div class="admin-table__img-placeholder">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" />
                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                    <polyline points="21 15 16 10 5 21" />
                                                </svg>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="admin-table__name">Ao so mi Oxford tay dai</div>
                                            <div class="admin-table__meta admin-table__id">#2</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">Ao so mi</td>
                                        <td style="font-size:13px;">8 bien the</td>
                                        <td>
                                            <span class="price">459.000d</span>
                                        </td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/products/2/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/products/2/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa san pham nay? Hanh dong nay khong the hoan tac.')">
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
                                        <td>
                                            <div class="admin-table__img-placeholder">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" />
                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                    <polyline points="21 15 16 10 5 21" />
                                                </svg>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="admin-table__name">Quan chinos slim fit</div>
                                            <div class="admin-table__meta admin-table__id">#3</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">Quan chinos</td>
                                        <td style="font-size:13px;">9 bien the</td>
                                        <td>
                                            <span class="price">529.000d</span>
                                        </td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/products/3/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/products/3/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa san pham nay? Hanh dong nay khong the hoan tac.')">
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
                                        <td>
                                            <div class="admin-table__img-placeholder">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" />
                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                    <polyline points="21 15 16 10 5 21" />
                                                </svg>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="admin-table__name">Ao khoac bomber toi gian</div>
                                            <div class="admin-table__meta admin-table__id">#4</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">Ao khoac</td>
                                        <td style="font-size:13px;">4 bien the</td>
                                        <td>
                                            <span class="price">790.000d</span>
                                        </td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/products/4/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/products/4/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa san pham nay? Hanh dong nay khong the hoan tac.')">
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
                                        <td>
                                            <div class="admin-table__img-placeholder">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" />
                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                    <polyline points="21 15 16 10 5 21" />
                                                </svg>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="admin-table__name">Mu luoi trai cotton</div>
                                            <div class="admin-table__meta admin-table__id">#5</div>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:13px;">Phu kien</td>
                                        <td style="font-size:13px;">3 bien the</td>
                                        <td>
                                            <span class="price">199.000d</span>
                                        </td>
                                        <td>
                                            <div class="admin-table__actions">
                                                <a href="/admin/products/5/edit" class="btn-icon" title="Sua">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                </a>
                                                <form method="post" action="/admin/products/5/delete"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn-icon btn-icon--danger" title="Xoa"
                                                        onclick="return confirm('Xac nhan xoa san pham nay? Hanh dong nay khong the hoan tac.')">
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
                            <span class="admin-pagination__info">Trang 1 / 3 — Tong 56 san pham</span>
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