<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng — Fashion Shop</title>
    <meta name="description" content="Xem và quản lý các sản phẩm trong giỏ hàng của bạn tại Fashion Shop.">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${ctx}/assets/css/customer.css">
    <link rel="stylesheet" href="${ctx}/assets/css/cart.css">
</head>
<body data-context-path="${ctx}">

    <!-- NAVBAR CHUNG -->
    <header class="navbar">
        <div class="navbar__inner">
            <a href="${ctx}/" class="navbar__logo">Fashion<span>.</span></a>

            <form class="navbar__search" action="${ctx}/products" method="get">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8" />
                    <line x1="21" y1="21" x2="16.65" y2="16.65" />
                </svg>
                <input type="text" name="q" placeholder="Tìm kiếm sản phẩm..." value="">
            </form>

            <nav class="navbar__actions">
                <a href="${ctx}/wishlist/toggle" class="navbar__icon-btn" title="Wishlist">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                    </svg>
                </a>
                <a href="${ctx}/cart" class="navbar__icon-btn" title="Giỏ hàng" id="cartNavBtn">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                        <line x1="3" y1="6" x2="21" y2="6" />
                        <path d="M16 10a4 4 0 0 1-8 0" />
                    </svg>
                    <c:if test="${not empty cart and cart.totalQuantity > 0}">
                        <span class="navbar__cart-badge" id="cartNavBadge">${cart.totalQuantity}</span>
                    </c:if>
                </a>
                <div class="navbar__divider"></div>
                <a href="${ctx}/login" class="navbar__user-link" id="navUserLink" title="Tài khoản">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                    <span id="logoText">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <c:out value="${sessionScope.user.fullName}" />
                            </c:when>
                            <c:when test="${not empty sessionScope.logoName}">
                                <c:out value="${sessionScope.logoName}" />
                            </c:when>
                            <c:otherwise>Tài khoản</c:otherwise>
                        </c:choose>
                    </span>
                </a>
            </nav>
        </div>
    </header>

    <!-- MAIN CART CONTENT -->
    <main class="cart-page">
        <div class="cart-container">

            <!-- PAGE HEADER -->
            <div class="cart-header">
                <h1 class="cart-header__title">Giỏ Hàng Của Bạn</h1>
                <span class="cart-header__count" id="cartHeaderCount">
                    <c:choose>
                        <c:when test="${not empty cart and cart.totalQuantity > 0}">
                            (${cart.totalQuantity} sản phẩm)
                        </c:when>
                        <c:otherwise>(0 sản phẩm)</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <!-- SUCCESS ALERT -->
            <c:if test="${not empty successMessage}">
                <div class="cart-alert cart-alert--success" id="cartSuccessAlert" role="alert">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                        <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                    <span><c:out value="${successMessage}" /></span>
                </div>
            </c:if>

            <!-- ERROR ALERT -->
            <c:if test="${not empty formError}">
                <div class="cart-alert cart-alert--error" id="cartErrorAlert" role="alert">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="12" />
                        <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                    <span><c:out value="${formError}" /></span>
                </div>
            </c:if>

            <!-- VOUCHER WARNING ALERT (NẾU MÃ BỊ TẮT / KHÔNG ĐỦ ĐƠN TỐI THIỂU KHI XEM LẠI) -->
            <c:if test="${not empty cart and not empty cart.voucherWarning}">
                <div class="cart-alert cart-alert--warning" id="voucherWarningAlert" role="alert">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                        <line x1="12" y1="9" x2="12" y2="13" />
                        <line x1="12" y1="17" x2="12.01" y2="17" />
                    </svg>
                    <span><c:out value="${cart.voucherWarning}" /></span>
                </div>
            </c:if>

            <c:choose>
                <%-- ==================== TRƯỜNG HỢP GIỎ HÀNG TRỐNG ==================== --%>
                <c:when test="${empty cart or empty cart.items}">
                    <div class="cart-empty" id="cartEmptyView">
                        <svg class="cart-empty__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                            <line x1="3" y1="6" x2="21" y2="6" />
                            <path d="M16 10a4 4 0 0 1-8 0" />
                        </svg>
                        <h2 class="cart-empty__title">Giỏ hàng của bạn đang trống</h2>
                        <p class="cart-empty__desc">Khám phá các sản phẩm thời trang tối giản chất lượng cao và thêm vào giỏ hàng ngay.</p>
                        <a href="${ctx}/products" class="cart-checkout-btn" style="display: inline-flex; width: auto; padding: 0 28px;">
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </c:when>

                <%-- ==================== TRƯỜNG HỢP GIỎ HÀNG CÓ SẢN PHẨM ==================== --%>
                <c:otherwise>
                    <div class="cart-layout">

                        <!-- CỘT TRÁI: DANH SÁCH SẢN PHẨM -->
                        <div class="cart-items-wrapper">
                            <div class="cart-items-header">
                                <span>Sản phẩm</span>
                                <span>Số lượng & Giá</span>
                            </div>

                            <ul class="cart-items-list" id="cartItemsList">
                                <c:forEach var="item" items="${cart.items}">
                                    <li class="cart-item ${not item.available ? 'cart-item--unavailable' : ''}" id="cartItem-${item.id}">
                                        
                                        <!-- Ảnh sản phẩm -->
                                        <div class="cart-item__image-wrap">
                                            <c:choose>
                                                <c:when test="${not empty item.imageUrl}">
                                                    <img src="${item.imageUrl}" alt="${item.productName}" class="cart-item__image" loading="lazy">
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;color:var(--text-muted);font-size:11px;">
                                                        Ảnh
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Thông tin chi tiết -->
                                        <div class="cart-item__content">
                                            <div class="cart-item__info">
                                                <h3 class="cart-item__name"><c:out value="${item.productName}" /></h3>
                                                <div class="cart-item__meta"><c:out value="${item.variantName}" /></div>
                                                <div class="cart-item__sku">SKU: <c:out value="${item.sku}" /></div>
                                                
                                                <c:if test="${not item.available and not empty item.warningMessage}">
                                                    <div class="cart-item__warning">
                                                        ⚠ <c:out value="${item.warningMessage}" />
                                                    </div>
                                                </c:if>
                                            </div>

                                            <!-- Điều chỉnh số lượng -->
                                            <div class="cart-item__qty-wrapper">
                                                <div class="cart-qty-ctrl">
                                                    <button type="button" class="cart-qty-ctrl__btn js-qty-btn" data-item-id="${item.id}" data-delta="-1" aria-label="Giảm số lượng">-</button>
                                                    <input type="number" class="cart-qty-ctrl__input js-qty-input" id="qty-input-${item.id}" data-item-id="${item.id}" value="${item.quantity}" min="1" max="99" aria-label="Số lượng">
                                                    <button type="button" class="cart-qty-ctrl__btn js-qty-btn" data-item-id="${item.id}" data-delta="1" aria-label="Tăng số lượng">+</button>
                                                </div>
                                            </div>

                                            <!-- Thành tiền & Xóa -->
                                            <div class="cart-item__price-block">
                                                <div class="cart-item__price">
                                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" />đ
                                                </div>
                                                <div class="cart-item__unit-price">
                                                    (<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0" />đ / sp)
                                                </div>
                                                
                                                <form action="${ctx}/cart" method="post">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="itemId" value="${item.id}">
                                                    <button type="submit" class="cart-item__remove-btn" id="removeBtn-${item.id}">Xóa</button>
                                                </form>
                                            </div>
                                        </div>

                                    </li>
                                </c:forEach>
                            </ul>

                            <!-- Chân bảng giỏ hàng -->
                            <div class="cart-items-footer">
                                <a href="${ctx}/products" class="cart-link-btn">
                                    ← Tiếp tục mua sắm
                                </a>

                                <form action="${ctx}/cart" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa toàn bộ sản phẩm trong giỏ hàng?');">
                                    <input type="hidden" name="action" value="clear">
                                    <button type="submit" class="cart-clear-btn" id="clearCartBtn">Xóa tất cả</button>
                                </form>
                            </div>
                        </div>

                        <!-- CỘT PHẢI: TỔNG KẾT ĐƠN HÀNG (STICKY) -->
                        <div class="cart-summary">
                            <h2 class="cart-summary__title">Tóm Tắt Đơn Hàng</h2>

                            <!-- Tiền hàng -->
                            <div class="cart-summary__row">
                                <span>Tạm tính:</span>
                                <span class="cart-summary__value" id="cartSubtotalVal">
                                    <fmt:formatNumber value="${cart.subtotal}" pattern="#,##0" />đ
                                </span>
                            </div>

                            <!-- Giảm giá voucher (nếu có) -->
                            <c:if test="${cart.discountAmount > 0}">
                                <div class="cart-summary__row cart-summary__row--discount" id="cartDiscountRow">
                                    <span>Giảm giá voucher:</span>
                                    <span class="cart-summary__value">
                                        -<fmt:formatNumber value="${cart.discountAmount}" pattern="#,##0" />đ
                                    </span>
                                </div>
                            </c:if>

                            <div class="cart-summary__divider"></div>

                            <!-- Nhập mã Voucher -->
                            <div class="cart-voucher">
                                <span class="cart-voucher__label">Mã Giảm Giá</span>
                                
                                <c:choose>
                                    <c:when test="${not empty cart.voucherCode}">
                                        <div class="cart-voucher__applied-badge" id="appliedVoucherBadge">
                                            <span>Mã đã áp dụng: <span class="cart-voucher__code-tag"><c:out value="${cart.voucherCode}" /></span></span>
                                            <form action="${ctx}/cart" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="removeVoucher">
                                                <button type="submit" class="cart-voucher__remove-link" id="removeVoucherBtn">Gỡ bỏ</button>
                                            </form>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${ctx}/cart" method="post" class="cart-voucher__form" id="applyVoucherForm">
                                            <input type="hidden" name="action" value="applyVoucher">
                                            <input type="text" name="voucherCode" class="cart-voucher__input" placeholder="Nhập mã voucher..." required maxlength="50" id="voucherCodeInput">
                                            <button type="submit" class="cart-voucher__btn" id="applyVoucherBtn">Áp dụng</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="cart-summary__divider"></div>

                            <!-- Tổng cộng -->
                            <div class="cart-summary__row cart-summary__row--total">
                                <span>Tổng tiền:</span>
                                <span class="cart-summary__value" id="cartTotalVal">
                                    <fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0" />đ
                                </span>
                            </div>

                            <!-- Nút thanh toán -->
                            <c:choose>
                                <c:when test="${cart.canCheckout}">
                                    <a href="${ctx}/checkout" class="cart-checkout-btn" id="proceedCheckoutBtn">
                                        Tiến Hành Đặt Hàng
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="cart-checkout-btn" disabled id="proceedCheckoutBtnDisabled" title="Vui lòng điều chỉnh lại số lượng hoặc xóa các sản phẩm không đủ hàng">
                                        Chưa thể đặt hàng
                                    </button>
                                </c:otherwise>
                            </c:choose>

                        </div>

                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </main>

    <!-- JS -->
    <script src="${ctx}/assets/js/cart.js"></script>
</body>
</html>
