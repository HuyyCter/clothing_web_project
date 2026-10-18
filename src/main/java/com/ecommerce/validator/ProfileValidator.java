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

    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^(0|\\+84)[1-9][0-9]{8}$");

    public static String validateUpdatePhone(String currentPhone, String newPhone, String confirmCommand) {
        if (newPhone == null || newPhone.trim().isEmpty()) {
            return "Số điện thoại mới không được để trống.";
        }
        String trimmedPhone = newPhone.trim();
        if (!PHONE_PATTERN.matcher(trimmedPhone).matches()) {
            return "Số điện thoại không hợp lệ (cần 10 chữ số, ví dụ: 0912345678).";
        }
        if (currentPhone != null && currentPhone.trim().equals(trimmedPhone)) {
            return "Số điện thoại mới không được trùng với số điện thoại hiện tại.";
        }
        if (confirmCommand == null || confirmCommand.trim().isEmpty()) {
            return "Vui lòng nhập dòng lệnh xác minh.";
        }
        String expectedCommand = "Change Phone " + trimmedPhone;
        if (!confirmCommand.trim().equalsIgnoreCase(expectedCommand)) {
            return "Dòng lệnh xác minh không chính xác. Bạn cần nhập đúng: " + expectedCommand;
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
