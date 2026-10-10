<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Them san pham — Fashion Shop Admin</title>
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
                        <a href="/admin/products">San pham</a>
                        <span class="admin-topbar__breadcrumb-sep">/</span>
                        <span class="admin-topbar__breadcrumb-current">Them moi</span>
                    </div>
                </div>
                <div class="admin-content">
                    <div class="admin-page-header">
                        <div>
                            <h1 class="admin-page-header__title">Them san pham moi</h1>
                            <p class="admin-page-header__subtitle">Dien thong tin san pham goc, sau do them bien the
                                (size, mau, gia, ton kho) va upload anh.</p>
                        </div>
                    </div>

                    <form method="post" enctype="multipart/form-data" action="/admin/products">

                        <!-- Basic Info -->
                        <div class="admin-form-panel" style="margin-bottom:20px;">
                            <div class="admin-form-panel__header"><span class="admin-form-panel__title">Thong tin co
                                    ban</span></div>
                            <div class="admin-form-panel__body">
                                <div class="admin-form-grid">
                                    <div class="admin-form-group admin-form-group--span2">
                                        <label for="name" class="admin-form-label admin-form-label--required">Ten san
                                            pham</label>
                                        <input type="text" id="name" name="name" class="admin-form-input"
                                            placeholder="Nhap ten san pham..." value="" required>
                                    </div>
                                    <div class="admin-form-group">
                                        <label for="categoryId" class="admin-form-label admin-form-label--required">Danh
                                            muc</label>
                                        <select id="categoryId" name="categoryId" class="admin-form-select" required>
                                            <option value="">-- Chon danh muc --</option>
                                            <optgroup label="Ao">
                                                <option value="1">Ao (goc)</option>
                                                <option value="5">&nbsp;&nbsp;Ao thun</option>
                                                <option value="6">&nbsp;&nbsp;Ao so mi</option>
                                            </optgroup>
                                            <optgroup label="Quan">
                                                <option value="2">Quan (goc)</option>
                                                <option value="7">&nbsp;&nbsp;Quan jeans</option>
                                                <option value="8">&nbsp;&nbsp;Quan chinos</option>
                                            </optgroup>
                                            <optgroup label="Phu kien">
                                                <option value="3">Phu kien (goc)</option>
                                            </optgroup>
                                        </select>
                                    </div>
                                    <div class="admin-form-group admin-form-group--span2">
                                        <label for="description" class="admin-form-label">Mo ta san pham</label>
                                        <textarea id="description" name="description" class="admin-form-textarea"
                                            rows="4" placeholder="Mo ta chi tiet ve san pham..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Variants -->
                        <div class="admin-form-panel" style="margin-bottom:20px;">
                            <div class="admin-form-panel__header">
                                <span class="admin-form-panel__title">Bien the san pham (Size / Mau)</span>
                                <button type="button" class="btn btn--secondary btn--sm" id="btnAddVariant">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="12" y1="5" x2="12" y2="19" />
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                    </svg>
                                    Them bien the
                                </button>
                            </div>
                            <div class="admin-form-panel__body" style="padding:16px 24px;">
                                <div class="admin-variant-table-wrap">
                                    <table class="admin-variant-table" id="variantTable">
                                        <thead>
                                            <tr>
                                                <th>Size</th>
                                                <th>Mau sac</th>
                                                <th>SKU</th>
                                                <th>Gia (VND)</th>
                                                <th>Ton kho</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody id="variantBody">
                                            <tr>
                                                <td><input type="text" name="variants[0].size"
                                                        class="admin-variant-input" placeholder="S / M / L / XL...">
                                                </td>
                                                <td><input type="text" name="variants[0].color"
                                                        class="admin-variant-input" placeholder="White / Black..."></td>
                                                <td><input type="text" name="variants[0].sku"
                                                        class="admin-variant-input admin-variant-input--mono"
                                                        placeholder="SKU-001"></td>
                                                <td><input type="number" name="variants[0].price"
                                                        class="admin-variant-input" placeholder="299000" min="0"></td>
                                                <td><input type="number" name="variants[0].stock"
                                                        class="admin-variant-input" placeholder="0" min="0"></td>
                                                <td><button type="button"
                                                        class="btn-icon btn-icon--danger btn-remove-variant"><svg
                                                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <line x1="18" y1="6" x2="6" y2="18" />
                                                            <line x1="6" y1="6" x2="18" y2="18" />
                                                        </svg></button></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Images -->
                        <div class="admin-form-panel" style="margin-bottom:20px;">
                            <div class="admin-form-panel__header"><span class="admin-form-panel__title">Anh san pham
                                    (upload len Cloudinary)</span></div>
                            <div class="admin-form-panel__body">
                                <div class="admin-form-grid admin-form-grid--1col">
                                    <div class="admin-form-group">
                                        <label class="admin-form-label">Chon mau de upload anh</label>
                                        <select name="imageColor" class="admin-form-select" style="max-width:300px;">
                                            <option value="">-- Chon mau --</option>
                                        </select>
                                        <span class="admin-form-hint">Chon mau truoc khi upload. Anh se gan voi mau
                                            do.</span>
                                    </div>
                                    <div class="admin-form-group">
                                        <label class="admin-form-label">Upload anh</label>
                                        <input type="file" name="images" multiple accept="image/*"
                                            class="admin-form-input" style="padding:6px;">
                                        <span class="admin-form-hint">Co the chon nhieu anh cung luc. Anh hien
                                            tai:</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="admin-form-actions" style="background:transparent;padding:0;margin-top:8px;">
                            <a href="/admin/products" class="btn btn--secondary">Huy</a>
                            <button type="submit" class="btn btn--primary">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                    <polyline points="17 21 17 13 7 13 7 21" />
                                    <polyline points="7 3 7 8 15 8" />
                                </svg>
                                Tao san pham
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
        <script>
            // Variant row add/remove
            let variantCount = document.querySelectorAll('#variantBody tr').length;
            document.getElementById('btnAddVariant').addEventListener('click', function () {
                const idx = variantCount++;
                const row = document.createElement('tr');
                row.innerHTML =
                    '<td><input type="text" name="variants[' + idx + '].size" class="admin-variant-input" placeholder="S/M/L/XL..."></td>' +
                    '<td><input type="text" name="variants[' + idx + '].color" class="admin-variant-input" placeholder="White/Black..."></td>' +
                    '<td><input type="text" name="variants[' + idx + '].sku" class="admin-variant-input admin-variant-input--mono" placeholder="SKU-00' + (idx + 1) + '"></td>' +
                    '<td><input type="number" name="variants[' + idx + '].price" class="admin-variant-input" placeholder="299000" min="0"></td>' +
                    '<td><input type="number" name="variants[' + idx + '].stock" class="admin-variant-input" placeholder="0" min="0"></td>' +
                    '<td><button type="button" class="btn-icon btn-icon--danger btn-remove-variant"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button></td>';
                document.getElementById('variantBody').appendChild(row);
                attachRemove(row.querySelector('.btn-remove-variant'));
            });
            document.querySelectorAll('.btn-remove-variant').forEach(attachRemove);
            function attachRemove(btn) {
                btn.addEventListener('click', function () {
                    const rows = document.querySelectorAll('#variantBody tr');
                    if (rows.length > 1) btn.closest('tr').remove();
                });
            }
        </script>
    </body>

    </html>