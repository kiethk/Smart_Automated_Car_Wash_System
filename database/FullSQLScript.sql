CREATE DATABASE CAR_WASH_DB
GO

USE CAR_WASH_DB
GO

-- ========================================================
-- 1. NHÓM BẢNG ĐỘC LẬP (ÍT PHỤ THUỘC)
-- ========================================================

-- Bảng Vai trò (Role) - Giữ nguyên ID cố định để cấu hình hệ thống
CREATE TABLE Role (
    role_id INT PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX)
);

-- Bảng Hạng thành viên (Tiers) - Giữ nguyên ID cố định để dễ quản lý logic phân hạng
CREATE TABLE Tiers (
    tier_id INT PRIMARY KEY,
    tier_name NVARCHAR(50) NOT NULL, -- Member, Silver, Gold, Platinum
    min_washes INT NOT NULL,          -- Số lần rửa tối thiểu
    min_spent BIGINT NOT NULL,        -- Chi tiêu tối thiểu (VND)
    point_multiplier DECIMAL(3, 2),   -- Hệ số nhân điểm (1.1, 1.2, 1.3)
    discount_percent DECIMAL(5, 2),   -- Giảm giá %
    booking_window_days INT,          -- Số ngày được đặt trước
    description NVARCHAR(MAX)
);

-- Bảng Khuyến mãi (Promotion)
CREATE TABLE Promotion (
    promotion_id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(50) UNIQUE NOT NULL,
    discount_type NVARCHAR(20), -- 'percent', 'fixed'
    discount_value BIGINT,      -- Giá trị giảm (VND hoặc %)
    min_order_amount BIGINT,    -- Giá trị đơn hàng tối thiểu (VND)
    usage_limit INT,
    start_date DATE,
    end_date DATE,
    is_active INT, -- 1: Hoạt động, 0: Tạm dừng
    target_tier_id INT NULL, -- Gửi đến hạng cụ thể (Silver+ only)
    FOREIGN KEY (target_tier_id) REFERENCES Tiers(tier_id)
);

-- Bảng Khoang rửa xe (Bay)
CREATE TABLE Bay (
    bay_id INT PRIMARY KEY IDENTITY(1,1),
    bay_name NVARCHAR(50) NOT NULL,
    status NVARCHAR(20), -- available, occupied, maintenance
    capacity_per_hour INT
);

-- Bảng Dịch vụ (Service)
CREATE TABLE Service (
    service_id INT PRIMARY KEY IDENTITY(1,1),
    service_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price BIGINT NOT NULL, -- Giá dịch vụ (VND)
    duration_minutes INT,
    is_active INT
);

-- ========================================================
-- 2. NHÓM BẢNG QUẢN LÝ NGƯỜI DÙNG & KHÁCH HÀNG
-- ========================================================

-- Bảng Tài khoản người dùng (User)
CREATE TABLE [User] (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(15),
    password NVARCHAR(255) NOT NULL,
    is_active INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    role_id INT,
    avatar_url NVARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

-- Bảng Khách hàng (Customer)
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    address NVARCHAR(MAX),
    total_points INT DEFAULT 0,
    total_spent BIGINT DEFAULT 0, -- Tổng chi tiêu (VND)
    total_washes INT DEFAULT 0,   -- Tổng số lần rửa
    join_date DATE,
    date_of_birth DATE,
    user_id INT UNIQUE,
    tier_id INT,
    last_review_date DATE, -- Lần cuối review để upgrade/downgrade
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (tier_id) REFERENCES Tiers(tier_id)
);

-- Bảng Xe (Vehicle) - LPR
CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),
    plate_number NVARCHAR(20) UNIQUE NOT NULL,
    brand NVARCHAR(50),
    model NVARCHAR(50),
    vehicle_type NVARCHAR(30),
    color NVARCHAR(20),
    manufacture_year INT,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Bảng Lịch sử điểm thưởng (LoyaltyPointHistory)
CREATE TABLE LoyaltyPointHistory (
    point_history_id INT PRIMARY KEY IDENTITY(1,1),
    points_earned INT DEFAULT 0,
    points_used INT DEFAULT 0,
    transaction_type NVARCHAR(20), -- earned, redeemed, expired
    description NVARCHAR(MAX),
    expired_date DATE NULL, -- Điểm hết hạn sau 12 tháng
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Bảng Thông báo (Notifications)
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(200) NOT NULL,
    content NVARCHAR(MAX),
    type NVARCHAR(30),
    is_read INT DEFAULT 0,
    reference_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- ========================================================
-- 3. NHÓM BẢNG ĐẶT LỊCH VÀ GIAO DỊCH
-- ========================================================

-- Bảng Đặt lịch (Booking)
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    booking_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    discount_amount BIGINT DEFAULT 0, -- Số tiền giảm (VND)
    total_amount BIGINT NOT NULL,     -- Tổng tiền phải trả (VND)
    points_earned INT DEFAULT 0,      -- Điểm kiếm được từ booking này
    status NVARCHAR(20), -- pending, confirmed, completed, cancelled
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT,
    vehicle_id INT,
    bay_id INT,
    promotion_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (bay_id) REFERENCES Bay(bay_id),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id)
);

-- Bảng Thanh toán (Payment)
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    payment_method NVARCHAR(50), -- cash, credit_card, wallet, momo, vnpay
    payment_status NVARCHAR(20), -- pending, completed, failed, refunded
    amount BIGINT NOT NULL,       -- Số tiền thanh toán (VND)
    paid_at DATETIME,
    transaction_id NVARCHAR(100),
    booking_id INT UNIQUE,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Bảng Đánh giá (Feedback)
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    booking_id INT UNIQUE,
    customer_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Bảng Lịch sử rửa xe (WashHistory) - Kết hợp với LPR
CREATE TABLE WashHistory (
    wash_history_id INT PRIMARY KEY IDENTITY(1,1),
    start_time DATETIME,
    end_time DATETIME,
    wash_status NVARCHAR(20), -- pending, washing, completed, cancelled
    lpr_image_url NVARCHAR(500), -- Ảnh biển số từ camera
    notes NVARCHAR(MAX),
    booking_id INT,
    bay_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (bay_id) REFERENCES Bay(bay_id)
);

-- ========================================================
-- 4. NHÓM BẢNG TRUNG GIAN
-- ========================================================

-- Bảng trung gian: Chi tiết dịch vụ được đặt
CREATE TABLE BookingService (
    booking_service_id INT PRIMARY KEY IDENTITY(1,1),
    quantity INT DEFAULT 1,
    price BIGINT NOT NULL, -- Giá dịch vụ tại thời điểm đặt (VND)
    booking_id INT,
    service_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

-- Bảng trung gian: Lịch sử dùng mã khuyến mãi
CREATE TABLE PromotionUsage (
    promotion_usage_id INT PRIMARY KEY IDENTITY(1,1),
    used_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    promotion_id INT,
    booking_id INT,
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- ========================================================
-- 5. NHÓM BẢNG VÍ TIỀN (ĐƠN GIẢN CHO SINH VIÊN)
-- ========================================================

-- Bảng Ví tiền (Wallet)
CREATE TABLE Wallet (
    wallet_id INT PRIMARY KEY IDENTITY(1,1),
    balance BIGINT DEFAULT 0, -- Số dư ví (VND)
    customer_id INT UNIQUE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Bảng Lịch sử giao dịch ví
CREATE TABLE WalletTransaction (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    amount BIGINT NOT NULL, -- dương: nạp, âm: trừ (VND)
    type NVARCHAR(20), -- deposit, payment, refund
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    wallet_id INT,
    booking_id INT NULL,
    FOREIGN KEY (wallet_id) REFERENCES Wallet(wallet_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- ========================================================
-- THÊM CÁC RÀNG BUỘC (CONSTRAINTS) - PHIÊN BẢN ĐÃ SỬA LỖI
-- ========================================================

-- Ràng buộc Role
ALTER TABLE Role ADD CONSTRAINT CHK_Role_Name 
CHECK (role_name IN (N'Admin', N'Staff', N'Customer'));

-- Ràng buộc Tiers
ALTER TABLE Tiers ADD CONSTRAINT CHK_Tier_Name 
CHECK (tier_name IN (N'Member', N'Silver', N'Gold', N'Platinum'));

ALTER TABLE Tiers ADD CONSTRAINT CHK_Tier_MinWashes 
CHECK (min_washes >= 0);

ALTER TABLE Tiers ADD CONSTRAINT CHK_Tier_MinSpent 
CHECK (min_spent >= 0);

-- Ràng buộc dịch vụ
ALTER TABLE Service ADD CONSTRAINT CHK_Service_Price 
CHECK (price > 0);

ALTER TABLE Service ADD CONSTRAINT CHK_Service_Duration 
CHECK (duration_minutes > 0);

-- Ràng buộc Booking (CHỈ CHECK, KHÔNG DEFAULT)
ALTER TABLE Booking ADD CONSTRAINT CHK_Booking_Amount 
CHECK (total_amount >= 0);

-- Ràng buộc Wallet
ALTER TABLE Wallet ADD CONSTRAINT CHK_Wallet_Balance 
CHECK (balance >= 0);

-- Ràng buộc WalletTransaction
ALTER TABLE WalletTransaction ADD CONSTRAINT CHK_WT_Type 
CHECK (type IN (N'deposit', N'payment', N'refund'));

-- UNIQUE cho số điện thoại
ALTER TABLE [User] ADD CONSTRAINT UQ_User_Phone UNIQUE (phone);


-- ========================================================
-- SCRIPT ADD DATA
-- ========================================================
-- ========================================================
-- KỊCH BẢN XÓA DỮ LIỆU CŨ THEO ĐÚNG THỨ TỰ KHÓA NGOẠI
-- ========================================================
DELETE FROM PromotionUsage;
DELETE FROM BookingService;
DELETE FROM WashHistory;
DELETE FROM Feedback;
DELETE FROM Payment;
DELETE FROM WalletTransaction;
DELETE FROM Wallet;
DELETE FROM Booking;
DELETE FROM Notifications;
DELETE FROM LoyaltyPointHistory;
DELETE FROM Vehicle;
DELETE FROM Customer;
DELETE FROM [User];
DELETE FROM Service;
DELETE FROM Bay;
DELETE FROM Promotion;
DELETE FROM Tiers;
DELETE FROM Role;
GO

-- ========================================================
-- 1. NHÓM BẢNG ĐỘC LẬP (ÍT PHỤ THUỘC)
-- ========================================================

-- Nạp bảng Role (Khớp với CONSTRAINT CHK_Role_Name)
INSERT INTO Role (role_id, role_name, description) VALUES 
(1, N'Admin', N'Quản trị viên toàn quyền hệ thống'),
(2, N'Staff', N'Nhân viên vận hành khoang rửa xe'),
(3, N'Customer', N'Khách hàng sử dụng dịch vụ');

-- Nạp bảng Tiers (Khớp với CONSTRAINT CHK_Tier_Name và cấu trúc cột của bạn)
INSERT INTO Tiers (tier_id, tier_name, min_washes, min_spent, point_multiplier, discount_percent, booking_window_days, description) VALUES 
(1, N'Member',   0,  0,        1.00, 0.00,  7,  N'Thành viên mới đăng ký'),
(2, N'Silver',   5,  2000000,  1.10, 5.00,  10, N'Thành viên Bạc - Đạt 5 lần rửa hoặc tiêu 2 triệu'),
(3, N'Gold',     15, 6000000,  1.20, 10.00, 12, N'Thành viên Vàng - Đạt 15 lần rửa hoặc tiêu 6 triệu'),
(4, N'Platinum', 30, 15000000, 1.30, 15.00, 14, N'Thành viên Bạch Kim - Đạt 30 lần rửa hoặc tiêu 15 triệu');

-- Nạp bảng Promotion (Mã giảm giá)
INSERT INTO Promotion (code, discount_type, discount_value, min_order_amount, usage_limit, start_date, end_date, is_active, target_tier_id) VALUES
(N'WELCOME50', N'fixed', 50000, 0, 100, '2026-01-01', '2026-12-31', 1, NULL),
(N'GOLDPREMIUM', N'percent', 15, 100000, 50, '2026-01-01', '2026-12-31', 1, 3); -- Dành riêng cho Gold+

-- Nạp bảng Bay (Khoang rửa xe)
INSERT INTO Bay (bay_name, status, capacity_per_hour) VALUES
(N'Bay Tự Động 01', N'available', 6),
(N'Bay Tự Động 02', N'available', 6),
(N'Bay Tự động 03', N'maintenance', 0);

-- Nạp bảng Service (Các gói dịch vụ phân tách theo ý tưởng dòng xe của bạn)
INSERT INTO Service (service_name, description, price, duration_minutes, is_active) VALUES
-- Nhóm dịch vụ dành cho xe nhỏ (Sedan)
(N'Express Wash (Sedan)', N'Rửa nhanh áp lực cao, bọt tuyết, sấy khô cho Sedan', 50000, 5, 1),
(N'Deluxe Wash (Sedan)', N'Gói Express + làm sạch mâm lốp, dưỡng bóng lốp cho Sedan', 80000, 7, 1),
(N'Ultimate Wax Wash (Sedan)', N'Gói Deluxe + xịt sáp bóng ceramic, khử mùi cabin cho Sedan', 120000, 10, 1),

-- Nhóm dịch vụ dành cho xe lớn (SUV / Truck)
(N'Express Wash (SUV/Truck)', N'Rửa nhanh áp lực cao công suất lớn cho gầm cao SUV/Truck', 70000, 7, 1),
(N'Deluxe Wash (SUV/Truck)', N'Gói Express + tẩy ố lazang chuyên sâu cho SUV/Truck', 100000, 10, 1),
(N'Ultimate Wax Wash (SUV/Truck)', N'Gói Deluxe + phủ bóng sáp bảo vệ sơn diện tích lớn cho SUV/Truck', 150000, 13, 1);

-- ========================================================
-- 2. NHÓM BẢNG QUẢN LÝ NGƯỜI DÙNG & KHÁCH HÀNG
-- ========================================================

-- Nạp bảng User (Tạo tài khoản trước)
INSERT INTO [User] (full_name, email, phone, password, is_active, role_id) VALUES
(N'Nguyễn Admin', 'admin@autowash.com', '0900000001', 'password123', 1, 1), -- Admin
(N'Trần Nhân Viên', 'staff@autowash.com', '0900000002', 'password123', 1, 2), -- Staff
(N'Nguyễn Minh Hoàng', 'hoang@gmail.com', '0912345678', 'password123', 1, 3), -- Khách 1
(N'Trần Thị Ngọc', 'ngoc@gmail.com', '0987654321', 'password123', 1, 3),    -- Khách 2
(N'Cao Minh Kỳ', 'ky@gmail.com', '0905111222', 'password123', 1, 3),       -- Khách 3
(N'Lê Hoàng Long', 'long@gmail.com', '0933444555', 'password123', 1, 3);    -- Khách 4

-- Nạp bảng Customer (Liên kết 1-1 với User vừa tạo qua user_id)
-- Giả định ID sinh tự động từ 1 đến 4 cho nhóm tài khoản khách hàng (user_id 3, 4, 5, 6)
INSERT INTO Customer (address, total_points, total_spent, total_washes, join_date, date_of_birth, user_id, tier_id, last_review_date) VALUES
(N'Quận 9, TP. HCM', 3,  150000,   3,  '2026-01-15', '1998-05-20', 3, 1, '2026-05-01'), -- Member
(N'Quận 7, TP. HCM', 8,  2400000,  6,  '2026-02-10', '1995-11-12', 4, 2, '2026-05-01'), -- Silver
(N'Thủ Đức, TP. HCM', 25, 7200000,  16, '2025-12-01', '1990-02-15', 5, 3, '2026-05-01'), -- Gold
(N'Quận 1, TP. HCM', 45, 16500000, 32, '2025-08-20', '1988-08-08', 6, 4, '2026-05-01'); -- Platinum

-- Nạp bảng Vehicle (Khớp với các dòng xe tương ứng của từng khách hàng)
INSERT INTO Vehicle (plate_number, brand, model, vehicle_type, color, manufacture_year, customer_id) VALUES
('51G-12345', 'Toyota', 'Vios', 'Sedan', N'Trắng', 2021, 1), -- Xe Khách 1 (Sedan)
('51H-67890', 'Mazda', 'CX-5', 'SUV', N'Đỏ', 2022, 2),       -- Xe Khách 2 (SUV)
('51K-55555', 'Honda', 'City', 'Sedan', N'Đen', 2023, 3),     -- Xe Khách 3 (Sedan)
('51L-99999', 'Ford', 'Ranger', 'Truck', N'Xám', 2022, 4);   -- Xe Khách 4 (Truck)

-- Nạp bảng Wallet (Tạo ví tiền điện tử cho khách hàng)
INSERT INTO Wallet (balance, customer_id) VALUES
(100000, 1),
(500000, 2),
(1200000, 3),
(2500000, 4);

-- ========================================================
-- 3. NHÓM BẢNG ĐẶT LỊCH VÀ GIAO DỊCH LỊCH SỬ
-- ========================================================

-- Nạp bảng Booking (Lịch sử đặt lịch)
-- Khách 1 và Khách 2 đã hoàn thành lịch trình cũ
INSERT INTO Booking (booking_date, appointment_time, discount_amount, total_amount, points_earned, status, notes, customer_id, vehicle_id, bay_id, promotion_id) VALUES
('2026-05-24', '08:30:00', 0, 50000, 1, N'completed', N'Rửa nhanh sạch sẽ', 1, 1, 1, NULL),
('2026-05-25', '10:00:00', 0, 100000, 2, N'completed', N'Rửa kỹ mâm lốp', 2, 2, 2, NULL);

-- Khách 3 (Thành viên hạng GOLD - Xe Sedan) đặt lịch sắp tới để test trên React
INSERT INTO Booking (booking_date, appointment_time, discount_amount, total_amount, points_earned, status, notes, customer_id, vehicle_id, bay_id, promotion_id) VALUES
('2026-06-05', '14:00:00', 12000, 108000, 2, N'pending', N'Khách hàng Gold đặt gói Premium Wax', 3, 3, 1, NULL);

-- ========================================================
-- 4. NHÓM BẢNG CHI TIẾT TRUNG GIAN
-- ========================================================

-- Nạp bảng BookingService (Liên kết Booking với dịch vụ đã chọn)
INSERT INTO BookingService (quantity, price, booking_id, service_id) VALUES
(1, 50000, 1, 1),  -- Booking 1 dùng gói Express (Sedan)
(1, 100000, 2, 5), -- Booking 2 dùng gói Deluxe (SUV/Truck)
(1, 120000, 3, 3); -- Booking 3 dùng gói Ultimate Wax (Sedan)

-- Nạp bảng WashHistory (Lịch sử camera LPR quét nhận diện xe tự động tại khoang)
INSERT INTO WashHistory (start_time, end_time, wash_status, lpr_image_url, notes, booking_id, bay_id) VALUES
('2026-05-24 08:31:12', '2026-05-24 08:36:45', N'completed', N'https://storage.autowash.com/lpr/51G12345.jpg', N'LPR nhận diện khớp 100%', 1, 1),
('2026-05-25 10:02:05', '2026-05-25 10:12:20', N'completed', N'https://storage.autowash.com/lpr/51H67890.jpg', N'LPR quét thành công', 2, 2);

-- Nạp bảng Payment (Hóa đơn thanh toán)
INSERT INTO Payment (payment_method, payment_status, amount, paid_at, transaction_id, booking_id) VALUES
(N'cash', N'completed', 50000, '2026-05-24 08:38:00', N'TXN-001', 1),
(N'wallet', N'completed', 100000, '2026-05-25 10:13:00', N'TXN-002', 2);
GO