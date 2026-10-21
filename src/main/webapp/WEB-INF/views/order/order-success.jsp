<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công — Fashion Shop</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/customer.css">
    <link rel="stylesheet" href="${ctx}/assets/css/payment.css">
</head>
<body data-context-path="${ctx}">

<%@ include file="../payment/_navbar.jspf" %>

<main class="pay-page">
    <div class="pay-container pay-container--narrow">

        <section class="pay-card pay-result pay-result--success">
            <div class="pay-result__icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12" /></svg>
            </div>
            <h1 class="pay-result__title">Đặt hàng thành công</h1>
            <p class="pay-result__msg">
                Đơn hàng <span class="pay-mono"><c:out value="${order.orderCode}" /></span> đang ở trạng thái
                "<c:out value="${order.statusName}" />". Bạn sẽ thanh toán khi nhận hàng.
            </p>
        </section>

        <section class="pay-card pay-details">
            <h2 class="pay-card__title">Chi tiết đơn hàng</h2>
            <c:forEach var="item" items="${order.items}">
                <div class="pay-item">
                    <div><c:out value="${item.productName}" /> × ${item.quantity}</div>
                    <div><fmt:formatNumber value="${item.subtotal}" pattern="#,##0" />đ</div>
                </div>
            </c:forEach>
            <div class="pay-row pay-row--total">
                <span>Tổng thanh toán</span>
                <span><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" />đ</span>
            </div>
            <div class="pay-row"><span>Người nhận</span><span><c:out value="${order.shippingRecipientName}" /> · <c:out value="${order.shippingPhone}" /></span></div>
            <div class="pay-row"><span>Địa chỉ</span><span style="text-align:right; max-width:65%;"><c:out value="${order.shippingAddressLine}" /></span></div>
            <c:if test="${not empty order.note}">
                <div class="pay-row"><span>Ghi chú</span><span><c:out value="${order.note}" /></span></div>
            </c:if>
            <div class="pay-row"><span>Thanh toán</span><span>Thanh toán khi nhận hàng (COD)</span></div>

            <div class="pay-actions">
                <a href="${ctx}/profile" class="pay-btn">Xem đơn hàng của tôi</a>
                <a href="${ctx}/" class="pay-btn pay-btn--ghost">Tiếp tục mua sắm</a>
            </div>
        </section>
    </div>
</main>
</body>
</html>
