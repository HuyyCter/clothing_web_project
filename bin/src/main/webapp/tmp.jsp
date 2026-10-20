<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Fashion Shop — Thời trang tối giản</title>
        <meta name="description"
            content="Fashion Shop — Bộ sưu tập thời trang tối giản, chất lượng cao. Mua sắm dễ dàng với đa dạng size và màu sắc.">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Playfair+Display:wght@600;700&family=Geist+Mono:wght@400;500&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer.css">
    </head>

    <body>

        <!-- NAVBAR -->
        <header class="navbar">
            <div class="navbar__inner">
                <a href="/" class="navbar__logo">Fashion<span>.</span></a>

                <form class="navbar__search" action="/products" method="get">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                        stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8" />
                        <line x1="21" y1="21" x2="16.65" y2="16.65" />
                    </svg>
                    <input type="text" name="q" placeholder="Tìm kiếm sản phẩm..." value="">
                </form>

                <nav class="navbar__actions">
                    <a href="/clothing_web_project/wishlist/toggle" class="navbar__icon-btn" title="Wishlist">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round">
                            <path
                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                        </svg>
                    </a>
                    <a href="/cart" class="navbar__icon-btn" title="Giỏ hàng">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round">
                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                            <line x1="3" y1="6" x2="21" y2="6" />
                            <path d="M16 10a4 4 0 0 1-8 0" />
                        </svg>
                        <span class="navbar__cart-badge">2</span>
                    </a>
                    <div class="navbar__divider"></div>
                    <a href="/profile" class="navbar__user-link">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                            <circle cx="12" cy="7" r="4" />
                        </svg>
                        HuyCter
                    </a>
                </nav>
            </div>
        </header>

        <!-- CATEGORY NAV -->
        <nav class="cat-nav">
            <div class="cat-nav__inner">
                <a href="${pageContext.request.contextPath}/products" class="cat-nav__item cat-nav__item--active">Tất
                    cả</a>
                <a href="${pageContext.request.contextPath}/products?categoryId=1" class="cat-nav__item">Áo</a>
                <a href="${pageContext.request.contextPath}/products?categoryId=2" class="cat-nav__item">Quần</a>
                <a href="${pageContext.request.contextPath}/products?categoryId=3" class="cat-nav__item">Áo khoác</a>
                <a href="${pageContext.request.contextPath}/products?categoryId=4" class="cat-nav__item">Phụ kiện</a>
            </div>
        </nav>

        <!-- HERO -->
        <section class="hero">
            <div class="hero__inner">
                <div class="hero__text">
                    <p class="hero__eyebrow">Bộ sưu tập mới — Thu Đông 2026</p>
                    <h1 class="hero__title">Tối giản.<br>Bền vững.<br>Đẳng cấp.</h1>
                    <p class="hero__desc">Thời trang không cần phức tạp. Chúng tôi tin rằng cái đẹp thực sự đến từ sự
                        đơn giản — chất liệu tốt, đường may chuẩn, và thiết kế vượt thời gian.</p>
                    <div class="hero__actions">
                        <a href="/products" class="hero__btn-primary">
                            Khám phá ngay
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="5" y1="12" x2="19" y2="12" />
                                <polyline points="12 5 19 12 12 19" />
                            </svg>
                        </a>
                        <a href="/products?sort=newest" class="hero__btn-secondary">Hàng mới về</a>
                    </div>
                </div>
                <div class="hero__image-wrap">
                    <img src="/assets/img/hero-placeholder.jpg" alt="Bộ sưu tập mới">
                </div>
            </div>
        </section>

        <!-- FEATURED PRODUCTS -->
        <section class="section">
            <div class="section__inner">
                <div class="section__head">
                    <h2 class="section__title">Sản phẩm nổi bật</h2>
                    <a href="${pageContext.request.contextPath}/products" class="section__link">Xem tất cả →</a>
                </div>
                <div class="product-grid">
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/1">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=1" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Áo thun</span>
                            <a class="product-card__name" href="/products/1">Áo thun cotton basic</a>
                            <div class="product-card__price">249.000đ</div>
                            <a href="/products/1" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/2">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=2" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Áo sơ mi</span>
                            <a class="product-card__name" href="/products/2">Áo sơ mi Oxford tay dài</a>
                            <div class="product-card__price">459.000đ</div>
                            <a href="/products/2" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/3">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=3" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Quần</span>
                            <a class="product-card__name" href="/products/3">Quần chinos slim fit</a>
                            <div class="product-card__price">529.000đ</div>
                            <a href="/products/3" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/4">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=4" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Áo khoác</span>
                            <a class="product-card__name" href="/products/4">Áo khoác bomber tối giản</a>
                            <div class="product-card__price">790.000đ</div>
                            <a href="/products/4" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <!-- CATEGORY STRIP -->
        <section class="section"
            style="padding-top:0;background-color:var(--bg-base);border-top:1px solid var(--border-default);">
            <div class="section__inner" style="padding-top:48px;">
                <div class="section__head">
                    <h2 class="section__title">Khám phá danh mục</h2>
                </div>
                <div class="cat-strip">
                    <a href="/products?categoryId=1" class="cat-strip__card">
                        <div>
                            <div class="cat-strip__label">Áo</div>
                            <div class="cat-strip__count">24 sản phẩm</div>
                        </div>
                        <div class="cat-strip__arrow">
                            Xem ngay
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" stroke-linejoin="round">
                                <line x1="5" y1="12" x2="19" y2="12" />
                                <polyline points="12 5 19 12 12 19" />
                            </svg>
                        </div>
                    </a>
                    <a href="/products?categoryId=2" class="cat-strip__card">
                        <div>
                            <div class="cat-strip__label">Quần</div>
                            <div class="cat-strip__count">16 sản phẩm</div>
                        </div>
                        <div class="cat-strip__arrow">
                            Xem ngay
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" stroke-linejoin="round">
                                <line x1="5" y1="12" x2="19" y2="12" />
                                <polyline points="12 5 19 12 12 19" />
                            </svg>
                        </div>
                    </a>
                    <a href="/products?categoryId=3" class="cat-strip__card">
                        <div>
                            <div class="cat-strip__label">Áo khoác</div>
                            <div class="cat-strip__count">9 sản phẩm</div>
                        </div>
                        <div class="cat-strip__arrow">
                            Xem ngay
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                stroke-linecap="round" stroke-linejoin="round">
                                <line x1="5" y1="12" x2="19" y2="12" />
                                <polyline points="12 5 19 12 12 19" />
                            </svg>
                        </div>
                    </a>
                </div>
            </div>
        </section>

        <!-- NEW ARRIVALS -->
        <section class="section">
            <div class="section__inner">
                <div class="section__head">
                    <h2 class="section__title">Hàng mới về</h2>
                    <a href="/products?sort=newest" class="section__link">Xem tất cả →</a>
                </div>
                <div class="product-grid">
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/5">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=5" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Áo len</span>
                            <a class="product-card__name" href="/products/5">Áo len cổ tròn</a>
                            <div class="product-card__price">599.000đ</div>
                            <a href="/products/5" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/6">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=6" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Quần</span>
                            <a class="product-card__name" href="/products/6">Quần jeans ống đứng</a>
                            <div class="product-card__price">649.000đ</div>
                            <a href="/products/6" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/7">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=7" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Phụ kiện</span>
                            <a class="product-card__name" href="/products/7">Mũ lưỡi trai cotton</a>
                            <div class="product-card__price">199.000đ</div>
                            <a href="/products/7" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                    <article class="product-card">
                        <div class="product-card__img-wrap">
                            <a href="/products/8">
                                <div
                                    style="width:100%;height:100%;background:var(--bg-base);display:flex;align-items:center;justify-content:center;">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--border-default)" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" />
                                        <circle cx="8.5" cy="8.5" r="1.5" />
                                        <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                </div>
                            </a>
                            <a href="/wishlist/toggle?productId=8" class="product-card__wishlist">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </a>
                        </div>
                        <div class="product-card__body">
                            <span class="product-card__cat">Áo khoác</span>
                            <a class="product-card__name" href="/products/8">Áo khoác gió nhẹ</a>
                            <div class="product-card__price">690.000đ</div>
                            <a href="/products/8" class="product-card__add-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Thêm vào giỏ
                            </a>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer class="footer">
            <div class="footer__inner">
                <div>
                    <div class="footer__brand-name">Fashion.</div>
                    <p class="footer__brand-desc">Thời trang tối giản, bền vững — dành cho những ai trân trọng sự đơn
                        giản và chất lượng.</p>
                </div>
                <div>
                    <div class="footer__col-title">Sản phẩm</div>
                    <div class="footer__links">
                        <a href="/products" class="footer__link">Tất cả sản phẩm</a>
                        <a href="/products?sort=newest" class="footer__link">Hàng mới về</a>
                        <a href="/products?sort=bestseller" class="footer__link">Bán chạy nhất</a>
                    </div>
                </div>
                <div>
                    <div class="footer__col-title">Tài khoản</div>
                    <div class="footer__links">
                        <a href="/login" class="footer__link">Đăng nhập</a>
                        <a href="/register" class="footer__link">Đăng ký</a>
                        <a href="/orders" class="footer__link">Đơn hàng của tôi</a>
                        <a href="/profile" class="footer__link">Hồ sơ</a>
                    </div>
                </div>
                <div>
                    <div class="footer__col-title">Hỗ trợ</div>
                    <div class="footer__links">
                        <a href="#" class="footer__link">Chính sách đổi trả</a>
                        <a href="#" class="footer__link">Hướng dẫn chọn size</a>
                        <a href="#" class="footer__link">Liên hệ</a>
                    </div>
                </div>
            </div>
            <div class="footer__bottom">© 2026 Fashion Shop. All rights reserved.</div>
        </footer>

    </body>

    </html>