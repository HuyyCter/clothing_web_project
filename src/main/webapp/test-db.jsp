<%@ page import="jakarta.persistence.Persistence" %>
<%@ page import="jakarta.persistence.EntityManagerFactory" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Khởi tạo Database</title>
</head>
<body>
<%
    EntityManagerFactory emf = null;
    try {
        // "ClothingWebPU" là tên persistence-unit trong persistence.xml
        emf = Persistence.createEntityManagerFactory("ClothingWebPU");
        out.println("<h3 style='color:green;'>Khởi tạo JPA thành công! Kiểm tra PostgreSQL để xem các bảng đã tạo.</h3>");
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Lỗi khởi tạo: " + e.getMessage() + "</h3>");
        // Log lỗi ra console/file log của Server thay vì in ra màn hình JSP
        e.printStackTrace(); 
    } finally {
        if (emf != null && emf.isOpen()) {
            emf.close(); // Đảm bảo luôn đóng EMF kể cả khi có lỗi
        }
    }
%>
</body>
</html>