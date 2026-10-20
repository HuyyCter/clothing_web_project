package com.ecommerce.controller;

import com.ecommerce.dto.CartDTO;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.exception.NotFoundException;
import com.ecommerce.exception.UnauthorizedException;
import com.ecommerce.model.Cart;
import com.ecommerce.validator.CartValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = getRequiredUserId(request);
        CartDTO cart = Cart.getCart(userId);
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Long userId = getRequiredUserId(request);
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "view";
        }

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));

        try {
            switch (action) {
                case "add":
                    handleAdd(request, response, userId, isAjax);
                    break;
                case "update":
                    handleUpdate(request, response, userId, isAjax);
                    break;
                case "remove":
                    handleRemove(request, response, userId, isAjax);
                    break;
                case "clear":
                    handleClear(request, response, userId, isAjax);
                    break;
                case "applyVoucher":
                    handleApplyVoucher(request, response, userId, isAjax);
                    break;
                case "removeVoucher":
                    handleRemoveVoucher(request, response, userId, isAjax);
                    break;
                default:
                    renderCart(request, response, userId, null, null);
                    break;
            }
        } catch (BusinessException | NotFoundException e) {
            if (isAjax) {
                // Nhường cho GlobalExceptionFilter định dạng RFC 7807 Problem Detail JSON
                throw e;
            } else {
                // Request form thông thường: forward lại cart.jsp kèm thông báo lỗi
                renderCart(request, response, userId, null, e.getMessage());
            }
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, Long userId, boolean isAjax)
            throws ServletException, IOException {
        String variantIdStr = request.getParameter("variantId");
        String quantityStr = request.getParameter("quantity");

        Long variantId = parseLong(variantIdStr);
        String errVariant = CartValidator.validateVariantId(variantId);
        if (errVariant != null) {
            respondValidationError(request, response, userId, isAjax, errVariant);
            return;
        }

        Integer quantity = parseInteger(quantityStr);
        if (quantity == null) {
            quantity = 1;
        }
        String errQty = CartValidator.validateQuantity(quantity);
        if (errQty != null) {
            respondValidationError(request, response, userId, isAjax, errQty);
            return;
        }

        CartDTO updatedCart = Cart.addItem(userId, variantId, quantity);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"totalQuantity\":" + updatedCart.getTotalQuantity() + ",\"totalAmount\":" + updatedCart.getTotalAmount() + "}");
        } else {
            renderCart(request, response, userId, "Đã thêm sản phẩm vào giỏ hàng thành công!", null);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Long userId, boolean isAjax)
            throws ServletException, IOException {
        String itemIdStr = request.getParameter("itemId");
        String quantityStr = request.getParameter("quantity");

        Long itemId = parseLong(itemIdStr);
        if (itemId == null || itemId <= 0) {
            respondValidationError(request, response, userId, isAjax, "Mã sản phẩm trong giỏ hàng không hợp lệ.");
            return;
        }

        Integer quantity = parseInteger(quantityStr);
        String errQty = CartValidator.validateQuantity(quantity);
        if (errQty != null) {
            respondValidationError(request, response, userId, isAjax, errQty);
            return;
        }

        CartDTO updatedCart = Cart.updateQuantity(userId, itemId, quantity);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"totalQuantity\":" + updatedCart.getTotalQuantity() + ",\"subtotal\":" + updatedCart.getSubtotal() + ",\"discountAmount\":" + updatedCart.getDiscountAmount() + ",\"totalAmount\":" + updatedCart.getTotalAmount() + "}");
        } else {
            renderCart(request, response, userId, "Đã cập nhật số lượng thành công!", null);
        }
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response, Long userId, boolean isAjax)
            throws ServletException, IOException {
        String itemIdStr = request.getParameter("itemId");
        Long itemId = parseLong(itemIdStr);
        if (itemId == null || itemId <= 0) {
            respondValidationError(request, response, userId, isAjax, "Mã sản phẩm cần xóa không hợp lệ.");
            return;
        }

        CartDTO updatedCart = Cart.removeItem(userId, itemId);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"totalQuantity\":" + updatedCart.getTotalQuantity() + ",\"totalAmount\":" + updatedCart.getTotalAmount() + "}");
        } else {
            renderCart(request, response, userId, "Đã xóa sản phẩm khỏi giỏ hàng!", null);
        }
    }

    private void handleClear(HttpServletRequest request, HttpServletResponse response, Long userId, boolean isAjax)
            throws ServletException, IOException {
        Cart.clearCart(userId);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"totalQuantity\":0,\"totalAmount\":0}");
        } else {
            renderCart(request, response, userId, "Đã làm trống giỏ hàng thành công!", null);
        }
    }

    private void handleApplyVoucher(HttpServletRequest request, HttpServletResponse response, Long userId, boolean isAjax)
            throws ServletException, IOException {
        String voucherCode = request.getParameter("voucherCode");
        String errVoucher = CartValidator.validateVoucherCode(voucherCode);
        if (errVoucher != null) {
            respondValidationError(request, response, userId, isAjax, errVoucher);
            return;
        }

        CartDTO updatedCart = Cart.applyVoucher(userId, voucherCode);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"discountAmount\":" + updatedCart.getDiscountAmount() + ",\"totalAmount\":" + updatedCart.getTotalAmount() + "}");
        } else {
            renderCart(request, response, userId, "Áp dụng mã voucher '" + updatedCart.getVoucherCode() + "' thành công!", null);
        }
    }

    private void handleRemoveVoucher(HttpServletRequest request, HttpServletResponse response, Long userId, boolean isAjax)
            throws ServletException, IOException {
        CartDTO updatedCart = Cart.removeVoucher(userId);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"discountAmount\":0,\"totalAmount\":" + updatedCart.getTotalAmount() + "}");
        } else {
            renderCart(request, response, userId, "Đã gỡ mã voucher khỏi giỏ hàng!", null);
        }
    }

    private void respondValidationError(HttpServletRequest request, HttpServletResponse response, Long userId, boolean isAjax, String errorMsg)
            throws ServletException, IOException {
        if (isAjax) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/problem+json;charset=UTF-8");
            response.getWriter().write("{\"type\":\"about:blank\",\"title\":\"Validation Error\",\"status\":400,\"detail\":\"" + escapeJson(errorMsg) + "\"}");
        } else {
            renderCart(request, response, userId, null, errorMsg);
        }
    }

    private void renderCart(HttpServletRequest request, HttpServletResponse response, Long userId, String successMessage, String formError)
            throws ServletException, IOException {
        CartDTO cart = Cart.getCart(userId);
        request.setAttribute("cart", cart);
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
        }
        if (formError != null) {
            request.setAttribute("formError", formError);
        }
        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(request, response);
    }

    private Long getRequiredUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            throw new UnauthorizedException("Vui lòng đăng nhập để sử dụng tính năng giỏ hàng.");
        }
        Object uidObj = session.getAttribute("userId");
        if (uidObj instanceof Number) {
            return ((Number) uidObj).longValue();
        }
        throw new UnauthorizedException("Vui lòng đăng nhập để sử dụng tính năng giỏ hàng.");
    }

    private Long parseLong(String val) {
        if (val == null || val.trim().isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseInteger(String val) {
        if (val == null || val.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
