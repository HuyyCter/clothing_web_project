package com.ecommerce.model;

/**
 * Trạng thái của 1 giao dịch MoMo (khớp enum PaymentStatus trên class diagram:
 * PENDING / SUCCESS / FAILED). Đặt tên riêng để không đụng tới class
 * PaymentStatus nếu thành viên phụ trách Payment tạo sau này.
 */
public enum MomoTransactionStatus {
    /** Đã tạo link thanh toán, đang chờ khách trả tiền. */
    PENDING,
    /** MoMo xác nhận đã trừ tiền thành công (resultCode 0 / 9000). */
    SUCCESS,
    /** Khách hủy, hết hạn, lỗi... — không trừ tiền. */
    FAILED
}
