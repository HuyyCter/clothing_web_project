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
- [x] `src/main/webapp/login.jsp` & `register.jsp` — Giao diện đăng nhập và đăng ký.

## In Progress

- Hoàn thiện luồng xác thực Customer/Admin và tích hợp với client side.
- Unit "CRUD Category": còn test thủ công. Rule chặn xóa khi còn sản phẩm chưa làm (đang có TODO trong Category.delete), cần thêm query đếm sản phẩm trong CategoryDB sau khi có entity Product.

## Next Up

- Hoàn thiện `ui-context.md` (bảng màu, typography, layout
  pattern cụ thể) sau khi chốt tông màu với HuyCter.
- Sau khi đủ 6 file + `CLAUDE.md`: dừng lại, chờ yêu cầu tiếp theo
  (chia unit / viết spec feature) — không tự động làm tiếp.

## Open Questions

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