<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">
		<c:set var="isLoggedIn"
       		value="${not empty sessionScope.userId}" />
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sản phẩm</title>

            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 40px;
                    background: #f8f9fa;
                }

                h1 {
                    margin-bottom: 30px;
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
                    width: 300px;
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

                /* PRODUCT CARD */
                .product-card {
                    position: relative;
                    min-width: 0;
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
                    transition: color 0.2s, background 0.2s, transform 0.2s;
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
                    opacity: 0.6;
                    cursor: wait;
                }

                .product-image {
                    height: 300px;
                    background: #f3f3f3;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #aaa;
                }

                .product-image img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .product-info {
                    padding: 18px;
                }

                .product-name {
                    font-size: 18px;
                    margin-bottom: 10px;
                }

                .product-description {
                    color: #666;
                    margin-bottom: 15px;
                }

                .product-price {
                    margin-bottom: 15px;
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

                @media (max-width: 1000px) {
                    .product-grid {
                        grid-template-columns: repeat(2, minmax(0, 1fr));
                    }
                }

                @media (max-width: 600px) {
                    body {
                        margin: 20px;
                    }

                    .product-grid {
                        grid-template-columns: 1fr;
                    }

                    .toolbar input {
                        width: 100%;
                    }
                }
				/* PRODUCT VARIANT MODAL */
				.variant-modal {
				    display: none;
				    position: fixed;
				    inset: 0;
				    z-index: 9999;
				    background: rgba(0, 0, 0, 0.55);
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
				    padding: 28px;
				    border-radius: 12px;
				    box-sizing: border-box;
				    box-shadow: 0 10px 35px rgba(0, 0, 0, 0.2);
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
				    box-sizing: border-box;
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
				    opacity: 0.6;
				    cursor: wait;
				}
				
				.variant-message {
				    margin-top: 12px;
				    color: #c62828;
				    font-size: 14px;
				}
				.product-image {
				    width: 100%;
				    height: 260px;
				    overflow: hidden;
				    background: #f5f5f5;
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
                .variant-preview {
				    width: 100%;
				    height: 260px;
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
            </style>
        </head>

        <body>

            <h1>Tất cả sản phẩm</h1>

            <!-- SEARCH / FILTER / SORT -->
            <form method="get" action="${pageContext.request.contextPath}/products" class="toolbar">

                <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..."
                    value="<c:out value='${search}'/>" />

                <select name="categoryId">
                    <option value="">Tất cả danh mục</option>

                    <option value="1" <c:if test="${categoryId != null && categoryId == 1}">selected</c:if>>
                        Áo
                    </option>

                    <option value="2" <c:if test="${categoryId != null && categoryId == 2}">selected</c:if>>
                        Quần
                    </option>

                    <option value="3" <c:if test="${categoryId != null && categoryId == 3}">selected</c:if>>
                        Áo khoác
                    </option>

                    <option value="4" <c:if test="${categoryId != null && categoryId == 4}">selected</c:if>>
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
						    <c:set var="imageUrl"
						           value="${firstImageUrls[product.id]}" />
						
						    <c:choose>
						        <c:when test="${not empty imageUrl}">
						            <img src="${pageContext.request.contextPath}<c:out value='${imageUrl}'/>"
									     alt="<c:out value='${product.name}'/>"
									     loading="lazy">
						        </c:when>
						
						        <c:otherwise>
						            <div class="no-image">
						                Chưa có ảnh sản phẩm
						            </div>
						        </c:otherwise>
						    </c:choose>
						</div>

                        <!-- WISHLIST -->
                        <form method="post" action="${pageContext.request.contextPath}/wishlist/toggle"
                            class="wishlist-form" data-wishlist-form>

                            <input type="hidden" name="action"
                                value="${favoriteProductIds.contains(product.id) ? 'remove' : 'add'}">
                            <input type="hidden" name="productId" value="${product.id}">

                            <button type="submit"
                                class="wishlist-button ${favoriteProductIds.contains(product.id) ? 'is-favorite' : ''}"
                                aria-pressed="${favoriteProductIds.contains(product.id)}">
                                ${favoriteProductIds.contains(product.id) ? '♥' : '♡'}
                            </button>
                        </form>

                        <!-- PRODUCT INFO -->
                        <div class="product-info">

                            <h3 class="product-name">
                                <c:out value="${product.name}" />
                            </h3>

                            <p class="product-description">
                                <c:out value="${product.description}" />
                            </p>

                            <p class="product-price">
                                <c:choose>
                                    <c:when test="${minVariantPrices[product.id] != null}">
                                        Từ
                                        <c:out value="${minVariantPrices[product.id]}" /> VNĐ
                                    </c:when>

                                    <c:otherwise>
                                        <c:out value="${product.price}" /> VNĐ
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <button
							    type="button"
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
                                <c:param name="page" value="${currentPage - 1}" />
                                <c:param name="search" value="${search}" />
                                <c:param name="categoryId" value="${categoryId}" />
                                <c:param name="sort" value="${sort}" />
                            </c:url>

                            <a href="${pageContext.request.contextPath}${previousUrl}">
                                ← Trang trước
                            </a>
                        </c:when>

                        <c:otherwise>
                            <span class="disabled">← Trang trước</span>
                        </c:otherwise>
                    </c:choose>

                    <!-- PAGE NUMBER -->
                    <span class="current">
                        Trang
                        <c:out value="${currentPage}" />
                        /
                        <c:out value="${totalPages}" />
                    </span>

                    <!-- NEXT -->
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <c:url var="nextUrl" value="/products">
                                <c:param name="page" value="${currentPage + 1}" />
                                <c:param name="search" value="${search}" />
                                <c:param name="categoryId" value="${categoryId}" />
                                <c:param name="sort" value="${sort}" />
                            </c:url>

                            <a href="${pageContext.request.contextPath}${nextUrl}">
                                Trang sau →
                            </a>
                        </c:when>

                        <c:otherwise>
                            <span class="disabled">Trang sau →</span>
                        </c:otherwise>
                    </c:choose>

                </div>

            </c:if>
			
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
					    <img id="variantImage"
			     alt="Ảnh sản phẩm"
			     style="display: none;">
					
					    <p id="variantImagePlaceholder">
					        Chọn màu sắc để xem ảnh
					    </p>
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
			            <input type="number" id="variantQuantity"
			                   min="1" value="1">
			        </div>
			
			        <button type="button" class="variant-submit" id="variantAddButton">
			            Xác nhận thêm vào giỏ
			        </button>
			
			        <p id="variantMessage" class="variant-message"
			           role="status"></p>
			    </div>
			</div>
			<script>
			(() => {
			    const contextPath = '${pageContext.request.contextPath}';
			
			    const modal = document.getElementById('variantModal');
			    const sizeSelect = document.getElementById('variantSize');
			    const colorSelect = document.getElementById('variantColor');
			    const priceElement = document.getElementById('variantPrice');
			    const variantImage = document.getElementById('variantImage');
			    const imagePlaceholder =
			        document.getElementById('variantImagePlaceholder');
			    const messageElement = document.getElementById('variantMessage');
			    const quantityInput = document.getElementById('variantQuantity');
			    const addButton = document.getElementById('variantAddButton');
			
			    let variants = [];
			    let selectedProductId = null;
			    let selectedProductName = '';
			    let loadingVariants = false;
			    let addingToCart = false;
			
			    function closeModal() {
			        if (loadingVariants || addingToCart) return;
			
			        modal.classList.remove('is-open');
			        modal.setAttribute('aria-hidden', 'true');
			    }
			
			    function showMessage(message) {
			        messageElement.textContent = message;
			    }
			
			    function formatPrice(price) {
			        return Number(price).toLocaleString('vi-VN') + ' VNĐ';
			    }
			
			    function getAvailableColors(size) {
			        return [...new Set(
			            variants
			                .filter(v => v.size === size)
			                .map(v => v.color)
			        )].sort();
			    }
			
			    function updatePrice() {
			        const variant = variants.find(v =>
			            v.size === sizeSelect.value &&
			            v.color === colorSelect.value
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

			        // Cập nhật giá theo biến thể đã chọn.
			        priceElement.textContent = 'Giá: ' + formatPrice(variant.price);

			        // Cập nhật ảnh theo màu sắc.
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

			            const imageUrl = variant.imageUrl;

			            if (imageUrl.startsWith('http://') ||
			                imageUrl.startsWith('https://')) {
			                variantImage.src = imageUrl;
			            } else {
			                variantImage.src = contextPath + imageUrl;
			            }
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
			
			        colorSelect.replaceChildren(
			            new Option('Chọn màu sắc', '')
			        );
			
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
			
			        selectedProductName =
			            card?.querySelector('.product-name')?.textContent.trim() || '';
			
			        document.getElementById('variantProductName').textContent =
			            selectedProductName;
			
			        variants = [];
			        sizeSelect.replaceChildren(new Option('Đang tải...', ''));
			        colorSelect.replaceChildren(new Option('Chọn màu sắc', ''));
			        colorSelect.disabled = true;
			        quantityInput.value = '1';
			        priceElement.textContent = 'Giá: --';
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
			
			            // Gộp các bản ghi có cùng size và màu.
			            // Giữ lại một variantId còn AVAILABLE để thêm vào giỏ.
			            const grouped = new Map();
			
			            data.forEach(variant => {
			                const key = JSON.stringify([
			                    variant.size,
			                    variant.color
			                ]);
			
			                if (!grouped.has(key)) {
			                    grouped.set(key, variant);
			                }
			            });
			
			            variants = [...grouped.values()].filter(v =>
			                v.id != null && v.price != null
			            );
			
			            if (variants.length === 0) {
			                sizeSelect.replaceChildren(
			                    new Option('Hết hàng', '')
			                );
			                showMessage('Sản phẩm hiện không có biến thể còn hàng.');
			                return;
			            }
			
			            const sizes = [...new Set(variants.map(v => v.size))].sort();
			
			            sizeSelect.replaceChildren(
			                new Option('Chọn size', '')
			            );
			
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
			
			    const isLoggedIn = '${isLoggedIn}' === 'true';
			    const loginUrl = '${pageContext.request.contextPath}/login';

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
			            v.size === sizeSelect.value &&
			            v.color === colorSelect.value
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
			                    'Content-Type':
			                        'application/x-www-form-urlencoded;charset=UTF-8'
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
			})();
			
			</script>
			
			<script>
			    const isLoggedIn = ${isLoggedIn};
			    const loginUrl = '${pageContext.request.contextPath}/login';
			</script>
            <!-- WISHLIST JAVASCRIPT -->
            <script>

                document.querySelectorAll("[data-wishlist-form]").forEach(form => {
                    const button = form.querySelector(".wishlist-button");
                    const actionInput = form.querySelector('[name="action"]');
                    const productIdInput = form.querySelector('[name="productId"]');
					
                    form.addEventListener("submit", async event => {
                        event.preventDefault();

                        if (!isLoggedIn) {
                            window.location.href = loginUrl;
                            return;
                        }

                        if (button.disabled) return;

                        const wasFavorite = button.classList.contains("is-favorite");
                        actionInput.value = wasFavorite ? "remove" : "add";

                        const formData = new URLSearchParams({
                            action: actionInput.value,
                            productId: productIdInput.value
                        });

                        const wishlistUrl = form.getAttribute("action");

                        button.disabled = true;
                        console.log("URL:", wishlistUrl);
                        console.log("action:", actionInput.value);
                        console.log("productId:", productIdInput.value);
                        console.log("Payload:", formData.toString());
                       
                        try {
                            const response = await fetch(wishlistUrl, {
                                method: "POST",
                                body: formData,
                                headers: {
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Content-Type": "application/x-www-form-urlencoded"
                                }
                            });

                            if (!response.ok || response.redirected) {
                                throw new Error("HTTP " + response.status);
                            }

                            const isFavorite = !wasFavorite;

                            button.classList.toggle("is-favorite", isFavorite);
                            button.textContent = isFavorite ? "♥" : "♡";
                            button.setAttribute("aria-pressed", String(isFavorite));
                            button.setAttribute(
                                "aria-label",
                                isFavorite ? "Bỏ yêu thích" : "Thêm vào yêu thích"
                            );
                            button.title = isFavorite
                                ? "Bỏ yêu thích"
                                : "Thêm vào yêu thích";

                        } catch (error) {
                            console.error("Wishlist error:", error);
                            alert("Không thể cập nhật yêu thích. Vui lòng thử lại.");
                        } finally {
                            button.disabled = false;
                        }
                    });
                });

            </script>

        </body>

        </html>