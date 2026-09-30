<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Danh sách Voucher — Fashion Shop Admin</title>
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
                        </svg>Thống kê</a>
                    <div class="admin-sidebar__section-label">Quản lý</div>
                    <a href="/admin/categories" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                        </svg>Danh mục</a>
                    <a href="/admin/products" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <rect x="2" y="7" width="20" height="14" rx="2" />
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                        </svg>Sản phẩm</a>
                    <a href="/admin/orders" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                        </svg>Đơn hàng</a>
                    <a href="/admin/vouchers" class="admin-nav__item admin-nav__item--active"><svg viewBox="0 0 24 24"
                            fill="none" stroke="currentColor" stroke-width="2">
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
                        <span class="admin-topbar__breadcrumb-current">Voucher</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">Mã giảm giá (Voucher)</h1>
                            <p class="admin-page-header__subtitle">Quản lý mã giảm giá theo %, điều kiện đơn tối thiểu
                                và thời hạn áp dụng.</p>
                        </div>
                        <div class="admin-page-header__actions">
                            <a href="/admin/vouchers/new" class="btn btn--primary">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Tạo voucher mới
                            </a>
                        </div>
                    </div>

                    <div class="admin-panel">
                        <div class="admin-filter-bar">
                            <form method="get" action="/admin/vouchers" style="display:flex;gap:8px;width:100%;">
                                <div class="admin-search">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="11" cy="11" r="8" />
                                        <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                    </svg>
                                    <input type="text" name="q" placeholder="Tìm kiếm theo mã voucher..." value="">
                                </div>
                                <select name="status" class="admin-select">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active">Đang hoạt động</option>
                                    <option value="inactive">Tạm ngưng</option>
                                </select>
                                <button type="submit" class="btn btn--secondary">Lọc</button>
                            </form>
                        </div>
                        <div class="admin-table-wrap">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Mã Voucher</th>
                                        <th>Giảm (%)</th>
                                        <th>Điều kiện áp dụng</th>
                                        <th>Lượt dùng</th>
                                        <th>Thời gian hiệu lực</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><span class="admin-table__id">#1</span></td>
                                        <td>
                                            <div
                                                style="font-family: var(--font-mono); font-weight: 600; color: var(--primary-bg); background: var(--primary-bg-subtle); display: inline-block; padding: 2px 8px; border-radius: var(--radius-sm); border: 1px dashed var(--primary-border);">
                                                WELCOME10
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600; color: var(--text-primary);">10%</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 12px; color: var(--text-primary);">Đơn tối thiểu: 0đ
                                            </div>
                                            <div style="font-size: 11px; color: var(--text-muted);">
                                                Không giới hạn mức giảm
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 500;">12</span> / <span
                                                style="color: var(--text-muted);">100</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 11px; color: var(--text-secondary);">Từ: 01/09/2026
                                                00:00</div>
                                            <div style="font-size: 11px; color: var(--text-muted);">Đến: 31/12/2026
                                                23:59</div>
                                        </td>
                                        <td>
                                            <span class="badge badge--active">Hoạt động</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px;">
                                                <a href="/admin/vouchers/1/edit"
                                                    class="btn btn--secondary btn--sm">Sửa</a>
                                                <form method="post" action="/admin/vouchers/1/toggle-status"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn btn--secondary btn--sm"
                                                        title="Tạm ngưng voucher">
                                                        Khóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#2</span></td>
                                        <td>
                                            <div
                                                style="font-family: var(--font-mono); font-weight: 600; color: var(--primary-bg); background: var(--primary-bg-subtle); display: inline-block; padding: 2px 8px; border-radius: var(--radius-sm); border: 1px dashed var(--primary-border);">
                                                FREESHIP20
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600; color: var(--text-primary);">20%</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 12px; color: var(--text-primary);">Đơn tối thiểu:
                                                500.000đ</div>
                                            <div style="font-size: 11px; color: var(--text-muted);">
                                                Tối đa: 100.000đ
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 500;">45</span> / <span
                                                style="color: var(--text-muted);">200</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 11px; color: var(--text-secondary);">Từ: 15/09/2026
                                                00:00</div>
                                            <div style="font-size: 11px; color: var(--text-muted);">Đến: 15/10/2026
                                                23:59</div>
                                        </td>
                                        <td>
                                            <span class="badge badge--active">Hoạt động</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px;">
                                                <a href="/admin/vouchers/2/edit"
                                                    class="btn btn--secondary btn--sm">Sửa</a>
                                                <form method="post" action="/admin/vouchers/2/toggle-status"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn btn--secondary btn--sm"
                                                        title="Tạm ngưng voucher">
                                                        Khóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#3</span></td>
                                        <td>
                                            <div
                                                style="font-family: var(--font-mono); font-weight: 600; color: var(--primary-bg); background: var(--primary-bg-subtle); display: inline-block; padding: 2px 8px; border-radius: var(--radius-sm); border: 1px dashed var(--primary-border);">
                                                THUDONG15
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600; color: var(--text-primary);">15%</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 12px; color: var(--text-primary);">Đơn tối thiểu:
                                                300.000đ</div>
                                            <div style="font-size: 11px; color: var(--text-muted);">
                                                Tối đa: 150.000đ
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 500;">3</span> / <span
                                                style="color: var(--text-muted);">50</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 11px; color: var(--text-secondary);">Từ: 01/10/2026
                                                00:00</div>
                                            <div style="font-size: 11px; color: var(--text-muted);">Đến: 30/11/2026
                                                23:59</div>
                                        </td>
                                        <td>
                                            <span class="badge badge--active">Hoạt động</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px;">
                                                <a href="/admin/vouchers/3/edit"
                                                    class="btn btn--secondary btn--sm">Sửa</a>
                                                <form method="post" action="/admin/vouchers/3/toggle-status"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn btn--secondary btn--sm"
                                                        title="Tạm ngưng voucher">
                                                        Khóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="admin-table__id">#4</span></td>
                                        <td>
                                            <div
                                                style="font-family: var(--font-mono); font-weight: 600; color: var(--primary-bg); background: var(--primary-bg-subtle); display: inline-block; padding: 2px 8px; border-radius: var(--radius-sm); border: 1px dashed var(--primary-border);">
                                                SUMMER2026
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600; color: var(--text-primary);">30%</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 12px; color: var(--text-primary);">Đơn tối thiểu:
                                                1.000.000đ</div>
                                            <div style="font-size: 11px; color: var(--text-muted);">
                                                Tối đa: 200.000đ
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 500;">100</span> / <span
                                                style="color: var(--text-muted);">100</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 11px; color: var(--text-secondary);">Từ: 01/06/2026
                                                00:00</div>
                                            <div style="font-size: 11px; color: var(--text-muted);">Đến: 30/06/2026
                                                23:59</div>
                                        </td>
                                        <td>
                                            <span class="badge badge--inactive">Tạm ngưng</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px;">
                                                <a href="/admin/vouchers/4/edit"
                                                    class="btn btn--secondary btn--sm">Sửa</a>
                                                <form method="post" action="/admin/vouchers/4/toggle-status"
                                                    style="display:inline;">
                                                    <button type="submit" class="btn btn--secondary btn--sm"
                                                        title="Kích hoạt voucher">
                                                        Mở
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="admin-pagination">
                            <span class="admin-pagination__info">Trang 1 / 1 — Tổng 4 voucher</span>
                            <div class="admin-pagination__pages">
                                <a href="?page=1" class="admin-pagination__btn admin-pagination__btn--active">1</a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>

    </html>