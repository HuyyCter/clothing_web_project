package com.ecommerce.controller;

import com.ecommerce.dto.MomoTransactionDTO;
import com.ecommerce.exception.BusinessException;
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
 * Servlet nhận kết quả từ cổng MoMo (việc tạo giao dịch nằm ở CheckoutServlet khi khách chọn MoMo).
 * <ul>
 *   <li>GET  /payment/momo/return  — MoMo đưa khách quay về (redirectUrl), hiển thị kết quả</li>
 *   <li>POST /payment/momo/ipn     — MoMo gọi server-to-server báo kết quả (ipnUrl), trả 204</li>
 *   <li>GET/POST /payment/momo     — đường dẫn cũ, chuyển về trang /checkout</li>
 * </ul>
 * /payment/momo/ipn KHÔNG được nằm trong AuthFilter (server MoMo không có session).
 */
@WebServlet(urlPatterns = {"/payment/momo", "/payment/momo/return", "/payment/momo/ipn"})
public class MomoPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOG = Logger.getLogger(MomoPaymentServlet.class.getName());

    private static final String RESULT_VIEW = "/WEB-INF/views/payment/momo-result.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/payment/momo/return".equals(path)) {
            handleReturn(request, response);
        } else if ("/payment/momo".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/checkout");
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
            response.sendRedirect(request.getContextPath() + "/checkout");
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    // ==========================================
    // HANDLERS
    // ==========================================

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
