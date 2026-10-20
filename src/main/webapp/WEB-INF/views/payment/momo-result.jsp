<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán — Fashion Shop</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/customer.css">
    <link rel="stylesheet" href="${ctx}/assets/css/payment.css">
</head>
<body data-context-path="${ctx}">

<%@ include file="_navbar.jspf" %>

<main class="pay-page">
    <div class="pay-container pay-container--narrow">

        <c:choose>
            <c:when test="${tx.success}">
                <c:set var="variant" value="success" />
            </c:when>
            <c:when test="${tx.pending}">
                <c:set var="variant" value="pending" />
            </c:when>
            <c:otherwise>
                <c:set var="variant" value="failed" />
            </c:otherwise>
        </c:choose>

        <section class="pay-card pay-result pay-result--${variant}">
            <div class="pay-result__icon" aria-hidden="true">
                <c:choose>
                    <c:when test="${variant == 'success'}">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12" /></svg>
                    </c:when>
                    <c:when test="${variant == 'pending'}">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 15 14" /></svg>
                    </c:when>
                    <c:otherwise>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <c:when test="${variant == 'success'}">
                    <h1 class="pay-result__title">Thanh toán thành công</h1>
                    <p class="pay-result__msg">
                        <c:choose>
                            <c:when test="${not empty tx.orderId}">
                                Đơn hàng <span class="pay-mono">#${tx.orderId}</span> đã được xác nhận và đang được chuẩn bị.
                            </c:when>
                            <c:when test="${not empty tx.orderError}">
                                MoMo đã nhận tiền nhưng hệ thống chưa tạo được đơn hàng.
                                Vui lòng liên hệ shop kèm mã giao dịch bên dưới để được hỗ trợ hoặc hoàn tiền.
                            </c:when>
                            <c:otherwise>
                                MoMo đã xác nhận thanh toán. Đơn hàng của bạn đang được xử lý.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </c:when>
                <c:when test="${variant == 'pending'}">
                    <h1 class="pay-result__title">Đang chờ xác nhận</h1>
                    <p class="pay-result__msg">MoMo chưa trả kết quả cuối cùng cho giao dịch này. Vui lòng đợi vài giây rồi tải lại trang.</p>
                </c:when>
                <c:otherwise>
                    <h1 class="pay-result__title">Thanh toán không thành công</h1>
                    <p class="pay-result__msg">
                        <c:out value="${not empty tx.message ? tx.message : 'Giao dịch đã bị hủy hoặc thất bại.'}" />
                        Bạn chưa bị trừ tiền, giỏ hàng vẫn được giữ nguyên.
                    </p>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="pay-card pay-details">
            <h2 class="pay-card__title">Chi tiết giao dịch</h2>
            <div class="pay-row"><span>Mã giao dịch</span><span class="pay-mono"><c:out value="${tx.momoOrderId}" /></span></div>
            <div class="pay-row"><span>Số tiền</span><span><fmt:formatNumber value="${tx.amount}" pattern="#,##0" />đ</span></div>
            <c:if test="${not empty tx.transId}">
                <div class="pay-row"><span>Mã MoMo (transId)</span><span class="pay-mono"><c:out value="${tx.transId}" /></span></div>
            </c:if>
            <c:if test="${not empty tx.payType}">
                <div class="pay-row"><span>Hình thức</span><span><c:out value="${tx.payType}" /></span></div>
            </c:if>
            <c:if test="${not empty tx.paidAtText}">
                <div class="pay-row"><span>Thời gian thanh toán</span><span><c:out value="${tx.paidAtText}" /></span></div>
            </c:if>
            <c:if test="${not empty tx.resultCode}">
                <div class="pay-row"><span>Mã kết quả</span><span class="pay-mono">${tx.resultCode}</span></div>
            </c:if>

            <div class="pay-actions">
                <c:choose>
                    <c:when test="${variant == 'pending'}">
                        <a href="${ctx}/payment/momo/return?orderId=${tx.momoOrderId}" class="pay-btn">Kiểm tra lại</a>
                        <a href="${ctx}/cart" class="pay-btn pay-btn--ghost">Về giỏ hàng</a>
                    </c:when>
                    <c:when test="${variant == 'failed'}">
                        <a href="${ctx}/payment/momo" class="pay-btn">Thử thanh toán lại</a>
                        <a href="${ctx}/cart" class="pay-btn pay-btn--ghost">Về giỏ hàng</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${ctx}/" class="pay-btn">Tiếp tục mua sắm</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>
</main>
</body>
</html>
