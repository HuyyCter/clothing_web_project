# Progress Tracker

Update this file after every meaningful implementation
change.

## Current Phase

- Thiết kế context files (chưa code, chưa chia unit, chưa viết
  spec feature).

## Current Goal

- Hoàn thiện đầy đủ 6 file context (`project-overview.md`,
  `architecture.md`, `code-standards.md`, `ai-workflow-rules.md`,
  `ui-context.md`, `progress-tracker.md`) trước khi bắt đầu chia
  unit và code. Hiện đang chờ chốt bảng màu cụ thể cho
  `ui-context.md`.

## Completed

- [x] `src/main/webapp/index.jsp` — Giao diện trang chủ cửa hàng (Hero banner, danh mục nổi bật, sản phẩm mới, tính năng).
- [x] `src/main/webapp/assets/css/admin.css` & `common.css` — Hệ thống design token và CSS thuần quản trị viên.
- [x] `src/main/webapp/WEB-INF/views/admin/dashboard.jsp` — Tổng quan thống kê doanh thu, đơn hàng, khách hàng, biểu đồ và bảng hoạt động.
- [x] `src/main/webapp/WEB-INF/views/admin/category-list.jsp` — Danh sách quản lý danh mục cha/con.
- [x] `src/main/webapp/WEB-INF/views/admin/category-form.jsp` — Form thêm/sửa danh mục sản phẩm (hỗ trợ phân cấp 2 tầng).
- [x] `src/main/webapp/WEB-INF/views/admin/product-list.jsp` — Danh sách sản phẩm với bộ lọc, trạng thái và hiển thị biến thể.
- [x] `src/main/webapp/WEB-INF/views/admin/product-form.jsp` — Form thêm/sửa sản phẩm kèm quản lý biến thể (Size/Màu) và liên kết ảnh Cloudinary.
- [x] `src/main/webapp/WEB-INF/views/admin/order-list.jsp` — Danh sách đơn hàng với bộ lọc trạng thái và phân trang.
- [x] `src/main/webapp/WEB-INF/views/admin/order-detail.jsp` — Chi tiết đơn hàng, snapshot thông tin giao hàng, cập nhật state machine trạng thái đơn.
- [x] `src/main/webapp/WEB-INF/views/admin/voucher-list.jsp` — Danh sách quản lý mã giảm giá (voucher).
- [x] `src/main/webapp/WEB-INF/views/admin/voucher-form.jsp` — Form thêm/sửa voucher (% giảm, đơn tối thiểu, giảm tối đa, hạn dùng, giới hạn lượt dùng).

## In Progress

- None yet.

## Next Up

- Hoàn thiện `ui-context.md` (bảng màu, typography, layout
  pattern cụ thể) sau khi chốt tông màu với HuyCter.
- Sau khi đủ 6 file + `CLAUDE.md`: dừng lại, chờ yêu cầu tiếp theo
  (chia unit / viết spec feature) — không tự động làm tiếp.

## Open Questions

- ORM hiện chọn JPA/Hibernate thuần. Có khả năng giảng viên yêu
  cầu đổi sang JDBC thuần — chưa chốt, cần theo dõi và cập nhật
  `architecture.md` nếu có thay đổi.
- Package name Java tạm đặt `com.javaproject.e-commerce-web` — chỉ là
  gợi ý ban đầu, có thể đổi tên bất kỳ lúc nào trước khi code.

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
- Danh mục sản phẩm giới hạn tối đa 2 cấp (cha — con), không cho
  phép lồng cấp thứ 3, để đơn giản hóa truy vấn và UI breadcrumb.
- Ảnh sản phẩm lưu qua Cloudinary (free tier) thay vì lưu trên ổ
  đĩa server, vì project được host thực tế và cần tránh mất ảnh
  khi redeploy/restart server.
- Đổi hướng cấu hình DB: hardcode trực tiếp trong persistence.xml
  (bám theo giáo trình giảng viên) thay vì tách db.properties +
  AppContextListener đọc runtime. File persistence.xml không commit
  git, gửi riêng từng thành viên tự điền password.

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