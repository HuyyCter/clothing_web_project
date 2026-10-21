package com.ecommerce.controller;

import com.ecommerce.dto.CartDTO;
import com.ecommerce.dto.CheckoutRequestDTO;
import com.ecommerce.dto.OrderDTO;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.exception.NotFoundException;
import com.ecommerce.model.Cart;
import com.ecommerce.model.MomoTransaction;
import com.ecommerce.model.Order;
import com.ecommerce.validator.CheckoutValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Module E — Checkout (Nguyễn Phạm Thanh Tín).
 * <ul>
 *   <li>GET  /checkout — trang đặt hàng: tóm tắt giỏ, chọn địa chỉ, ghi chú, phương thức thanh toán</li>
 *   <li>POST /checkout — COD: tạo đơn ngay (Chờ xác nhận) rồi hiển thị trang đặt hàng thành công;
 *       MOMO: tạo giao dịch MoMo rồi redirect sang trang thanh toán của MoMo
 *       (đơn chỉ được tạo sau khi MoMo xác nhận — xem MomoTransaction / Order.createPaidOrder)</li>
 * </ul>
 * /checkout đã nằm trong AuthFilter nên luôn có userId trong session.
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String CHECKOUT_VIEW = "/WEB-INF/views/order/checkout.jsp";
    private static final String SUCCESS_VIEW = "/WEB-INF/views/order/order-success.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        renderCheckout(request, response, userId, null, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Integer userId = getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CheckoutRequestDTO form = readForm(request);
        String error = CheckoutValidator.validate(form);
        if (error != null) {
            renderCheckout(request, response, userId, form, error);
            return;
        }

        try {
            if ("MOMO".equals(form.getPaymentMethod())) {
                String payUrl = MomoTransaction.initiate(userId, form, baseUrl(request));
                // Redirect vì phải sang domain của MoMo — ngoại lệ được phép trong code-standards.md
                response.sendRedirect(payUrl);
                return;
            }
            OrderDTO order = Order.placeCodOrder(userId, form);
            request.setAttribute("order", order);
            request.getRequestDispatcher(SUCCESS_VIEW).forward(request, response);
        } catch (BusinessException | NotFoundException e) {
            renderCheckout(request, response, userId, form, e.getMessage());
        }
    }

    private void renderCheckout(HttpServletRequest request, HttpServletResponse response, int userId,
            CheckoutRequestDTO form, String formError) throws ServletException, IOException {
        CartDTO cart = Cart.getCart((long) userId);
        request.setAttribute("cart", cart);
        request.setAttribute("addresses", Order.getAddressOptions(userId));
        request.setAttribute("form", form != null ? form : new CheckoutRequestDTO());
        request.setAttribute("momoMinAmount", MomoTransaction.MIN_AMOUNT);
        request.setAttribute("momoMaxAmount", MomoTransaction.MAX_AMOUNT);
        if (formError != null) {
            request.setAttribute("formError", formError);
        }
        request.getRequestDispatcher(CHECKOUT_VIEW).forward(request, response);
    }

    private CheckoutRequestDTO readForm(HttpServletRequest request) {
        CheckoutRequestDTO dto = new CheckoutRequestDTO();
        String addressId = request.getParameter("addressId");
        if (addressId != null && !addressId.trim().isEmpty() && !"new".equals(addressId.trim())) {
            try {
                dto.setAddressId(Integer.parseInt(addressId.trim()));
            } catch (NumberFormatException e) {
                dto.setAddressId(-1); // validator sẽ báo lỗi
            }
        }
        dto.setRecipientName(request.getParameter("recipientName"));
        dto.setPhone(request.getParameter("phone"));
        dto.setShippingAddress(request.getParameter("shippingAddress"));
        dto.setNote(request.getParameter("note"));
        String method = request.getParameter("paymentMethod");
        dto.setPaymentMethod(method != null ? method.trim().toUpperCase() : null);
        return dto;
    }

    /** userId lấy từ session (LoginServlet lưu kiểu Integer) — không tin tham số request. */
    private Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object uid = session.getAttribute("userId");
        return (uid instanceof Number) ? ((Number) uid).intValue() : null;
    }

    /**
     * Địa chỉ gốc của website để MoMo gọi về: APP_BASE_URL nếu có (giống MailUtil), nếu không thì lấy từ header
     * mà Render/proxy gửi kèm (X-Forwarded-Proto, Host) — tránh lấy nhầm port nội bộ của container.
     */
    static String baseUrl(HttpServletRequest request) {
        String env = System.getenv("APP_BASE_URL");
        if (env != null && !env.isBlank()) {
            String trimmed = env.trim();
            return trimmed.endsWith("/") ? trimmed.substring(0, trimmed.length() - 1) : trimmed;
        }
        String proto = request.getHeader("X-Forwarded-Proto");
        if (proto == null || proto.isBlank()) {
            proto = request.getScheme();
        } else if (proto.contains(",")) {
            proto = proto.substring(0, proto.indexOf(',')).trim();
        }
        String host = request.getHeader("X-Forwarded-Host");
        if (host == null || host.isBlank()) {
            host = request.getHeader("Host");
        }
        if (host == null || host.isBlank()) {
            int port = request.getServerPort();
            host = request.getServerName() + ((port == 80 || port == 443) ? "" : ":" + port);
        }
        return proto + "://" + host + request.getContextPath();
    }
}
