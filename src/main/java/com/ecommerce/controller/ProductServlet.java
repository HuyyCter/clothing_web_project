package com.ecommerce.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.ecommerce.model.Product;
import com.ecommerce.model.WishlistItem;
import com.ecommerce.repository.ProductDB;
import com.ecommerce.repository.WishlistDB;
import com.ecommerce.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final int PAGE_SIZE = 8;
    private static final String PRODUCT_VIEW = "/WEB-INF/views/product/product.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            // =========================
            // SEARCH
            // =========================
            String search = request.getParameter("search");

            // =========================
            // FILTER CATEGORY
            // =========================
            Integer categoryId = null;
            String categoryParam = request.getParameter("categoryId");

            if (categoryParam != null && !categoryParam.isBlank()) {
                categoryId = Integer.parseInt(categoryParam);
            }

            // =========================
            // SORT
            // =========================
            String sort = request.getParameter("sort");

            // =========================
            // PAGINATION
            // =========================
            int page = 1;
            String pageParam = request.getParameter("page");

            if (pageParam != null && !pageParam.isBlank()) {
                page = Integer.parseInt(pageParam);
            }

            if (page < 1) {
                page = 1;
            }

            // =========================
            // GET PRODUCTS
            // =========================
            List<Product> products = ProductDB.findPage(em, search, categoryId, sort, page, PAGE_SIZE);

            // =========================
            // COUNT
            // =========================
            long totalProducts = ProductDB.count(em, search, categoryId);
            int totalPages = (int)Math.ceil((double)totalProducts / PAGE_SIZE);

            // Nếu page vượt quá số trang
            if (totalPages > 0 && page > totalPages) {
                page = totalPages;
                products = ProductDB.findPage(em, search, categoryId, sort, page, PAGE_SIZE);
            }

            // =========================
            // GET MINIMUM VARIANT PRICES
            // =========================
            Map<Integer, BigDecimal> minVariantPrices = ProductDB.findMinVariantPrices(em, products);
            Map<Integer, String> firstImageUrls = ProductDB.findFirstImageUrls(em, products);

            // =========================
            // GET WISHLIST
            // =========================
            HttpSession session = request.getSession(false);
            Integer userId = null;

            if (session != null) {
                Object sessionUserId = session.getAttribute("userId");

                if (sessionUserId instanceof Integer) {
                    userId = (Integer)sessionUserId;
                }
            }

            Set<Integer> favoriteProductIds = new HashSet<>();

            // Tạm dùng user ID = 1 để đồng bộ với WishlistServlet
            // hiện đang dùng cho mục đích test local.
            if (userId == null) {
                userId = 1;
            }

            List<WishlistItem> wishlistItems = WishlistDB.findByUserId(em, userId);

            for (WishlistItem item : wishlistItems) {
                favoriteProductIds.add(item.getProduct().getId());
            }

            // =========================
            // SEND DATA TO JSP
            // =========================
            request.setAttribute("favoriteProductIds", favoriteProductIds);
            request.setAttribute("products", products);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("search", search);
            request.setAttribute("categoryId", categoryId);
            request.setAttribute("sort", sort);
            request.setAttribute("minVariantPrices", minVariantPrices);
            request.setAttribute("firstImageUrls", firstImageUrls);

            // =========================
            // FORWARD
            // =========================
            request.getRequestDispatcher(PRODUCT_VIEW).forward(request, response);
        } finally {
            em.close();
        }
    }
}
