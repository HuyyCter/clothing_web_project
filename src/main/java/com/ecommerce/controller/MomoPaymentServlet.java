package com.ecommerce.controller;

import com.ecommerce.dto.CartDTO;
import com.ecommerce.dto.MomoCheckoutRequestDTO;
import com.ecommerce.dto.MomoTransactionDTO;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.exception.NotFoundException;
import com.ecommerce.model.Cart;
import com.ecommerce.model.MomoTransaction;
import com.ecommerce.util.MomoUtil;
import com.ecommerce.validator.MomoValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet thanh toán MoMo.
 * <ul>
 *   <li>GET  /payment/momo         — trang xác nhận (giỏ hàng + chọn địa chỉ) trước khi sang MoMo</li>
 *   <li>POST /payment/momo         — tạo giao dịch, redirect trình duyệt sang payUrl của MoMo</li>
 *   <li>GET  /payment/momo/return  — MoMo đưa khách quay về (redirectUrl), hiển thị kết quả</li>
 *   <li>POST /payment/momo/ipn     — MoMo gọi server-to-server báo kết quả (ipnUrl), trả 204</li>
 * </ul>
 * Trang checkout của module Order có thể POST thẳng tới /payment/momo
 * (tham số: addressId hoặc recipientName/phone/shippingAddress, và note).
 */
@WebServlet(urlPatterns = {"/payment/momo", "/payment/momo/return", "/payment/momo/ipn"})
public class MomoPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOG = Logger.getLogger(MomoPaymentServlet.class.getName());

    private static final String CHECKOUT_VIEW = "/WEB-INF/views/payment/momo-checkout.jsp";
    private static final String RESULT_VIEW = "/WEB-INF/views/payment/momo-result.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/payment/momo/return".equals(path)) {
            handleReturn(request, response);
        } else if ("/payment/momo".equals(path)) {
            Integer userId = getUserId(request);
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            renderCheckout(request, response, userId, null, null);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        if ("/payment/momo/ipn".equals(path)) {
            handleIpn(request, response);
        } else if ("/payment/momo".equals(path)) {
            handleCreate(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    // ==========================================
    // HANDLERS
    // ==========================================

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        MomoCheckoutRequestDTO form = readForm(request);
        String error = MomoValidator.validateCheckout(form);
        if (error != null) {
            renderCheckout(request, response, userId, form, error);
            return;
        }

        try {
            String payUrl = MomoTransaction.initiate(userId, form);
            // Redirect (không forward) vì phải đổi sang domain của MoMo — đúng ngoại lệ trong code-standards.md
            response.sendRedirect(payUrl);
        } catch (BusinessException | NotFoundException e) {
            renderCheckout(request, response, userId, form, e.getMessage());
        }
    }

    private void handleReturn(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String> params = new LinkedHashMap<>();
        for (Map.Entry<String, String[]> e : request.getParameterMap().entrySet()) {
            params.put(e.getKey(), e.getValue().length > 0 ? e.getValue()[0] : "");
        }

        String momoOrderId = params.get("orderId");
        if (MomoValidator.validateMomoOrderId(momoOrderId) != null) {
            throw new BusinessException("Đường dẫn kết quả thanh toán không hợp lệ.");
        }

        // Tham số redirect có chữ ký → ghi nhận ngay (idempotent với IPN).
        // Nếu chữ ký sai/thiếu thì bỏ qua, getResult() sẽ tự hỏi lại MoMo.
        if (params.containsKey("signature")) {
            MomoTransaction.handleGatewayCallback(params);
        }

        Integer userId = getUserId(request);
        if (userId == null) {
            // Phiên đăng nhập hết hạn trong lúc thanh toán: kết quả đã được ghi nhận ở trên
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        MomoTransactionDTO result = MomoTransaction.getResult(userId, momoOrderId);
        request.setAttribute("tx", result);
        request.getRequestDispatcher(RESULT_VIEW).forward(request, response);
    }

    /**
     * IPN: luôn phải trả lời MoMo nhanh (trong 15s). 204 = đã nhận.
     * Không ném exception ra GlobalExceptionFilter vì MoMo không đọc được trang lỗi HTML.
     */
    private void handleIpn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String body = new String(request.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            Map<String, String> params = MomoUtil.parseJsonToStringMap(body);
            boolean accepted = MomoTransaction.handleGatewayCallback(params);
            response.setStatus(accepted ? HttpServletResponse.SC_NO_CONTENT : HttpServletResponse.SC_BAD_REQUEST);
        } catch (BusinessException e) {
            // Body không phải JSON hợp lệ → yêu cầu sai, không cần MoMo gửi lại
            LOG.warning("[MoMo] IPN không hợp lệ: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (RuntimeException e) {
            // Lỗi phía mình (vd DB) → 500 để MoMo gửi lại IPN
            LOG.log(Level.SEVERE, "[MoMo] Lỗi xử lý IPN", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ==========================================
    // HELPERS
    // ==========================================

    private void renderCheckout(HttpServletRequest request, HttpServletResponse response, int userId,
            MomoCheckoutRequestDTO form, String formError) throws ServletException, IOException {
        CartDTO cart = Cart.getCart((long) userId);
        request.setAttribute("cart", cart);
        request.setAttribute("addresses", MomoTransaction.getAddressOptions(userId));
        request.setAttribute("form", form != null ? form : new MomoCheckoutRequestDTO());
        request.setAttribute("minAmount", MomoTransaction.MIN_AMOUNT);
        request.setAttribute("maxAmount", MomoTransaction.MAX_AMOUNT);
        if (formError != null) {
            request.setAttribute("formError", formError);
        }
        request.getRequestDispatcher(CHECKOUT_VIEW).forward(request, response);
    }

    private MomoCheckoutRequestDTO readForm(HttpServletRequest request) {
        MomoCheckoutRequestDTO dto = new MomoCheckoutRequestDTO();
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
}
