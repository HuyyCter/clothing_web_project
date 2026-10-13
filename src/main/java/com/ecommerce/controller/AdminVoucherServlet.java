package com.ecommerce.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.ecommerce.model.Voucher;
import com.ecommerce.dto.VoucherDTO;
import com.ecommerce.exception.*;
import com.ecommerce.validator.VoucherValidator;

/**
 * Servlet implementation class AdminVoucherServlet
 */
@WebServlet("/AdminVoucherServlet")
public class AdminVoucherServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static String LIST_VIEW = "/WEB-INF/views/admin/voucher-list.jsp";
	private static String FORM_VIEW = "/WEB-INF/views/admin/voucher-form.jsp";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AdminVoucherServlet() {
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
		} else if ("new".equals(action)) {
			request.setAttribute("voucher", new VoucherDTO());
			request.getRequestDispatcher(FORM_VIEW).forward(request, response);
		} else if ("edit".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			request.setAttribute("voucher", Voucher.getById(id));
			request.getRequestDispatcher(FORM_VIEW).forward(request, response);
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

		if ("create".equals(action)) {
			handleCreate(request, response);
		} else if ("update".equals(action)) {
			handleUpdate(request, response);
		} else if ("delete".equals(action)) {
			handleDelete(request, response);
		} else if ("toggle".equals(action)) {
			handleToggle(request, response);
		} else {
			throw new BusinessException("Hành động không hợp lệ.");
		}
	}

	// ==========================================
	// HANDLERS
	// ==========================================
	private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		VoucherDTO dto = readDto(request, response);
		String error = VoucherValidator.validate(dto);
		if (error != null) {
			showError(request, response, dto, error);
			return;
		}

		VoucherDTO createdVoucher = Voucher.create(dto);
		String message = "Đã tạo voucher " + createdVoucher.getCode() + " thành công.";
		request.setAttribute("successMessage", message);
		showList(request, response);
	}

	private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		VoucherDTO dto = readDto(request, response);
		int id = parseInt(request.getParameter("id"), "Mã ID voucher");
		dto.setId(id);
		String error = VoucherValidator.validate(dto);
		if (error != null) {
			showError(request, response, dto, error);
			return;
		}

		VoucherDTO updatedVoucher = Voucher.update(dto.getId(), dto);
		String message = "Đã cập nhật voucher " + updatedVoucher.getCode() + " thành công.";
		request.setAttribute("successMessage", message);
		showList(request, response);
	}

	private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = parseInt(request.getParameter("id"), "Mã ID voucher");
		Voucher.delete(id);
		request.setAttribute("successMessage", "Đã xóa danh mục thành công.");
		showList(request, response);
	}

	private void handleToggle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = parseInt(request.getParameter("id"), "Mã ID voucher");
		VoucherDTO dto = Voucher.toggleActive(id);
		String state = dto.isActive() ? "Bật" : "Tắt";
		String message = "Đã " + state + " voucher " + dto.getCode() + ".";
		request.setAttribute("successMessage", message);
		showList(request, response);
	}

	// ==========================================
	// PRIVATE HELPERS
	// ==========================================
	private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("vouchers", Voucher.getAll());
		request.setAttribute("now", LocalDateTime.now());
		request.getRequestDispatcher(LIST_VIEW).forward(request, response);
	}

	private void showError(HttpServletRequest request, HttpServletResponse response, VoucherDTO dto, String error) throws ServletException,
			IOException {
		request.setAttribute("voucher", dto);
		request.setAttribute("error", error);
		request.getRequestDispatcher(FORM_VIEW).forward(request, response);
	}

	private VoucherDTO readDto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String code = request.getParameter("code");
		int discountPercent = parseInt(request.getParameter("discountPercent"), "Phần trăm giảm giá");
		BigDecimal minOrderAmount = parseBigDecimal(request.getParameter("minOrderAmount"), "Đơn hàng tối thiểu");
		BigDecimal maxDiscountAmount = parseBigDecimal(request.getParameter("maxDiscountAmount"), "Mức giảm tối đa");
		LocalDateTime startAt = parseDateTime(request.getParameter("startAt"), "Ngày bắt đầu");
		LocalDateTime endAt = parseDateTime(request.getParameter("endAt"), "Ngày kết thúc");
		int usageLimit = parseInt(request.getParameter("usageLimit"), "Giới hạn lượt dùng");

		VoucherDTO dto = new VoucherDTO();
		dto.setCode(code);
		dto.setDiscountPercent(discountPercent);
		dto.setMinOrderAmount(minOrderAmount);
		dto.setMaxDiscountAmount(maxDiscountAmount);
		dto.setStartAt(startAt);
		dto.setEndAt(endAt);
		dto.setUsageLimit(usageLimit);

		return dto;
	}

	private int parseInt(String value, String attribute) throws ServletException, IOException {
		value = value.trim();

		if (value == null || value.isEmpty()) {
			return 0;
		}

		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			throw new BusinessException(attribute + " không hợp lệ.");
		}
	}

	private BigDecimal parseBigDecimal(String value, String attribute) throws ServletException, IOException {
		value = value.trim();

		if (value == null || value.isEmpty()) {
			return null;
		}

		try {
			return new BigDecimal(value);
		} catch (NumberFormatException e) {
			throw new BusinessException(attribute + " không hợp lệ.");
		}
	}

	private LocalDateTime parseDateTime(String value, String attribute) throws ServletException, IOException {
		value = value.trim();

		if (value == null || value.isEmpty()) {
			return null;
		}

		try {
			return LocalDateTime.parse(value);
		} catch (NumberFormatException e) {
			throw new BusinessException(attribute + " không hợp lệ.");
		}
	}

}
