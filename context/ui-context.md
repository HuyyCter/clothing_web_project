## Phần 1 — LOCKED (bắt buộc tuân thủ tuyệt đối, không được đổi)

### Nguồn Primitives
Toàn bộ giá trị số (hex, radius, spacing, border-width) trong phần
này lấy từ `primitives.md`.

- Primary color = Sky (step 500 = `#00A6F4FF`)
- Secondary color = Slate
- Theme = Light (sáng, tối giản kiểu Uniqlo/Muji — không có dark
  mode)

### Theme
Light only. Nền sáng gần trắng, bề mặt trắng tinh, phân lớp bằng
border mỏng thay vì đổ bóng đậm. Không dùng gradient. Cảm giác
tổng thể: sạch, thoáng, đáng tin cậy — giống gian hàng bán lẻ tối
giản (Uniqlo/Muji) hơn là landing page công nghệ nhiều màu.

### Colors

**Neutral (khung nền chung của UI)**
| Role            | CSS Variable       | Step (từ Primitives)          |
| ---------------- | -------------------- | -------------------------------- |
| Page background   | `--bg-base`          | gray-50 (`#F9FAFBFF`)            |
| Surface           | `--bg-surface`       | white (`#FFFFFFFF`)              |
| Border mặc định   | `--border-default`   | gray-200 (`#E5E7EBFF`)           |
| Text chính        | `--text-primary`     | gray-900 (`#101828FF`)           |
| Text phụ / muted   | `--text-muted`       | gray-500 (`#6A7282FF`)           |

**Primary (Sky)**
| Role                | CSS Variable            | Step (từ Primitives)         |
| -------------------- | -------------------------- | -------------------------------- |
| Background (subtle)   | `--primary-bg-subtle`      | sky-50 (`#F0F9FFFF`)            |
| Background (default)  | `--primary-bg`             | sky-500 (`#00A6F4FF`)           |
| Background (strong)   | `--primary-bg-strong`      | sky-700 (`#0069A8FF`)           |
| Text                  | `--primary-text`           | sky-700 (`#0069A8FF`)           |
| Text trên nền solid    | `--primary-text-on-solid`  | white (`#FFFFFFFF`)             |
| Border                | `--primary-border`         | sky-500 (`#00A6F4FF`)           |

**Secondary (Slate)**
| Role                | CSS Variable              | Step (từ Primitives)          |
| -------------------- | ---------------------------- | --------------------------------- |
| Background (subtle)   | `--secondary-bg-subtle`      | slate-100 (`#F1F5F9FF`)          |
| Background (default)  | `--secondary-bg`             | slate-700 (`#314158FF`)          |
| Background (strong)   | `--secondary-bg-strong`      | slate-900 (`#0F172BFF`)          |
| Text                  | `--secondary-text`           | slate-700 (`#314158FF`)          |
| Text trên nền solid    | `--secondary-text-on-solid`  | white (`#FFFFFFFF`)              |
| Border                | `--secondary-border`         | slate-300 (`#CAD5E2FF`)          |

**Error**
| Role                | CSS Variable           | Step (từ Primitives)             |
| -------------------- | -------------------------- | ------------------------------------ |
| Background (subtle)   | `--error-bg-subtle`        | red-50 (`#FEF2F2FF`)                |
| Text                  | `--error-text`             | red-600 (`#E7000BFF`)               |
| Border                | `--error-border`           | red-300 (`#FFA2A2FF`)               |

**Success**
| Role                | CSS Variable             | Step (từ Primitives)              |
| -------------------- | ---------------------------- | -------------------------------------- |
| Background (subtle)   | `--success-bg-subtle`        | green-50 (`#F0FDF4FF`)               |
| Text                  | `--success-text`             | green-600 (`#00A63EFF`)              |
| Border                | `--success-border`           | green-300 (`#7BF1A8FF`)              |

### Typography

| Role                              | Loại font        | Variable       |
| ---------------------------------- | ------------------ | ---------------- |
| Heading / Title (H1, H2, section title) | Serif (có chân)     | `--font-serif`  |
| Subtitle, body, UI text, label     | Sans (không chân)   | `--font-sans`   |
| Code / số liệu kỹ thuật (SKU, mã đơn) | Monospace         | `--font-mono`   |

- `--font-serif: "Playfair Display"` — dùng cho mọi heading, tạo
  cảm giác nghiêm túc, có điểm nhấn cao cấp hơn so với toàn bộ UI
  còn lại.
- `--font-sans: "Inter"` — dùng cho body, label, button, mọi text
  UI còn lại.
- `--font-mono: "Geist Mono"` — dùng cho SKU, mã đơn hàng, mã
  coupon (số liệu cần căn chỉnh đều ký tự).
- Font-size lấy trực tiếp từ bảng Font Size trong `primitives.md`.
- Quy tắc bắt buộc: **Heading luôn dùng `--font-serif`**, mọi text
  còn lại (kể cả label trong component) dùng `--font-sans`. Không
  trộn ngược.

### Border Radius & Border Width

| Ngữ cảnh                            | Step áp dụng (từ Primitives) |
| -------------------------------------- | -------------------------------- |
| Inline element (badge, tag, input)     | `--radius-md` (6px)             |
| Card sản phẩm, panel, container chính  | `--radius-lg` (8px)              |
| Modal, overlay, popup lớn              | `--radius-2xl` (16px)           |
| Border mặc định (viền input, card)     | `--border-width-1` (1px)        |
| Border nhấn mạnh (focus, active, nút primary) | `--border-width-2` (2px) |

### Component Library
Không dùng thư viện UI ngoài (đúng yêu cầu JSP thuần). CSS viết
tay theo naming BEM (`.product-card__title`, `.btn--primary`),
tổ chức file theo module trong `resources/css/`.

### Icons
Không cài thư viện icon ngoài (Font Awesome, Lucide...). Dùng SVG
inline viết tay cho bộ icon tối thiểu cần thiết: giỏ hàng, tài
khoản, tìm kiếm, tim (wishlist), mũi tên. Toàn bộ icon dạng
outline (stroke, không fill), 1 màu, đồng bộ với `--text-primary`
hoặc `--primary-bg` tùy ngữ cảnh. Kích thước: 16px cho icon inline
trong text, 20px cho icon trong button/navbar.


## Phần 2 — CREATIVE BRIEF (AI được toàn quyền sáng tạo trong khuôn khổ Phần 1)

### Mood / Personality
Tối giản, gọn gàng, đáng tin cậy, hiện đại, có chút nghiêm túc
nhờ heading serif tạo điểm nhấn cao cấp giữa một nền UI rất phẳng
và sạch.

### Reference points
Uniqlo (bố cục sản phẩm, tông sáng, ít màu), Muji (tối giản, nhiều
khoảng trắng, ít chi tiết trang trí).

### Signature element
Nút "Thêm vào giỏ hàng" luôn có viền đậm (`--border-width-2`) màu
`--primary-border`, nền trắng, chữ `--primary-text`. Khi hover,
đảo màu: nền chuyển thành `--primary-bg`, chữ chuyển thành
`--primary-text-on-solid`. Không dùng shadow hay glow — hiệu ứng
nhận diện chỉ đến từ việc đảo màu nền/chữ.

### Permission statements (AI được phép làm gì)
- Gradient: KHÔNG dùng gradient ở bất kỳ đâu — giữ tối giản tuyệt
  đối đúng tinh thần Uniqlo.
- Shadow/depth: chỉ dùng shadow rất nhẹ (`--opacity-10` trở
  xuống) cho Card sản phẩm khi hover và cho Modal/overlay. Không
  dùng shadow cho button hay input.
- Motion: dùng cho hover (button, card sản phẩm) và transition khi
  mở modal, thời lượng ngắn (150–200ms). Không làm animation phức
  tạp, không làm page transition khi chuyển trang (vì dùng
  `forward` server-side, không phải SPA).
- Mức độ risk cho phép: giữ kỷ luật toàn bộ giao diện, kể cả ở
  signature element — đây là shop bán hàng, ưu tiên rõ ràng và dễ
  thao tác hơn là gây ấn tượng thị giác.

### Anti-patterns (tuyệt đối tránh)
- Card sản phẩm không có border/shadow phân tách — dính phẳng vào
  nền, khó nhận biết ranh giới.
- Bố cục lưới đều tăm tắp kiểu Bootstrap mặc định, spacing sát
  nhau không có khoảng thở.
- Dùng nhiều hơn 2 màu chính (primary + neutral) trong cùng 1
  màn hình — màu semantic (error/success) chỉ xuất hiện đúng lúc
  cần, không trang trí lan man.
- Icon nhiều màu, icon dạng fill/3D — phá vỡ tính tối giản.

---

## Layout Patterns

- **Trang danh sách sản phẩm**: lưới (grid) 4 cột trên desktop, 2
  cột trên mobile. Sidebar filter (danh mục, khoảng giá, còn
  hàng) cố định bên trái trên desktop; trên mobile thu gọn thành
  thanh filter dạng dropdown phía trên danh sách.
- **Trang chi tiết sản phẩm**: bố cục 2 cột — gallery ảnh bên
  trái (ảnh đổi theo màu đang chọn), thông tin sản phẩm + chọn
  size/màu + nút "Thêm vào giỏ hàng" bên phải, cố định (sticky)
  khi cuộn trên desktop.
- **Giỏ hàng & Checkout**: danh sách item dạng cột dọc, mỗi sản
  phẩm 1 hàng. Khối tổng tiền + ô nhập coupon + nút checkout nằm
  cố định (sticky) bên phải trên desktop, dưới cùng trên mobile.
- **Navbar**: thanh trên cùng cố định (sticky top), có
  `border-bottom` mỏng (`--border-default`). Logo bên trái, thanh
  tìm kiếm ở giữa, icon giỏ hàng/wishlist/tài khoản bên phải.
- **Modal** (đăng nhập nhanh, xác nhận xóa, xác nhận hủy đơn):
  overlay căn giữa màn hình, backdrop đen mờ (`--opacity-50`), bo
  góc `--radius-2xl`.
- **Admin**: dùng chung 1 layout tổng thể (cùng token màu/
  typography/spacing) với trang khách hàng, chỉ khác phần menu —
  thay navbar khách bằng sidebar trái cố định gồm: Dashboard,
  Danh mục, Sản phẩm, Đơn hàng, Coupon, Thống kê.