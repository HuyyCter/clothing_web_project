package com.ecommerce.dto;

import java.io.Serializable;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

public class OtpSessionData implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final long TTL_MILLIS = 2 * 60 * 1000; // 2 phút (120 giây)
    public static final long RESEND_COOLDOWN_MILLIS = 30 * 1000; // 30 giây chờ gửi lại
    public static final int MAX_ATTEMPTS = 3;         // Tối đa 3 lần nhập sai

    private String code;
    private String targetEmail;
    private String purpose;
    private long createdAt;
    private long expiresAt;
    private long lastSentAt;
    private int attemptsLeft;
    private Map<String, String> payload = new HashMap<>();

    public OtpSessionData() {
    }

    public static OtpSessionData create(String targetEmail, String purpose, Map<String, String> payload) {
        OtpSessionData data = new OtpSessionData();
        data.targetEmail = targetEmail;
        data.purpose = purpose;
        data.payload = (payload != null) ? new HashMap<>(payload) : new HashMap<>();
        data.forceRefreshCode();
        return data;
    }

    public void forceRefreshCode() {
        SecureRandom random = new SecureRandom();
        int num = random.nextInt(1000000);
        this.code = String.format("%06d", num);
        this.createdAt = System.currentTimeMillis();
        this.expiresAt = this.createdAt + TTL_MILLIS;
        this.lastSentAt = this.createdAt;
        this.attemptsLeft = MAX_ATTEMPTS;
    }

    /**
     * Làm mới mã OTP nếu đã hết thời gian chờ 30s.
     * @return true nếu gửi lại được, false nếu còn trong cooldown 30s
     */
    public boolean refreshCode() {
        if (!canResend()) {
            return false;
        }
        forceRefreshCode();
        return true;
    }

    public boolean canResend() {
        return (System.currentTimeMillis() - this.lastSentAt) >= RESEND_COOLDOWN_MILLIS;
    }

    public long getResendCooldownRemainingSeconds() {
        long elapsed = System.currentTimeMillis() - this.lastSentAt;
        if (elapsed >= RESEND_COOLDOWN_MILLIS) {
            return 0;
        }
        return Math.max(0, (RESEND_COOLDOWN_MILLIS - elapsed) / 1000);
    }

    public boolean isExpired() {
        return System.currentTimeMillis() > this.expiresAt;
    }

    public long getRemainingSeconds() {
        long remaining = (this.expiresAt - System.currentTimeMillis()) / 1000;
        return Math.max(0, remaining);
    }

    /**
     * Xác thực mã OTP người dùng nhập vào.
     * @param enteredCode mã người dùng nhập
     * @return null nếu thành công; chuỗi thông báo lỗi nếu thất bại
     */
    public String verify(String enteredCode) {
        if (isExpired()) {
            return "Mã OTP đã hết hạn (chỉ có hiệu lực trong 2 phút). Vui lòng bấm 'Gửi lại mã'.";
        }
        if (attemptsLeft <= 0) {
            return "Bạn đã nhập sai quá số lần cho phép (3 lần). Mã OTP đã bị vô hiệu hóa. Vui lòng bấm 'Gửi lại mã'.";
        }

        if (enteredCode == null || !enteredCode.trim().equals(this.code)) {
            this.attemptsLeft--;
            if (this.attemptsLeft <= 0) {
                return "Bạn đã nhập sai mã OTP 3 lần. Mã đã bị hủy, vui lòng bấm 'Gửi lại mã' để nhận mã mới.";
            }
            return "Mã OTP không chính xác. Bạn còn " + this.attemptsLeft + " lần thử.";
        }

        return null; // Xác thực thành công
    }

    // ==========================================
    // GETTERS & SETTERS
    // ==========================================
    public String getCode() {
        return code;
    }

    public String getTargetEmail() {
        return targetEmail;
    }

    public void setTargetEmail(String targetEmail) {
        this.targetEmail = targetEmail;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public long getCreatedAt() {
        return createdAt;
    }

    public long getExpiresAt() {
        return expiresAt;
    }

    public long getLastSentAt() {
        return lastSentAt;
    }

    public int getAttemptsLeft() {
        return attemptsLeft;
    }

    public void setAttemptsLeft(int attemptsLeft) {
        this.attemptsLeft = attemptsLeft;
    }

    public Map<String, String> getPayload() {
        return payload;
    }

    public void setPayload(Map<String, String> payload) {
        this.payload = payload;
    }
}
