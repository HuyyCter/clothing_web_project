<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Thêm Voucher — Fashion Shop Admin</title>
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
                        <a href="/admin/vouchers">Voucher</a>
                        <span class="admin-topbar__breadcrumb-sep">/</span>
                        <span class="admin-topbar__breadcrumb-current">Thêm mới</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">Tạo mã voucher mới</h1>
                            <p class="admin-page-header__subtitle">Thiết lập tỉ lệ giảm %, đơn hàng tối thiểu và giới
                                hạn số lượng áp dụng.</p>
                        </div>
                    </div>

                    <form method="post" action="/admin/vouchers">
                        <div class="admin-form-panel">
                            <div class="admin-form-panel__header">
                                <span class="admin-form-panel__title">Thông tin mã giảm giá</span>
                            </div>
                            <div class="admin-form-panel__body">
                                <div class="admin-form-grid">
                                    <div class="admin-form-group">
                                        <label for="code" class="admin-form-label admin-form-label--required">Mã
                                            Voucher</label>
                                        <input type="text" id="code" name="code" class="admin-form-input"
                                            placeholder="VD: SUMMER2024, TET2025..." value=""
                                            style="text-transform: uppercase; font-family: var(--font-mono); font-weight: 600;"
                                            required>
                                        <span class="admin-form-hint">Mã viết liền không dấu, không chứa khoảng trắng.
                                            Khách hàng sẽ nhập mã này khi checkout.</span>
                                    </div>

                                    <div class="admin-form-group">
                                        <label for="discountPercent"
                                            class="admin-form-label admin-form-label--required">Mức giảm (%)</label>
                                        <input type="number" id="discountPercent" name="discountPercent"
                                            class="admin-form-input" min="1" max="100" placeholder="VD: 10, 20..."
                                            value="" required>
                                        <span class="admin-form-hint">Tỉ lệ giảm giá theo phần trăm (từ 1% đến
                                            100%).</span>
                                    </div>

                                    <div class="admin-form-group">
                                        <label for="minOrderAmount" class="admin-form-label">Đơn hàng tối thiểu
                                            (VNĐ)</label>
                                        <input type="number" id="minOrderAmount" name="minOrderAmount"
                                            class="admin-form-input" min="0" step="1000" placeholder="0" value="0">
                                        <span class="admin-form-hint">Giá trị tổng sản phẩm tối thiểu trong giỏ hàng để
                                            voucher có hiệu lực.</span>
                                    </div>

                                    <div class="admin-form-group">
                                        <label for="maxDiscountAmount" class="admin-form-label">Giảm tối đa
                                            (VNĐ)</label>
                                        <input type="number" id="maxDiscountAmount" name="maxDiscountAmount"
                                            class="admin-form-input" min="0" step="1000"
                                            placeholder="0 = không giới hạn" value="0">
                                        <span class="admin-form-hint">Số tiền tối đa được chiết khấu. Nhập 0 nếu không
                                            giới hạn mức giảm.</span>
                                    </div>

                                    <div class="admin-form-group">
                                        <label for="startAt" class="admin-form-label">Thời gian bắt đầu</label>
                                        <input type="datetime-local" id="startAt" name="startAt"
                                            class="admin-form-input" value="">
                                        <span class="admin-form-hint">Thời điểm voucher bắt đầu có hiệu lực sử
                                            dụng.</span>
                                    </div>

                                    <div class="admin-form-group">
                                        <label for="endAt" class="admin-form-label">Thời gian kết thúc</label>
                                        <input type="datetime-local" id="endAt" name="endAt" class="admin-form-input"
                                            value="">
                                        <span class="admin-form-hint">Hạn chót voucher được phép sử dụng.</span>
                                    </div>

                                    <div class="admin-form-group">
                                        <label for="usageLimit" class="admin-form-label admin-form-label--required">Số
                                            lượt dùng tối đa</label>
                                        <input type="number" id="usageLimit" name="usageLimit" class="admin-form-input"
                                            min="1" placeholder="VD: 100" value="100" required>
                                        <span class="admin-form-hint">Tổng số lần khách hàng có thể áp dụng mã này thành
                                            công.</span>
                                    </div>

                                    <div class="admin-form-group" style="justify-content: center;">
                                        <label class="admin-form-check" style="margin-top: 24px;">
                                            <input type="checkbox" name="isActive" value="true" checked>
                                            <span class="admin-form-check-label">Kích hoạt voucher ngay lập tức</span>
                                        </label>
                                        <span class="admin-form-hint" style="margin-left: 23px;">Nếu bỏ chọn, mã sẽ bị
                                            tạm ngưng và khách hàng không thể áp dụng khi thanh toán.</span>
                                    </div>
                                </div>
                            </div>
                            <div class="admin-form-actions">
                                <a href="/admin/vouchers" class="btn btn--secondary">Hủy</a>
                                <button type="submit" class="btn btn--primary">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                        <polyline points="17 21 17 13 7 13 7 21" />
                                        <polyline points="7 3 7 8 15 8" />
                                    </svg>
                                    Tạo voucher
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </body>

    </html>