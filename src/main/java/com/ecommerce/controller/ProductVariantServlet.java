
package com.ecommerce.controller;

import java.io.IOException;
import java.util.List;

import com.ecommerce.model.ProductVariant;
import com.ecommerce.repository.ProductVariantDB;
import com.ecommerce.util.JpaUtil;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ecommerce.model.ProductImage;
import com.ecommerce.repository.ProductImageDB;
@WebServlet("/product-variants")
public class ProductVariantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String productIdParam = request.getParameter("productId");

        if (productIdParam == null || productIdParam.isBlank()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Thiếu productId"
            );
            return;
        }

        int productId;

        try {
            productId = Integer.parseInt(productIdParam);

            if (productId <= 0) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "productId không hợp lệ"
                );
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "productId không hợp lệ"
            );
            return;
        }

        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            List<ProductVariant> variants =
                ProductVariantDB.findAvailableByProductId(em, productId);

            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            for (ProductVariant variant : variants) {
                if (!first) {
                    json.append(",");
                }

                json.append("{")
                    .append("\"id\":").append(variant.getId()).append(",")
                    .append("\"size\":\"")
                    .append(escapeJson(variant.getSize()))
                    .append("\",")
                    .append("\"color\":\"")
                    .append(escapeJson(variant.getColor()))
                    .append("\",")
                    .append("\"price\":")
                    .append(variant.getPrice() == null
                        ? "null"
                        : variant.getPrice().toPlainString())
                    .append(",");

                    ProductImage productImage =
                            ProductImageDB.findByProductIdAndColor(
                                    em,
                                    productId,
                                    variant.getColor()
                            );

                    json.append("\"imageUrl\":");

                    if (productImage == null || productImage.getImageUrl() == null) {
                        json.append("null");
                    } else {
                        json.append("\"")
                            .append(escapeJson(productImage.getImageUrl()))
                            .append("\"");
                    }

                    json.append("}");

                first = false;
            }

            json.append("]");
            response.getWriter().write(json.toString());

        } finally {
            em.close();
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }

        return value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
    }
}
