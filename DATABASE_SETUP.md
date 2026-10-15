# Hướng dẫn Cài đặt & Sử dụng Database (Dành cho thành viên nhóm)

Tài liệu này hướng dẫn cách cấu hình cơ sở dữ liệu PostgreSQL cục bộ để chạy dự án `clothing_web_project` và sử dụng các tài khoản kiểm thử đã tạo sẵn.

---

## 1. Yêu cầu môi trường

- **PostgreSQL** (khuyến nghị phiên bản 15 trở lên, đang chạy trên cổng mặc định `5432`).
- **Apache Tomcat 10+** (Jakarta EE namespace).

---

## 2. Các bước thiết lập khi kéo code về máy mới

### Bước 1: Tạo database trống trên PostgreSQL
Mở **pgAdmin** hoặc dòng lệnh (psql) và chạy lệnh:

```sql
CREATE DATABASE clothing_web;
```

---

### Bước 2: Tạo file cấu hình `persistence.xml`
Vì lý do bảo mật, file `persistence.xml` chứa mật khẩu cá nhân được đưa vào `.gitignore` (không đẩy lên git).

1. Vào thư mục: `src/main/resources/META-INF/`
2. Tạo bản sao từ file mẫu:
   - Copy file `persistence.xml.example` thành file mới có tên `persistence.xml` (cùng thư mục).
3. Mở file `persistence.xml` vừa tạo, tìm đến dòng cấu hình mật khẩu và điền mật khẩu PostgreSQL trên máy của bạn:

```xml
<property name="jakarta.persistence.jdbc.url" value="jdbc:postgresql://localhost:5432/clothing_web" />
<property name="jakarta.persistence.jdbc.user" value="postgres" />
<property name="jakarta.persistence.jdbc.password" value="MẬT_KHẨU_POSTGRES_CỦA_BẠN" />
```

---

### Bước 3: Nạp dữ liệu & Tài khoản kiểm thử

Bạn có thể chọn **1 trong 2 cách** sau:

#### Cách 1: Tự động (Khuyên dùng)
- Dự án đã tích hợp `AppContextListener` và chế độ `hibernate.hbm2ddl.auto=update`.
- Khi bạn khởi động Tomcat (qua SmartTomcat hoặc Eclipse/IntelliJ), hệ thống sẽ **tự động tạo toàn bộ các bảng quan hệ** và **tự động seed sẵn 2 tài khoản** (Admin và User) vào database nếu chưa có.

#### Cách 2: Chạy file SQL thủ công
- Nếu muốn nạp dữ liệu ngay trước khi bật server, mở pgAdmin (Query Tool) chọn database `clothing_web` và chạy script:
  - File: [`database/init_database.sql`](./database/init_database.sql) (Nạp bảng users và tài khoản test).
  - Hoặc file: [`database/seed_database.sql`](./database/seed_database.sql) (Dump đầy đủ cấu trúc DB).

---

## 3. Tài khoản kiểm thử đăng nhập

Truy cập đường dẫn đăng nhập: `http://localhost:8080/ecommerce-web/login`

| Vai trò | Email | Mật khẩu | Trang chuyển hướng sau khi đăng nhập |
| :--- | :--- | :--- | :--- |
| **Quản trị viên (ADMIN)** | `admin@clothingstore.com`<br>*(hoặc `admin@admin.com`)* | `admin123` | `/admin/dashboard` &rarr; Giao diện Quản trị viên (`dashboard.jsp`) |
| **Khách hàng (CUSTOMER)** | `user@clothingstore.com`<br>*(hoặc `user@user.com`)* | `user123` | `/index.jsp` &rarr; Giao diện Cửa hàng dành cho Khách hàng |

---

## 4. Những file cần commit khi push lên Git

Khi thực hiện lệnh `git commit` và `git push`, hãy đảm bảo các file sau được đẩy lên:
- `database/init_database.sql` (Script SQL nạp tài khoản mẫu)
- `database/seed_database.sql` (File dump PostgreSQL hoàn chỉnh)
- `DATABASE_SETUP.md` (Hướng dẫn này)
- `src/main/java/com/ecommerce/config/AppContextListener.java` (Cơ chế auto-seed khi bật server)
- `src/main/java/com/ecommerce/controller/AdminDashboardServlet.java` (Điều hướng Admin)
- `src/main/resources/META-INF/persistence.xml.example` (File mẫu cấu hình DB)

> **Lưu ý:** Không gỡ `persistence.xml` khỏi `.gitignore` để tránh xung đột mật khẩu cá nhân giữa các thành viên trong nhóm.
