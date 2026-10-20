package com.ecommerce.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Properties;

/**
 * Utility hỗ trợ gửi email thông báo và mã OTP.
 * Ưu tiên gửi qua Brevo REST API v3 (Port 443 HTTPS) để tránh tình trạng Render Free Tier
 * chặn các cổng SMTP truyền thống (25, 465, 587).
 * Tự động fallback sang SMTP Gmail nếu chưa thiết lập Brevo API Key.
 */
public class MailUtil {

    private static final String DEFAULT_FROM_EMAIL = "anhhaduy1906@gmail.com";
    private static final String DEFAULT_FROM_NAME = "Fashion Shop";
    private static final String DEFAULT_APP_PASSWORD = "mqnn xgug vkyh ofqo";

    private static final String BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";
    private static final String BREVO_CONFIG_FILE = "brevo.properties";

    /**
     * Nạp cấu hình từ file brevo.properties trong classpath (nếu có).
     */
    private static Properties loadBrevoProperties() {
        Properties props = new Properties();
        try (InputStream in = MailUtil.class.getClassLoader().getResourceAsStream(BREVO_CONFIG_FILE)) {
            if (in != null) {
                props.load(in);
            }
        } catch (Exception ignored) {
        }
        return props;
    }

    /**
     * Lấy Brevo API Key theo thứ tự ưu tiên:
     * 1. Biến môi trường BREVO_API_KEY (trên Render / Production)
     * 2. Java System Property BREVO_API_KEY
     * 3. File brevo.properties trong classpath
     */
    public static String getBrevoApiKey() {
        String envKey = System.getenv("BREVO_API_KEY");
        if (envKey != null && !envKey.isBlank()) {
            return envKey.trim();
        }

        String sysProp = System.getProperty("BREVO_API_KEY");
        if (sysProp != null && !sysProp.isBlank()) {
            return sysProp.trim();
        }

        Properties props = loadBrevoProperties();
        String fileKey = props.getProperty("brevo.apiKey");
        if (fileKey == null || fileKey.isBlank()) {
            fileKey = props.getProperty("api_key");
        }
        if (fileKey != null && !fileKey.isBlank()) {
            return fileKey.trim();
        }

        return null;
    }

    /**
     * Lấy email người gửi (phải là email đã được kích hoạt/xác minh trên Brevo).
     */
    public static String getSenderEmail() {
        String envEmail = System.getenv("BREVO_SENDER_EMAIL");
        if (envEmail != null && !envEmail.isBlank()) return envEmail.trim();

        envEmail = System.getenv("MAIL_USERNAME");
        if (envEmail != null && !envEmail.isBlank()) return envEmail.trim();

        Properties props = loadBrevoProperties();
        String fileEmail = props.getProperty("brevo.senderEmail");
        if (fileEmail == null || fileEmail.isBlank()) fileEmail = props.getProperty("sender_email");
        if (fileEmail != null && !fileEmail.isBlank()) return fileEmail.trim();

        return DEFAULT_FROM_EMAIL;
    }

    /**
     * Lấy tên người gửi hiển thị (mặc định "Fashion Shop").
     */
    public static String getSenderName() {
        String envName = System.getenv("BREVO_SENDER_NAME");
        if (envName != null && !envName.isBlank()) return envName.trim();

        envName = System.getenv("MAIL_FROM_NAME");
        if (envName != null && !envName.isBlank()) return envName.trim();

        Properties props = loadBrevoProperties();
        String fileName = props.getProperty("brevo.senderName");
        if (fileName == null || fileName.isBlank()) fileName = props.getProperty("sender_name");
        if (fileName != null && !fileName.isBlank()) return fileName.trim();

        return DEFAULT_FROM_NAME;
    }

    /**
     * Xác định đường dẫn gốc (Base URL) của ứng dụng.
     * Khi deploy lên server thật (production), chỉ cần đặt biến môi trường APP_BASE_URL (ví dụ: https://myfashion.onrender.com).
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

    /**
     * Gửi email chung: Ưu tiên Brevo REST API (HTTPS Port 443).
     * Nếu chưa cấu hình Brevo API Key, tự động chuyển sang Gmail SMTP (cổng 465).
     */
    public static void sendMail(String to, String subject, String body, boolean bodyIsHTML) throws Exception {
        String brevoApiKey = getBrevoApiKey();
        String senderEmail = getSenderEmail();
        String senderName = getSenderName();

        if (brevoApiKey != null && !brevoApiKey.isBlank()) {
            boolean sent = sendViaBrevoApi(to, subject, body, bodyIsHTML, brevoApiKey, senderEmail, senderName);
            if (sent) {
                return;
            }
            throw new RuntimeException("Gửi email qua Brevo API thất bại.");
        }

        // Nếu chưa cấu hình Brevo API Key, fallback sang SMTP Gmail
        System.out.println("[MailUtil] Chưa phát hiện cấu hình BREVO_API_KEY, fallback gửi qua Gmail SMTP...");
        sendViaSmtp(to, subject, body, bodyIsHTML);
    }

    /**
     * Gửi email thông qua Brevo REST API v3 (POST https://api.brevo.com/v3/smtp/email).
     */
    private static boolean sendViaBrevoApi(String to, String subject, String body, boolean bodyIsHTML,
                                          String apiKey, String senderEmail, String senderName) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            ObjectNode root = mapper.createObjectNode();

            ObjectNode sender = root.putObject("sender");
            sender.put("name", senderName);
            sender.put("email", senderEmail);

            ArrayNode toArray = root.putArray("to");
            ObjectNode recipient = toArray.addObject();
            recipient.put("email", to);

            root.put("subject", subject);
            if (bodyIsHTML) {
                root.put("htmlContent", body);
            } else {
                root.put("textContent", body);
            }

            String requestBody = mapper.writeValueAsString(root);

            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(BREVO_API_URL))
                    .header("accept", "application/json")
                    .header("api-key", apiKey)
                    .header("content-type", "application/json")
                    .timeout(Duration.ofSeconds(15))
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                System.out.println("[MailUtil] Gửi email thành công qua Brevo API tới " + to);
                return true;
            } else {
                System.err.println("[MailUtil] Brevo API trả về mã lỗi HTTP " + response.statusCode() + ": " + response.body());
                return false;
            }
        } catch (Exception e) {
            System.err.println("[MailUtil] Ngoại lệ khi gọi Brevo API: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi email thông qua Gmail SMTP (cổng 465 SSL).
     */
    private static void sendViaSmtp(String to, String subject, String body, boolean bodyIsHTML)
            throws MessagingException, UnsupportedEncodingException {
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

            // In mã OTP ra màn hình server log (Rất hữu ích khi xem logs trên Render Dashboard)
            System.out.println("==================================================================");
            System.out.println("[DEMO / DEBUG OTP] Không gửi được mail tới: " + toEmail);
            System.out.println("[DEMO / DEBUG OTP] Mã xác thực OTP là: " + otpCode);
            System.out.println("[DEMO / DEBUG OTP] Hãy cấu hình biến BREVO_API_KEY trên Render hoặc tạo brevo.properties");
            System.out.println("==================================================================");

            // Cho phép bypass khi bật biến môi trường ALLOW_CONSOLE_OTP=true trên server test
            String allowConsoleOtp = System.getenv("ALLOW_CONSOLE_OTP");
            if ("true".equalsIgnoreCase(allowConsoleOtp)) {
                System.out.println("[DEMO / DEBUG OTP] Chế độ ALLOW_CONSOLE_OTP=true đang bật. Cho phép tiếp tục luồng xác thực.");
                return true;
            }

            return false;
        }
    }

    /**
     * Gửi email thông báo Đăng ký tài khoản thành công kèm lời chào và link website.
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
