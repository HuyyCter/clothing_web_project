package com.ecommerce.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Đọc cấu hình MoMo từ file {@code momo.properties} trong classpath
 * (src/main/resources). Không hardcode secret trong code — theo architecture.md.
 *
 * File được nạp lười (lazy) ở lần dùng đầu tiên, nên app vẫn khởi động bình
 * thường khi chưa có file; chỉ khi khách chọn thanh toán MoMo mới báo lỗi rõ ràng.
 */
public final class MomoConfig {

    private static final String CONFIG_FILE = "momo.properties";
    private static volatile MomoConfig instance;

    private final String partnerCode;
    private final String accessKey;
    private final String secretKey;
    private final String endpoint;
    private final String redirectUrl;
    private final String ipnUrl;
    private final String requestType;
    private final String lang;
    private final int timeoutSeconds;

    private MomoConfig(Properties props) {
        this.partnerCode = required(props, "momo.partnerCode");
        this.accessKey = required(props, "momo.accessKey");
        this.secretKey = required(props, "momo.secretKey");
        this.endpoint = stripTrailingSlash(required(props, "momo.endpoint"));
        this.redirectUrl = required(props, "momo.redirectUrl");
        this.ipnUrl = required(props, "momo.ipnUrl");
        this.requestType = props.getProperty("momo.requestType", "payWithMethod").trim();
        this.lang = props.getProperty("momo.lang", "vi").trim();
        this.timeoutSeconds = Integer.parseInt(props.getProperty("momo.timeoutSeconds", "30").trim());
    }

    public static MomoConfig get() {
        MomoConfig local = instance;
        if (local == null) {
            synchronized (MomoConfig.class) {
                local = instance;
                if (local == null) {
                    local = new MomoConfig(load());
                    instance = local;
                }
            }
        }
        return local;
    }

    private static Properties load() {
        Properties props = new Properties();
        try (InputStream in = MomoConfig.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (in == null) {
                throw new IllegalStateException("Không tìm thấy file " + CONFIG_FILE
                        + " trong classpath. Hãy copy momo.properties.example thành momo.properties.");
            }
            props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Không đọc được file " + CONFIG_FILE, e);
        }
        return props;
    }

    private static String required(Properties props, String key) {
        String value = props.getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException("Thiếu cấu hình '" + key + "' trong " + CONFIG_FILE);
        }
        return value.trim();
    }

    private static String stripTrailingSlash(String url) {
        return url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
    }

    public String getPartnerCode() { return partnerCode; }
    public String getAccessKey() { return accessKey; }
    public String getSecretKey() { return secretKey; }
    public String getEndpoint() { return endpoint; }
    public String getCreateUrl() { return endpoint + "/v2/gateway/api/create"; }
    public String getQueryUrl() { return endpoint + "/v2/gateway/api/query"; }
    public String getRedirectUrl() { return redirectUrl; }
    public String getIpnUrl() { return ipnUrl; }
    public String getRequestType() { return requestType; }
    public String getLang() { return lang; }
    public int getTimeoutSeconds() { return timeoutSeconds; }
}
