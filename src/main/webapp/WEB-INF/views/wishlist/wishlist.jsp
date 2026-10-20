
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sản phẩm yêu thích — Fashion Shop</title>
    <meta name="description"
          content="Danh sách sản phẩm yêu thích của bạn tại Fashion Shop.">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500&display=swap"
          rel="stylesheet">

    <!-- CSS navbar dùng chung với index.jsp -->
    <link rel="stylesheet" href="${ctx}/assets/css/customer.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Inter', Arial, sans-serif;
            background: #f7f7f7;
            color: #222;
        }

        /* WISHLIST */
        .wishlist-container {
            max-width: 1200px;
            margin: 40px auto 60px;
            padding: 0 20px;
            min-height: 50vh;
        }

        .wishlist-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 28px;
        }

        .wishlist-header h1 {
            margin: 0;
            font-family: 'Playfair Display', Georgia, serif;
            font-size: 30px;
            font-weight: 700;
        }

        .wishlist-count {
            margin: 8px 0 0;
            color: #777;
            font-size: 14px;
        }

        .back-link {
            display: inline-block;
            color: #222;
            text-decoration: none;
            border: 1px solid #ddd;
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 14px;
            white-space: nowrap;
            transition: background 0.2s;
        }

        .back-link:hover {
            background: #eee;
        }

        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 22px;
        }

        .wishlist-card {
            display: flex;
            flex-direction: column;
            min-width: 0;
            overflow: hidden;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 10px;
            transition: box-shadow 0.2s, transform 0.2s;
        }

        .wishlist-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.07);
        }

        .product-image {
            height: 250px;
            background: #eee;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            color: #888;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .product-image-placeholder {
            font-size: 14px;
            color: #888;
        }

        .product-info {
            display: flex;
            flex-direction: column;
            flex: 1;
            padding: 16px;
        }

        .product-name {
            margin: 0 0 10px;
            font-size: 16px;
            font-weight: 600;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .product-description {
            color: #777;
            font-size: 13px;
            line-height: 1.6;
            margin: 0;
            min-height: 42px;
            overflow-wrap: anywhere;
        }

        .product-price {
            margin: 16px 0;
            font-size: 15px;
            font-weight: 600;
            color: #222;
        }

        .card-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-top: auto;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 11px 12px;
            border: 1px solid transparent;
            border-radius: 6px;
            cursor: pointer;
            text-align: center;
            font-family: inherit;
            font-size: 14px;
            text-decoration: none;
            transition: opacity 0.2s, background 0.2s;
        }

        .btn:hover {
            opacity: 0.85;
        }

        .btn-detail {
            background: #222;
            color: #fff;
        }

        .btn-remove {
            background: #fff;
            color: #c62828;
            border-color: #e0bcbc;
        }

        .btn-remove:hover {
            background: #fff5f5;
        }

        .empty-state {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 10px;
            padding: 60px 20px;
            text-align: center;
        }

        .empty-heart {
            font-size: 54px;
            color: #bbb;
            line-height: 1.2;
        }

        .empty-state h2 {
            margin: 18px 0 0;
            font-size: 22px;
        }

        .empty-state p {
            color: #777;
            line-height: 1.7;
            margin: 12px auto 24px;
            max-width: 460px;
        }

        .empty-action {
            display: inline-block;
            width: auto;
            min-width: 200px;
        }

        /* RESPONSIVE */
        @media (max-width: 1000px) {
            .wishlist-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .product-image {
                height: 230px;
            }
        }

        @media (max-width: 760px) {
            .wishlist-container {
                margin-top: 28px;
            }

            .wishlist-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 16px;
            }

            .product-image {
                height: 220px;
            }

            .wishlist-header h1 {
                font-size: 25px;
            }
        }

        @media (max-width: 500px) {
            .wishlist-container {
                padding: 0 14px;
            }

            .wishlist-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .wishlist-header h1 {
                font-size: 23px;
            }

            .wishlist-grid {
                gap: 12px;
            }

            .product-image {
                height: 175px;
            }

            .product-info {
                padding: 12px;
            }

            .product-name {
                font-size: 14px;
            }

            .product-description {
                font-size: 12px;
            }

            .product-price {
                font-size: 14px;
            }

            .btn {
                padding: 10px 8px;
                font-size: 12px;
            }

            .empty-state {
                padding: 42px 16px;
            }
        }
    </style>
</head>

<body>

    <!-- NAVBAR: đồng bộ với index.jsp -->
    <header class="navbar">
        <div class="navbar__inner">

            <a href="${ctx}/" class="navbar__logo">
                Fashion<span>.</span>
            </a>

            <form class="navbar__search"
                  action="${ctx}/products"
                  method="get">

                <svg viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8" />
                    <line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>

                <input type="text"
                       name="q"
                       placeholder="Tìm kiếm sản phẩm...">
            </form>

            <nav class="navbar__actions">

                <!-- Mở danh sách yêu thích -->
                <a href="${ctx}/wishlist"
                   class="navbar__icon-btn"
                   title="Sản phẩm yêu thích"
                   aria-label="Sản phẩm yêu thích">

                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         stroke-linecap="round"
                         stroke-linejoin="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                    </svg>
                </a>

                <!-- Giỏ hàng -->
                <a href="${ctx}/cart"
                   class="navbar__icon-btn"
                   title="Giỏ hàng"
                   aria-label="Giỏ hàng">

                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         stroke-linecap="round"
                         stroke-linejoin="round">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                        <line x1="3" y1="6" x2="21" y2="6" />
                        <path d="M16 10a4 4 0 0 1-8 0" />
                    </svg>

                    <c:if test="${not empty sessionScope.cart
                                  and sessionScope.cart.totalQuantity > 0}">
                        <span class="navbar__cart-badge">
                            <c:out value="${sessionScope.cart.totalQuantity}" />
                        </span>
                    </c:if>
                </a>

                <div class="navbar__divider"></div>

                <!-- Tài khoản người dùng -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">

                        <div class="navbar__user-dropdown" id="userDropdown">

                            <button type="button"
                                    class="navbar__user-link navbar__user-dropdown-toggle"
                                    id="userDropdownBtn"
                                    aria-expanded="false"
                                    title="Tài khoản">

                                <svg viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                    <circle cx="12" cy="7" r="4" />
                                </svg>

                                <span id="logoText">
                                    <c:out value="${not empty sessionScope.user.fullName
                                        ? sessionScope.user.fullName
                                        : (not empty sessionScope.logoName
                                            ? sessionScope.logoName : 'HuyCter')}" />
                                </span>
                            </button>

                            <div class="navbar__user-menu" id="userMenuPanel">
                                <a href="${ctx}/profile">Hồ sơ</a>
                                <a href="${ctx}/logout"
                                   class="navbar__logout-link">
                                    Đăng xuất
                                </a>
                            </div>

                        </div>
                    </c:when>

                    <c:otherwise>

                        <div class="navbar__guest-group">

                            <a href="${ctx}/login"
                               class="navbar__user-link"
                               id="navUserLink"
                               title="Đăng nhập">

                                <svg viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round">
                                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
                                    <polyline points="10 17 15 12 10 7" />
                                    <line x1="15" y1="12" x2="3" y2="12" />
                                </svg>

                                <span id="logoText">Đăng nhập</span>
                            </a>

                            <span class="navbar__guest-divider">|</span>

                            <a href="${ctx}/register"
                               class="navbar__user-link"
                               id="navRegisterLink"
                               title="Đăng ký tài khoản">

                                <svg viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round">
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

            </nav>
        </div>
    </header>

    <!-- NỘI DUNG WISHLIST -->
    <main class="wishlist-container">

        <div class="wishlist-header">
            <div>
                <h1>♡ Sản phẩm yêu thích</h1>

                <p class="wishlist-count">
                    Bạn có
                    <strong>
                        <c:choose>
                            <c:when test="${not empty wishlistItems}">
                                <c:out value="${wishlistItems.size()}" />
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </strong>
                    sản phẩm yêu thích
                </p>
            </div>

            <a class="back-link" href="${ctx}/products">
                ← Tiếp tục mua sắm
            </a>
        </div>

        <c:choose>

            
            <c:when test="${empty wishlistItems}">

                <section class="empty-state">
                    <div class="empty-heart">♡</div>

                    <h2>Wishlist đang trống</h2>

                    <p>
                        Hãy thêm những sản phẩm bạn yêu thích để
                        dễ dàng tìm lại và mua sắm sau này.
                    </p>

                    <a class="btn btn-detail empty-action"
                       href="${ctx}/products">
                        Khám phá sản phẩm
                    </a>
                </section>
            </c:when>       
            <c:otherwise>

                <section class="wishlist-grid">

                    <c:forEach var="item" items="${wishlistItems}">

                        <article class="wishlist-card">

                            <!-- Ảnh sản phẩm -->
                            <div class="product-image">

                                <c:choose>
                                    <c:when test="${not empty item.product.images}">
                                        <img
                                            src="<c:out value='${item.product.images}'/>"
                                            alt="<c:out value='${item.product.name}'/>"
                                            loading="lazy"
                                            onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">

                                        <span class="product-image-placeholder"
                                              style="display:none;">
                                            Không tải được ảnh
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="product-image-placeholder">
                                            Chưa có ảnh sản phẩm
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                            </div>

                            <div class="product-info">

                                <h2 class="product-name">
                                    <c:out value="${item.product.name}" />
                                </h2>

                                <p class="product-description">
                                    <c:choose>
                                        <c:when test="${not empty item.product.description}">
                                            <c:out value="${item.product.description}" />
                                        </c:when>
                                        <c:otherwise>
                                            Chưa có mô tả sản phẩm.
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <!-- Giá lấy từ priceRanges, không dùng product.price -->
                                <c:set var="priceRange"
                                       value="${priceRanges[item.product.id]}" />

                                <p class="product-price">
                                    <c:choose>
                                        <c:when test="${empty priceRange or empty priceRange[0]}">
                                            Chưa có giá
                                        </c:when>

                                        <c:otherwise>
                                            Từ
                                            <fmt:formatNumber
                                                value="${priceRange[0]}"
                                                pattern="#,##0"
                                                groupingUsed="true" />
                                            ₫
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <div class="card-actions">

                                    <!--
                                        Chưa đặt link chi tiết vì cần khớp
                                        chính xác mapping Servlet của dự án.
                                    -->
                                    <a class="btn btn-detail"
                                       href="${ctx}/products">
                                        Xem sản phẩm
                                    </a>

                                    <!-- Bỏ sản phẩm khỏi wishlist -->
                                    <form method="post"
                                          action="${ctx}/wishlist/toggle">

                                        <input type="hidden"
                                               name="action"
                                               value="remove">

                                        <input type="hidden"
                                               name="productId"
                                               value="<c:out value='${item.product.id}'/>">

                                        <button class="btn btn-remove"
                                                type="submit">
                                            ♡ Bỏ yêu thích
                                        </button>
                                    </form>

                                </div>
                            </div>
                        </article>

                    </c:forEach>

                </section>

            </c:otherwise>
        </c:choose>

    </main>

    <!-- DROPDOWN TÀI KHOẢN -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const userDropdown = document.getElementById('userDropdown');
            const userDropdownBtn = document.getElementById('userDropdownBtn');

            if (userDropdown && userDropdownBtn) {
                userDropdownBtn.addEventListener('click', function (event) {
                    event.stopPropagation();

                    const isOpen = userDropdown.classList.toggle('is-open');
                    userDropdownBtn.setAttribute('aria-expanded', isOpen);
                });

                document.addEventListener('click', function (event) {
                    if (!userDropdown.contains(event.target)) {
                        userDropdown.classList.remove('is-open');
                        userDropdownBtn.setAttribute('aria-expanded', 'false');
                    }
                });
            }
        });
    </script>

</body>
</html>
