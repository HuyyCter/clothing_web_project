<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="ctx" value="${pageContext.request.contextPath}" />
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>400 — Yêu cầu không hợp lệ</title>

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
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                    </div>
                    <div class="error-code">400</div>
                    <h1 class="error-title">
                        <c:choose>
                            <c:when test="${not empty errorTitle}">
                                <c:out value="${errorTitle}" />
                            </c:when>
                            <c:otherwise>
                                Yêu cầu không hợp lệ
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="error-desc">
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                <c:out value="${errorMessage}" />
                            </c:when>
                            <c:otherwise>
                                Yêu cầu của bạn không thể thực hiện được. Vui lòng kiểm tra lại thao tác và thử lại.
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