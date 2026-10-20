<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Biểu mẫu sản phẩm — Fashion Shop Admin</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-product.css">
            </head>

            <body>
                <div class="admin-shell">
                    <aside class="admin-sidebar">
                        <div class="admin-sidebar__brand">
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
                                <a href="logout" class="admin-sidebar__logout">
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
                        <c:set var="isEdit" value="${product.id > 0}" />
                        <div class="admin-topbar">
                            <div class="admin-topbar__breadcrumb">
                                <a href="AdminDashboardServlet">Admin</a>
                                <span class="admin-topbar__breadcrumb-sep">/</span>
                                <a href="AdminProductServlet">Sản phẩm</a>
                                <span class="admin-topbar__breadcrumb-sep">/</span>
                                <span class="admin-topbar__breadcrumb-current">
                                    <c:choose>
                                        <c:when test="${isEdit}">Chỉnh sửa</c:when>
                                        <c:otherwise>Thêm mới</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="admin-content">
                            <div class="admin-page-header">
                                <div>
                                    <h1 class="admin-page-header__title">
                                        <c:choose>
                                            <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
                                            <c:otherwise>Thêm sản phẩm mới</c:otherwise>
                                        </c:choose>
                                    </h1>
                                    <p class="admin-page-header__subtitle">
                                        <c:choose>
                                            <c:when test="${isEdit}">
                                                Cập nhật thông tin, quản lý kho hàng và ảnh của sản phẩm.
                                            </c:when>
                                            <c:otherwise>
                                                Sau khi tạo, bạn có thể thêm loại hàng (size, màu) và ảnh.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>

                            <c:if test="${not empty successMessage}">
                                <div role="status"
                                    style="background:var(--success-bg-subtle);color:var(--success-text);border:var(--border-width-1) solid var(--success-border);border-radius:var(--radius-md);padding:12px 16px;margin-bottom:16px;font-size:14px;">
                                    <c:out value="${successMessage}" />
                                </div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div role="alert"
                                    style="background:var(--error-bg-subtle);color:var(--error-text);border:var(--border-width-1) solid var(--error-border);border-radius:var(--radius-md);padding:12px 16px;margin-bottom:16px;font-size:14px;">
                                    <c:out value="${error}" />
                                </div>
                            </c:if>

                            <!-- ============KHỐI 1: THÔNG TIN SẢN PHẨM============ -->
                            <form method="post" action="AdminProductServlet">
                                <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
                                <c:if test="${isEdit}">
                                    <input type="hidden" name="id" value="${product.id}">
                                </c:if>
                                <div class="admin-form-panel">
                                    <div class="admin-form-panel__header product-panel-header">
                                        <span class="admin-form-panel__title">Thông tin sản phẩm</span>
                                        <c:if test="${isEdit}">
                                            <c:choose>
                                                <c:when test="${product.active}">
                                                    <span class="admin-badge admin-badge--success">
                                                        Đang hiển thị
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="admin-badge admin-badge--neutral">
                                                        Đã ẩn
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                    <div class="admin-form-panel__body">
                                        <div class="admin-form-grid admin-form-grid--1col">
                                            <div class="admin-form-group">
                                                <label for="name" class="admin-form-label admin-form-label--required">
                                                    Tên sản phẩm
                                                </label>
                                                <input type="text" id="name" name="name" class="admin-form-input"
                                                    placeholder="Nhập tên sản phẩm..." maxlength="255"
                                                    value="<c:out value='${product.name}' />" required>
                                            </div>
                                            <div class="admin-form-group">
                                                <label for="categoryId"
                                                    class="admin-form-label admin-form-label--required">
                                                    Danh mục
                                                </label>
                                                <select id="categoryId" name="categoryId" class="admin-form-input"
                                                    required>
                                                    <option value="0">-- Chọn danh mục --</option>
                                                    <c:forEach var="category" items="${categories}">
                                                        <option value="${category.id}" ${category.id==product.categoryId
                                                            ? 'selected' : '' }>
                                                            <c:out value="${category.name}" />
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="admin-form-group">
                                                <label for="description" class="admin-form-label">Mô tả</label>
                                                <textarea id="description" name="description" class="admin-form-input"
                                                    rows="4"
                                                    placeholder="Mô tả sản phẩm (không bắt buộc)..."><c:out value="${product.description}" /></textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="admin-form-actions">
                                        <a href="AdminProductServlet" class="btn btn--secondary">Hủy</a>
                                        <button type="submit" class="btn btn--primary">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path
                                                    d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                                <polyline points="17 21 17 13 7 13 7 21" />
                                                <polyline points="7 3 7 8 15 8" />
                                            </svg>
                                            <c:choose>
                                                <c:when test="${isEdit}">Lưu thay đổi</c:when>
                                                <c:otherwise>Tạo sản phẩm</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </div>
                            </form>

                            <c:if test="${isEdit}">
                                <!-- Ẩn / hiện sản phẩm -->
                                <form method="post" action="AdminProductServlet" class="product-toggle-form">
                                    <input type="hidden" name="action" value="toggleActive">
                                    <input type="hidden" name="id" value="${product.id}">
                                    <input type="hidden" name="active" value="${product.active ? 'false' : 'true'}">
                                    <c:choose>
                                        <c:when test="${product.active}">
                                            <button type="submit" class="btn btn--secondary"
                                                onclick="return confirm('Ẩn sản phẩm này khỏi cửa hàng?')">
                                                Ẩn sản phẩm
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" class="btn btn--secondary">
                                                Hiện sản phẩm
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>

                                <!-- ============KHỐI 2: KHO HÀNG============ -->
                                <div class="admin-panel product-section">
                                    <div class="admin-form-panel__header">
                                        <span class="admin-form-panel__title">Kho hàng</span>
                                    </div>
                                    <div class="admin-table-wrap">
                                        <table class="admin-table">
                                            <thead>
                                                <tr>
                                                    <th>Size</th>
                                                    <th>Màu</th>
                                                    <th>SKU</th>
                                                    <th>Giá</th>
                                                    <th>Còn</th>
                                                    <th>Trạng thái</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="variant" items="${product.variants}">
                                                    <tr>
                                                        <td>
                                                            <c:out value="${variant.size}" />
                                                        </td>
                                                        <td>
                                                            <c:out value="${variant.color}" />
                                                        </td>
                                                        <td class="product-mono">
                                                            <c:out value="${variant.sku}" />
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${variant.price}"
                                                                pattern="#,##0" />
                                                            &nbsp;₫
                                                        </td>
                                                        <td>
                                                            <c:out value="${variant.quantity}" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${variant.status == 'AVAILABLE'}">
                                                                    <span class="admin-badge admin-badge--success">
                                                                        Đang bán
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${variant.status == 'DISCONTINUED'}">
                                                                    <span class="admin-badge admin-badge--error">
                                                                        Ngừng bán
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="admin-badge admin-badge--neutral">
                                                                        Hết hàng
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="product-type-actions">
                                                                <!-- Nhập thêm -->
                                                                <form method="post" action="AdminProductServlet"
                                                                    class="product-inline-form">
                                                                    <input type="hidden" name="action"
                                                                        value="restockVariant">
                                                                    <input type="hidden" name="productId"
                                                                        value="${product.id}">
                                                                    <input type="hidden" name="size"
                                                                        value="<c:out value='${variant.size}' />">
                                                                    <input type="hidden" name="color"
                                                                        value="<c:out value='${variant.color}' />">
                                                                    <input type="hidden" name="sku"
                                                                        value="<c:out value='${variant.sku}' />">
                                                                    <input type="hidden" name="price"
                                                                        value="${variant.price}">
                                                                    <input type="number" name="quantity"
                                                                        class="admin-form-input product-qty-input"
                                                                        min="1" value="1"
                                                                        aria-label="Số lượng nhập thêm" required>
                                                                    <button type="submit"
                                                                        class="btn btn--secondary btn--sm">
                                                                        Nhập thêm
                                                                    </button>
                                                                </form>

                                                                <!-- Sửa SKU / giá của cả loại -->
                                                                <details class="product-edit-details">
                                                                    <summary class="btn btn--secondary btn--sm">
                                                                        Sửa
                                                                    </summary>
                                                                    <form method="post" action="AdminProductServlet"
                                                                        class="product-edit-form">
                                                                        <input type="hidden" name="action"
                                                                            value="updateVariant">
                                                                        <input type="hidden" name="productId"
                                                                            value="${product.id}">
                                                                        <input type="hidden" name="size"
                                                                            value="<c:out value='${variant.size}' />">
                                                                        <input type="hidden" name="color"
                                                                            value="<c:out value='${variant.color}' />">
                                                                        <label class="admin-form-label">
                                                                            SKU
                                                                            <input type="text" name="sku"
                                                                                class="admin-form-input" maxlength="255"
                                                                                value="<c:out value='${variant.sku}' />"
                                                                                required>
                                                                        </label>
                                                                        <label class="admin-form-label">
                                                                            Giá (₫)
                                                                            <input type="number" name="price"
                                                                                class="admin-form-input" min="0"
                                                                                step="0.01" value="${variant.price}"
                                                                                required>
                                                                        </label>
                                                                        <button type="submit"
                                                                            class="btn btn--primary btn--sm">
                                                                            Lưu
                                                                        </button>
                                                                    </form>
                                                                </details>

                                                                <!-- Ngừng bán / Bán lại -->
                                                                <c:if test="${variant.status == 'AVAILABLE'}">
                                                                    <form method="post" action="AdminProductServlet"
                                                                        class="product-inline-form">
                                                                        <input type="hidden" name="action"
                                                                            value="discontinueVariant">
                                                                        <input type="hidden" name="productId"
                                                                            value="${product.id}">
                                                                        <input type="hidden" name="size"
                                                                            value="<c:out value='${variant.size}' />">
                                                                        <input type="hidden" name="color"
                                                                            value="<c:out value='${variant.color}' />">
                                                                        <input type="hidden" name="sku"
                                                                            value="<c:out value='${variant.sku}' />">
                                                                        <input type="hidden" name="price"
                                                                            value="${variant.price}">
                                                                        <button type="submit"
                                                                            class="btn btn--secondary btn--sm"
                                                                            onclick="return confirm('Ngừng bán loại này?')">
                                                                            Ngừng bán
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                                <c:if test="${variant.status == 'DISCONTINUED'}">
                                                                    <form method="post" action="AdminProductServlet"
                                                                        class="product-inline-form">
                                                                        <input type="hidden" name="action"
                                                                            value="resumeVariant">
                                                                        <input type="hidden" name="productId"
                                                                            value="${product.id}">
                                                                        <input type="hidden" name="size"
                                                                            value="<c:out value='${variant.size}' />">
                                                                        <input type="hidden" name="color"
                                                                            value="<c:out value='${variant.color}' />">
                                                                        <input type="hidden" name="sku"
                                                                            value="<c:out value='${variant.sku}' />">
                                                                        <input type="hidden" name="price"
                                                                            value="${variant.price}">
                                                                        <button type="submit"
                                                                            class="btn btn--secondary btn--sm">
                                                                            Bán lại
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty product.variants}">
                                                    <tr>
                                                        <td colspan="7"
                                                            style="text-align:center;color:var(--text-muted);padding:32px 0;">
                                                            Chưa có loại hàng nào. Hãy thêm loại đầu tiên bên dưới.
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Thêm loại mới -->
                                    <form method="post" action="AdminProductServlet" class="product-add-form">
                                        <input type="hidden" name="action" value="addVariant">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <div class="admin-form-label product-add-form__title">
                                            Thêm loại mới
                                        </div>
                                        <div class="product-add-form__row">
                                            <input type="text" name="size" class="admin-form-input"
                                                placeholder="Size (vd M)" maxlength="255"
                                                value="<c:out value='${variantForm.size}' />" required>
                                            <input type="text" name="color" class="admin-form-input"
                                                placeholder="Màu (vd xanh navy)" maxlength="255"
                                                value="<c:out value='${variantForm.color}' />" required>
                                            <input type="text" name="sku" class="admin-form-input" placeholder="SKU"
                                                maxlength="255" value="<c:out value='${variantForm.sku}' />" required>
                                            <input type="number" name="price" class="admin-form-input"
                                                placeholder="Giá (₫)" min="0" step="0.01" value="${variantForm.price}"
                                                required>
                                            <input type="number" name="quantity" class="admin-form-input"
                                                placeholder="Số lượng" min="1"
                                                value="${variantForm.quantity > 0 ? variantForm.quantity : ''}"
                                                required>
                                            <button type="submit" class="btn btn--primary">
                                                Thêm loại
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- ============KHỐI 3: ẢNH SẢN PHẨM============ -->
                                <div class="admin-panel product-section">
                                    <div class="admin-form-panel__header">
                                        <span class="admin-form-panel__title">Ảnh sản phẩm</span>
                                    </div>
                                    <div class="product-image-grid">
                                        <c:forEach var="img" items="${product.images}">
                                            <div class="product-image-card">
                                                <img src="<c:out value='${img.imageUrl}' />"
                                                    alt="Ảnh màu <c:out value='${img.color}' />"
                                                    class="product-image-card__img">
                                                <div class="product-image-card__footer">
                                                    <span class="admin-badge admin-badge--neutral">
                                                        <c:out value="${img.color}" />
                                                    </span>
                                                    <form method="post" action="AdminProductServlet">
                                                        <input type="hidden" name="action" value="deleteImage">
                                                        <input type="hidden" name="productId" value="${product.id}">
                                                        <input type="hidden" name="imageId" value="${img.id}">
                                                        <button type="submit" class="btn-icon btn-icon--danger"
                                                            title="Xóa ảnh"
                                                            onclick="return confirm('Xác nhận xóa ảnh này?')">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                                stroke-width="2">
                                                                <polyline points="3 6 5 6 21 6" />
                                                                <path
                                                                    d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                            </svg>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${empty product.images}">
                                            <div class="product-image-empty">Chưa có ảnh nào.</div>
                                        </c:if>
                                    </div>

                                    <form method="post" action="AdminProductServlet" enctype="multipart/form-data"
                                        class="product-add-form">
                                        <input type="hidden" name="action" value="addImage">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <div class="admin-form-label product-add-form__title">
                                            Thêm ảnh
                                        </div>
                                        <div class="product-add-form__row">
                                            <input type="file" name="image" class="admin-form-input"
                                                accept="image/jpeg,image/png,image/webp" required>
                                            <input type="text" name="color" class="admin-form-input"
                                                placeholder="Màu của ảnh (vd xanh navy)" maxlength="255" required>
                                            <button type="submit" class="btn btn--primary">
                                                Tải ảnh lên
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </main>
                </div>
            </body>

            </html>