package com.ecommerce.controller;

import com.ecommerce.model.Product;
import com.ecommerce.model.WishlistItem;
import com.ecommerce.repository.WishlistRepository;
import jakarta.servlet.http.HttpSession;
import java.util.Set;
import java.util.HashSet;
import com.ecommerce.repository.ProductRepository;
import com.ecommerce.util.JpaUtil;

import jakarta.persistence.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.math.BigDecimal;
import java.util.Map;
@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private static final int PAGE_SIZE = 8;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        EntityManager entityManager =
                JpaUtil.getEntityManager();

        try {

            ProductRepository productRepository =
                    new ProductRepository();

            // =========================
            // SEARCH
            // =========================

            String search =
                    request.getParameter("search");


            // =========================
            // FILTER CATEGORY
            // =========================

            Integer categoryId = null;

            String categoryParam =
                    request.getParameter("categoryId");

            if (categoryParam != null
                    && !categoryParam.isBlank()) {

                categoryId =
                        Integer.parseInt(categoryParam);
            }


            // =========================
            // SORT
            // =========================

            String sort =
                    request.getParameter("sort");

            
            // =========================
            // PAGINATION
            // =========================

            int page = 1;

            String pageParam =
                    request.getParameter("page");

            if (pageParam != null
                    && !pageParam.isBlank()) {

                page = Integer.parseInt(pageParam);
            }

            if (page < 1) {
                page = 1;
            }


            // =========================
            // GET PRODUCTS
            // =========================

            List<Product> products =
                    productRepository.findPage(
                            entityManager,
                            search,
                            categoryId,
                            sort,
                            page,
                            PAGE_SIZE
                    );


            // =========================
            // COUNT
            // =========================

            long totalProducts =
                    productRepository.count(
                            entityManager,
                            search,
                            categoryId
                    );


            int totalPages =
                    (int) Math.ceil(
                            (double) totalProducts
                                    / PAGE_SIZE
                    );


            // Nếu page vượt quá số trang
            if (totalPages > 0 && page > totalPages) {
                page = totalPages;

                products =
                        productRepository.findPage(
                                entityManager,
                                search,
                                categoryId,
                                sort,
                                page,
                                PAGE_SIZE
                        );
            }
            // =========================
            // GET MINIMUM VARIANT PRICES
            // =========================

            Map<Integer, BigDecimal> minVariantPrices =
                    productRepository.findMinVariantPrices(
                            entityManager,
                            products
                    );
	         // =========================
	         // GET WISHLIST
	         // =========================
	
	         HttpSession session = request.getSession(false);
	
	         Integer userId = null;
	
	         if (session != null) {
	             Object sessionUserId = session.getAttribute("userId");
	
	             if (sessionUserId instanceof Integer) {
	                 userId = (Integer) sessionUserId;
	             }
	         }
	
	         Set<Integer> favoriteProductIds = new HashSet<>();
	
	         // Tạm dùng user ID = 1 để đồng bộ với WishlistServlet
	         // hiện đang dùng cho mục đích test local.
	         if (userId == null) {
	             userId = 1;
	         }
	
	         WishlistRepository wishlistRepository =
	                 new WishlistRepository();
	
	         List<WishlistItem> wishlistItems =
	                 wishlistRepository.findByUserId(
	                         entityManager,
	                         userId
	                 );
	
	         for (WishlistItem item : wishlistItems) {
	             favoriteProductIds.add(item.getProduct().getId());
	         }
	
	         request.setAttribute(
	                 "favoriteProductIds",
	                 favoriteProductIds
	         );
            // =========================
            // SEND DATA TO JSP
            // =========================

            request.setAttribute(
                    "products",
                    products
            );

            request.setAttribute(
                    "currentPage",
                    page
            );

            request.setAttribute(
                    "totalPages",
                    totalPages
            );

            request.setAttribute(
                    "totalProducts",
                    totalProducts
            );

            request.setAttribute(
                    "search",
                    search
            );

            request.setAttribute(
                    "categoryId",
                    categoryId
            );

            request.setAttribute(
                    "sort",
                    sort
            );

            request.setAttribute(
                    "minVariantPrices",
                    minVariantPrices
            );
            // =========================
            // FORWARD
            // =========================

            request.getRequestDispatcher(
                    "/WEB-INF/views/product/product.jsp"
            ).forward(request, response);

        } finally {

            entityManager.close();
        }
    }
}