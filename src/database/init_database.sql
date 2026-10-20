-- ====================================================================
-- Script khởi tạo và nạp dữ liệu mẫu cho Database: clothing_web
-- Sử dụng: Chạy file này trên PostgreSQL (pgAdmin hoặc psql)
-- Lưu ý: Mật khẩu mặc định đã được băm chuẩn BCrypt (12 rounds)
--   - admin@clothingstore.com (hoặc admin@admin.com): mật khẩu là admin123
--   - user@clothingstore.com (hoặc user@user.com): mật khẩu là user123
-- ====================================================================

-- 1. Đảm bảo bảng users tồn tại (phòng trường hợp chưa chạy Hibernate update)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    role VARCHAR(50) NOT NULL CHECK (role IN ('CUSTOMER', 'ADMIN')),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Chèn 2 tài khoản chính và alias
INSERT INTO users (full_name, email, password_hash, phone, role, created_at)
VALUES 
    (
        'Quản Trị Viên',
        'admin@clothingstore.com',
        '$2a$12$9hs61TxB/zBhi1jEG0bjIOcD/pma/YBmAzkyFDZL7S.h6YKKDjeyW',
        '0901234567',
        'ADMIN',
        NOW()
    ),
    (
        'Khách Hàng Mẫu',
        'user@clothingstore.com',
        '$2a$12$yV1o6yL0a.gq80dBX/LffO6tpq9j3DmG0Hd.huJXfw0ym2yLbSrky',
        '0987654321',
        'CUSTOMER',
        NOW()
    ),
    (
        'Admin',
        'admin@admin.com',
        '$2a$12$9hs61TxB/zBhi1jEG0bjIOcD/pma/YBmAzkyFDZL7S.h6YKKDjeyW',
        '0901234567',
        'ADMIN',
        NOW()
    ),
    (
        'User',
        'user@user.com',
        '$2a$12$yV1o6yL0a.gq80dBX/LffO6tpq9j3DmG0Hd.huJXfw0ym2yLbSrky',
        '0987654321',
        'CUSTOMER',
        NOW()
    )
ON CONFLICT (email) DO UPDATE 
SET password_hash = EXCLUDED.password_hash,
    role = EXCLUDED.role;
