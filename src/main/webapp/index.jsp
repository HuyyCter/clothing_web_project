<%@ page import="jakarta.persistence.Persistence" %>
    <%@ page import="jakarta.persistence.EntityManagerFactory" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <html>

            <head>
                <title>Khởi tạo Database</title>
            </head>

            <body>
                <% try { // "ClothingWebPU" là tên persistence-unit trong file persistence.xml của bạn
                    EntityManagerFactory emf=Persistence.createEntityManagerFactory("ClothingWebPU"); out.println("<h3
                    style='color:green;'>Khởi tạo JPA thành công! Kiểm tra PostgreSQL để xem các bảng đã tạo.</h3>");
                    emf.close(); // Đóng EMF sau khi khởi tạo xong
                    } catch (Exception e) {
                    out.println("<h3 style='color:red;'>Lỗi khởi tạo: " + e.getMessage() + "</h3>");
                    e.printStackTrace(new java.io.PrintWriter(out));
                    }
                    %>
            </body>

            </html>