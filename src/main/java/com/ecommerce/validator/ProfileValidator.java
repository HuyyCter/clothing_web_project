package com.ecommerce.validator;

import java.util.regex.Pattern;

public class ProfileValidator {

    private static final int NAME_MAX_LENGTH = 255;
    private static final Pattern PASSWORD_PATTERN =
        Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$");

    public static String validateUpdateName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Họ và tên không được để trống.";
        }
        if (fullName.trim().length() > NAME_MAX_LENGTH) {
            return "Họ và tên không được vượt quá " + NAME_MAX_LENGTH + " ký tự.";
        }
        return null;
    }

    public static String validateChangePassword(String currentPassword, String newPassword, String confirmPassword) {
        if (currentPassword == null || currentPassword.isEmpty()) {
            return "Vui lòng nhập mật khẩu hiện tại.";
        }
        if (newPassword == null || newPassword.isEmpty()) {
            return "Vui lòng nhập mật khẩu mới.";
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            return "Vui lòng xác nhận mật khẩu mới.";
        }
        if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
            return "Mật khẩu mới phải có ít nhất 8 ký tự, chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số.";
        }
        if (newPassword.equals(currentPassword)) {
            return "Mật khẩu mới không được trùng với mật khẩu hiện tại.";
        }
        if (!newPassword.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp.";
        }
        return null;
    }

    public static String validateAddress(String recipientName, String phone, String street, String city) {
        if (recipientName == null || recipientName.trim().isEmpty()) {
            return "Tên người nhận không được để trống.";
        }
        if (phone == null || phone.trim().isEmpty()) {
            return "Số điện thoại không được để trống.";
        }
        if (street == null || street.trim().isEmpty()) {
            return "Địa chỉ đường / số nhà không được để trống.";
        }
        if (city == null || city.trim().isEmpty()) {
            return "Tỉnh / Thành phố không được để trống.";
        }
        return null;
    }
}
