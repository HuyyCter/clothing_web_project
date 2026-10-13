package com.ecommerce.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility hỗ trợ băm (hash) và kiểm tra mật khẩu sử dụng jBCrypt. Đảm bảo mật khẩu không bao giờ
 * được lưu trữ dưới dạng plain text.
 */
public class PasswordUtil {

    private static final int LOG_ROUNDS = 12;

    private PasswordUtil() {
        // Private constructor ngăn khởi tạo utility class
    }

    /**
     * Băm mật khẩu bằng thuật toán BCrypt với salt ngẫu nhiên.
     *
     * @param plainPassword mật khẩu dạng văn bản gốc
     * @return chuỗi hash BCrypt
     * @throws IllegalArgumentException nếu mật khẩu rỗng hoặc null
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isBlank()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(LOG_ROUNDS));
    }

    /**
     * Kiểm tra mật khẩu gốc có khớp với chuỗi hash đã lưu hay không.
     *
     * @param plainPassword mật khẩu do người dùng nhập vào
     * @param hashedPassword chuỗi hash đã lưu trong database
     * @return true nếu mật khẩu chính xác, ngược lại false
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || plainPassword.isBlank() || hashedPassword == null || hashedPassword.isBlank()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Trường hợp hash không đúng định dạng BCrypt
            return false;
        }
    }
}
