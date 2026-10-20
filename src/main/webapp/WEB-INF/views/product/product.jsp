
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isLoggedIn" value="${not empty sessionScope.userId}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm — Fashion Shop</title>
    <meta name="description" content="Khám phá các sản phẩm thời trang tại Fashion Shop.">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500;600&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="${ctx}/assets/css/customer.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f8f9fa;
            color: #222;
        }

        /* NAVBAR */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: #fff;
            border-bottom: 1px solid #eee;
        }

        .navbar__inner {
            max-width: 1400px;
            min-height: 76px;
            margin: 0 auto;
            padding: 12px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 28px;
        }

        .navbar__logo {
            flex-shrink: 0;
            color: #222;
            text-decoration: none;
            font-family: "Playfair Display", serif;
            font-size: 30px;
            font-weight: 700;
        }

        .navbar__logo span {
            color: #d32f2f;
        }

        .navbar__search {
            flex: 1;
            max-width: 500px;
            height: 42px;
            margin: 0;
            padding: 0 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: #fff;
        }

        .navbar__search svg {
            width: 20px;
            height: 20px;
            flex-shrink: 0;
            color: #777;
        }

        .navbar__search input {
            width: 100%;
            height: 100%;
            padding: 0;
            border: 0;
            outline: none;
            background: transparent;
            font-size: 14px;
        }

        .navbar__actions {
            display: flex;
            align-items: center;
            gap: 18px;
            flex-shrink: 0;
        }

        .navbar__icon-btn {
            position: relative;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            color: #333;
            text-decoration: none;
        }

        .navbar__icon-btn svg,
        .navbar__user-link svg {
            width: 22px;
            height: 22px;
        }

        .navbar__icon-btn:hover,
        .navbar__user-link:hover {
            color: #d32f2f;
        }

        .navbar__cart-badge {
            position: absolute;
            top: -3px;
            right: -5px;
            min-width: 18px;
            height: 18px;
            padding: 0 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: #d32f2f;
            color: white;
            font-size: 11px;
            line-height: 1;
        }

        .navbar__divider {
            width: 1px;
            height: 28px;
            background: #ddd;
        }

        .navbar__user-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            white-space: nowrap;
        }

        /* PAGE CONTENT */
        .products-page {
            max-width: 1400px;
            margin: 0 auto;
            padding: 32px;
        }

        h1 {
            margin: 0 0 30px;
            font-size: 28px;
        }

        /* SEARCH / FILTER / SORT */
        .toolbar {
            display: flex;
            gap: 12px;
            margin-bottom: 30px;
            align-items: center;
            flex-wrap: wrap;
        }

        .toolbar input,
        .toolbar select,
        .toolbar button {
            height: 42px;
            padding: 0 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: white;
            box-sizing: border-box;
        }

        .toolbar input {
            width: 260px;
        }

        .toolbar button {
            cursor: pointer;
        }

        /* PRODUCT GRID */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 24px;
        }

        .product-card {
            position: relative;
            min-width: 0;
            overflow: hidden;
            border: 1px solid #eee;
            border-radius: 8px;
            background: #fff;
        }

        /* WISHLIST */
        .wishlist-form {
            position: absolute;
            top: 12px;
            right: 12px;
            z-index: 2;
            margin: 0;
        }

        .wishlist-button {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #e5e5e5;
            border-radius: 50%;
            background: #fff;
            color: #777;
            font-size: 25px;
            line-height: 1;
            cursor: pointer;
            transition: color .2s, background .2s, transform .2s;
        }

        .wishlist-button:hover {
            transform: scale(1.08);
            background: #fff0f2;
        }

        .wishlist-button.is-favorite {
            color: #e53950;
            background: #fff0f2;
        }

        .wishlist-button:disabled {
            opacity: .6;
            cursor: wait;
        }

        .product-image {
            width: 100%;
            height: 280px;
            overflow: hidden;
            background: #f3f3f3;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .no-image {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
        }

        .product-info {
            padding: 18px;
        }

        .product-name {
            margin: 0 0 10px;
            font-size: 18px;
        }

        .product-description {
            margin: 0 0 15px;
            color: #666;
            line-height: 1.5;
        }

        .product-price {
            min-height: 22px;
            margin: 0 0 15px;
            color: #d32f2f;
            font-weight: 600;
        }

        .product-button {
            width: 100%;
            min-height: 44px;
            border: 1px solid #0099ff;
            border-radius: 6px;
            background: white;
            color: #0088dd;
            cursor: pointer;
        }

        .product-button:hover {
            background: #0088dd;
            color: #fff;
        }

        /* PAGINATION */
        .pagination {
            margin-top: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .pagination a,
        .pagination span {
            padding: 10px 16px;
            border: 1px solid #ddd;
            border-radius: 6px;
            text-decoration: none;
            background: white;
            color: #333;
        }

        .pagination .current {
            background: #0088dd;
            color: white;
            border-color: #0088dd;
        }

        .pagination .disabled {
            color: #aaa;
            cursor: not-allowed;
        }

        /* PRODUCT VARIANT MODAL */
        .variant-modal {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 9999;
            background: rgba(0, 0, 0, .55);
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .variant-modal.is-open {
            display: flex;
        }

        .variant-modal-content {
            position: relative;
            background: white;
            width: 100%;
            max-width: 440px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, .2);
        }

        .variant-close {
            position: absolute;
            top: 10px;
            right: 14px;
            border: none;
            background: transparent;
            font-size: 28px;
            cursor: pointer;
        }

        .variant-modal-content h2 {
            margin-top: 0;
            padding-right: 20px;
        }

        .variant-field {
            margin: 18px 0;
        }

        .variant-field label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .variant-field select,
        .variant-field input {
            width: 100%;
            height: 42px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .variant-preview {
            width: 100%;
            height: 220px;
            margin: 16px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border-radius: 8px;
            background: #f5f5f5;
        }

        .variant-preview img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .variant-preview p {
            color: #888;
            text-align: center;
        }

        .variant-current-price {
            margin: 20px 0;
            font-size: 22px;
            font-weight: bold;
            color: #d32f2f;
        }

        .variant-submit {
            width: 100%;
            min-height: 44px;
            border: none;
            border-radius: 6px;
            background: #0088dd;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        .variant-submit:disabled {
            opacity: .6;
            cursor: wait;
        }

        .variant-message {
            margin-top: 12px;
            color: #c62828;
            font-size: 14px;
        }

        @media (max-width: 1000px) {
            .product-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .navbar__inner {
                gap: 16px;
                padding: 12px 20px;
            }

            .navbar__actions {
                gap: 12px;
            }
        }

        @media (max-width: 600px) {
            .navbar__inner {
                flex-wrap: wrap;
                padding: 12px 16px;
                gap: 12px;
            }

            .navbar__logo {
                font-size: 25px;
            }

            .navbar__search {
                order: 3;
                flex-basis: 100%;
                max-width: none;
            }

            .navbar__actions {
                margin-left: auto;
                gap: 10px;
            }

            .navbar__user-link span {
                max-width: 90px;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .products-page {
                padding: 22px 16px;
            }

            .product-grid {
                grid-template-columns: 1fr;
            }

            .toolbar {
                align-items: stretch;
            }

            .toolbar input,
            .toolbar select,
            .toolbar button {
                width: 100%;
            }
        }
    </style>
</head>

<body data-context-path="${ctx}">

    <!-- NAVBAR CHUNG -->
    <header class="navbar">
        <div class="navbar__inner">

            <a href="${ctx}/" class="navbar__logo">
                Fashion<span>.</span>
            </a>
            <nav class="navbar__actions">

                <a href="${ctx}/wishlist/toggle"
                   class="navbar__icon-btn"
                   title="Yêu thích"
                   aria-label="Danh sách yêu thích">
                    <svg viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                    </svg>
                </a>

                <a href="${ctx}/cart"
                   class="navbar__icon-btn"
                   title="Giỏ hàng"
                   id="cartNavBtn">
                    <svg viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                        <line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 0 1-8 0"/>
                    </svg>

                    <c:if test="${not empty cart and cart.totalQuantity > 0}">
                        <span class="navbar__cart-badge" id="cartNavBadge">
                            <c:out value="${cart.totalQuantity}"/>
                        </span>
                    </c:if>
                </a>

                <div class="navbar__divider"></div> 
                     <c:choose>
                                 <c:when test="${not empty sessionScope.user}">
                                     <div class="navbar__user-dropdown" id="userDropdown">
                                         <button type="button" class="navbar__user-link navbar__user-dropdown-toggle"
                                             id="userDropdownBtn" aria-expanded="false" title="Tài khoản">
                                             <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                 <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                                 <circle cx="12" cy="7" r="4" />
                                             </svg>
                                             <span id="logoText">
                                                 <c:out
                                                     value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : (not empty sessionScope.logoName ? sessionScope.logoName : 'HuyCter')}" />
                                             </span>
                                         </button>
                                         <div class="navbar__user-menu" id="userMenuPanel">
                                             <a href="${ctx}/profile">Hồ sơ</a>
                                             <a href="${ctx}/logout" class="navbar__logout-link">Đăng xuất</a>
                                         </div>
                                     </div>
                                 </c:when>
                                 <c:otherwise>
                                     <div class="navbar__guest-group">
                                         <a href="${ctx}/login" class="navbar__user-link" id="navUserLink"
                                             title="Đăng nhập">
                                             <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                 <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
                                                 <polyline points="10 17 15 12 10 7" />
                                                 <line x1="15" y1="12" x2="3" y2="12" />
                                             </svg>
                                             <span id="logoText">Đăng nhập</span>
                                         </a>
                                         <span class="navbar__guest-divider">|</span>
                                         <a href="${ctx}/register" class="navbar__user-link" id="navRegisterLink"
                                             title="Đăng ký tài khoản">
                                             <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                 <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                 <circle cx="8.5" cy="7" r="4" />
                                                 <line x1="20" y1="8" x2="20" y2="14" />
                                                 <line x1="23" y1="11" x2="17" y2="11" />
                                             </svg>
                                             <span>Đăng ký</span>
                                         </a>
                                     </div>
                                 </c:otherwise>
                             </c:choose>
                    </span>
                </a>

            </nav>
        </div>
    </header>

    <main class="products-page">

        <h1>Tất cả sản phẩm</h1>

        <!-- SEARCH / FILTER / SORT -->
        <form method="get" action="${ctx}/products" class="toolbar">

            <input type="text" name="search"
                   placeholder="Tìm kiếm sản phẩm..."
                   value="<c:out value='${search}'/>">

            <select name="categoryId">
                <option value="">Tất cả danh mục</option>

                <option value="1"
                    <c:if test="${categoryId != null && categoryId == 1}">selected</c:if>>
                    Áo
                </option>

                <option value="2"
                    <c:if test="${categoryId != null && categoryId == 2}">selected</c:if>>
                    Áo khoác
                </option>

                <option value="3"
                    <c:if test="${categoryId != null && categoryId == 3}">selected</c:if>>
                    Quần
                </option>

                <option value="4"
                    <c:if test="${categoryId != null && categoryId == 4}">selected</c:if>>
                    Phụ kiện
                </option>
            </select>

            <select name="sort">
                <option value="" <c:if test="${empty sort}">selected</c:if>>
                    Sắp xếp
                </option>
                <option value="asc" <c:if test="${sort == 'asc'}">selected</c:if>>
                    Giá thấp → cao
                </option>
                <option value="desc" <c:if test="${sort == 'desc'}">selected</c:if>>
                    Giá cao → thấp
                </option>
            </select>

            <button type="submit">Tìm kiếm</button>
        </form>

        <!-- PRODUCT GRID -->
        <div class="product-grid">

            <c:forEach var="product" items="${products}">

                <div class="product-card">

                    <!-- IMAGE -->
                    <div class="product-image">
                        <c:set var="imageUrl" value="${firstImageUrls[product.id]}"/>

                        <c:choose>
                            <c:when test="${not empty imageUrl}">
                                <img src="<c:out value='${imageUrl}'/>"
                                     alt="<c:out value='${product.name}'/>"
                                     loading="lazy">
                            </c:when>
                            <c:otherwise>
                                <div class="no-image">Chưa có ảnh sản phẩm</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- WISHLIST -->
                    <form method="post"
                          action="${ctx}/wishlist/toggle"
                          class="wishlist-form"
                          data-wishlist-form>

                        <input type="hidden" name="action"
                               value="${favoriteProductIds.contains(product.id) ? 'remove' : 'add'}">
                        <input type="hidden" name="productId" value="${product.id}">

                        <button type="submit"
                                class="wishlist-button ${favoriteProductIds.contains(product.id) ? 'is-favorite' : ''}"
                                aria-pressed="${favoriteProductIds.contains(product.id)}"
                                aria-label="${favoriteProductIds.contains(product.id) ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}">
                            ${favoriteProductIds.contains(product.id) ? '♥' : '♡'}
                        </button>
                    </form>

                    <!-- PRODUCT INFO -->
                    <div class="product-info">

                        <h3 class="product-name">
                            <c:out value="${product.name}"/>
                        </h3>

                        <p class="product-description">
                            <c:out value="${product.description}"/>
                        </p>

                        <p class="product-price">
                            <c:choose>
                                <c:when test="${minVariantPrices[product.id] != null}">
                                    Từ <fmt:formatNumber
                                        value="${minVariantPrices[product.id]}"
                                        type="number"
                                        groupingUsed="true"/> VNĐ
                                </c:when>
                                <c:otherwise>
                                    Chưa có giá
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <button type="button"
                                class="product-button"
                                data-product-id="${product.id}">
                            + Thêm vào giỏ
                        </button>

                    </div>
                </div>

            </c:forEach>
        </div>

        <!-- NO PRODUCTS -->
        <c:if test="${empty products}">
            <p>Không tìm thấy sản phẩm.</p>
        </c:if>

        <!-- PAGINATION -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">

                <!-- PREVIOUS -->
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <c:url var="previousUrl" value="/products">
                            <c:param name="page" value="${currentPage - 1}"/>
                            <c:param name="search" value="${search}"/>
                            <c:param name="categoryId" value="${categoryId}"/>
                            <c:param name="sort" value="${sort}"/>
                        </c:url>

                        <a href="${ctx}${previousUrl}">← Trang trước</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">← Trang trước</span>
                    </c:otherwise>
                </c:choose>

                <span class="current">
                    Trang <c:out value="${currentPage}"/>
                    / <c:out value="${totalPages}"/>
                </span>

                <!-- NEXT -->
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <c:url var="nextUrl" value="/products">
                            <c:param name="page" value="${currentPage + 1}"/>
                            <c:param name="search" value="${search}"/>
                            <c:param name="categoryId" value="${categoryId}"/>
                            <c:param name="sort" value="${sort}"/>
                        </c:url>

                        <a href="${ctx}${nextUrl}">Trang sau →</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">Trang sau →</span>
                    </c:otherwise>
                </c:choose>

            </div>
        </c:if>

    </main>

    <!-- PRODUCT VARIANT MODAL -->
    <div id="variantModal" class="variant-modal" aria-hidden="true">
        <div class="variant-modal-content"
             role="dialog"
             aria-modal="true"
             aria-labelledby="variantModalTitle">

            <button type="button" class="variant-close"
                    id="variantClose" aria-label="Đóng">&times;</button>

            <h2 id="variantModalTitle">Chọn size và màu sắc</h2>
            <p id="variantProductName"></p>

            <div class="variant-preview">
                <img id="variantImage" alt="Ảnh sản phẩm" style="display:none">
                <p id="variantImagePlaceholder">Chọn size và màu sắc để xem ảnh</p>
            </div>

            <div class="variant-field">
                <label for="variantSize">Size</label>
                <select id="variantSize">
                    <option value="">Đang tải...</option>
                </select>
            </div>

            <div class="variant-field">
                <label for="variantColor">Màu sắc</label>
                <select id="variantColor" disabled>
                    <option value="">Chọn màu sắc</option>
                </select>
            </div>

            <div class="variant-current-price" id="variantPrice">
                Giá: --
            </div>

            <div class="variant-field">
                <label for="variantQuantity">Số lượng</label>
                <input type="number" id="variantQuantity" min="1" value="1">
            </div>

            <button type="button" class="variant-submit" id="variantAddButton" disabled>
                Xác nhận thêm vào giỏ
            </button>

            <p id="variantMessage" class="variant-message" role="status"></p>
        </div>
    </div>

    <script>
    (() => {
        const contextPath = document.body.dataset.contextPath || '';
        const isLoggedIn = ${isLoggedIn};
        const loginUrl = contextPath + '/login';

        const modal = document.getElementById('variantModal');
        const sizeSelect = document.getElementById('variantSize');
        const colorSelect = document.getElementById('variantColor');
        const priceElement = document.getElementById('variantPrice');
        const variantImage = document.getElementById('variantImage');
        const imagePlaceholder = document.getElementById('variantImagePlaceholder');
        const messageElement = document.getElementById('variantMessage');
        const quantityInput = document.getElementById('variantQuantity');
        const addButton = document.getElementById('variantAddButton');

        let variants = [];
        let selectedProductId = null;
        let loadingVariants = false;
        let addingToCart = false;

        function showMessage(message) {
            messageElement.textContent = message;
        }

        function closeModal() {
            if (loadingVariants || addingToCart) return;
            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
        }

        function formatPrice(price) {
            return Number(price).toLocaleString('vi-VN') + ' VNĐ';
        }

        function getAvailableColors(size) {
            return [...new Set(
                variants
                    .filter(v => String(v.size) === size)
                    .map(v => String(v.color))
            )].sort();
        }

        function updatePrice() {
            const variant = variants.find(v =>
                String(v.size) === sizeSelect.value &&
                String(v.color) === colorSelect.value
            );

            if (!variant) {
                priceElement.textContent = 'Giá: --';
                variantImage.style.display = 'none';
                variantImage.removeAttribute('src');
                imagePlaceholder.style.display = 'block';
                imagePlaceholder.textContent = 'Chọn size và màu sắc để xem ảnh';
                addButton.disabled = true;
                return;
            }

            priceElement.textContent = 'Giá: ' + formatPrice(variant.price);

            if (variant.imageUrl) {
                variantImage.onload = () => {
                    variantImage.style.display = 'block';
                    imagePlaceholder.style.display = 'none';
                };

                variantImage.onerror = () => {
                    variantImage.style.display = 'none';
                    imagePlaceholder.style.display = 'block';
                    imagePlaceholder.textContent = 'Không tải được ảnh sản phẩm';
                };

                const imageUrl = String(variant.imageUrl);

                variantImage.src = /^https?:\/\//i.test(imageUrl)
                    ? imageUrl
                    : contextPath + (imageUrl.startsWith('/') ? imageUrl : '/' + imageUrl);
            } else {
                variantImage.style.display = 'none';
                variantImage.removeAttribute('src');
                imagePlaceholder.style.display = 'block';
                imagePlaceholder.textContent = 'Chưa có ảnh cho màu này';
            }

            addButton.disabled = false;
        }

        function updateColors() {
            const colors = getAvailableColors(sizeSelect.value);

            colorSelect.replaceChildren(new Option('Chọn màu sắc', ''));

            colors.forEach(color => {
                colorSelect.add(new Option(color, color));
            });

            colorSelect.disabled = colors.length === 0;
            updatePrice();
        }

        async function openModal(button) {
            if (loadingVariants || addingToCart) return;

            selectedProductId = button.dataset.productId;
            const card = button.closest('.product-card');
            const productName =
                card?.querySelector('.product-name')?.textContent.trim() || '';

            document.getElementById('variantProductName').textContent = productName;

            variants = [];
            sizeSelect.replaceChildren(new Option('Đang tải...', ''));
            colorSelect.replaceChildren(new Option('Chọn màu sắc', ''));
            colorSelect.disabled = true;
            quantityInput.value = '1';
            priceElement.textContent = 'Giá: --';
            variantImage.style.display = 'none';
            variantImage.removeAttribute('src');
            imagePlaceholder.style.display = 'block';
            imagePlaceholder.textContent = 'Chọn size và màu sắc để xem ảnh';
            showMessage('');
            addButton.disabled = true;

            modal.classList.add('is-open');
            modal.setAttribute('aria-hidden', 'false');
            loadingVariants = true;

            try {
                const response = await fetch(
                    contextPath + '/product-variants?productId=' +
                    encodeURIComponent(selectedProductId)
                );

                if (!response.ok) {
                    throw new Error('Không tải được biến thể sản phẩm.');
                }

                const data = await response.json();
                const grouped = new Map();

                data.forEach(variant => {
                    const key = JSON.stringify([variant.size, variant.color]);

                    if (!grouped.has(key)) {
                        grouped.set(key, variant);
                    }
                });

                variants = [...grouped.values()].filter(v =>
                    v.id != null && v.price != null
                );

                if (variants.length === 0) {
                    sizeSelect.replaceChildren(new Option('Hết hàng', ''));
                    showMessage('Sản phẩm hiện không có biến thể còn hàng.');
                    return;
                }

                const sizes = [...new Set(variants.map(v => String(v.size)))].sort();

                sizeSelect.replaceChildren(new Option('Chọn size', ''));

                sizes.forEach(size => {
                    sizeSelect.add(new Option(size, size));
                });

                sizeSelect.onchange = updateColors;
                colorSelect.onchange = updatePrice;

            } catch (error) {
                console.error('Product variant error:', error);
                showMessage('Không thể tải size và màu sắc. Vui lòng thử lại.');
            } finally {
                loadingVariants = false;
            }
        }

        document.querySelectorAll('.product-button[data-product-id]')
            .forEach(button => {
                button.addEventListener('click', () => {
                    if (!isLoggedIn) {
                        window.location.href = loginUrl;
                        return;
                    }

                    openModal(button);
                });
            });

        document.getElementById('variantClose')
            .addEventListener('click', closeModal);

        modal.addEventListener('click', event => {
            if (event.target === modal) closeModal();
        });

        document.addEventListener('keydown', event => {
            if (event.key === 'Escape') closeModal();
        });

        addButton.addEventListener('click', async () => {
            if (addingToCart) return;

            const variant = variants.find(v =>
                String(v.size) === sizeSelect.value &&
                String(v.color) === colorSelect.value
            );

            const quantity = Number(quantityInput.value);

            if (!variant) {
                showMessage('Vui lòng chọn size và màu sắc.');
                return;
            }

            if (!Number.isInteger(quantity) || quantity < 1) {
                showMessage('Số lượng phải là số nguyên lớn hơn 0.');
                return;
            }

            addingToCart = true;
            addButton.disabled = true;
            showMessage('');

            try {
                const formData = new URLSearchParams({
                    action: 'add',
                    variantId: String(variant.id),
                    quantity: String(quantity)
                });

                const response = await fetch(contextPath + '/cart', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                    },
                    body: formData
                });

                const result = await response.json();

                if (!response.ok || !result.success) {
                    throw new Error(result.message || 'Không thể thêm vào giỏ.');
                }

                window.location.href = contextPath + '/cart';

            } catch (error) {
                console.error('Add to cart error:', error);
                showMessage(
                    error.message ||
                    'Không thể thêm vào giỏ. Hãy kiểm tra đăng nhập và thử lại.'
                );
            } finally {
                addingToCart = false;
                addButton.disabled = false;
            }
        });

        /* WISHLIST AJAX */
        document.querySelectorAll('[data-wishlist-form]').forEach(form => {
            const button = form.querySelector('.wishlist-button');
            const actionInput = form.querySelector('[name="action"]');
            const productIdInput = form.querySelector('[name="productId"]');

            form.addEventListener('submit', async event => {
                event.preventDefault();

                if (!isLoggedIn) {
                    window.location.href = loginUrl;
                    return;
                }

                if (button.disabled) return;

                const wasFavorite = button.classList.contains('is-favorite');
                const action = wasFavorite ? 'remove' : 'add';

                const formData = new URLSearchParams({
                    action,
                    productId: productIdInput.value
                });

                button.disabled = true;

                try {
                    const response = await fetch(form.action, {
                        method: 'POST',
                        body: formData,
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest',
                            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                        }
                    });

                    if (!response.ok || response.redirected) {
                        throw new Error('HTTP ' + response.status);
                    }

                    const isFavorite = !wasFavorite;

                    actionInput.value = isFavorite ? 'remove' : 'add';
                    button.classList.toggle('is-favorite', isFavorite);
                    button.textContent = isFavorite ? '♥' : '♡';
                    button.setAttribute('aria-pressed', String(isFavorite));
                    button.setAttribute(
                        'aria-label',
                        isFavorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'
                    );

                } catch (error) {
                    console.error('Wishlist error:', error);
                    alert('Không thể cập nhật yêu thích. Vui lòng thử lại.');
                } finally {
                    button.disabled = false;
                }
            });
        });
    })();
    </script>

</body>
</html>
