package com.ecommerce.util;

public class PaginationUtil {
    public static final int DEFAULT_PAGE_SIZE = 10;

    private PaginationUtil() {}

    // Đọc số trang từ request param. Thiếu, sai định dạng hoặc < 1 thì về trang 1.
    public static int parsePage(String rawPage) {
        try {
            return Math.max(1, Integer.parseInt(rawPage));
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    // Tổng số trang, luôn >= 1 (danh sách rỗng vẫn hiện "trang 1").
    public static int totalPages(long totalItems, int pageSize) {
        return (int)Math.max(1, (totalItems + pageSize - 1) / pageSize);
    }

    // Trang vượt quá tổng số trang (vd xóa hết dòng của trang cuối) thì lùi về trang cuối.
    public static int clampPage(int page, int totalPages) {
        return Math.min(page, totalPages);
    }

    // Vị trí dòng đầu tiên của trang, dùng làm offset cho query.
    public static int offset(int page, int pageSize) {
        return (page - 1) * pageSize;
    }
}
