# Cấu trúc thư mục — Fashion Shop

## Cây thư mục

```text
fashion-shop/
├── pom.xml
├── .gitignore
├── README.md
├── GIT_WORKFLOW.md
├── context/
│   └── progress-tracker.md
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── ecommerce/
        │           ├── controller/        (Servlet — sẽ thêm khi code feature)
        │           ├── model/             (JPA Entity — sẽ thêm khi code feature)
        │           ├── repository/        (DAO — sẽ thêm khi code feature)
        │           ├── dto/               (DTO — sẽ thêm khi code feature)
        │           ├── validator/         (Custom validator — sẽ thêm khi code feature)
        │           ├── exception/
        │           │   ├── BusinessException.java
        │           │   ├── ValidationException.java
        │           │   ├── UnauthorizedException.java
        │           │   ├── NotFoundException.java
        │           │   └── GlobalExceptionFilter.java
        │           ├── filter/
        │           │   ├── AuthFilter.java
        │           │   └── AdminFilter.java
        │           ├── util/
        │           │   ├── JpaUtil.java
        │           │   ├── PasswordUtil.java
        │           │   ├── SlugUtil.java
        │           │   ├── PaginationUtil.java
        │           │   └── CloudinaryUtil.java
        │           └── config/
        │               ├── AppContextListener.java
        │               └── CloudinaryConfig.java
        ├── resources/
        │   ├── META-INF/
        │   │   └── persistence.xml
        │   ├── db.properties.example
        │   ├── cloudinary.properties.example
        │   └── payment.properties.example
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml
            │   └── views/
            │       ├── product/    (JSP — sẽ thêm khi code feature)
            │       ├── cart/       (JSP — sẽ thêm khi code feature)
            │       ├── order/      (JSP — sẽ thêm khi code feature)
            │       ├── auth/       (JSP — sẽ thêm khi code feature)
            │       ├── admin/      (JSP — sẽ thêm khi code feature)
            │       └── error/
            │           ├── error-400.jsp
            │           ├── error-401.jsp
            │           ├── error-403.jsp
            │           ├── error-404.jsp
            │           ├── error-422.jsp
            │           └── error-500.jsp
            ├── index.jsp
            └── assets/
                ├── css/
                │   ├── common.css
                │   ├── product.css
                │   ├── cart.css
                │   ├── order.css
                │   └── admin.css
                ├── js/     (JS thuần — sẽ thêm khi cần)
                └── img/    (ảnh tĩnh — logo, favicon)
```

## Giải thích từng folder

### Gốc project

- **`pom.xml`** — khai báo project Maven: groupId/artifactId, toàn
  bộ dependency (Servlet, JPA/Hibernate, PostgreSQL, HikariCP,
  Bean Validation, jBCrypt, Cloudinary, Jackson), version JDK.
  Đây là file Maven đọc đầu tiên để biết build project như thế nào.
- **`.gitignore`** — liệt kê file/folder không commit lên git:
  `target/` (build output), file IDE (`.classpath`, `.idea/`...),
  và đặc biệt là 3 file `*.properties` chứa secret thật (DB
  password, Cloudinary key, VNPay/MoMo secret).
- **`README.md`** — hướng dẫn setup máy local: cần JDK/Maven/Tomcat
  bản nào, copy file `.properties.example` thành file thật ra sao,
  lệnh build (`mvn clean package`).
- **`GIT_WORKFLOW.md`** — quy tắc làm việc nhóm: cách chia
  feature-unit, đặt tên branch, quy trình PR, danh sách file dễ
  conflict cần báo nhóm trước khi sửa.
- **`context/`** — chứa các file tài liệu spec-driven
  (`progress-tracker.md` và về sau có thể thêm bản sao
  `project-overview.md`, `architecture.md`... nếu muốn đồng bộ
  ngay trong repo thay vì chỉ lưu ở Claude Project).

### `src/main/java/com/ecommerce/` — code Java, chia theo tầng kiến trúc

Đây là phần quan trọng nhất, đúng mô hình phân lớp trong
`architecture.md`. Request đi qua các tầng theo thứ tự:
`controller → model → repository`, không được nhảy tắt.

- **`controller/`** — chứa Servlet. Chỉ làm 4 việc: đọc tham số
  request → validate cơ bản → gọi method nghiệp vụ trên `model/` →
  forward sang JSP. Không viết business logic, không tự query DB
  ở đây.
- **`model/`** — chứa JPA Entity, nhưng khác với nhiều tutorial
  Spring bạn từng thấy: ở đây Entity **kiêm luôn** business logic
  (Rich Domain Model), vì project không có tầng Service riêng.
  Ví dụ: method trừ tồn kho, method chuyển trạng thái đơn hàng đều
  nằm trong class `Product`/`Order` ở đây, không nằm ở Controller.
- **`repository/`** — chứa DAO, chỉ làm nhiệm vụ query/ghi
  `EntityManager` (JPQL). Không chứa business logic, không tự mở
  transaction — transaction do `model/` quản lý và truyền
  `EntityManager` xuống.
- **`dto/`** — Data Transfer Object, dùng để đưa dữ liệu ra/vào
  giữa Controller và JSP, hoặc Controller và Model. Mục đích: JSP
  không bao giờ được cầm trực tiếp 1 JPA Entity (tránh lộ field
  nhạy cảm như `passwordHash`, tránh lỗi lazy-loading).
- **`validator/`** — nơi viết các rule phức tạp mà annotation
  (`@NotBlank`, `@Email`...) không diễn tả được, ví dụ: "voucher
  còn hạn dùng không", "tồn kho có đủ không".
- **`exception/`** — 4 custom Exception (`BusinessException`,
  `ValidationException`, `UnauthorizedException`,
  `NotFoundException`) và `GlobalExceptionFilter` — nơi duy nhất
  bắt lỗi tập trung cho toàn app, map mỗi loại Exception sang 1 mã
  HTTP status và forward sang trang lỗi tương ứng.
- **`filter/`** — `AuthFilter` (chặn URL cần đăng nhập) và
  `AdminFilter` (chặn `/admin/*` nếu không phải role ADMIN). Chạy
  trước khi request tới được Controller.
- **`util/`** — các class hỗ trợ dùng chung, không chứa business
  logic của riêng nghiệp vụ nào: `JpaUtil` (quản lý kết nối
  EntityManager), `PasswordUtil` (hash/verify mật khẩu),
  `SlugUtil` (sinh URL-friendly string cho category),
  `PaginationUtil` (tính offset/limit phân trang),
  `CloudinaryUtil` (upload/xóa ảnh).
- **`config/`** — nơi khởi tạo các thành phần dùng 1 lần lúc app
  start: `AppContextListener` (tạo `EntityManagerFactory`,
  Cloudinary client), `CloudinaryConfig` (đọc credential).

### `src/main/resources/` — cấu hình, không phải code Java

- **`META-INF/persistence.xml`** — khai báo persistence-unit cho
  JPA/Hibernate, cấu hình dialect PostgreSQL, HikariCP.
- **`*.properties.example`** — file mẫu cho DB, Cloudinary,
  VNPay/MoMo. Mỗi thành viên tự copy thành file thật
  (`db.properties`...) rồi điền thông tin riêng của máy mình, file
  thật không commit git.

### `src/main/webapp/` — phần chạy trên Tomcat (JSP, CSS, JS tĩnh)

- **`WEB-INF/web.xml`** — nơi duy nhất đăng ký Filter và error-page
  mapping (Servlet không đăng ký ở đây, dùng annotation
  `@WebServlet`).
- **`WEB-INF/views/`** — chứa file JSP, chia theo module nghiệp vụ
  (`product/`, `cart/`, `order/`, `auth/`, `admin/`). Đặt trong
  `WEB-INF` để không ai truy cập trực tiếp JSP qua URL — bắt buộc
  phải đi qua Servlet `forward()`.
- **`WEB-INF/views/error/`** — 6 trang lỗi tương ứng
  400/401/403/404/422/500, được `GlobalExceptionFilter` và
  `web.xml` forward tới khi có lỗi.
- **`index.jsp`** — trang chủ tạm, đặt ngoài `WEB-INF` nên truy cập
  trực tiếp được qua URL gốc.
- **`resources/css/`** — CSS thuần, chia theo module giống JSP.
  `common.css` là file gốc chứa toàn bộ CSS variable (màu,
  typography, spacing) — mọi file CSS khác chỉ được dùng
  `var(--...)` từ đây, cấm hardcode mã màu.
- **`resources/js/`** — JS thuần (vanilla), dùng cho validate form
  phía client.
- **`resources/img/`** — ảnh tĩnh của site (logo, favicon). Ảnh
  sản phẩm KHÔNG lưu ở đây — lưu trên Cloudinary.