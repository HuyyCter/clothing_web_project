package com.ecommerce.filter;

import com.ecommerce.model.User;
import com.ecommerce.model.UserRole;
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
 * Filter phân quyền cho các URL quản trị (Admin).
 * Kiểm tra role trong session, nếu chưa đăng nhập redirect về /login,
 * nếu role != ADMIN sẽ trả về lỗi 403 (forward sang error-403.jsp).
 */
@WebFilter(
    filterName = "AdminFilter",
    urlPatterns = {
        "/admin/*",
        "/admin-home.jsp",
        "/AdminCategoryServlet",
        "/AdminDashboardServlet",
        "/AdminOrderServlet",
        "/AdminProductServlet",
        "/AdminVoucherServlet"
    }
)
public class AdminFilter implements Filter {

    private static final String FORBIDDEN_VIEW = "/WEB-INF/views/error/error-403.jsp";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo AdminFilter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);

        if (!isLoggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        String role = (session != null) ? (String) session.getAttribute("role") : null;
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        boolean isAdmin = UserRole.ADMIN.name().equalsIgnoreCase(role) || (user != null && user.isAdmin());

        if (!isAdmin) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.setAttribute("errorMessage", "Bạn không có quyền truy cập vào khu vực quản trị này.");
            httpRequest.getRequestDispatcher(FORBIDDEN_VIEW).forward(httpRequest, httpResponse);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy AdminFilter
    }
}
