# Code Standards

## General

- Mỗi lớp (Servlet, Model, Repository) chỉ đảm nhiệm 1 nhóm
  chức năng liên quan — không nhồi logic của nhiều nghiệp vụ khác
  nhau vào cùng 1 class.
- Sửa lỗi tận gốc (root cause), không vá tạm bằng cách thêm điều
  kiện chắp vá ở tầng trên.
- Controller không được chứa business logic; Model chứa toàn bộ
  business logic (không có Service riêng); Repository không được
  chứa business logic — mỗi tầng chỉ làm đúng việc của mình (xem
  `architecture.md` — System Boundaries).

## Java

- Class, Interface, Model: `PascalCase` (vd `ProductVariant`,
  `Order`).
- Method, biến, field: `camelCase` (vd `getProductById`,
  `totalAmount`).
- Hằng số (`static final`): `UPPER_SNAKE_CASE` (vd
  `MAX_PAGE_SIZE`).
- Tên package: toàn bộ chữ thường, không dấu gạch dưới (vd
  `com.ecommerce.model`).
- Không dùng scriptlet Java (`<% %>`) trong JSP — chỉ dùng JSTL
  (`<c:forEach>`, `<c:if>`, `<c:choose>`) và EL (`${...}`).
- DTO và Model tách biệt hoàn toàn: Model chứa business logic,
  gọi trực tiếp Repository, không bao giờ lộ ra Controller/JSP;
  DTO dùng khi Controller nhận dữ liệu từ form hoặc truyền dữ liệu
  ra JSP. Mapping Model ↔ DTO thực hiện thủ công qua constructor
  hoặc static factory method (không dùng MapStruct/ModelMapper,
  giữ đơn giản cho đồ án).

## Servlet/JSP

- 1 Servlet phụ trách 1 nhóm chức năng liên quan (vd `ProductServlet`
  xử lý cả list và detail sản phẩm), không tách vụn thành nhiều
  Servlet cho từng action nhỏ.
- Servlet chỉ làm: đọc request parameter → validate cơ bản (Bean
  Validation trên DTO) → gọi business method trên Model tương ứng
  → set attribute vào request → `forward()` sang JSP. Không tự
  query DB, không tự mở transaction (transaction do Model quản lý).
- Không dùng `redirect` để chuyển trang sau khi submit form thành
  công trong luồng chính (giữ đơn giản, dùng `forward` xuyên suốt
  theo đúng yêu cầu môn học) — chỉ dùng `redirect` khi thực sự cần
  đổi URL trên trình duyệt (vd sau khi thanh toán online quay về).
- Đăng ký Servlet bằng annotation `@WebServlet` (không khai báo
  trong `web.xml`, trừ filter và error-page).

## Styling

- CSS thuần, không dùng framework (Bootstrap/Tailwind).
- Toàn bộ màu sắc lấy từ CSS variable định nghĩa trong
  `ui-context.md` — cấm hardcode mã hex trong file CSS của từng
  component/trang.
- Tổ chức CSS theo module, khớp với cấu trúc JSP: `product.css`,
  `cart.css`, `order.css`, `admin.css`, `common.css` (chứa
  variable + reset + layout dùng chung).
- JS thuần (vanilla), chỉ dùng cho validate form phía client và
  tương tác nhỏ (vd tăng/giảm số lượng trong giỏ hàng qua AJAX).
  Không dùng framework JS ngoài.

## Validation

- Field đơn giản (bắt buộc nhập, định dạng email, độ dài chuỗi,
  giá trị số dương...) validate bằng Jakarta Bean Validation
  annotation trên DTO (`@NotBlank`, `@Email`, `@Min`, `@Size`...),
  chạy qua `Validator` (Hibernate Validator) ngay tại Controller
  trước khi gọi Model.
- Business rule phức tạp (không cho hủy đơn đã giao, không cho
  mua vượt tồn kho, voucher phải `isActive`, còn trong khoảng
  `startAt`–`endAt`, chưa vượt `usageLimit`, đơn đạt
  `minOrderAmount`, user phải đã mua mới được review...) validate
  bằng if/else thuần ngay trong business method của Model, ném
  `BusinessException` kèm message rõ ràng khi vi phạm.

## Exception Handling

- Toàn bộ Exception từ Controller/Model được bắt tập trung tại
  `GlobalExceptionFilter` (implements `jakarta.servlet.Filter`,
  bọc quanh toàn bộ filter chain).
- Exception hierarchy cố định, mỗi loại map 1 HTTP status:
  - `BusinessException` → 400
  - `ValidationException` → 422
  - `UnauthorizedException` → 401
  - `NotFoundException` → 404
- Với request thông thường (form submit, forward render HTML):
  `GlobalExceptionFilter` forward sang JSP lỗi tương ứng
  (`error-400.jsp`, `error-404.jsp`, `error-500.jsp`...), truyền
  message qua request attribute để hiển thị cho user.
- Với request AJAX (nhận diện qua header
  `X-Requested-With: XMLHttpRequest`): trả JSON theo chuẩn
  Problem Detail (RFC 7807), gồm đủ 4 field:
  `type`, `title`, `status`, `detail`, `instance`.
- Cấm try-catch rải rác trong Model/Repository, trừ trường hợp
  cần rollback transaction hoặc wrap Exception gốc thành custom
  Exception rồi re-throw.

## Data and Storage

- Toàn bộ dữ liệu quan hệ (user, sản phẩm, biến thể, đơn hàng,
  voucher, review, wishlist...) lưu trong PostgreSQL, quản lý qua
  JPA Model (Entity).
- Ảnh sản phẩm không lưu trong DB hay ổ đĩa server — upload qua
  Cloudinary, DB chỉ lưu URL trả về.
- Tên bảng dùng `snake_case`, số nhiều (vd `products`,
  `order_items`, `product_variants`).
- Repository chỉ chứa CRUD + query (JPQL/Criteria), không tự mở
  hoặc đóng transaction — transaction boundary do Model quản lý.

## File Organization

- `controller/` — Servlet, nhận request, gọi method trên Model,
  forward JSP.
- `model/` — JPA Entity kiêm business logic: transaction, state
  machine, tính voucher, trừ/hoàn tồn kho.
- `repository/` — DAO, thao tác `EntityManager` (được Model
  truyền vào).
- `dto/` — Data Transfer Object cho Controller ↔ JSP/Model.
- `validator/` — Custom validator cho business rule phức tạp.
- `exception/` — Custom Exception + `GlobalExceptionFilter`.
- `filter/` — `AuthFilter`, `AdminFilter`.
- `util/` — Helper dùng chung (`PasswordUtil`, `CloudinaryUtil`,
  `SlugUtil`, `PaginationUtil`, `JpaUtil` — lấy `EntityManager` từ
  `EntityManagerFactory` singleton cho Model dùng để mở
  transaction).
- `config/` — Khởi tạo `EntityManagerFactory`, cấu hình
  Cloudinary, VNPay, MoMo.