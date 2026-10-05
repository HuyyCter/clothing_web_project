<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Don hang — Fashion Shop Admin</title>
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
                    <div class="admin-sidebar__section-label">Tong quan</div>
                    <a href="/admin/dashboard" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
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
                        </svg>Thong ke</a>
                    <div class="admin-sidebar__section-label">Quan ly</div>
                    <a href="/admin/categories" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                        </svg>Danh muc</a>
                    <a href="/admin/products" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <rect x="2" y="7" width="20" height="14" rx="2" />
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                        </svg>San pham</a>
                    <a href="/admin/orders" class="admin-nav__item admin-nav__item--active"><svg viewBox="0 0 24 24"
                            fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                        </svg>Don hang</a>
                    <a href="/admin/vouchers" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z" />
                        </svg>Voucher</a>
                </nav>
                <div class="admin-sidebar__footer">
                    <div class="admin-sidebar__user">
                        <div class="admin-sidebar__avatar">A</div>
                        <div class="admin-sidebar__user-info">
                            <div class="admin-sidebar__user-name">Admin</div>
                            <div class="admin-sidebar__user-role">Quan tri vien</div>
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
                        <span class="admin-topbar__breadcrumb-current">Don hang</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">Quan ly don hang</h1>
                            <p class="admin-page-header__subtitle">Xem va cap nhat trang thai don hang theo dung state
                                machine.</p>
                        </div>
                    </div>

                    <div class="admin-panel">
                        <div class="admin-filter-bar">
                            <form method="get" action="/admin/orders"
                                style="display:flex;gap:8px;flex:1;flex-wrap:wrap;">
                                <div class="admin-search" style="flex:1;min-width:180px;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="11" cy="11" r="8" />
                                        <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                    </svg>
                                    <input type="text" name="q" placeholder="Tim theo ma don / ten khach..." value="">
                                </div>
                                <select name="status" class="admin-select">
                                    <option value="">Tat ca trang thai</option>
                                    <option value="PENDING">Cho xac nhan</option>
                                    <option value="CONFIRMED">Da xac nhan</option>
                                    <option value="SHIPPING">Dang giao</option>
                                    <option value="DELIVERED">Da giao</option>
                                    <option value="CANCELLED">Da huy</option>
                                </select>
                                <button type="submit" class="btn btn--secondary">Loc</button>
                            </form>
                        </div>
                        <div class="admin-table-wrap">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Ma don</th>
                                        <th>Khach hang</th>
                                        <th>Tong tien</th>
                                        <th>Thanh toan</th>
                                        <th>Trang thai</th>
                                        <th>Ngay dat</th>
                                        <th>Thao tac</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><span class="admin-table__id">#1024</span></td>
                                        <td>
                                            <div class="admin-table__name">Nguyen Van An</div>
                                            <div class="admin-table__meta">an.nguyen@example.com</div>
                                        </td>
                                        <td><span class="price">890.000d</span></td>
                                        <td style="font-size:12px;color:var(--text-muted);">COD</td>
                                        <td>
                                            <span class="badge badge--pending">Cho xac nhan</span>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:12px;white-space:nowrap;">
                                            30/09/2026 09:15</td>
                                        <td>
                                            <a href="/admin/orders/1024" class="btn btn--secondary btn--sm">Chi tiet</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#1023</span></td>
                                        <td>
                                            <div class="admin-table__name">Tran Thi Binh</div>
                                            <div class="admin-table__meta">binh.tran@example.com</div>
                                        </td>
                                        <td><span class="price">1.250.000d</span></td>
                                        <td style="font-size:12px;color:var(--text-muted);">VNPAY</td>
                                        <td>
                                            <span class="badge badge--confirmed">Da xac nhan</span>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:12px;white-space:nowrap;">
                                            29/09/2026 16:40</td>
                                        <td>
                                            <a href="/admin/orders/1023" class="btn btn--secondary btn--sm">Chi tiet</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#1022</span></td>
                                        <td>
                                            <div class="admin-table__name">Le Minh Cuong</div>
                                            <div class="admin-table__meta">cuong.le@example.com</div>
                                        </td>
                                        <td><span class="price">529.000d</span></td>
                                        <td style="font-size:12px;color:var(--text-muted);">MOMO</td>
                                        <td>
                                            <span class="badge badge--shipping">Dang giao</span>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:12px;white-space:nowrap;">
                                            29/09/2026 11:05</td>
                                        <td>
                                            <a href="/admin/orders/1022" class="btn btn--secondary btn--sm">Chi tiet</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#1021</span></td>
                                        <td>
                                            <div class="admin-table__name">Pham Thu Ha</div>
                                            <div class="admin-table__meta">ha.pham@example.com</div>
                                        </td>
                                        <td><span class="price">2.140.000d</span></td>
                                        <td style="font-size:12px;color:var(--text-muted);">VNPAY</td>
                                        <td>
                                            <span class="badge badge--delivered">Da giao</span>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:12px;white-space:nowrap;">
                                            28/09/2026 14:30</td>
                                        <td>
                                            <a href="/admin/orders/1021" class="btn btn--secondary btn--sm">Chi tiet</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#1020</span></td>
                                        <td>
                                            <div class="admin-table__name">Hoang Duc Long</div>
                                            <div class="admin-table__meta">long.hoang@example.com</div>
                                        </td>
                                        <td><span class="price">459.000d</span></td>
                                        <td style="font-size:12px;color:var(--text-muted);">COD</td>
                                        <td>
                                            <span class="badge badge--cancelled">Da huy</span>
                                        </td>
                                        <td style="color:var(--text-muted);font-size:12px;white-space:nowrap;">
                                            27/09/2026 20:22</td>
                                        <td>
                                            <a href="/admin/orders/1020" class="btn btn--secondary btn--sm">Chi tiet</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="admin-pagination">
                            <span class="admin-pagination__info">Trang 1 / 3 — Tong 24 don</span>
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