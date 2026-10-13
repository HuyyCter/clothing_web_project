package com.ecommerce.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;
import com.ecommerce.model.ProductImage;
import com.ecommerce.model.ProductVariant;
import com.ecommerce.dto.ProductDTO;
import com.ecommerce.dto.ProductImageDTO;
import com.ecommerce.dto.ProductVariantDTO;
import com.ecommerce.exception.*;
import com.ecommerce.util.*;
import com.ecommerce.validator.ProductImageValidator;
import com.ecommerce.validator.ProductValidator;
import com.ecommerce.validator.ProductVariantValidator;

/**
 * Servlet implementation class AdminProductServlet
 */
@WebServlet("/AdminProductServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class AdminProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String LIST_VIEW = "/WEB-INF/views/admin/product-list.jsp";
	private static final String FORM_VIEW = "/WEB-INF/views/admin/product-form.jsp";
	private static final int PAGE_SIZE = PaginationUtil.DEFAULT_PAGE_SIZE;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AdminProductServlet() {
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
			showForm(request, response, new ProductDTO());
		} else if ("edit".equals(action)) {
			int id = parseId(request);
			showForm(request, response, Product.getById(id));
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
		} else if ("toggleActive".equals(action)) {
			handleToggleActive(request, response);
		} else if ("addVariant".equals(action)) {
			handleAddVariant(request, response);
		} else if ("restockVariant".equals(action)) {
			handleRestockVariant(request, response);
		} else if ("updateVariant".equals(action)) {
			handleUpdateVariant(request, response);
		} else if ("discontinueVariant".equals(action)) {
			handleDiscontinueVariant(request, response);
		} else if ("resumeVariant".equals(action)) {
			handleResumeVariant(request, response);
		} else if ("addImage".equals(action)) {
			handleAddImage(request, response);
		} else if ("deleteImage".equals(action)) {
			handleDeleteImage(request, response);
		} else {
			throw new BusinessException("Hành động không hợp lệ.");
		}
	}

	// ==========================================
	// HANDLERS
	// ==========================================
	private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDTO dto = readDto(request);
		String error = ProductValidator.validate(dto);
		if (error != null) {
			showError(request, response, dto, error);
			return;
		}

		// Tạo xong chuyển thẳng sang trang sửa của sản phẩm vừa tạo,
		// vì loại hàng (variant) và ảnh chỉ thêm được khi sản phẩm đã có id.
		ProductDTO createdProduct = Product.create(dto);
		String message = "Đã tạo sản phẩm \"" + createdProduct.getName() + "\" thành công.";
		request.setAttribute("successMessage", message);
		showForm(request, response, Product.getById(createdProduct.getId()));
	}

	private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDTO dto = readDto(request);
		int id = parseId(request);
		dto.setId(id);
		String error = ProductValidator.validate(dto);
		if (error != null) {
			showError(request, response, dto, error);
			return;
		}

		ProductDTO updatedProduct = Product.update(dto.getId(), dto);
		String message = "Đã cập nhật sản phẩm \"" + updatedProduct.getName() + "\" thành công.";
		request.setAttribute("successMessage", message);
		showList(request, response);
	}

	private void handleToggleActive(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = parseId(request);
		boolean active = parseActive(request);
		Product.setActive(id, active);
		request.setAttribute("successMessage", active ? "Đã hiện sản phẩm thành công." : "Đã ẩn sản phẩm thành công.");
		showList(request, response);
	}

	// ---- Loại hàng (ProductVariant) ----
	// Form gửi kèm hidden productId/size/color/sku/price cho mọi thao tác theo loại.
	// Lỗi validate -> hiện lại trang sửa kèm lỗi; BusinessException/NotFoundException ->
	// GlobalExceptionFilter.
	private void handleAddVariant(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductVariantDTO dto = readVariantDto(request);
		String error = ProductVariantValidator.validate(dto, true);
		if (error != null) {
			showVariantError(request, response, dto, error);
			return;
		}

		ProductVariant.addVariants(dto);
		request.setAttribute("successMessage", "Đã thêm loại " + dto.getSize() + " / " + dto.getColor() + " với " + dto.getQuantity() + " sản phẩm.");
		showEdit(request, response, dto.getProductId());
	}

	private void handleRestockVariant(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductVariantDTO dto = readVariantDto(request);
		String error = ProductVariantValidator.validate(dto, true);
		if (error != null) {
			showVariantError(request, response, dto, error);
			return;
		}

		ProductVariant.restockVariants(dto);
		request.setAttribute("successMessage", "Đã nhập thêm " + dto.getQuantity() + " sản phẩm cho loại " + dto.getSize() + " / " + dto.getColor()
				+ ".");
		showEdit(request, response, dto.getProductId());
	}

	private void handleUpdateVariant(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductVariantDTO dto = readVariantDto(request);
		String error = ProductVariantValidator.validate(dto, false);
		if (error != null) {
			showVariantError(request, response, dto, error);
			return;
		}

		ProductVariant.updateVariants(dto);
		request.setAttribute("successMessage", "Đã cập nhật SKU/giá cho loại " + dto.getSize() + " / " + dto.getColor() + ".");
		showEdit(request, response, dto.getProductId());
	}

	private void handleDiscontinueVariant(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductVariantDTO dto = readVariantDto(request);
		ProductVariant.discontinueType(dto.getProductId(), dto.getSize(), dto.getColor());
		request.setAttribute("successMessage", "Đã ngừng bán loại " + dto.getSize() + " / " + dto.getColor() + ".");
		showEdit(request, response, dto.getProductId());
	}

	private void handleResumeVariant(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductVariantDTO dto = readVariantDto(request);
		ProductVariant.resumeType(dto.getProductId(), dto.getSize(), dto.getColor());
		request.setAttribute("successMessage", "Đã bán lại loại " + dto.getSize() + " / " + dto.getColor() + ".");
		showEdit(request, response, dto.getProductId());
	}

	// ---- Ảnh (ProductImage) ----
	// Validate hết (sản phẩm, màu, file) TRƯỚC khi upload để không sinh file mồ côi trên Cloudinary.
	private void handleAddImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int productId = parseProductId(request);
		String color = request.getParameter("color");

		String error = ProductImageValidator.validateTarget(productId, color);
		Part file = request.getPart("image");
		if (error == null) {
			error = ProductImageValidator.validateFile(file == null ? null : file.getContentType(), file == null ? 0 : file.getSize());
		}
		if (error != null) {
			request.setAttribute("error", error);
			showEdit(request, response, productId);
			return;
		}

		String imageUrl = CloudinaryUtil.uploadImage(file);

		ProductImageDTO dto = new ProductImageDTO();
		dto.setProductId(productId);
		dto.setImageUrl(imageUrl);
		dto.setColor(color);

		error = ProductImageValidator.validate(dto);
		if (error != null) {
			request.setAttribute("error", error);
			showEdit(request, response, productId);
			return;
		}

		ProductImage.add(dto);
		request.setAttribute("successMessage", "Đã thêm ảnh cho màu " + ProductVariant.normalizeColor(color) + ".");
		showEdit(request, response, productId);
	}

	private void handleDeleteImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int productId = parseProductId(request);
		int imageId = parseImageId(request);
		ProductImage.delete(imageId);
		request.setAttribute("successMessage", "Đã xóa ảnh thành công.");
		showEdit(request, response, productId);
	}

	// ==========================================
	// PRIVATE HELPERS
	// ==========================================
	private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		long totalProducts = Product.countAll();
		int totalPages = PaginationUtil.totalPages(totalProducts, PAGE_SIZE);
		int currentPage = PaginationUtil.clampPage(PaginationUtil.parsePage(request.getParameter("page")), totalPages);
		List<ProductDTO> products = Product.getAll(PaginationUtil.offset(currentPage, PAGE_SIZE), PAGE_SIZE);

		request.setAttribute("products", products);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("totalPages", totalPages);
		request.getRequestDispatcher(LIST_VIEW).forward(request, response);
	}

	private void showForm(HttpServletRequest request, HttpServletResponse response, ProductDTO product) throws ServletException, IOException {
		request.setAttribute("product", product);
		request.setAttribute("categories", Category.getAll());
		request.getRequestDispatcher(FORM_VIEW).forward(request, response);
	}

	// Hiện lại trang sửa sản phẩm (dữ liệu mới từ DB).
	private void showEdit(HttpServletRequest request, HttpServletResponse response, int productId) throws ServletException, IOException {
		showForm(request, response, Product.getById(productId));
	}

	// Lỗi validate ở form loại hàng: hiện lại trang sửa kèm lỗi và giá trị vừa nhập (variantForm).
	private void showVariantError(HttpServletRequest request, HttpServletResponse response, ProductVariantDTO dto, String error)
			throws ServletException, IOException {
		request.setAttribute("variantForm", dto);
		request.setAttribute("error", error);
		showEdit(request, response, dto.getProductId());
	}

	private void showError(HttpServletRequest request, HttpServletResponse response, ProductDTO dto, String error) throws ServletException,
			IOException {
		ProductDTO product = dto;
		if (dto.getId() > 0) {
			// Đang sửa: lấy lại sản phẩm từ DB để trang sửa vẫn hiện đủ loại hàng và ảnh,
			// rồi đè lại các giá trị người dùng vừa nhập để họ không phải gõ lại.
			product = Product.getById(dto.getId());
			product.setName(dto.getName());
			product.setDescription(dto.getDescription());
			product.setCategoryId(dto.getCategoryId());
		}
		request.setAttribute("error", error);
		showForm(request, response, product);
	}

	private ProductDTO readDto(HttpServletRequest request) {
		String name = request.getParameter("name");
		String description = request.getParameter("description");

		ProductDTO dto = new ProductDTO();
		dto.setName(name);
		dto.setDescription(description);
		dto.setCategoryId(parseCategoryId(request));

		return dto;
	}

	private ProductVariantDTO readVariantDto(HttpServletRequest request) {
		ProductVariantDTO dto = new ProductVariantDTO();
		dto.setProductId(parseProductId(request));
		dto.setSize(request.getParameter("size"));
		dto.setColor(request.getParameter("color"));
		dto.setSku(request.getParameter("sku"));
		dto.setPrice(parsePrice(request));
		dto.setQuantity(parseQuantity(request));
		return dto;
	}

	private int parseId(HttpServletRequest request) {
		try {
			int id = Integer.parseInt(request.getParameter("id"));
			return id;
		} catch (NumberFormatException e) {
			throw new BusinessException("Mã ID sản phẩm không hợp lệ.");
		}
	}

	// Chưa chọn danh mục hoặc giá trị sai thì trả 0 để ProductValidator báo lỗi "Vui lòng chọn danh
	// mục".
	private int parseCategoryId(HttpServletRequest request) {
		try {
			return Integer.parseInt(request.getParameter("categoryId"));
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	private int parseProductId(HttpServletRequest request) {
		try {
			return Integer.parseInt(request.getParameter("productId"));
		} catch (NumberFormatException e) {
			throw new BusinessException("Mã ID sản phẩm không hợp lệ.");
		}
	}

	private int parseImageId(HttpServletRequest request) {
		try {
			return Integer.parseInt(request.getParameter("imageId"));
		} catch (NumberFormatException e) {
			throw new BusinessException("Mã ID ảnh không hợp lệ.");
		}
	}

	// Giá sai định dạng hoặc để trống thì trả null để ProductVariantValidator báo lỗi giá.
	private BigDecimal parsePrice(HttpServletRequest request) {
		try {
			return new BigDecimal(request.getParameter("price").trim());
		} catch (NumberFormatException | NullPointerException e) {
			return null;
		}
	}

	// Số lượng sai định dạng thì trả 0 để ProductVariantValidator báo lỗi số lượng.
	private int parseQuantity(HttpServletRequest request) {
		try {
			return Integer.parseInt(request.getParameter("quantity").trim());
		} catch (NumberFormatException | NullPointerException e) {
			return 0;
		}
	}

	// Bắt buộc là "true" hoặc "false"; thiếu param thì báo lỗi chứ không tự ẩn sản phẩm.
	private boolean parseActive(HttpServletRequest request) {
		String active = request.getParameter("active");
		if ("true".equals(active)) {
			return true;
		}
		if ("false".equals(active)) {
			return false;
		}
		throw new BusinessException("Trạng thái hiển thị không hợp lệ.");
	}

}
