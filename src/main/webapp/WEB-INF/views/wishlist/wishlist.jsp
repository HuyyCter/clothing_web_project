<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
	<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sản phẩm yêu thích</title>

            <style>
                * {
                    box-sizing: border-box;
                }

                body {
                    margin: 0;
                    font-family: Arial, sans-serif;
                    background: #f7f7f7;
                    color: #222;
                }

                .wishlist-container {
                    max-width: 1200px;
                    margin: 40px auto;
                    padding: 0 20px;
                }

                .wishlist-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 28px;
                    gap: 16px;
                }

                .wishlist-header h1 {
                    margin: 0;
                    font-size: 28px;
                }

                .wishlist-count {
                    color: #777;
                    font-size: 14px;
                    margin-top: 8px;
                }

                .back-link {
                    color: #222;
                    text-decoration: none;
                    border: 1px solid #ddd;
                    padding: 10px 16px;
                    border-radius: 6px;
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
                    background: white;
                    border-radius: 10px;
                    overflow: hidden;
                    border: 1px solid #eee;
                }

                .product-image {
                    height: 220px;
                    background: #eee;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    color: #888;
                }

                .product-info {
                    padding: 16px;
                }

                .product-name {
                    font-size: 17px;
                    margin: 0 0 10px;
                }

                .product-description {
                    color: #777;
                    font-size: 13px;
                    line-height: 1.5;
                    min-height: 38px;
                }

                .product-price {
                    font-weight: bold;
                    margin: 14px 0;
                }

                .card-actions {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }

                .btn {
                    display: block;
                    width: 100%;
                    padding: 11px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    text-align: center;
                    font-size: 14px;
                    text-decoration: none;
                }

                .btn-detail {
                    background: #222;
                    color: white;
                }

                .btn-remove {
                    background: white;
                    color: #c62828;
                    border: 1px solid #e0bcbc;
                }

                .btn:hover {
                    opacity: 0.85;
                }

                .empty-state {
                    background: white;
                    border-radius: 10px;
                    padding: 60px 20px;
                    text-align: center;
                }

                .empty-heart {
                    font-size: 48px;
                    color: #bbb;
                }

                .empty-state p {
                    color: #777;
                    margin: 12px 0 24px;
                }

                @media (max-width: 900px) {
                    .wishlist-grid {
                        grid-template-columns: repeat(2, minmax(0, 1fr));
                    }
                }

                @media (max-width: 500px) {
                    .wishlist-grid {
                        grid-template-columns: 1fr;
                    }

                    .wishlist-header h1 {
                        font-size: 22px;
                    }
                }
            </style>
        </head>

        <body>
            <main class="wishlist-container">

                <div class="wishlist-header">
                    <div>
                        <h1>♡ Sản phẩm yêu thích</h1>
                        <p class="wishlist-count">
                            Bạn có
                            <strong>
                                <c:out value="${wishlistItems.size()}" default="0" />
                            </strong>
                            sản phẩm yêu thích
                        </p>
                    </div>

                    <a class="back-link" href="${pageContext.request.contextPath}/products">
                        ← Tiếp tục mua sắm
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty wishlistItems}">
                        <section class="empty-state">
                            <div class="empty-heart">♡</div>
                            <h2>Wishlist đang trống</h2>
                            <p>Hãy thêm những sản phẩm bạn yêu thích để dễ dàng tìm lại sau này.</p>

                            <a class="btn btn-detail" style="max-width: 220px; margin: 0 auto;"
                                href="${pageContext.request.contextPath}/products">
                                Khám phá sản phẩm
                            </a>
                        </section>
                    </c:when>

                    <c:otherwise>
                        <section class="wishlist-grid">
                            <c:forEach var="item" items="${wishlistItems}">
                                <article class="wishlist-card">

                                    <div class="product-image">
                                        Ảnh sản phẩm
                                    </div>

                                    <div class="product-info">
                                        <h2 class="product-name">
                                            <c:out value="${item.product.name}" />
                                        </h2>

                                        <p class="product-description">
                                            <c:out value="${item.product.description}" />
                                        </p>

                                        <c:set var="priceRange"
										       value="${priceRanges[item.product.id]}" />
										
										<p class="product-price">
										    <c:choose>
										        <c:when test="${empty priceRange or empty priceRange[0]}">
										            Tạm hết hàng
										        </c:when>
										
										        <c:otherwise>
										            Từ
										            <fmt:formatNumber
										                value="${priceRange[0]}"
										                pattern="#,##0"
										                groupingUsed="true" /> ₫
										        </c:otherwise>
										    </c:choose>
										</p>

                                        <div class="card-actions">

                                            <form method="post" action="${pageContext.request.contextPath}/wishlist/toggle">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="productId" value="${item.product.id}">

                                                <button class="btn btn-remove" type="submit">
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
        </body>

        </html>