# AI Workflow Rules

## Approach

Xây dựng project theo hướng spec-driven: các file context
(`project-overview.md`, `architecture.md`, `code-standards.md`,
`ui-context.md`) định nghĩa chính xác phải xây cái gì và xây như
thế nào. Khi bắt đầu code (giai đoạn sau, chưa diễn ra ở bước
này), luôn implement đúng theo các file này — không tự suy diễn
hay bịa thêm hành vi/field/nghiệp vụ không có trong spec.

## Scoping Rules

- Làm từng đơn vị chức năng (feature unit) một lúc — vd "CRUD
  Category" xong mới sang "CRUD Product", không làm song song
  nhiều nhóm chưa liên quan.
- Ưu tiên thay đổi nhỏ, kiểm chứng được ngay, hơn là thay đổi lớn
  mang tính suy đoán.
- Không gộp chung các boundary khác nhau (vd không sửa logic
  Order cùng lúc với sửa logic Category) trong 1 bước implement.

## When to Split Work

Tách nhỏ 1 bước implement nếu nó gộp chung:

- Thay đổi ở tầng Entity/DB (migration) và thay đổi logic
  Service/Controller trong cùng 1 bước.
- Nhiều Servlet không liên quan tới nhau (vd `ProductServlet` và
  `OrderServlet`).
- Hành vi chưa được định nghĩa rõ trong `project-overview.md`
  hoặc `architecture.md`.

Nếu 1 bước không thể test/verify từ đầu đến cuối trong thời gian
ngắn, nghĩa là scope đang quá rộng — phải tách nhỏ hơn.

## Handling Missing Requirements

- Không tự bịa thêm hành vi nghiệp vụ chưa được ghi trong các file
  context.
- Nếu 1 yêu cầu còn mơ hồ, phải làm rõ trong file context liên
  quan (vd cập nhật `project-overview.md` hoặc hỏi lại người dùng)
  trước khi implement, không đoán rồi code luôn.
- Nếu phát hiện thiếu 1 yêu cầu, thêm nó vào mục "Open Questions"
  trong `progress-tracker.md` trước khi tiếp tục, không tự quyết
  định thay.

## Protected Files

Không được tự ý sửa các file/thư mục sau trừ khi được yêu cầu rõ
ràng:

- `src/main/webapp/WEB-INF/web.xml` — chỉ sửa khi cần thêm
  filter/error-page mới, không sửa cấu trúc khác.
- `src/main/resources/META-INF/persistence.xml` — cấu hình kết
  nối DB, chỉ sửa khi đổi thông tin connection hoặc đổi ORM
  (JPA → JDBC) theo yêu cầu giảng viên.
- Thư viện bên thứ 3 đã thêm vào `pom.xml` — không tự ý đổi version
  hoặc thêm dependency mới ngoài phạm vi đã thống nhất trong
  `architecture.md`.

## Keeping Docs in Sync

Cập nhật file context tương ứng ngay khi implementation thay đổi:

- Thay đổi kiến trúc hệ thống hoặc ranh giới folder → cập nhật
  `architecture.md`.
- Thay đổi schema DB hoặc quyết định lưu trữ → cập nhật
  `architecture.md` (Storage Model).
- Thay đổi convention code → cập nhật `code-standards.md`.
- Thay đổi phạm vi tính năng (thêm/bớt scope) → cập nhật
  `project-overview.md`.

## Before Moving to the Next Unit

1. Unit hiện tại chạy được end-to-end đúng trong phạm vi đã định
   nghĩa (test thủ công qua giao diện, không chỉ compile được).
2. Không vi phạm bất kỳ invariant nào trong `architecture.md`.
3. `progress-tracker.md` đã phản ánh đúng phần vừa hoàn thành.
4. Project build thành công bằng Maven (`mvn clean package`) và
   deploy chạy được trên Tomcat 10 không lỗi.