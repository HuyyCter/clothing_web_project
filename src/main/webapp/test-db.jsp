<%@ page import="jakarta.persistence.EntityManager" %>
<%@ page import="com.ecommerce.util.JpaUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Khởi tạo Database - Clothing Web</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
            padding: 40px;
            max-width: 800px;
            margin: 0 auto;
        }
        .card {
            background: white;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        .success {
            color: #15803d;
            background-color: #f0fdf4;
            border: 1px solid #bbf7d0;
            padding: 16px;
            border-radius: 6px;
            margin-top: 16px;
        }
        .error {
            color: #b91c1c;
            background-color: #fef2f2;
            border: 1px solid #fecaca;
            padding: 16px;
            border-radius: 6px;
            margin-top: 16px;
        }
        pre {
            background: #1e293b;
            color: #f8fafc;
            padding: 12px;
            border-radius: 4px;
            overflow-x: auto;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Trạng thái Khởi tạo Hệ thống (JPA / PostgreSQL)</h2>
        <%
            try {
                EntityManager em = JpaUtil.createEntityManager();
                em.getTransaction().begin();
                em.getTransaction().commit();
                em.close();
        %>
            <div class="success">
                <h3>Khởi tạo JPA thành công!</h3>
                <p>Kết nối Cơ sở dữ liệu và các bảng đã được đồng bộ tự động vào PostgreSQL.</p>
            </div>
        <%
            } catch (Throwable e) {
        %>
            <div class="error">
                <h3>Lỗi kết nối / Khởi tạo Cơ sở dữ liệu:</h3>
                <p><strong>Thông báo:</strong> <%= e.getMessage() != null ? e.getMessage() : e.toString() %></p>
                <p>Chi tiết lỗi:</p>
                <pre><% e.printStackTrace(new java.io.PrintWriter(out)); %></pre>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>