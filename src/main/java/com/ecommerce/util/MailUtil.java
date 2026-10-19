package com.ecommerce.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class MailUtil {

    private static final String DEFAULT_FROM_EMAIL = "anhhaduy1906@gmail.com";
    private static final String DEFAULT_FROM_NAME = "Fashion Shop";
    private static final String DEFAULT_APP_PASSWORD = "mqnn xgug vkyh ofqo";

    /**
     * Xác định đường dẫn gốc (Base URL) của ứng dụng.
     * Khi deploy lên server thật (production), chỉ cần đặt biến môi trường APP_BASE_URL (ví dụ: https://myfashion.com).
     * Mặc định ở môi trường dev cục bộ sẽ tự động sinh theo thông tin của request.
     */
    public static String getAppBaseUrl(HttpServletRequest request) {
        String envBaseUrl = System.getenv("APP_BASE_URL");
        if (envBaseUrl != null && !envBaseUrl.isBlank()) {
            String trimmed = envBaseUrl.trim();
            return trimmed.endsWith("/") ? trimmed.substring(0, trimmed.length() - 1) : trimmed;
        }

        if (request != null) {
            String forwardedProto = request.getHeader("X-Forwarded-Proto");
            String forwardedHost = request.getHeader("X-Forwarded-Host");
            if (forwardedHost != null && !forwardedHost.isBlank()) {
                String proto = (forwardedProto != null && !forwardedProto.isBlank()) ? forwardedProto : request.getScheme();
                return proto + "://" + forwardedHost + request.getContextPath();
            }

            String scheme = request.getScheme();
            String serverName = request.getServerName();
            int serverPort = request.getServerPort();
            String contextPath = request.getContextPath();
            String portPart = (serverPort == 80 || serverPort == 443) ? "" : (":" + serverPort);
            return scheme + "://" + serverName + portPart + contextPath;
        }

        return "http://localhost:8080";
    }

    public static void sendMail(String to, String subject, String body, boolean bodyIsHTML) throws MessagingException, UnsupportedEncodingException {
        String from = System.getenv("MAIL_USERNAME");
        if (from == null || from.isBlank()) {
            from = DEFAULT_FROM_EMAIL;
        }

        String fromName = System.getenv("MAIL_FROM_NAME");
        if (fromName == null || fromName.isBlank()) {
            fromName = DEFAULT_FROM_NAME;
        }

        String appPassword = System.getenv("MAIL_PASSWORD");
        if (appPassword == null || appPassword.isBlank()) {
            appPassword = DEFAULT_APP_PASSWORD;
        }
        appPassword = appPassword.replaceAll("\\s+", "");

        Properties props = new Properties();
        props.put("mail.transport.protocol", "smtps");
        props.put("mail.smtps.host", "smtp.gmail.com");
        props.put("mail.smtps.port", "465");
        props.put("mail.smtps.auth", "true");
        props.put("mail.smtps.ssl.enable", "true");
        props.put("mail.smtps.connectiontimeout", "8000"); // 8s timeout
        props.put("mail.smtps.timeout", "8000");
        props.put("mail.smtps.writetimeout", "8000");
        props.put("mail.smtps.quitwait", "false");

        Session session = Session.getInstance(props);

        Message message = new MimeMessage(session);
        message.setSubject(subject);
        if (bodyIsHTML) {
            message.setContent(body, "text/html; charset=UTF-8");
        } else {
            message.setText(body);
        }

        // Đổi tên người gửi hiển thị thành "Fashion Shop" (hoặc biến môi trường cấu hình)
        Address fromAddress = new InternetAddress(from, fromName, "UTF-8");
        Address toAddress = new InternetAddress(to);
        message.setFrom(fromAddress);
        message.setRecipient(Message.RecipientType.TO, toAddress);

        Transport transport = session.getTransport();
        try {
            transport.connect("smtp.gmail.com", from, appPassword);
            transport.sendMessage(message, message.getAllRecipients());
        } finally {
            transport.close();
        }
    }

    public static boolean sendOtpEmail(String toEmail, String otpCode, String purposeDescription) {
        try {
            String subject = "[Fashion Shop] Mã xác thực OTP (" + otpCode + ")";

            String htmlContent = "<!DOCTYPE html>"
                    + "<html>"
                    + "<head><meta charset='UTF-8'></head>"
                    + "<body style='margin:0;padding:24px;background-color:#f8fafc;font-family:-apple-system,BlinkMacSystemFont,\"Segoe UI\",Roboto,sans-serif;'>"
                    + "<div style='max-width:520px;margin:0 auto;background:#ffffff;border-radius:12px;padding:32px;border:1px solid #e2e8f0;box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);'>"
                    + "<div style='text-align:center;margin-bottom:24px;'>"
                    + "<h1 style='font-size:24px;font-weight:700;color:#0f172a;margin:0;'>Fashion<span style='color:#1e3a8a;'>.</span> Shop</h1>"
                    + "<p style='color:#64748b;font-size:14px;margin-top:4px;'>Hệ thống thời trang tối giản & thanh lịch</p>"
                    + "</div>"
                    + "<div style='border-top:1px solid #f1f5f9;border-bottom:1px solid #f1f5f9;padding:20px 0;margin-bottom:24px;'>"
                    + "<p style='font-size:15px;color:#334155;line-height:1.6;margin:0 0 16px 0;'>"
                    + "Xin chào,<br>Bạn đang thực hiện thao tác: <strong>" + purposeDescription + "</strong> trên hệ thống Fashion Shop."
                    + "</p>"
                    + "<div style='background-color:#0f172a;border-radius:8px;padding:18px;text-align:center;margin:20px 0;'>"
                    + "<span style='font-size:32px;font-weight:800;letter-spacing:8px;color:#38bdf8;font-family:monospace;display:inline-block;'>"
                    + otpCode
                    + "</span>"
                    + "</div>"
                    + "<p style='font-size:13px;color:#dc2626;font-weight:600;margin:12px 0 0 0;text-align:center;'>"
                    + "⏱️ Mã OTP có hiệu lực trong vòng 2 phút (120 giây) và chỉ cho phép nhập sai tối đa 3 lần."
                    + "</p>"
                    + "</div>"
                    + "<p style='font-size:12px;color:#94a3b8;line-height:1.5;margin:0;'>"
                    + "⚠️ Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email và bảo mật tài khoản. Tuyệt đối không chia sẻ mã này cho bất kỳ ai."
                    + "</p>"
                    + "</div>"
                    + "</body>"
                    + "</html>";

            sendMail(toEmail, subject, htmlContent, true);
            return true;
        } catch (Throwable e) {
            System.err.println("[MailUtil] Lỗi gửi email OTP tới " + toEmail + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi email thông báo Đăng ký tài khoản thành công kèm lời chào và link website.
     * @param toEmail email người dùng vừa đăng ký
     * @param fullName họ và tên người dùng
     * @param websiteUrl đường dẫn tới trang web
     * @return true nếu gửi thành công, false nếu có lỗi
     */
    public static boolean sendWelcomeEmail(String toEmail, String fullName, String websiteUrl) {
        try {
            String subject = "[Fashion Shop] Đăng ký tài khoản thành công - Chào mừng bạn!";

            String displayName = (fullName != null && !fullName.isBlank()) ? fullName : "Quý khách";
            String link = (websiteUrl != null && !websiteUrl.isBlank()) ? websiteUrl : "#";

            String htmlContent = "<!DOCTYPE html>"
                    + "<html>"
                    + "<head><meta charset='UTF-8'></head>"
                    + "<body style='margin:0;padding:24px;background-color:#f8fafc;font-family:-apple-system,BlinkMacSystemFont,\"Segoe UI\",Roboto,sans-serif;'>"
                    + "<div style='max-width:560px;margin:0 auto;background:#ffffff;border-radius:12px;padding:36px;border:1px solid #e2e8f0;box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);'>"
                    + "<div style='text-align:center;margin-bottom:28px;'>"
                    + "<h1 style='font-size:26px;font-weight:800;color:#0f172a;margin:0;'>Fashion<span style='color:#2563eb;'>.</span> Shop</h1>"
                    + "<p style='color:#64748b;font-size:14px;margin-top:6px;'>Chào mừng bạn gia nhập cộng đồng thời trang</p>"
                    + "</div>"
                    + "<div style='border-top:1px solid #f1f5f9;border-bottom:1px solid #f1f5f9;padding:24px 0;margin-bottom:24px;'>"
                    + "<p style='font-size:16px;color:#1e293b;line-height:1.6;margin:0 0 14px 0;'>"
                    + "Xin chào <strong>" + displayName + "</strong>,"
                    + "</p>"
                    + "<p style='font-size:15px;color:#334155;line-height:1.6;margin:0 0 16px 0;'>"
                    + "Chúc mừng bạn đã tạo tài khoản thành công tại <strong>Fashion Shop</strong>. Chúng tôi rất hân hạnh được đồng hành cùng bạn trên hành trình định hình phong cách cá nhân với những sản phẩm thời trang tối giản và thanh lịch nhất."
                    + "</p>"
                    + "<p style='font-size:15px;color:#334155;line-height:1.6;margin:0 0 24px 0;'>"
                    + "Tài khoản của bạn đã được kích hoạt hoàn toàn. Bạn có thể đăng nhập bất cứ lúc nào bằng Email hoặc Số điện thoại của mình để theo dõi đơn hàng và tận hưởng những ưu đãi dành riêng cho thành viên."
                    + "</p>"
                    + "<div style='text-align:center;margin:28px 0;'>"
                    + "<a href='" + link + "' style='display:inline-block;background-color:#0f172a;color:#ffffff;text-decoration:none;font-weight:600;font-size:15px;padding:12px 28px;border-radius:8px;box-shadow:0 2px 4px rgba(0,0,0,0.1);'>"
                    + "Khám phá cửa hàng ngay →"
                    + "</a>"
                    + "</div>"
                    + "<p style='font-size:13px;color:#64748b;line-height:1.5;margin:0;text-align:center;'>"
                    + "Hoặc truy cập theo liên kết: <a href='" + link + "' style='color:#2563eb;word-break:break-all;'>" + link + "</a>"
                    + "</p>"
                    + "</div>"
                    + "<div style='text-align:center;font-size:13px;color:#94a3b8;line-height:1.5;'>"
                    + "<p style='margin:0 0 4px 0;'>Trân trọng cảm ơn bạn đã lựa chọn Fashion Shop.</p>"
                    + "<p style='margin:0;'>&copy; 2026 Fashion Shop. Mọi quyền được bảo lưu.</p>"
                    + "</div>"
                    + "</div>"
                    + "</body>"
                    + "</html>";

            sendMail(toEmail, subject, htmlContent, true);
            return true;
        } catch (Throwable e) {
            System.err.println("[MailUtil] Lỗi gửi email chào mừng tới " + toEmail + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
