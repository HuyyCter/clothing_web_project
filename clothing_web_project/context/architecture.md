# Architecture Context

## Stack

| Layer               | Technology                                         | Role                                                                                      |
| -------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Web Framework         | Jakarta Servlet 6.0 + JSP + JSTL                    | Nhận HTTP request, xử lý MVC, render HTML phía server bằng forward (không dùng scriptlet). |
| Build Tool            | Maven (`maven-archetype-webapp`)                    | Quản lý dependency, đóng gói WAR để deploy lên Tomcat.                                     |
| Application Server    | Apache Tomcat 10                                    | Servlet container chạy WAR, namespace Jakarta.                                            |
| ORM                   | Hibernate/JPA (Jakarta Persistence, thuần)          | Ánh xạ Model (Entity) ↔ bảng PostgreSQL, quản lý transaction thủ công qua `EntityManager`. Có thể đổi sang JDBC thuần nếu giảng viên yêu cầu (xem `progress-tracker.md` — Open Questions). |
| Database              | PostgreSQL                                          | Lưu toàn bộ dữ liệu quan hệ: user, sản phẩm, biến thể, đơn hàng, voucher, review...          |
| Connection Pool       | HikariCP                                            | Quản lý pool connection tới PostgreSQL, cấu hình trong `persistence.xml`.                  |
| Validation            | Validate thủ công (if/else) trong class `validator/` | Validate field đơn giản (bắt buộc nhập, độ dài...) tại Controller, trả thông báo lỗi để hiển thị lại form. |
| Password Hashing      | jBCrypt                                             | Hash và verify mật khẩu user, không lưu plain text.                                        |
| File/Image Storage    | Cloudinary (free tier)                              | Lưu ảnh sản phẩm (theo từng màu), trả về URL lưu trong PostgreSQL.                         |
| Payment Gateway       | VNPay + MoMo (sandbox)                              | Redirect thanh toán online + xử lý callback (IPN) xác nhận kết quả.                        |
| Frontend Rendering    | JSP + JSTL + CSS thuần                              | Render giao diện phía server, không dùng React/Tailwind/thư viện JS ngoài.                |
| Session Management    | Jakarta `HttpSession`                               | Lưu trạng thái đăng nhập (`userId`, `role`) sau khi login thành công.                      |
| IDE                   | Eclipse                                             | Môi trường phát triển chính.                                                               |

## System Boundaries

- `src/main/java/com/ecommerce/controller/` — Servlet.
  Nhận HTTP request, đọc param, validate cơ bản (gọi Bean
  Validation), gọi method nghiệp vụ trên Model tương ứng, set
  attribute và forward sang JSP. Không chứa business logic, không
  query DB trực tiếp.
- `src/main/java/com/ecommerce/model/` — JPA Entity kiêm
  business logic (Rich Domain Model, không có Service riêng).
  Chứa field, quan hệ (`@OneToMany`, `@ManyToOne`...) VÀ toàn bộ
  business method (state machine đơn hàng, trừ/hoàn tồn kho, tính
  voucher...). Mỗi business method tự mở/đóng transaction
  (`EntityManager.getTransaction()`) qua `JpaUtil.getEntityManager()`
  (helper trong `util/`), gọi Repository để đọc/ghi DB trong
  transaction đó.
- `src/main/java/com/ecommerce/repository/` — DAO, thao
  tác trực tiếp với `EntityManager` (JPQL/Criteria) được Model
  truyền vào. Chỉ chứa query, không chứa business logic, không
  tự mở/đóng transaction (transaction boundary do Model quản lý).
- `src/main/java/com/ecommerce/dto/` — Data Transfer
  Object, dùng để truyền dữ liệu giữa Controller ↔ JSP và
  Controller ↔ Model. Tách biệt hoàn toàn với Model (không bao
  giờ để Model lộ ra ngoài Controller/JSP).
- `src/main/java/com/ecommerce/validator/` — Validator viết
  thủ công (if/else), mỗi nhóm chức năng 1 class (vd
  `CategoryValidator`), kiểm tra dữ liệu form (bắt buộc nhập, độ
  dài...) và trả về thông báo lỗi. Business rule phức tạp (tồn kho,
  voucher...) vẫn nằm trong business method của Model.
- `src/main/java/com/ecommerce/exception/` — Custom
  Exception hierarchy (`BusinessException`, `NotFoundException`,
  `UnauthorizedException`, `ValidationException`) và
  `GlobalExceptionFilter` xử lý tập trung.
- `src/main/java/com/ecommerce/filter/` — `AuthFilter`
  (chặn URL cần đăng nhập), `AdminFilter` (chặn `/admin/*` nếu
  role khác ADMIN), `GlobalExceptionFilter`.
- `src/main/java/com/ecommerce/util/` — Helper dùng
  chung: `PasswordUtil` (BCrypt), `CloudinaryUtil`, `SlugUtil`,
  `PaginationUtil`, `JpaUtil` (lấy `EntityManager` từ
  `EntityManagerFactory` singleton cho Model dùng để mở
  transaction).
- `src/main/java/com/ecommerce/config/` — Khởi tạo
  `EntityManagerFactory` (singleton qua `ServletContextListener`),
  cấu hình Cloudinary SDK, cấu hình VNPay/MoMo (merchant id, secret
  key đọc từ file properties, không hardcode).
- `src/main/resources/META-INF/persistence.xml` — Cấu hình JPA +
  datasource HikariCP.
- `src/main/webapp/WEB-INF/views/` — File JSP, tổ chức theo module
  con: `product/`, `cart/`, `order/`, `auth/`, `admin/`, `error/`.
- `src/main/webapp/resources/` — CSS thuần, JS thuần (vanilla),
  ảnh tĩnh (logo, favicon). Ảnh sản phẩm KHÔNG lưu ở đây (lưu
  Cloudinary).
- `src/main/webapp/WEB-INF/web.xml` — Đăng ký filter, error-page
  mapping (404, 500 → JSP lỗi tương ứng).

## Storage Model

- **PostgreSQL**: lưu toàn bộ dữ liệu quan hệ — user, address,
  category, product, product_variant, product_image (URL
  Cloudinary), cart, cart_item, order, order_item, payment,
  voucher, review, wishlist.
- **Cloudinary**: lưu file ảnh thật (binary) của sản phẩm, theo
  từng biến thể/màu. PostgreSQL chỉ lưu URL trả về từ Cloudinary,
  không lưu binary trong DB.
- **Không dùng cache/Redis** ở giai đoạn này (out of scope) — mọi
  truy vấn đọc trực tiếp từ PostgreSQL qua JPA.

## Auth and Access Model

- Đăng nhập thành công → tạo `HttpSession`, lưu `userId` và `role`
  (không dùng JWT — phù hợp với yêu cầu học Servlet/JSP thuần của
  giảng viên).
- `AuthFilter` áp dụng cho các URL yêu cầu đăng nhập (giỏ hàng,
  checkout, profile, đặt review, wishlist...) — nếu session không
  có `userId`, redirect về trang login.
- `AdminFilter` áp dụng cho mọi URL dưới `/admin/*` — nếu
  `role != ADMIN`, trả lỗi 403 (forward sang `error-403.jsp`).
- Ownership check (user chỉ thấy/thao tác dữ liệu của chính mình —
  giỏ hàng, đơn hàng, địa chỉ, review) được enforce ở **Model
  layer**: mọi business method nhận `userId` (Controller lấy từ
  session truyền vào) và so khớp với `userId` sở hữu resource
  trước khi đọc/ghi. Controller không tự ý tin tưởng `userId`
  truyền từ request param.
- Mật khẩu hash bằng jBCrypt, không bao giờ lưu hoặc log plain
  text.

## Invariants

1. Không được bán âm tồn kho. Mọi thao tác trừ tồn kho (khi tạo
   đơn) phải nằm trong 1 transaction có khóa `PESSIMISTIC_WRITE`
   trên dòng `ProductVariant` liên quan, để tránh race condition
   khi 2 người mua cùng lúc.
2. Đơn hàng chỉ được chuyển trạng thái theo đúng state machine đã
   định nghĩa (`Chờ xác nhận → Đã xác nhận → Đang giao → Đã giao`,
   `Hủy` chỉ từ `Chờ xác nhận`/`Đã xác nhận`). **Model layer** phải
   validate transition hợp lệ trước khi update; Controller/Repository
   không được set trạng thái tùy ý.
3. Khi đơn hàng chuyển sang trạng thái `Hủy`, hệ thống phải hoàn
   trả (cộng lại) đúng số lượng tồn kho đã trừ trước đó cho từng
   biến thể trong đơn, trong cùng 1 transaction với việc đổi
   trạng thái.
4. User chỉ được xem/sửa dữ liệu thuộc sở hữu của chính mình (giỏ
   hàng, đơn hàng, địa chỉ, review, wishlist) — **Model layer** luôn
   kiểm tra `userId` từ session khớp với chủ sở hữu resource trước
   khi thực hiện thao tác.
5. Model (JPA Entity) không bao giờ được truyền trực tiếp ra
   Controller hoặc JSP — luôn phải map qua DTO trước, để tránh lộ
   field nhạy cảm (`passwordHash`) và tránh lỗi lazy-loading ngoài
   transaction.
6. Mọi Exception phải được xử lý tập trung tại `GlobalExceptionFilter`
   — cấm try-catch rải rác trong Model/Repository, trừ trường
   hợp cần rollback transaction hoặc wrap thành custom Exception
   rồi re-throw.
7. Đơn hàng (Order) không tham chiếu FK trực tiếp tới Address. Tại thời điểm tạo đơn, hệ thống copy (snapshot) recipientName, phone, addressLine từ Address đã chọn vào 3 field shippingRecipientName, shippingPhone, shippingAddressLine ngay trong Order. Mục đích: đảm bảo lịch sử đơn hàng không bị thay đổi ngược nếu user sau này sửa/xóa Address gốc — cùng nguyên tắc với snapshot giá ở OrderItem.unitPrice.