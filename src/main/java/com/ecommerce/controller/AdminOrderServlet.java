package com.ecommerce.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.ecommerce.dto.CategoryDTO;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderStatus;

/**
 * Servlet implementation class AdminOrderServlet
 */
@WebServlet("/AdminOrderServlet")
public class AdminOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static String LIST_VIEW = "/WEB-INF/views/admin/order-list.jsp";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AdminOrderServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");

		if (action == null || action.isEmpty()) {
			showList(request, response);
		} else {
			throw new BusinessException("Hành động không hợp lệ.");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");

		if ("updateStatus".equals(action)) {
			handleUpdateStatus(request, response);
		} else {
			throw new BusinessException("Hành động không hợp lệ.");
		}
	}

	// ==========================================
	// HANDLERS
	// ==========================================
	private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = parseId(request);
		OrderStatus status = parseStatus(request);

		Order.updateStatus(id, status);

		String message = "Đã cập nhật đơn #" + id + " sang trạng thái " + status + " thành công.";
		request.setAttribute("successMessage", message);
		showList(request, response);
	}

	// ==========================================
	// PRIVATE HELPERS
	// ==========================================
	private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("orders", Order.getAll());
		request.getRequestDispatcher(LIST_VIEW).forward(request, response);
	}

	private int parseId(HttpServletRequest request) {
		try {
			return Integer.parseInt(request.getParameter("id"));
		} catch (NumberFormatException e) {
			throw new BusinessException("Mã ID đơn hàng không hợp lệ.");
		}
	}

	private OrderStatus parseStatus(HttpServletRequest request) {
		try {
			return OrderStatus.valueOf(request.getParameter("status"));
		} catch (IllegalArgumentException | NullPointerException e) {
			throw new BusinessException("Trạng thái đơn hàng không hợp lệ.");
		}
	}
}
