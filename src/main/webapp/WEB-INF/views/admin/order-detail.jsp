<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Chi tiet don hang #1024 — Fashion Shop Admin</title>
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
                        <a href="/admin/orders">Don hang</a>
                        <span class="admin-topbar__breadcrumb-sep">/</span>
                        <span class="admin-topbar__breadcrumb-current">#1024</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">Don hang #1024</h1>
                            <p class="admin-page-header__subtitle">
                                Dat ngay 30/09/2026 09:15 &mdash;
                                <span class="badge badge--pending">Cho xac nhan</span>
                            </p>
                        </div>
                        <div class="admin-page-header__actions">
                            <a href="/admin/orders" class="btn btn--secondary">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="19" y1="12" x2="5" y2="12" />
                                    <polyline points="12 19 5 12 12 5" />
                                </svg>
                                Quay lai
                            </a>
                        </div>
                    </div>

                    <div class="admin-order-layout">
                        <!-- Left: Items + Timeline -->
                        <div style="display:flex;flex-direction:column;gap:20px;">

                            <!-- Order Items -->
                            <div class="admin-panel">
                                <div class="admin-panel__header"><span class="admin-panel__title">San pham trong
                                        don</span></div>
                                <div class="admin-order-item">
                                    <div class="admin-order-item__img"
                                        style="display:flex;align-items:center;justify-content:center;background:var(--bg-base);">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="var(--border-default)" stroke-width="2">
                                            <rect x="3" y="3" width="18" height="18" rx="2" />
                                            <circle cx="8.5" cy="8.5" r="1.5" />
                                            <polyline points="21 15 16 10 5 21" />
                                        </svg>
                                    </div>
                                    <div class="admin-order-item__info">
                                        <div class="admin-order-item__name">Ao thun cotton basic</div>
                                        <div class="admin-order-item__variant">M / Trang</div>
                                        <div class="admin-order-item__sku">AT-BASIC-M-WHT</div>
                                    </div>
                                    <div>
                                        <div class="admin-order-item__price">249.000d</div>
                                        <div class="admin-order-item__qty">x 2</div>
                                    </div>
                                </div>
                                <div class="admin-order-item">
                                    <div class="admin-order-item__img"
                                        style="display:flex;align-items:center;justify-content:center;background:var(--bg-base);">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="var(--border-default)" stroke-width="2">
                                            <rect x="3" y="3" width="18" height="18" rx="2" />
                                            <circle cx="8.5" cy="8.5" r="1.5" />
                                            <polyline points="21 15 16 10 5 21" />
                                        </svg>
                                    </div>
                                    <div class="admin-order-item__info">
                                        <div class="admin-order-item__name">Quan chinos slim fit</div>
                                        <div class="admin-order-item__variant">L / Den</div>
                                        <div class="admin-order-item__sku">QC-SLIM-L-BLK</div>
                                    </div>
                                    <div>
                                        <div class="admin-order-item__price">529.000d</div>
                                        <div class="admin-order-item__qty">x 1</div>
                                    </div>
                                </div>
                            </div>

                            <!-- State Machine: Cập nhật trạng thái -->
                            <div class="admin-panel">
                                <div class="admin-panel__header"><span class="admin-panel__title">Cap nhat trang thai
                                        don hang</span></div>
                                <div style="padding:20px;">
                                    <div class="admin-alert admin-alert--info" style="margin-bottom:16px;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <line x1="12" y1="8" x2="12" y2="12" />
                                            <line x1="12" y1="16" x2="12.01" y2="16" />
                                        </svg>
                                        State machine: Cho xac nhan → Da xac nhan → Dang giao → Da giao. Huy chi duoc tu
                                        "Cho xac nhan" hoac "Da xac nhan".
                                    </div>
                                    <form method="post" action="/admin/orders/1024/status" class="admin-status-form">
                                        <select name="newStatus" class="admin-form-select"
                                            style="flex:1;max-width:240px;">
                                            <option value="CONFIRMED">Da xac nhan</option>
                                            <option value="CANCELLED">Huy don</option>
                                        </select>
                                        <button type="submit" class="btn btn--primary">Cap nhat trang thai</button>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Summary + Customer Info -->
                        <div style="display:flex;flex-direction:column;gap:20px;">

                            <!-- Order Summary -->
                            <div class="admin-panel">
                                <div class="admin-panel__header"><span class="admin-panel__title">Tong ket don
                                        hang</span></div>
                                <div style="padding:16px 20px;">
                                    <div class="admin-order-summary">
                                        <div class="admin-order-summary-row">
                                            <span>Tam tinh</span>
                                            <span class="admin-order-summary-row__value">1.027.000d</span>
                                        </div>
                                        <div class="admin-order-summary-row">
                                            <span>Giam gia (WELCOME10)</span>
                                            <span class="admin-order-summary-row__value"
                                                style="color:var(--success-text);">-102.700d</span>
                                        </div>
                                        <div class="admin-order-summary-row admin-order-summary-row--total">
                                            <span>Tong cong</span>
                                            <span class="admin-order-summary-row__value">924.300d</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Customer Info -->
                            <div class="admin-panel">
                                <div class="admin-panel__header"><span class="admin-panel__title">Thong tin khach
                                        hang</span></div>
                                <div style="padding:16px 20px;">
                                    <div class="admin-info-list">
                                        <div class="admin-info-row">
                                            <span class="admin-info-row__label">Ho ten</span>
                                            <span class="admin-info-row__value">Nguyen Van An</span>
                                        </div>
                                        <div class="admin-info-row">
                                            <span class="admin-info-row__label">Email</span>
                                            <span class="admin-info-row__value">an.nguyen@example.com</span>
                                        </div>
                                        <div class="admin-info-row">
                                            <span class="admin-info-row__label">Phuong thuc</span>
                                            <span class="admin-info-row__value">COD</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Shipping Info (snapshot) -->
                            <div class="admin-panel">
                                <div class="admin-panel__header"><span class="admin-panel__title">Dia chi giao
                                        hang</span></div>
                                <div style="padding:16px 20px;">
                                    <div class="admin-info-list">
                                        <div class="admin-info-row">
                                            <span class="admin-info-row__label">Nguoi nhan</span>
                                            <span class="admin-info-row__value">Nguyen Van An</span>
                                        </div>
                                        <div class="admin-info-row">
                                            <span class="admin-info-row__label">SDT</span>
                                            <span class="admin-info-row__value">0901234567</span>
                                        </div>
                                        <div class="admin-info-row">
                                            <span class="admin-info-row__label">Dia chi</span>
                                            <span class="admin-info-row__value">12 Nguyen Hue, Quan 1, TP. Ho Chi
                                                Minh</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>

    </html>