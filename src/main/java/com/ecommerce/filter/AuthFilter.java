package com.ecommerce.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter xác thực người dùng cho các route yêu cầu đăng nhập.
 * Chuyển hướng người dùng về trang login nếu chưa có session userId.
 */
@WebFilter(
    filterName = "AuthFilter",
    urlPatterns = {
        "/profile",
        "/profile/*",
        "/cart",
        "/cart/*",
        "/wishlist/*",
        "/orders",
        "/orders/*",
        "/checkout",
        "/checkout/*"
    }
)
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo AuthFilter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);

        if (!isLoggedIn) {
            String ajaxHeader = httpRequest.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(ajaxHeader);

            if (isAjax) {
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                httpResponse.setContentType("application/json;charset=UTF-8");
                httpResponse.getWriter().write("{\"status\": 401, \"title\": \"Unauthorized\", \"detail\": \"Vui lòng đăng nhập để tiếp tục.\"}");
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            }
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy AuthFilter
    }
}
