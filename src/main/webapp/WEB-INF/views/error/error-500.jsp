<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="ctx" value="${pageContext.request.contextPath}" />
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>500 — Lỗi hệ thống</title>

            <!-- Google Fonts -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&display=swap"
                rel="stylesheet">

            <link rel="stylesheet" href="${ctx}/assets/css/common.css">
            <link rel="stylesheet" href="${ctx}/assets/css/error.css">
        </head>

        <body>
            <div class="error-page">
                <div class="error-card">
                    <div class="error-badge">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="3" width="20" height="8" rx="2" ry="2" />
                            <rect x="2" y="13" width="20" height="8" rx="2" ry="2" />
                            <line x1="6" y1="7" x2="6.01" y2="7" />
                            <line x1="6" y1="17" x2="6.01" y2="17" />
                        </svg>
                    </div>
                    <div class="error-code">500</div>
                    <h1 class="error-title">
                        <c:choose>
                            <c:when test="${not empty errorTitle}">
                                <c:out value="${errorTitle}" />
                            </c:when>
                            <c:otherwise>
                                Lỗi hệ thống
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="error-desc">
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                <c:out value="${errorMessage}" />
                            </c:when>
                            <c:otherwise>
                                Máy chủ gặp sự cố khi xử lý yêu cầu của bạn. Vui lòng thử lại sau ít phút.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="error-actions">
                        <button type="button" class="btn-primary" onclick="history.back()">Quay lại</button>
                        <a href="${ctx}/" class="btn-outline">Về trang chủ</a>
                    </div>
                </div>
            </div>
        </body>

        </html>