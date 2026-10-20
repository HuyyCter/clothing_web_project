# Fashion Shop — Website TMĐT bán quần áo

## Overview

Website thương mại điện tử bán quần áo, dạng đồ án môn học nhưng
được host thực tế (deploy production). Đối tượng dùng gồm 2 nhóm:
Customer (khách mua hàng) và Admin (quản trị shop). Hệ thống giải
quyết bài toán: cho phép khách duyệt sản phẩm theo danh mục, chọn
biến thể (size/màu), đặt hàng, thanh toán (COD hoặc online qua
VNPay/MoMo), theo dõi đơn hàng; đồng thời cho Admin quản lý toàn bộ
sản phẩm, tồn kho, đơn hàng và xem thống kê cơ bản.

Công nghệ: Java Servlet/JSP thuần theo mô hình MVC (namespace
Jakarta), chạy trên Tomcat 10, ORM JPA/Hibernate, database
PostgreSQL, build bằng Maven (maven-archetype-webapp), code trên
Eclipse.

## Goals

1. Xây dựng đầy đủ 4 nhóm nghiệp vụ cốt lõi của TMĐT: User & Auth,
   Catalog, Cart & Order, Payment — không thiếu logic quan trọng
   nào (đặc biệt là trừ tồn kho và state machine đơn hàng).
2. Tổ chức code phần Backend theo kiến trúc phân lớp rõ ràng
   (Controller — Service — Repository — Entity — DTO), dễ mở rộng
   và bảo trì, dù không dùng framework DI như Spring.
3. Database được thiết kế chuẩn hóa, đủ chi tiết để hỗ trợ biến thể
   sản phẩm (size/màu), review, voucher, wishlist mà không cần sửa
   schema khi mở rộng nhỏ sau này.

## Core User Flow

**Khách hàng (Customer):**

1. Đăng ký tài khoản → xác nhận thông tin cơ bản (họ tên, email,
   mật khẩu).
2. Đăng nhập → hệ thống tạo `HttpSession` lưu userId + role.
3. Duyệt sản phẩm: xem theo danh mục cha/con, tìm kiếm, lọc theo
   giá/danh mục/còn hàng, sắp xếp giá tăng/giảm hoặc mới nhất, có
   phân trang.
4. Xem chi tiết sản phẩm → chọn biến thể (size + màu) → xem ảnh
   riêng theo màu, giá riêng theo biến thể, số lượng tồn kho còn
   lại.
5. Thêm vào giỏ hàng (bắt buộc đã đăng nhập). Giỏ hàng lưu DB, gắn
   theo `userId`.
6. Vào giỏ hàng → sửa số lượng / xóa sản phẩm → nhập mã voucher
   (nếu có) → xem tổng tiền sau giảm.
7. Checkout: chọn địa chỉ giao hàng (từ sổ địa chỉ đã lưu hoặc
   thêm mới), chọn phương thức thanh toán (COD / VNPay / MoMo).
8. Nếu chọn thanh toán online: chuyển hướng sang cổng thanh toán →
   cổng gọi callback (IPN) báo kết quả → hệ thống tạo đơn hàng nếu
   thành công. Nếu chọn COD: đơn được tạo ngay.
9. Tồn kho của các biến thể trong đơn bị trừ ngay tại bước tạo đơn
   (trong 1 transaction có khóa để tránh bán âm kho).
10. Xem lịch sử đơn hàng, theo dõi trạng thái đơn (Chờ xác nhận →
    Đã xác nhận → Đang giao → Đã giao, hoặc Hủy).
11. Sau khi đơn ở trạng thái "Đã giao", có thể viết review (rating
    + comment) cho sản phẩm đã mua.
12. Có thể thêm sản phẩm vào Wishlist bất kỳ lúc nào (không cần đã
    mua).

**Admin:**

1. Đăng nhập cùng hệ thống, session có role = ADMIN.
2. Quản lý danh mục (thêm/sửa/xóa danh mục cha và con, tối đa 2
   cấp).
3. Quản lý sản phẩm: tạo sản phẩm gốc (tên, mô tả, danh mục), thêm
   các biến thể (size, màu, giá riêng, SKU riêng, tồn kho riêng),
   upload ảnh theo từng màu (lưu qua Cloudinary).
4. Quản lý đơn hàng: xem danh sách, xem chi tiết, cập nhật trạng
   thái đơn theo đúng state machine (không được set tùy ý trạng
   thái không hợp lệ).
5. Quản lý voucher: tạo mã giảm giá theo %, bật/tắt (`isActive`),
   đặt ngày bắt đầu/kết thúc (`startAt`/`endAt`), giới hạn số lần
   dùng (`usageLimit`), điều kiện đơn tối thiểu (`minOrderAmount`),
   mức giảm tối đa (`maxDiscountAmount`).
6. Xem thống kê dạng bảng: tổng số đơn, tổng doanh thu, top sản
   phẩm bán chạy.

## Features

### User & Auth

- Đăng ký / đăng nhập / đăng xuất (session-based, `HttpSession`).
- 2 role: Customer, Admin.
- Quản lý hồ sơ cá nhân (họ tên, email, số điện thoại).
- Sổ địa chỉ: 1 user có nhiều địa chỉ giao hàng, có thể đặt 1 địa
  chỉ mặc định.
- Đổi mật khẩu (yêu cầu nhập mật khẩu cũ). Không làm chức năng
  "quên mật khẩu" qua email ở bản đầu (xem Out of Scope).

### Catalog (Sản phẩm)

- CRUD sản phẩm (Admin).
- Danh mục phân cấp 2 cấp: Category cha (`ParentCategoryId = null`)
  và Category con (`ParentCategoryId` trỏ tới cha). Không cho phép
  cấp thứ 3.
- Biến thể sản phẩm theo size + màu, mỗi biến thể có SKU riêng,
  giá riêng, tồn kho riêng.
- Ảnh sản phẩm tách riêng theo từng màu (mỗi biến thể/nhóm màu có
  bộ ảnh riêng), lưu trên Cloudinary.
- Tìm kiếm theo tên, lọc theo danh mục/khoảng giá/còn hàng, sắp
  xếp theo giá hoặc ngày tạo mới nhất.
- Phân trang bắt buộc cho mọi danh sách sản phẩm.
- Wishlist: user lưu sản phẩm yêu thích ở cấp Product (không phân
  biệt biến thể).
- Review: chỉ user đã mua sản phẩm đó (đơn ở trạng thái "Đã giao")
  mới được review; hiển thị ngay, không cần Admin duyệt.

### Cart & Order

- Giỏ hàng lưu DB, chỉ dùng được khi đã đăng nhập (không hỗ trợ
  giỏ hàng cho khách vãng lai).
- Thêm / sửa số lượng / xóa sản phẩm trong giỏ.
- Áp mã voucher theo % khi checkout. Voucher có ngày bắt đầu/kết
  thúc (`startAt`/`endAt`), giới hạn số lần dùng (`usageLimit`,
  đếm qua `usedCount`), điều kiện đơn tối thiểu (`minOrderAmount`),
  và mức giảm tối đa (`maxDiscountAmount`) để tránh giảm quá nhiều
  khi đơn giá trị lớn. Voucher chỉ áp dụng được khi còn
  `isActive = true`, trong khoảng `startAt`–`endAt`, `usedCount <
  usageLimit`, và tổng tiền giỏ hàng >= `minOrderAmount`.
- Trừ tồn kho tại thời điểm tạo đơn, trong 1 transaction có khóa
  (pessimistic lock) trên biến thể sản phẩm để tránh bán âm kho
  khi có tranh chấp đồng thời.
- State machine trạng thái đơn hàng:
  `Chờ xác nhận → Đã xác nhận → Đang giao → Đã giao`.
  `Hủy` chỉ được phép thực hiện từ `Chờ xác nhận` hoặc
  `Đã xác nhận` (không hủy được khi đã "Đang giao" hoặc "Đã giao").
  Khi đơn chuyển sang `Hủy`, hệ thống tự động hoàn lại đúng số
  lượng tồn kho đã trừ trước đó.
- Lịch sử đơn hàng cho user xem lại toàn bộ đơn đã đặt.
- Admin xem, cập nhật trạng thái đơn (chỉ theo transition hợp lệ),
  xem thống kê.

### Payment

- COD: đơn tạo ngay với trạng thái "Chờ xác nhận", Admin xác nhận
  thủ công sau.
- VNPay / MoMo (sandbox): đơn chỉ được tạo sau khi nhận callback
  (IPN) báo thanh toán thành công; trạng thái ban đầu set thẳng
  "Đã xác nhận" (vì đã thanh toán).

## Scope

### In Scope

- 4 nhóm nghiệp vụ cốt lõi: User & Auth, Catalog (có variant),
  Cart & Order (có coupon, state machine đầy đủ), Payment (COD +
  VNPay + MoMo).
- Wishlist, Review (chỉ sau khi mua, không cần duyệt).
- Thống kê Admin dạng bảng (không biểu đồ).
- Upload ảnh sản phẩm qua Cloudinary.
- Phân trang, tìm kiếm, lọc, sắp xếp sản phẩm.

### Out of Scope

- Quên mật khẩu qua email (gửi mail reset password) — bản đầu chỉ
  có đổi mật khẩu khi đã đăng nhập.
- Giỏ hàng cho khách chưa đăng nhập (lưu Session tạm).
- Cache/Redis — mọi dữ liệu đọc trực tiếp từ PostgreSQL.
- Biểu đồ thống kê (chart) cho Admin — chỉ bảng số liệu.
- Vai trò Staff/Shipper riêng biệt — chỉ Customer và Admin.
- Cơ chế "giữ chỗ tồn kho" (stock reservation) có thời gian
  timeout khi thanh toán online đang chờ xử lý.
- Đa ngôn ngữ, đa tiền tệ.
- Ứng dụng mobile riêng — chỉ responsive web.

## Success Criteria

1. Customer đăng ký, đăng nhập, và thấy được session duy trì qua
   các trang khác nhau (không bị đăng xuất khi chuyển trang).
2. Customer chọn 1 biến thể sản phẩm cụ thể (size + màu), thêm vào
   giỏ hàng, và thấy đúng biến thể đó (đúng SKU, đúng giá) xuất
   hiện trong giỏ.
3. Khi checkout, tồn kho của biến thể tương ứng giảm đúng số lượng
   đã mua ngay sau khi đơn được tạo thành công.
4. Đơn hàng không thể được Admin chuyển sang trạng thái không hợp
   lệ theo state machine (vd không thể chuyển thẳng từ "Chờ xác
   nhận" sang "Đã giao").
5. Khi đơn bị hủy (từ trạng thái hợp lệ), tồn kho biến thể được
   cộng lại đúng số lượng đã trừ trước đó.
6. Customer chỉ review được sản phẩm nằm trong đơn hàng đã ở trạng
   thái "Đã giao" của chính họ; không review được sản phẩm chưa
   từng mua.
7. Voucher nhập đúng mã, còn `isActive = true`, đang trong khoảng
   `startAt`–`endAt`, chưa vượt `usageLimit`, và đơn hàng đạt
   `minOrderAmount` thì được áp dụng, tổng tiền giảm đúng theo %
   (không vượt quá `maxDiscountAmount`). Mã bị tắt, hết hạn, hết
   lượt dùng, hoặc đơn chưa đạt tối thiểu thì báo lỗi rõ ràng
   tương ứng khi áp dụng.