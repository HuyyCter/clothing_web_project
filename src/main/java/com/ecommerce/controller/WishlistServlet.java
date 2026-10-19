package com.ecommerce.controller;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import com.ecommerce.repository.ProductVariantDB;

import com.ecommerce.model.WishlistItem;
import com.ecommerce.repository.WishlistDB;
import com.ecommerce.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist/toggle")
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    	HttpSession session = request.getSession(false);
    	Integer userId = getUserId(session);

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Phiên đăng nhập không hợp lệ.");
            return;
        }

        EntityManager entityManager = JpaUtil.getEntityManager().createEntityManager();

        try {
			
			List<WishlistItem> wishlistItems =
			        WishlistDB.findByUserId(entityManager, userId);
			
			Map<Integer, List<BigDecimal>> priceRanges = new HashMap<>();
			
			for (WishlistItem item : wishlistItems) {
			    int productId = item.getProduct().getId();

			    List<BigDecimal> priceRange =
			            ProductVariantDB.findAvailablePriceRangeByProductId(
			                    entityManager, productId);

			    priceRanges.put(productId, priceRange);

			    System.out.println(
			            "[WISHLIST PRICE] productId=" + productId
			            + ", priceRange=" + priceRange
			    );
			}

			System.out.println("[WISHLIST PRICE] priceRanges=" + priceRanges);

			request.setAttribute("wishlistItems", wishlistItems);
			request.setAttribute("priceRanges", priceRanges);
            request.getRequestDispatcher("/WEB-INF/views/wishlist/wishlist.jsp").forward(request, response);

        } finally {
            entityManager.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = getUserId(session);



        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Phiên đăng nhập không hợp lệ.");
            return;
        }

        String action = request.getParameter("action");
        String productIdParam = request.getParameter("productId");

        System.out.println("Wishlist action = " + action);
        System.out.println("Wishlist productId = " + productIdParam);
        System.out.println("Content-Type = " + request.getContentType());

        if (action == null || action.isBlank() || productIdParam == null || productIdParam.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số action hoặc productId.");
            return;
        }

        int productId;

        try {
            productId = Integer.parseInt(productIdParam);

            if (productId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ.");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ.");
            return;
        }

        EntityManager entityManager = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();

        try {
            transaction.begin();

            if ("add".equals(action)) {
                WishlistDB.add(entityManager, userId, productId);

            } else if ("remove".equals(action)) {
                WishlistDB.remove(entityManager, userId, productId);

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thao tác Wishlist không hợp lệ.");

                transaction.rollback();
                return;
            }

            transaction.commit();

            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/wishlist/toggle");

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }

            throw new ServletException("Không thể cập nhật Wishlist.", e);

        } finally {
            entityManager.close();
        }
        System.out.println("Session exists = " + (session != null));
        System.out.println("Session userId = "
                + (session != null ? session.getAttribute("userId") : null));
        System.out.println("Resolved userId = " + userId);
    }

    private Integer getUserId(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("userId");

        if (value instanceof Integer) {
            return (Integer) value;
        }

        if (value instanceof Long) {
            Long id = (Long) value;

            if (id > 0 && id <= Integer.MAX_VALUE) {
                return id.intValue();
            }
        }

        return null;
    }
    
}
