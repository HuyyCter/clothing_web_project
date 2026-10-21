package com.ecommerce.model;

import com.ecommerce.dto.PaidCheckoutDTO;
import jakarta.persistence.EntityManager;

/**
 * "Điểm nối" giữa module thanh toán MoMo và module Order (Module E).
 *
 * Theo spec, đơn thanh toán online chỉ được tạo SAU KHI cổng thanh toán báo
 * thành công, trạng thái khởi tạo là CONFIRMED. Module MoMo không tự viết logic
 * tạo đơn (thuộc phạm vi thành viên làm Order) mà gọi qua interface này.
 *
 * Đã được đăng ký sẵn trong config/OrderPaymentHooks (Order.createPaidOrder) khi app khởi động:
 * <pre>
 *   MomoTransaction.registerOrderCreator((em, checkout) -&gt; Order.createPaidOrder(em, checkout));
 * </pre>
 *
 * Yêu cầu với implementation:
 * <ul>
 *   <li>Chạy trong transaction của {@code em} được truyền vào — KHÔNG tự begin/commit.</li>
 *   <li>Tạo Order (status CONFIRMED) + OrderItem từ {@code checkout.getItems()} (giá đã snapshot).</li>
 *   <li>Trừ tồn kho với khóa PESSIMISTIC_WRITE (invariant 1), gọi {@code Voucher.redeem(...)}
 *       nếu có voucherCode, và {@code Cart.clear(em, userId)}.</li>
 *   <li>KHÔNG tạo bản ghi Payment — module MoMo tự tạo sau khi nhận về orderId.</li>
 *   <li>Ném BusinessException nếu không tạo được đơn (vd hết hàng) — giao dịch MoMo vẫn
 *       giữ trạng thái SUCCESS và lỗi được ghi lại để Admin xử lý hoàn tiền.</li>
 * </ul>
 */
@FunctionalInterface
public interface PaidOrderCreator {

    /**
     * @return id của Order vừa tạo
     */
    int createPaidOrder(EntityManager em, PaidCheckoutDTO checkout);
}
