<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Them danh muc — Fashion Shop Admin</title>
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
                    <a href="/admin/categories" class="admin-nav__item admin-nav__item--active"><svg viewBox="0 0 24 24"
                            fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                        </svg>Danh muc</a>
                    <a href="/admin/products" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
                            <rect x="2" y="7" width="20" height="14" rx="2" />
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                        </svg>San pham</a>
                    <a href="/admin/orders" class="admin-nav__item"><svg viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2">
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
                        <a href="/admin/categories">Danh muc</a>
                        <span class="admin-topbar__breadcrumb-sep">/</span>
                        <span class="admin-topbar__breadcrumb-current">Them moi</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">Them danh muc moi</h1>
                            <p class="admin-page-header__subtitle">Danh muc toi da 2 cap: cha va con. Danh muc con phai
                                co danh muc cha.</p>
                        </div>
                    </div>

                    <form method="post" action="/admin/categories">
                        <div class="admin-form-panel">
                            <div class="admin-form-panel__header">
                                <span class="admin-form-panel__title">Thong tin danh muc</span>
                            </div>
                            <div class="admin-form-panel__body">
                                <div class="admin-form-grid admin-form-grid--1col">
                                    <div class="admin-form-group">
                                        <label for="name" class="admin-form-label admin-form-label--required">Ten danh
                                            muc</label>
                                        <input type="text" id="name" name="name" class="admin-form-input"
                                            placeholder="Nhap ten danh muc..." value="" required>
                                    </div>
                                    <div class="admin-form-group">
                                        <label for="parentId" class="admin-form-label">Danh muc cha</label>
                                        <select id="parentId" name="parentId" class="admin-form-select">
                                            <option value="">-- Khong co (day la danh muc cha) --</option>
                                            <option value="1">Ao</option>
                                            <option value="2">Quan</option>
                                            <option value="3">Phu kien</option>
                                        </select>
                                        <span class="admin-form-hint">Neu chon danh muc cha, day la danh muc con. Neu de
                                            trong, day la danh muc cha.</span>
                                    </div>
                                </div>
                            </div>
                            <div class="admin-form-actions">
                                <a href="/admin/categories" class="btn btn--secondary">Huy</a>
                                <button type="submit" class="btn btn--primary">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                        <polyline points="17 21 17 13 7 13 7 21" />
                                        <polyline points="7 3 7 8 15 8" />
                                    </svg>
                                    Tao danh muc
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </body>

    </html>