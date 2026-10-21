package com.ecommerce.util;

import com.ecommerce.config.MomoConfig;
import com.ecommerce.exception.BusinessException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Helper kỹ thuật cho cổng MoMo (API v2): ký HMAC-SHA256, kiểm chữ ký IPN,
 * gọi API create / query. Không chứa business logic (business nằm ở
 * {@link com.ecommerce.model.MomoTransaction}).
 *
 * Tài liệu: https://developers.momo.vn/v3/docs/payment/api/wallet/onetime
 */
public final class MomoUtil {

    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final HttpClient HTTP = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(15))
            .build();

    /** Thứ tự field trong raw signature của IPN / redirect (sắp xếp a → z theo tài liệu MoMo). */
    private static final String[] RESULT_SIGNATURE_FIELDS = {
        "amount", "extraData", "message", "orderId", "orderInfo", "orderType",
        "partnerCode", "payType", "requestId", "responseTime", "resultCode", "transId"
    };

    private MomoUtil() {}

    // ==========================================
    // CHỮ KÝ
    // ==========================================

    public static String hmacSha256(String data, String secretKey) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            byte[] raw = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder(raw.length * 2);
            for (byte b : raw) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (Exception e) {
            throw new IllegalStateException("Không tạo được chữ ký HMAC-SHA256", e);
        }
    }

    /** Raw signature cho API create (captureWallet / payWithMethod). */
    public static String buildCreateRawSignature(String accessKey, long amount, String extraData, String ipnUrl,
            String orderId, String orderInfo, String partnerCode, String redirectUrl, String requestId,
            String requestType) {
        return "accessKey=" + accessKey
                + "&amount=" + amount
                + "&extraData=" + extraData
                + "&ipnUrl=" + ipnUrl
                + "&orderId=" + orderId
                + "&orderInfo=" + orderInfo
                + "&partnerCode=" + partnerCode
                + "&redirectUrl=" + redirectUrl
                + "&requestId=" + requestId
                + "&requestType=" + requestType;
    }

    /** Raw signature cho kết quả thanh toán (IPN và tham số redirect). */
    public static String buildResultRawSignature(String accessKey, Map<String, String> params) {
        StringBuilder sb = new StringBuilder("accessKey=").append(accessKey);
        for (String field : RESULT_SIGNATURE_FIELDS) {
            String value = params.get(field);
            sb.append('&').append(field).append('=').append(value == null ? "" : value);
        }
        return sb.toString();
    }

    /**
     * Kiểm tra chữ ký của IPN / redirect do MoMo gửi về.
     * So sánh constant-time để tránh timing attack.
     */
    public static boolean verifyResultSignature(Map<String, String> params) {
        String received = params.get("signature");
        if (received == null || received.isEmpty()) {
            return false;
        }
        MomoConfig cfg = MomoConfig.get();
        String expected = hmacSha256(buildResultRawSignature(cfg.getAccessKey(), params), cfg.getSecretKey());
        return MessageDigest.isEqual(expected.getBytes(StandardCharsets.UTF_8),
                received.toLowerCase().getBytes(StandardCharsets.UTF_8));
    }

    // ==========================================
    // GỌI API
    // ==========================================

    /**
     * Gọi API tạo giao dịch. Trả về toàn bộ JSON response của MoMo dạng Map
     * (resultCode, message, payUrl, deeplink, qrCodeUrl...).
     */
    public static Map<String, Object> createPayment(String orderId, String requestId, long amount, String orderInfo,
            String extraData, String redirectUrl, String ipnUrl) {
        MomoConfig cfg = MomoConfig.get();
        String raw = buildCreateRawSignature(cfg.getAccessKey(), amount, extraData, ipnUrl, orderId,
                orderInfo, cfg.getPartnerCode(), redirectUrl, requestId, cfg.getRequestType());

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("partnerCode", cfg.getPartnerCode());
        body.put("partnerName", "Fashion Shop");
        body.put("storeId", "FashionShop");
        body.put("requestId", requestId);
        body.put("amount", amount);
        body.put("orderId", orderId);
        body.put("orderInfo", orderInfo);
        body.put("redirectUrl", redirectUrl);
        body.put("ipnUrl", ipnUrl);
        body.put("requestType", cfg.getRequestType());
        body.put("extraData", extraData);
        body.put("lang", cfg.getLang());
        body.put("signature", hmacSha256(raw, cfg.getSecretKey()));

        return postJson(cfg.getCreateUrl(), body, cfg.getTimeoutSeconds());
    }

    /** Gọi API truy vấn trạng thái giao dịch (dùng để đối soát khi IPN không tới được). */
    public static Map<String, Object> queryPayment(String orderId) {
        MomoConfig cfg = MomoConfig.get();
        String requestId = UUID.randomUUID().toString();
        String raw = "accessKey=" + cfg.getAccessKey()
                + "&orderId=" + orderId
                + "&partnerCode=" + cfg.getPartnerCode()
                + "&requestId=" + requestId;

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("partnerCode", cfg.getPartnerCode());
        body.put("requestId", requestId);
        body.put("orderId", orderId);
        body.put("lang", cfg.getLang());
        body.put("signature", hmacSha256(raw, cfg.getSecretKey()));

        return postJson(cfg.getQueryUrl(), body, cfg.getTimeoutSeconds());
    }

    /** Parse body JSON của IPN thành Map<String,String> (mọi giá trị đưa về chuỗi để ký lại). */
    public static Map<String, String> parseJsonToStringMap(String json) {
        try {
            Map<String, Object> raw = MAPPER.readValue(json, new TypeReference<Map<String, Object>>() {});
            Map<String, String> result = new LinkedHashMap<>();
            for (Map.Entry<String, Object> e : raw.entrySet()) {
                Object v = e.getValue();
                result.put(e.getKey(), v == null ? "" : (v instanceof String ? (String) v : String.valueOf(v)));
            }
            return result;
        } catch (IOException e) {
            throw new BusinessException("Dữ liệu IPN từ MoMo không phải JSON hợp lệ.");
        }
    }

    private static Map<String, Object> postJson(String url, Map<String, Object> body, int timeoutSeconds) {
        try {
            String json = MAPPER.writeValueAsString(body);
            HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                    .timeout(Duration.ofSeconds(timeoutSeconds))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                    .build();
            HttpResponse<String> response = HTTP.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            return MAPPER.readValue(response.body(), new TypeReference<Map<String, Object>>() {});
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new BusinessException("Kết nối tới MoMo bị gián đoạn, vui lòng thử lại.");
        } catch (IOException e) {
            throw new BusinessException("Không kết nối được tới cổng thanh toán MoMo, vui lòng thử lại sau.");
        }
    }
}
