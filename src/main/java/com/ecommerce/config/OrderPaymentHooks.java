package com.ecommerce.config;

import com.ecommerce.model.MomoTransaction;
import com.ecommerce.model.Order;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Nối module thanh toán MoMo với module Order khi app khởi động:
 * sau khi MoMo xác nhận thanh toán thành công, MomoTransaction gọi Order.createPaidOrder để tạo đơn
 * (trạng thái "Đã xác nhận", trừ kho, ghi nhận voucher, làm trống giỏ).
 */
@WebListener
public class OrderPaymentHooks implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        MomoTransaction.registerOrderCreator(Order::createPaidOrder);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        MomoTransaction.registerOrderCreator(null);
    }
}
