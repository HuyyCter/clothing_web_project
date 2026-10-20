package com.ecommerce.exception;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet Filter implementation class GlobalExceptionFilter
 */
@WebFilter("/*")
public class GlobalExceptionFilter extends HttpFilter implements Filter {
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpFilter#HttpFilter()
     */
    public GlobalExceptionFilter() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		try {
			// pass the request along the filter chain
			chain.doFilter(request, response);			
		} catch(ValidationException e) {
			handle(httpRequest, httpResponse, 422, "Validation Error", e.getMessage());
		} catch(UnauthorizedException e) {
			handle(httpRequest, httpResponse, 401, "Unauthorized", e.getMessage());
		} catch(NotFoundException e) {
			handle(httpRequest, httpResponse, 404, "Not Found", e.getMessage());
		} catch(BusinessException e) {
			handle(httpRequest, httpResponse, 400, "Business Rule Violation", e.getMessage());
		} catch (Exception e) {
			handle(httpRequest, httpResponse, 500, "Internal Server Error", "The server was unable to complete your request. Please try again later.");
		}
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}
	
	private void handle(HttpServletRequest request, HttpServletResponse response, 
			int statusCode, String title, String message) throws IOException, ServletException {
		response.setStatus(statusCode);
		request.setAttribute("errorTitle", title);
		request.setAttribute("errorMessage", message);
		
		String jspErrorPath = "/WEB-INF/views/error/error-" + statusCode + ".jsp";
		request.getRequestDispatcher(jspErrorPath).forward(request, response);
	}

}
