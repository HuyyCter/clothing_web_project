# TASK.md - HAS: User & Authentication + Address

## 0. Phạm vi nhiệm vụ

Chỉ thực hiện phần **HAS (User & Auth)** theo context đã được xác thực
của project.

### Core bắt buộc

-   Đăng ký tài khoản.
-   Đăng nhập / đăng xuất.
-   Profile.
-   Đổi mật khẩu.
-   Quản lý sổ địa chỉ.
-   Phân quyền và điều hướng sau login theo `UserRole`.

### Optional, chỉ thực hiện sau khi Core hoàn thành và còn đủ thời gian

-   OTP qua email.
-   OTP qua phone/SMS, chỉ sau khi OTP email đã ổn định.

**Không đưa `username`, `UserStatus`, `emailVerified`, `phoneVerified`,
`latitude`, `longitude` vào model chỉ vì đề xuất trước đây. Context đã
xác thực project không sử dụng các field này.**

**Không chỉnh sửa nghiệp vụ chính của Catalog, Cart/Voucher,
Order/Payment.** Các association của `User` với module khác vẫn phải
đúng trên business class diagram.

> Đây là **UML Business Class Diagram**, không phải ERD. Không thêm
> foreign key như `userId`, `orderId` chỉ để mô phỏng database.

------------------------------------------------------------------------

# 1. Chuẩn UML/Lucidchart

Dùng class, attribute, association và cardinality theo UML/Lucidchart.

Cardinality cần thể hiện rõ:

``` text
1
0..1
0..*
1..*
```

Không biến association thành các field ID.

------------------------------------------------------------------------

# 2. User

Giữ cấu trúc hiện tại đã được context xác thực:

``` text
User
- id: int
- fullName: String
- email: String
- passwordHash: String
- phone: String
- role: UserRole
```

### Quy tắc

-   Login dùng `email + password`.
-   Không thêm `username`.
-   `email` là định danh duy nhất.
-   Password không lưu plaintext, chỉ lưu `passwordHash`.
-   `role` dùng `UserRole`, không dùng integer trong business diagram.
-   Không thêm các security field kỹ thuật như `lastLoginAt`,
    `failedLoginAttempts`, `passwordResetToken` nếu project không yêu
    cầu.

------------------------------------------------------------------------

# 3. UserRole

Giữ:

``` text
<<enumeration>>
UserRole

CUSTOMER
ADMIN
```

Đây là hai role được xác thực trong project.

------------------------------------------------------------------------

# 4. Quan hệ User với các module

Giữ các association:

``` text
User 1 -------- 0..* Address
User 1 -------- 0..1 Cart
User 1 -------- 0..1 Wishlist
User 1 -------- 0..* Order
User 1 -------- 0..* Review
```

Không thêm `cartId`, `wishlistId`, `orderId` vào `User`.

------------------------------------------------------------------------

# 5. Address

Cấu trúc cần cập nhật:

``` text
Address
- id: int
- recipientName: String
- phone: String
- street: String
- ward: String
- district: String
- city: String
- isDefault: boolean
```

### Đã chốt naming

Dùng:

``` text
recipientName
phone
```

Không dùng `receiverName` / `receiverPhone`.

`Address.phone` là số điện thoại của người nhận tại địa chỉ đó, có thể
khác `User.phone`.

### Lý do

Context quy định Order phải snapshot thông tin người nhận khi tạo đơn.
User có thể mua hàng cho người khác, vì vậy Address cần thông tin người
nhận riêng.

------------------------------------------------------------------------

# 6. User - Address

``` text
User 1 -------- 0..* Address
```

Rule: - User có thể chưa có Address. - User có thể có nhiều Address. -
Tối đa một Address của User có `isDefault = true`. - Có thể thêm, sửa,
xóa và đặt Address mặc định. - Xóa Address không cần password. - Không
ép User phải có Address ngay sau registration. - Không tự thêm
`MAX_ADDRESS = 10` vì context không quy định giới hạn này.

------------------------------------------------------------------------

# 7. Order và Address snapshot

HAS chỉ quản lý Address hiện tại của User.

Khi tạo Order, hệ thống phải snapshot thông tin giao hàng thay vì để
Order phụ thuộc vào Address hiện tại sau này.

Không mở rộng business logic Order trong task HAS.

------------------------------------------------------------------------

# 8. Register - Core bắt buộc

Flow:

``` text
Register
 ↓
fullName + email + phone + password
 ↓
Validate
 ↓
Kiểm tra email / phone
 ↓
Hash password
 ↓
Create User
```

Context hiện tại cho phép đăng ký và đăng nhập mà không yêu cầu
email/SMS verification.

### Validation

-   `fullName` hợp lệ.
-   `email` đúng format và unique.
-   `phone` đúng format và theo rule project.
-   Password không lưu plaintext.

Không thêm `username`.

------------------------------------------------------------------------

# 9. Login - Core bắt buộc

Flow:

``` text
Login
 ↓
email + password
 ↓
Find User
 ↓
Verify password
 ↓
Create session
 ↓
Read UserRole
 ↓
Redirect
```

## Session

Session server-side chứa tối thiểu:

``` text
userId
role
```

Không lưu password/passwordHash trong session.

## Redirect theo role

``` text
                 Login success
                      |
                   UserRole
                  /        \
                 /          \
             ADMIN        CUSTOMER
                |              |
          Admin JSP       Customer JSP
```

Cụ thể:

``` text
ADMIN    → trang JSP dành cho Admin
CUSTOMER → trang JSP dành cho Customer
```

Server phải lấy role từ User đã authentication. Không tin role từ
request parameter, hidden field hoặc dữ liệu client tự tạo.

------------------------------------------------------------------------

# 10. Logout - Core bắt buộc

``` text
Logout
 ↓
Invalidate current session
 ↓
Redirect về trang phù hợp
```

Không cần OTP.

------------------------------------------------------------------------

# 11. Change Password - Core bắt buộc

Flow:

``` text
Profile
 ↓
Change Password
 ↓
Current password
 ↓
New password
 ↓
Confirm new password
 ↓
Verify current password
 ↓
Hash new password
 ↓
Update User.passwordHash
```

Không cần OTP trong core hiện tại.

------------------------------------------------------------------------

# 12. Profile - Core bắt buộc

Profile quản lý thông tin thuộc User.

### Có thể xem

``` text
fullName
email
phone
role
```

### Có thể thay đổi trong scope hiện tại

``` text
fullName
phone
```

Email không có flow OTP trong core hiện tại. Không tự mở rộng thành
change-email verification nếu chưa được thống nhất/triển khai.

Không cho client sửa trực tiếp:

``` text
id
role
passwordHash
```

------------------------------------------------------------------------

# 13. Address CRUD - Core bắt buộc

HAS thực hiện:

``` text
Add Address
Edit Address
Delete Address
Set Default Address
```

## Add

Kiểm tra: - `recipientName` hợp lệ. - `phone` hợp lệ. - `street` không
rỗng. - `ward`, `district`, `city` hợp lệ theo rule project.

Không có `latitude` / `longitude` vì project không tích hợp map.

## Edit

User chỉ được sửa Address của chính mình.

## Delete

Không cần password.

Có thể có confirmation trước khi xóa.

## Set default

Khi chọn Address mới làm default:

``` text
Address A.isDefault = false
Address B.isDefault = true
```

------------------------------------------------------------------------

# 14. OTP - Optional / Time Permitting

OTP **không nằm trong Core bắt buộc**.

Chỉ bắt đầu khi các chức năng Core HAS đã hoàn thành và test ổn định.

Thứ tự ưu tiên:

``` text
Core HAS
   ↓
OTP Email
   ↓
OTP Phone/SMS
```

Nếu hết thời gian sau Core hoặc OTP email, có thể bỏ OTP phone mà không
ảnh hưởng các chức năng Core.

------------------------------------------------------------------------

# 15. OTP Email - Optional phase 1

Nếu còn đủ thời gian và implementation đơn giản, có thể thêm OTP email.

Các flow ưu tiên có thể xem xét:

``` text
Email OTP
├── Register verification
└── Forgot password
```

Chỉ thêm những flow thực sự cần thiết và có thể hoàn thành/test trong
thời gian còn lại.

### Nếu implement

Có thể dùng abstraction tương đương:

``` text
OTPVerification
- target: String
- purpose: OTPPurpose
- expiresAt: DateTime
- attemptCount: int
- createdAt: DateTime
```

và:

``` text
<<enumeration>>
OTPPurpose

REGISTER
FORGOT_PASSWORD
```

Không lưu OTP plaintext lâu dài nếu implementation cần persistence.

### Rule tối thiểu

``` text
TTL = 5 minutes
Max attempts = 5
Resend cooldown = 60 seconds
Resend invalidates previous OTP
Used OTP becomes invalid
Purpose must match flow
```

Nếu OTP yêu cầu thêm hạ tầng phức tạp khiến Core bị chậm, **dừng ở đây
và ưu tiên Core**.

------------------------------------------------------------------------

# 16. OTP Phone/SMS - Optional phase 2

Chỉ thực hiện sau OTP email.

Điều kiện: - Core HAS hoàn thành. - OTP email hoạt động ổn định nếu đã
chọn làm. - Có thời gian. - Có cách gửi SMS phù hợp với project.

Có thể dùng cùng abstraction `OTPVerification` / `OTPPurpose` nếu
implementation thực tế phù hợp.

Không đưa latitude/longitude hoặc các field không liên quan vào OTP.

------------------------------------------------------------------------

# 17. Những nội dung KHÔNG thêm vào model hiện tại

Không thêm:

``` text
User.username
User.status
User.emailVerified
User.phoneVerified
UserStatus
Address.latitude
Address.longitude
```

Không thêm vào Business Class Diagram chỉ vì security best practice nếu
project không dùng:

``` text
lastLoginAt
failedLoginAttempts
passwordResetToken
```

OTP classes chỉ được thêm nếu nhóm thực sự quyết định implement optional
phase.

------------------------------------------------------------------------

# 18. Mapping HAS → implementation priority

  Chức năng         Priority   Trạng thái kế hoạch
  ----------------- ---------- -----------------------
  Register          P1         Bắt buộc
  Login             P1         Bắt buộc
  Logout            P1         Bắt buộc
  Role redirect     P1         Bắt buộc
  Profile           P1         Bắt buộc
  Change password   P1         Bắt buộc
  Address CRUD      P1         Bắt buộc
  OTP Email         P2         Làm nếu còn thời gian
  OTP Phone/SMS     P3         Chỉ sau OTP Email

------------------------------------------------------------------------

# 19. Checklist Lucidchart

## User

-   [ ] Giữ `id`.
-   [ ] Giữ `fullName`.
-   [ ] Giữ `email`.
-   [ ] Giữ `passwordHash`.
-   [ ] Giữ `phone`.
-   [ ] Giữ `role: UserRole`.
-   [ ] Không thêm `username`.
-   [ ] Không thêm `UserStatus`.

## Address

-   [ ] Thêm `recipientName: String`.
-   [ ] Thêm `phone: String`.
-   [ ] Giữ `street`, `ward`, `district`, `city`, `isDefault`.
-   [ ] Không thêm latitude/longitude.
-   [ ] User → Address = `1 : 0..*`.
-   [ ] Tối đa một Address mặc định.

## Associations

-   [ ] User → Cart = `1 : 0..1`.
-   [ ] User → Wishlist = `1 : 0..1`.
-   [ ] User → Order = `1 : 0..*`.
-   [ ] User → Review = `1 : 0..*`.

## Authentication

-   [ ] Login bằng email + password.
-   [ ] Session chứa userId + role.
-   [ ] ADMIN → Admin JSP.
-   [ ] CUSTOMER → Customer JSP.
-   [ ] Không tin role từ client.
-   [ ] Logout invalidate session.

## Optional OTP

-   [ ] Chỉ bắt đầu sau khi P1 hoàn thành.
-   [ ] Email trước.
-   [ ] Phone/SMS sau email.
-   [ ] Nếu thiếu thời gian, bỏ OTP phone trước.

------------------------------------------------------------------------

# 20. Definition of Done

## Core HAS

Phần HAS core được xem là hoàn thành khi:

1.  Register hoạt động với `fullName`, `email`, `phone`, password.
2.  Password được hash và không lưu plaintext.
3.  Login dùng email + password.
4.  Session được tạo sau authentication.
5.  ADMIN được redirect tới JSP dành cho Admin.
6.  CUSTOMER được redirect tới JSP dành cho Customer.
7.  Role được xác định server-side.
8.  Logout invalidate session.
9.  User đổi được password sau khi xác minh password hiện tại.
10. User xem/cập nhật được profile trong phạm vi cho phép.
11. User CRUD được Address của chính mình.
12. User có nhiều Address và tối đa một Address default.
13. `Address` có `recipientName` và `phone`.
14. Business class diagram vẫn là UML, không biến thành ERD.
15. Các association với Cart/Wishlist/Order/Review vẫn đúng.

## Optional

Nếu còn đủ thời gian:

16. OTP Email được implement và test ổn.
17. Sau đó mới cân nhắc OTP Phone/SMS.

OTP không được phép làm trì hoãn hoặc phá vỡ Core HAS.

------------------------------------------------------------------------

# 21. Thứ tự thực hiện đề xuất

``` text
1. User model + repository/service hiện có
        ↓
2. Register
        ↓
3. Login
        ↓
4. Session + role authorization
        ↓
5. Admin JSP / Customer JSP redirect
        ↓
6. Logout
        ↓
7. Profile
        ↓
8. Change Password
        ↓
9. Address CRUD
        ↓
10. Test toàn bộ Core HAS
        ↓
11. OTP Email (nếu còn thời gian)
        ↓
12. OTP Phone/SMS (chỉ khi OTP Email ổn)
```

**Nguyên tắc:** hoàn thành một Core flow có thể chạy/test được trước khi
mở rộng sang chức năng optional.

------------------------------------------------------------------------

# 22. Kết quả cuối cùng cần đạt

Business Class Diagram của HAS phải phản ánh đúng context project đã xác
thực, không thêm các field/class đã bị loại khỏi scope.

Baseline chính:

``` text
User
├── UserRole
├── Address
├── Cart
├── Wishlist
├── Order
└── Review
```

Optional khi triển khai OTP:

``` text
User
└── OTPVerification
      └── OTPPurpose
```

OTP là phần mở rộng, không phải điều kiện để Core HAS được xem là hoàn
thành.
