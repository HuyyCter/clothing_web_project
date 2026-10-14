package com.ecommerce.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.ecommerce.model.Category;
import com.ecommerce.dto.CategoryDTO;
import com.ecommerce.exception.*;
import com.ecommerce.validator.CategoryValidator;

/**
 * Servlet implementation class AdminCategoryServlet
 */
@WebServlet("/AdminCategoryServlet")
public class AdminCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static String LIST_VIEW = "/WEB-INF/views/admin/category-list.jsp";
	private static String FORM_VIEW = "/WEB-INF/views/admin/category-form.jsp";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AdminCategoryServlet() {
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
			request.setAttribute("category", new CategoryDTO());
			request.getRequestDispatcher(FORM_VIEW).forward(request, response);
		} else if ("edit".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			request.setAttribute("category", Category.getById(id));
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
		} else {
			throw new BusinessException("Hành động không hợp lệ.");
		}
	}

	// ==========================================
	// HANDLERS
	// ==========================================
	private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		CategoryDTO dto = readDto(request, response);
		String error = CategoryValidator.validate(dto);
		if (error != null) {
			showError(request, response, dto, error);
			return;
		}

		CategoryDTO createdCategory = Category.create(dto);
		String message = "Đã tạo danh mục /" + createdCategory.getName() + " thành công.";
		request.setAttribute("successMessage", message);
		showList(request, response);
	}

	private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		CategoryDTO dto = readDto(request, response);
		int id = parseId(request, response);
		dto.setId(id);
		String error = CategoryValidator.validate(dto);
		if (error != null) {
			showError(request, response, dto, error);
			return;
		}

		CategoryDTO updatedCategory = Category.update(dto.getId(), dto);
		String message = "Đã cập nhật danh mục /" + updatedCategory.getName() + " thành công.";
		request.setAttribute("successMessage", message);
		showList(request, response);
	}

	private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = parseId(request, response);
		Category.delete(id);
		request.setAttribute("successMessage", "Đã xóa danh mục thành công.");
		showList(request, response);
	}


	// ==========================================
	// PRIVATE HELPERS
	// ==========================================
	private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("categories", Category.getAll());
		request.getRequestDispatcher(LIST_VIEW).forward(request, response);
	}

	private void showError(HttpServletRequest request, HttpServletResponse response, CategoryDTO dto, String error) throws ServletException,
			IOException {
		request.setAttribute("categories", dto);
		request.setAttribute("error", error);
		request.getRequestDispatcher(FORM_VIEW).forward(request, response);
	}

	private CategoryDTO readDto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		String description = request.getParameter("description");

		CategoryDTO dto = new CategoryDTO();
		dto.setName(name);
		dto.setDescription(description);

		return dto;
	}

	private int parseId(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			int id = Integer.parseInt(request.getParameter("id"));
			return id;
		} catch (NumberFormatException e) {
			throw new BusinessException("Mã ID danh mục không hợp lệ.");
		}
	}
}
