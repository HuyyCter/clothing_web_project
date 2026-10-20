# Progress Tracker

Update this file after every meaningful implementation
change.

## Current Phase

- Code phần Admin: unit "CRUD Category" — đã xong repository, Model,
  Servlet, JSP; chưa test thủ công end-to-end trên Tomcat.

## Current Goal

- Hoàn thiện đầy đủ 6 file context (`project-overview.md`,
  `architecture.md`, `code-standards.md`, `ai-workflow-rules.md`,
  `ui-context.md`, `progress-tracker.md`) trước khi bắt đầu chia
  unit và code. Hiện đang chờ chốt bảng màu cụ thể cho
  `ui-context.md`.

## Completed

- `model/Category.java` (id, name, description, slug) — khớp class diagram, danh mục phẳng. Có business method create, update, delete, getById, getAll.
- `dto/CategoryDTO.java`, `validator/CategoryValidator.java`, `controller/AdminCategoryServlet.java`.
- `views/admin/category-list.jsp`, `category-form.jsp` — nối với Servlet bằng JSTL.
- `util/SlugUtil.java`, `repository/CategoryDB.java`.
- [x] `src/main/webapp/index.jsp` — Giao diện trang chủ cửa hàng (Hero banner, danh mục nổi bật, sản phẩm mới, tính năng).
- [x] `src/main/webapp/assets/css/admin.css` & `common.css` — Hệ thống design token và CSS thuần quản trị viên.
- [x] `src/main/webapp/WEB-INF/views/admin/dashboard.jsp` — Tổng quan thống kê doanh thu, đơn hàng, khách hàng, biểu đồ và bảng hoạt động.
- [x] `src/main/webapp/WEB-INF/views/admin/product-list.jsp` & `product-form.jsp` — Quản lý sản phẩm, biến thể và liên kết ảnh Cloudinary.
- [x] `src/main/webapp/WEB-INF/views/admin/order-list.jsp` & `order-detail.jsp` — Danh sách và chi tiết đơn hàng.
- [x] `src/main/webapp/WEB-INF/views/admin/voucher-list.jsp` & `voucher-form.jsp` — Quản lý voucher.
- [x] `src/main/java/com/ecommerce/model/Address.java` — Entity Address có recipientName và phone.
- [x] `src/main/java/com/ecommerce/util/PasswordUtil.java` — Helper băm và xác thực mật khẩu qua jBCrypt.
- [x] `src/main/java/com/ecommerce/repository/UserRepository.java` & `UserDB.java` — Quản lý truy vấn User.
- [x] `src/main/java/com/ecommerce/controller/LoginServlet.java` — Servlet xác thực đăng nhập session.
- [x] `src/main/webapp/login.jsp` & `register.jsp` — Giao diện đăng nhập và đăng ký (đã cập nhật hiển thị errorMessage).
- [x] `src/main/java/com/ecommerce/controller/RegisterServlet.java` — Servlet xử lý đăng ký tài khoản mới và tạo session đăng nhập tự động.
- [x] `src/main/java/com/ecommerce/controller/ProfileServlet.java`, `dto/UserDTO.java`, `dto/AddressDTO.java`, `validator/ProfileValidator.java` — Xử lý hiển thị thông tin tài khoản, cập nhật họ tên, đổi mật khẩu (xác nhận mật khẩu cũ) và hoàn thiện trọn vẹn Address CRUD (thêm, sửa, xóa, đặt mặc định).
- [x] `src/main/webapp/WEB-INF/views/user/profile.jsp` — Giao diện hồ sơ cá nhân theo mô hình MVC, gồm thông tin cơ bản, đổi mật khẩu, danh sách địa chỉ, modal sửa địa chỉ và form thêm địa chỉ.
- [x] `src/main/java/com/ecommerce/filter/AuthFilter.java` & `AdminFilter.java` — Bộ lọc phân quyền session cho các URL khách hàng cần đăng nhập và URL quản trị Admin (kèm `WEB-INF/views/error/error-403.jsp`).
- [x] `OrderDTO.java`, `OrderItemDTO.java`, `OrderDB.java`, `ProfileServlet.java`, `profile.jsp`, `customer.css` — Bổ sung tab "Đơn hàng của tôi" trong trang Profile khách hàng: hiển thị danh sách đơn hàng, chi tiết sản phẩm/biến thể/ảnh/giá, tình trạng đơn hàng với badge màu chuẩn state machine, bộ lọc theo trạng thái, snapshot thông tin giao hàng & phương thức thanh toán, cùng tính năng hủy đơn hàng (khi đang ở trạng thái Chờ xác nhận hoặc Đã xác nhận).
- [x] `UserDB.java`, `UserRepository.java`, `LoginServlet.java`, `login.jsp`, `ProfileValidator.java`, `ProfileServlet.java`, `profile.jsp`, `customer.css` — Hoàn thiện tính năng đổi số điện thoại trong Profile với bước xác minh an toàn (yêu cầu gõ đúng dòng lệnh `Change Phone [sdt mới]`) và hỗ trợ đăng nhập hệ thống linh hoạt bằng Email hoặc Số điện thoại.
- [x] `MailUtil.java`, `OtpSessionData.java`, `RegisterServlet.java`, `register.jsp`, `ProfileServlet.java`, `profile.jsp`, `ProfileValidator.java`, `customer.css` — Triển khai giải pháp gửi mã xác thực OTP qua Email (sử dụng Jakarta Mail & Gmail SMTP SSL cổng 465):
  + Tích hợp xác thực OTP cho Đăng ký tài khoản: Giao diện OTP trực tiếp trên `register.jsp` (nhập form -> gửi mã OTP -> giao diện nhập OTP với countdown 2 phút (120s) và đếm số lần thử còn lại -> xác thực thành công mới lưu vào DB và đăng nhập tự động).
  + Quy tắc OTP nâng cao: Thời gian tồn tại mã tăng lên 2 phút (120s), giới hạn gửi lại mã phải chờ ít nhất 30 giây (có bộ đếm ngược trực tiếp trên nút Resend và xác thực chặn spam ở Controller).
  + Gửi email thông báo "Đăng ký tài khoản thành công": Sau khi xác thực OTP đăng ký hoàn tất, hệ thống tự động gửi email chào mừng có tên người dùng, lời chúc mừng và link dẫn tới website.
  + Cấu hình người gửi: Đổi tên hiển thị từ địa chỉ email cá nhân sang thương hiệu **Fashion Shop** (`Fashion Shop <...>`).
  + Tính năng Thay đổi Email trong Profile qua 2 bước: Nhập mật khẩu hiện tại + Email mới -> Hệ thống gửi OTP xác minh quyền sở hữu đến Email mới -> Nhập OTP chính xác để cập nhật.
  + Nâng cấp Thay đổi Số điện thoại trong Profile: Bỏ cơ chế nhập dòng lệnh, thay bằng xác thực OTP gửi về Email đã đăng ký của tài khoản (tuân thủ nghiêm ngặt: không dùng SMS, TTL 2 phút, cooldown gửi lại 30s, tối đa 3 lần thử sai).
- [x] `ForgotPasswordServlet.java`, `forgot-password.jsp`, `LoginServlet.java`, `login.jsp`, `index.jsp`:
  + Triển khai trọn vẹn luồng Quên Mật Khẩu qua OTP Email: Nhập email tài khoản -> Gửi OTP -> Xác thực OTP và đặt mật khẩu mới với đếm ngược 120s, cooldown gửi lại 30s -> Chuyển về trang đăng nhập với thông báo thành công.
  + Đồng bộ Navbar trang chủ: Thêm nút Đăng ký với UI chuẩn icon + text đồng nhất hoàn toàn với nút Đăng nhập.
  + Xóa bỏ hiện tượng "Guest": Loại bỏ gán `logoName = Guest` trong session tại `LoginServlet`, cố định hiển thị nhãn "Đăng nhập" khi chưa có phiên người dùng.
  + Dọn dẹp giao diện Profile: Gỡ bỏ hoàn toàn các dòng chữ badge màu xanh ("Có thể thay đổi...") trong phần thông tin cá nhân.
- [x] **Kiểm tra & Chuẩn hóa toàn diện User A (HAS) theo Context, Mô hình MVC và Tách bạch CSS**:
  + **Tách CSS 100% ra khỏi JSP**: Loại bỏ toàn bộ thẻ `<style>` và thuộc tính `style="..."` trong tất cả các file JSP thuộc phạm vi của A (`login.jsp`, `register.jsp`, `forgot-password.jsp`, `profile.jsp`, `error-403.jsp`, thanh auth `index.jsp`). Toàn bộ được quy hoạch về file CSS chuyên biệt (`auth.css`, `customer.css`, `error.css`, `common.css`).
  + **Tuân thủ MVC**: Controller thuần túy tiếp nhận request/response, validation, DTO mapping và gọi Repository/Service; View (JSP) sử dụng 100% JSTL/EL và `c:out` (chống XSS), không chứa Java scriptlets (`<% %>`).
  + **Tuân thủ Context & Quy chuẩn**: Password băm BCrypt, PreparedStatements chống SQLi, OTP bảo mật (TTL 120s, cooldown 30s, tối đa 3 lần thử), hỗ trợ URL động môi trường production qua header proxy / env variable.
- [x] **Cơ sở dữ liệu mẫu cục bộ (Seed Test Data)**:
  + Tạo script `database/sample_test_data.sql` và nạp thành công vào cơ sở dữ liệu `clothing_web` trên PostgreSQL 18 local:
  + Gồm 9 Users (Admin, Customer có mật khẩu BCrypt), 6 Categories, 12 Products, 35 Product Variants (AVAILABLE, SOLD, DISCONTINUED), 20 Product Images, 5 Vouchers (hoạt động, hết hạn, chạm giới hạn), 3 Addresses, 2 Carts kèm Cart Items, 6 Orders đủ cả 5 trạng thái (PENDING, CONFIRMED, SHIPPING, DELIVERED, CANCELLED), 7 Order Items, 3 Reviews, Wishlists và Momo Transaction.
  + Đã tự động cập nhật lại toàn bộ Sequence ID của PostgreSQL để tránh xung đột khi sinh dữ liệu mới trong quá trình kiểm thử.
- [x] **Đồng bộ thanh điều hướng Admin Sidebar trên toàn bộ các trang quản trị**:
  + Thêm link "Trang chủ Admin" (`/admin-home.jsp`) và "Xem trang bán hàng" (`/`) vào nhóm Tổng quan trên toàn bộ 10 file JSP Admin (`dashboard.jsp`, `voucher-*.jsp`, `category-*.jsp`, `product-*.jsp`, `order-*.jsp`, `admin-home.jsp`).
  + Chuyển đổi logo Brand `Fashion. Admin Panel` thành link click được dẫn về `admin-home.jsp`.
  + Chuẩn hóa nút logout ở footer sidebar (`${pageContext.request.contextPath}/logout`).
- [x] **Sửa lỗi điều hướng Admin, Checkout giỏ hàng và Dropdown tài khoản**:
  + **Admin Dashboard**: Cập nhật nút "Xem tất cả" và các link đơn hàng gần đây trỏ đúng về `AdminOrderServlet` (thay vì `/admin/orders` gây lỗi 404).
  + **Checkout Giỏ hàng**: Bổ sung mapping `/checkout` vào `MomoPaymentServlet.java` để nút "Tiến hành thanh toán" trong `cart.jsp` mở trang xác nhận địa chỉ và giỏ hàng thanh toán liền mạch.
  + **Navbar Giỏ hàng & Thanh toán**: Đồng bộ dropdown menu tài khoản trong `cart.jsp` và `_navbar.jspf` với `index.jsp` (hiển thị đúng tên, menu thả xuống Hồ sơ, Trang quản trị, Đăng xuất; sửa lỗi thẻ `<a>` nhảy sang `/login`).
- [x] **Đồng bộ điều hướng Admin trên giao diện cửa hàng (`index.jsp`, `profile.jsp`, `admin-home.jsp`)**:
  + Bổ sung liên kết "Trang quản trị" (`/admin-home.jsp`) vào dropdown người dùng trong `index.jsp` và `profile.jsp` khi phiên đăng nhập có vai trò `role == 'ADMIN'`.
  + Bổ sung nút "Xem trang bán hàng" vào sidebar `admin-home.jsp` và chuẩn hóa đường dẫn đăng xuất với context path (`${pageContext.request.contextPath}/logout`).
- [x] **Tích hợp Brevo (Sendinblue) REST API v3 thay thế SMTP**:
  + Thay thế gửi email qua giao thức SMTP (bị Render Free Tier chặn outbound port 25, 465, 587) bằng **Brevo REST API v3 qua HTTPS (port 443)** trong `MailUtil.java`.
  + Hỗ trợ cấu hình linh hoạt qua biến môi trường (`BREVO_API_KEY`, `BREVO_SENDER_EMAIL`, `BREVO_SENDER_NAME`) trên Render Dashboard hoặc file `brevo.properties` (được cung cấp mẫu `brevo.properties.example` và ẩn trong `.gitignore`).
  + Cơ chế tự động fallback thông minh sang Gmail SMTP (khi chạy local nếu chưa có key Brevo) và cơ chế in OTP ra console log kèm cờ `ALLOW_CONSOLE_OTP=true` phục vụ kiểm thử / demo.

## In Progress

- Unit "CRUD Category": còn test thủ công. Rule chặn xóa khi còn sản phẩm chưa làm (đang có TODO trong Category.delete), cần thêm query đếm sản phẩm trong CategoryDB sau khi có entity Product.
- [Bug UI] Sửa lỗi tính năng hiện/ẩn mật khẩu: icon/nút toggle chỉ xuất hiện khi bắt đầu nhập vào ô trống.

## Next Up

- Hoàn thiện `ui-context.md` (bảng màu, typography, layout
  pattern cụ thể) sau khi chốt tông màu với HuyCter.
- Sau khi đủ 6 file + `CLAUDE.md`: dừng lại, chờ yêu cầu tiếp theo
  (chia unit / viết spec feature) — không tự động làm tiếp.

## Open Questions

- [Bug/UI] Tính năng hiện mật khẩu hoạt động không ổn định: nút/icon chỉ xuất hiện khi bắt đầu nhập vào ô trống (cần chuẩn hóa hiển thị giữa CSS và JavaScript cho ô input password).

## Architecture Decisions

- Dùng session-based auth (`HttpSession`) thay vì JWT — vì đây là
  Servlet/JSP thuần theo yêu cầu giảng viên, không phải REST API.
- Trừ tồn kho ngay tại thời điểm tạo đơn (bất kể COD hay thanh
  toán online), dùng pessimistic lock trong transaction — đơn
  giản hơn cơ chế "giữ chỗ tồn kho có timeout" nhưng vẫn đảm bảo
  không bán âm kho, phù hợp quy mô đồ án.
- Đổi tên "coupon" thành "voucher" (khớp class diagram). Voucher
  dùng cờ `isActive` thay vì xóa cứng khỏi DB — để giữ toàn vẹn dữ
  liệu tham chiếu với các đơn hàng cũ đã áp mã đó. Mở rộng scope so
  với bản đầu: voucher có `startAt`/`endAt` (ngày hết hạn),
  `usageLimit`/`usedCount` (giới hạn số lần dùng), `minOrderAmount`
  (đơn tối thiểu), `maxDiscountAmount` (giảm tối đa) — theo class
  diagram đã chốt với giảng viên.
- Đơn hàng thanh toán online (VNPay/MoMo) chỉ được tạo sau khi có
  callback (IPN) xác nhận thành công, trạng thái khởi tạo thẳng
  "Đã xác nhận"; đơn COD tạo ngay với trạng thái "Chờ xác nhận".
- Danh mục sản phẩm là danh sách phẳng (áo thun, áo khoác, áo tay
  dài...), không có cấp cha — con, để đơn giản hóa truy vấn và UI.
- `CategoryDB` dùng static method theo pattern `UserDAO`, nhận
  `EntityManager` làm tham số, không mở transaction và không nuốt
  exception. Model tự mở `EntityManager` + transaction trong từng
  method (rollback rồi ném lại cho `GlobalExceptionFilter`).
- Validate field đơn giản làm thủ công (if/else) trong `validator/`,
  không dùng Bean Validation annotation (vì giảng viên không dạy và
  khó giải thích khi vấn đáp). Đã đồng bộ `architecture.md` và
  `code-standards.md`.
- Sau POST thành công, Servlet `forward` về trang danh sách (theo
  `code-standards.md`), không `redirect`.
- Slug category tự sinh từ name qua `SlugUtil` (cả lúc tạo và sửa);
  trùng slug thì Model ném `BusinessException` trước khi ghi DB.
- Xóa Category còn sản phẩm: chặn xóa (ném `BusinessException`),
  sản phẩm không bị xóa theo.
- Ảnh sản phẩm lưu qua Cloudinary (free tier) thay vì lưu trên ổ
  đĩa server, vì project được host thực tế và cần tránh mất ảnh
  khi redeploy/restart server.

## Session Notes

- Stack đã chốt: Java Servlet/JSP (Jakarta), Tomcat 10, JPA/
  Hibernate, PostgreSQL, Maven (`maven-archetype-webapp`), Eclipse.
- Nghiệp vụ đã chốt đầy đủ: variant sản phẩm (size/màu, giá/SKU
  riêng), danh mục 2 cấp, giỏ hàng yêu cầu đăng nhập, state machine
  đơn hàng, thanh toán COD + VNPay + MoMo, review (chỉ sau khi
  mua), voucher (% giảm, có hạn dùng/số lần dùng/đơn tối thiểu/mức
  giảm tối đa), wishlist, thống kê Admin dạng bảng.
- Còn thiếu: bảng màu/token cụ thể cho `ui-context.md` — sẽ hỏi
  riêng ở bước tiếp theo trước khi hoàn thiện file này.