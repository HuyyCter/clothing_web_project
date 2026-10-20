<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="ctx" value="${pageContext.request.contextPath}" />
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>404 — Không tìm thấy trang</title>

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
                            <circle cx="11" cy="11" r="8" />
                            <line x1="21" y1="21" x2="16.65" y2="16.65" />
                        </svg>
                    </div>
                    <div class="error-code">404</div>
                    <h1 class="error-title">
                        <c:choose>
                            <c:when test="${not empty errorTitle}">
                                <c:out value="${errorTitle}" />
                            </c:when>
                            <c:otherwise>
                                Không tìm thấy nội dung
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="error-desc">
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                <c:out value="${errorMessage}" />
                            </c:when>
                            <c:otherwise>
                                Trang hoặc dữ liệu bạn đang tìm không tồn tại, hoặc đã bị di chuyển.
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