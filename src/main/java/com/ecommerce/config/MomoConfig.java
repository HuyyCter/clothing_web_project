package com.ecommerce.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Cấu hình cổng MoMo. Thứ tự ưu tiên cho mỗi giá trị:
 * <ol>
 *   <li>Biến môi trường (vd {@code MOMO_SECRET_KEY}) — dùng trên Render, giống BREVO_API_KEY của MailUtil.</li>
 *   <li>File {@code momo.properties} trong classpath (không commit, mỗi máy tự tạo từ momo.properties.example).</li>
 *   <li>Giá trị mặc định: khóa TEST CÔNG KHAI của MoMo (github.com/momo-wallet/payment) + endpoint sandbox.</li>
 * </ol>
 * redirectUrl / ipnUrl nếu không cấu hình sẽ tự suy ra từ địa chỉ website
 * (APP_BASE_URL hoặc chính request đang xử lý) — xem {@link #resolveRedirectUrl}.
 * Production bắt buộc đặt MOMO_PARTNER_CODE / MOMO_ACCESS_KEY / MOMO_SECRET_KEY / MOMO_ENDPOINT thật.
 */
public final class MomoConfig {

    private static final String CONFIG_FILE = "momo.properties";

    // Khóa test công khai của MoMo — chỉ chạy được trên sandbox
    private static final String SANDBOX_PARTNER_CODE = "MOMO";
    private static final String SANDBOX_ACCESS_KEY = "F8BBA842ECF85";
    private static final String SANDBOX_SECRET_KEY = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    private static final String SANDBOX_ENDPOINT = "https://test-payment.momo.vn";

    public static final String RETURN_PATH = "/payment/momo/return";
    public static final String IPN_PATH = "/payment/momo/ipn";

    private static volatile MomoConfig instance;

    private final String partnerCode;
    private final String accessKey;
    private final String secretKey;
    private final String endpoint;
    private final String redirectUrl; // có thể null → suy ra từ baseUrl
    private final String ipnUrl;      // có thể null → suy ra từ baseUrl
    private final String requestType;
    private final String lang;
    private final int timeoutSeconds;

    private MomoConfig(Properties props) {
        this.partnerCode = value(props, "MOMO_PARTNER_CODE", "momo.partnerCode", SANDBOX_PARTNER_CODE);
        this.accessKey = value(props, "MOMO_ACCESS_KEY", "momo.accessKey", SANDBOX_ACCESS_KEY);
        this.secretKey = value(props, "MOMO_SECRET_KEY", "momo.secretKey", SANDBOX_SECRET_KEY);
        this.endpoint = stripTrailingSlash(value(props, "MOMO_ENDPOINT", "momo.endpoint", SANDBOX_ENDPOINT));
        this.redirectUrl = value(props, "MOMO_REDIRECT_URL", "momo.redirectUrl", null);
        this.ipnUrl = value(props, "MOMO_IPN_URL", "momo.ipnUrl", null);
        this.requestType = value(props, "MOMO_REQUEST_TYPE", "momo.requestType", "payWithMethod");
        this.lang = value(props, "MOMO_LANG", "momo.lang", "vi");
        this.timeoutSeconds = Integer.parseInt(value(props, "MOMO_TIMEOUT_SECONDS", "momo.timeoutSeconds", "30"));
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

    /** Đọc momo.properties nếu có; không có file thì dùng biến môi trường / mặc định sandbox. */
    private static Properties load() {
        Properties props = new Properties();
        try (InputStream in = MomoConfig.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (in != null) {
                props.load(in);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Không đọc được file " + CONFIG_FILE, e);
        }
        return props;
    }

    private static String value(Properties props, String envKey, String propKey, String defaultValue) {
        String env = System.getenv(envKey);
        if (env != null && !env.trim().isEmpty()) {
            return env.trim();
        }
        String prop = props.getProperty(propKey);
        if (prop != null && !prop.trim().isEmpty()) {
            return prop.trim();
        }
        return defaultValue;
    }

    private static String stripTrailingSlash(String url) {
        return (url != null && url.endsWith("/")) ? url.substring(0, url.length() - 1) : url;
    }

    /** URL MoMo đưa trình duyệt của khách quay về: cấu hình sẵn, hoặc baseUrl + /payment/momo/return. */
    public String resolveRedirectUrl(String baseUrl) {
        return redirectUrl != null ? redirectUrl : stripTrailingSlash(baseUrl) + RETURN_PATH;
    }

    /** URL MoMo gọi server-to-server (IPN): cấu hình sẵn, hoặc baseUrl + /payment/momo/ipn. */
    public String resolveIpnUrl(String baseUrl) {
        return ipnUrl != null ? ipnUrl : stripTrailingSlash(baseUrl) + IPN_PATH;
    }

    public boolean isSandbox() { return endpoint.contains("test-payment"); }
    public String getPartnerCode() { return partnerCode; }
    public String getAccessKey() { return accessKey; }
    public String getSecretKey() { return secretKey; }
    public String getEndpoint() { return endpoint; }
    public String getCreateUrl() { return endpoint + "/v2/gateway/api/create"; }
    public String getQueryUrl() { return endpoint + "/v2/gateway/api/query"; }
    public String getRequestType() { return requestType; }
    public String getLang() { return lang; }
    public int getTimeoutSeconds() { return timeoutSeconds; }
}
