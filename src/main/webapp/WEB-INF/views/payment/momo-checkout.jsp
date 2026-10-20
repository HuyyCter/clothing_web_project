<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán MoMo — Fashion Shop</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/customer.css">
    <link rel="stylesheet" href="${ctx}/assets/css/payment.css">
</head>
<body data-context-path="${ctx}">

<%@ include file="_navbar.jspf" %>

<main class="pay-page">
    <div class="pay-container">

        <div class="pay-header">
            <h1 class="pay-header__title">Thanh toán bằng MoMo</h1>
            <p class="pay-header__sub">Kiểm tra đơn hàng và địa chỉ nhận hàng, sau đó bạn sẽ được chuyển sang cổng MoMo để thanh toán.</p>
        </div>

        <c:if test="${not empty formError}">
            <div class="pay-alert pay-alert--error" role="alert"><c:out value="${formError}" /></div>
        </c:if>

        <c:choose>
            <c:when test="${empty cart or empty cart.items}">
                <div class="pay-card">
                    <p>Giỏ hàng của bạn đang trống.</p>
                    <a href="${ctx}/products" class="pay-btn" style="max-width: 240px;">Tiếp tục mua sắm</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:set var="useNew" value="${empty addresses or (empty form.addressId and not empty form.recipientName)}" />
                <c:set var="amountOk" value="${cart.totalAmount >= minAmount and cart.totalAmount <= maxAmount}" />

                <form action="${ctx}/payment/momo" method="post" class="pay-layout" id="momoCheckoutForm">

                    <!-- CỘT TRÁI: ĐỊA CHỈ + GHI CHÚ -->
                    <div>
                        <section class="pay-card">
                            <h2 class="pay-card__title">Địa chỉ nhận hàng</h2>

                            <c:forEach var="a" items="${addresses}" varStatus="loop">
                                <label class="pay-address">
                                    <input type="radio" name="addressId" value="${a.id}"
                                        <c:if test="${form.addressId == a.id or (empty form.addressId and not useNew and loop.first)}">checked</c:if>>
                                    <span>
                                        <span class="pay-address__name">
                                            <c:out value="${a.recipientName}" /> · <c:out value="${a.phone}" />
                                            <c:if test="${a.defaultAddress}"><span class="pay-badge">Mặc định</span></c:if>
                                        </span>
                                        <span class="pay-address__line" style="display:block;"><c:out value="${a.fullAddress}" /></span>
                                    </span>
                                </label>
                            </c:forEach>

                            <label class="pay-address">
                                <input type="radio" name="addressId" value="new" id="addrNewRadio" <c:if test="${useNew}">checked</c:if>>
                                <span class="pay-address__name">Giao tới địa chỉ khác</span>
                            </label>

                            <div class="pay-manual" id="manualAddress">
                                <div class="pay-field">
                                    <label for="recipientName">Tên người nhận</label>
                                    <input type="text" id="recipientName" name="recipientName" maxlength="100" value="<c:out value='${form.recipientName}'/>">
                                </div>
                                <div class="pay-field">
                                    <label for="phone">Số điện thoại</label>
                                    <input type="tel" id="phone" name="phone" maxlength="10" placeholder="0xxxxxxxxx" value="<c:out value='${form.phone}'/>">
                                </div>
                                <div class="pay-field">
                                    <label for="shippingAddress">Địa chỉ (số nhà, đường, phường/xã, quận/huyện, tỉnh/thành)</label>
                                    <input type="text" id="shippingAddress" name="shippingAddress" maxlength="255" value="<c:out value='${form.shippingAddress}'/>">
                                </div>
                            </div>
                        </section>

                        <section class="pay-card">
                            <h2 class="pay-card__title">Ghi chú</h2>
                            <div class="pay-field">
                                <label for="note">Ghi chú cho người giao hàng (không bắt buộc)</label>
                                <textarea id="note" name="note" rows="3" maxlength="255"><c:out value="${form.note}" /></textarea>
                            </div>
                        </section>
                    </div>

                    <!-- CỘT PHẢI: TÓM TẮT ĐƠN -->
                    <aside class="pay-card">
                        <h2 class="pay-card__title">Đơn hàng (${cart.totalQuantity} sản phẩm)</h2>

                        <c:forEach var="item" items="${cart.items}">
                            <div class="pay-item">
                                <div>
                                    <div><c:out value="${item.productName}" /> × ${item.quantity}</div>
                                    <div class="pay-item__meta"><c:out value="${item.variantName}" /> · <span class="pay-mono"><c:out value="${item.sku}" /></span></div>
                                </div>
                                <div><fmt:formatNumber value="${item.subtotal}" pattern="#,##0" />đ</div>
                            </div>
                        </c:forEach>

                        <div class="pay-row" style="margin-top:8px;">
                            <span>Tạm tính</span>
                            <span><fmt:formatNumber value="${cart.subtotal}" pattern="#,##0" />đ</span>
                        </div>
                        <c:if test="${not empty cart.voucherCode and empty cart.voucherWarning}">
                            <div class="pay-row pay-row--discount">
                                <span>Voucher <span class="pay-mono"><c:out value="${cart.voucherCode}" /></span></span>
                                <span>-<fmt:formatNumber value="${cart.discountAmount}" pattern="#,##0" />đ</span>
                            </div>
                        </c:if>
                        <div class="pay-row pay-row--total">
                            <span>Tổng thanh toán</span>
                            <span><fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0" />đ</span>
                        </div>

                        <c:if test="${not empty cart.voucherWarning}">
                            <div class="pay-alert pay-alert--warning" style="margin-top:12px;"><c:out value="${cart.voucherWarning}" /></div>
                        </c:if>
                        <c:forEach var="w" items="${cart.warnings}">
                            <div class="pay-alert pay-alert--warning" style="margin-top:12px;"><c:out value="${w}" /></div>
                        </c:forEach>
                        <c:if test="${not amountOk}">
                            <div class="pay-alert pay-alert--warning" style="margin-top:12px;">
                                MoMo chỉ nhận giao dịch từ <fmt:formatNumber value="${minAmount}" pattern="#,##0" />đ
                                đến <fmt:formatNumber value="${maxAmount}" pattern="#,##0" />đ.
                            </div>
                        </c:if>

                        <button type="submit" class="pay-btn" id="momoPayBtn"
                            <c:if test="${not cart.canCheckout or not amountOk}">disabled</c:if>>
                            Thanh toán qua MoMo
                        </button>
                        <a href="${ctx}/cart" class="pay-btn pay-btn--ghost">Quay lại giỏ hàng</a>

                        <p class="pay-note">
                            Đơn hàng chỉ được tạo sau khi MoMo xác nhận thanh toán thành công.
                            Nếu bạn hủy trên trang MoMo, giỏ hàng vẫn được giữ nguyên.
                        </p>
                    </aside>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
    // Ẩn/hiện ô nhập địa chỉ tay theo lựa chọn radio (vanilla JS, không framework)
    (function () {
        var form = document.getElementById('momoCheckoutForm');
        var manual = document.getElementById('manualAddress');
        var newRadio = document.getElementById('addrNewRadio');
        if (!form || !manual || !newRadio) return;
        function sync() { manual.hidden = !newRadio.checked; }
        form.addEventListener('change', function (e) {
            if (e.target && e.target.name === 'addressId') sync();
        });
        form.addEventListener('submit', function () {
            var btn = document.getElementById('momoPayBtn');
            if (btn) { btn.disabled = true; btn.textContent = 'Đang chuyển sang MoMo...'; }
        });
        sync();
    })();
</script>
</body>
</html>
