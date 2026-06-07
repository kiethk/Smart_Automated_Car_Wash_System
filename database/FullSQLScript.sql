CREATE DATABASE CAR_WASH_DB
GO

USE CAR_WASH_DB
GO

-- ========================================================
-- 1. ĐỊNH NGHĨA CÁC BẢNG (DDL SCHEMA)
-- ========================================================

-- Bảng Vai trò
CREATE TABLE Role (
    role_id INT PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX)
);

-- Bảng Hạng thành viên
CREATE TABLE Tiers (
    tier_id INT PRIMARY KEY,
    tier_name NVARCHAR(50) NOT NULL, 
    min_washes INT NOT NULL,          
    min_spent BIGINT NOT NULL,        
    point_multiplier DECIMAL(3, 2),   
    discount_percent DECIMAL(5, 2),   
    booking_window_days INT,          
    description NVARCHAR(MAX)
);

-- Bảng Khuyến mãi
CREATE TABLE Promotion (
    promotion_id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(50) UNIQUE NOT NULL,
    discount_type NVARCHAR(20), 
    discount_value BIGINT,      
    min_order_amount BIGINT,    
    usage_limit INT,
    start_date DATE,
    end_date DATE,
    is_active INT, 
    target_tier_id INT NULL, 
    FOREIGN KEY (target_tier_id) REFERENCES Tiers(tier_id)
);

-- Bảng Khoang rửa xe
CREATE TABLE Bay (
    bay_id INT PRIMARY KEY IDENTITY(1,1),
    bay_name NVARCHAR(50) NOT NULL,
    status NVARCHAR(20), 
    capacity_per_hour INT
);

-- Bảng Dịch vụ
CREATE TABLE Service (
    service_id INT PRIMARY KEY IDENTITY(1,1),
    service_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price BIGINT NOT NULL, 
    duration_minutes INT,
    is_active INT
);

-- Bảng Tài khoản người dùng
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

-- Bảng Khách hàng
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    address NVARCHAR(MAX),
    total_points INT DEFAULT 0,
    total_spent BIGINT DEFAULT 0, 
    total_washes INT DEFAULT 0,   
    join_date DATE,
    date_of_birth DATE,
    user_id INT UNIQUE,
    tier_id INT,
    last_review_date DATE, 
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (tier_id) REFERENCES Tiers(tier_id)
);

-- Bảng Hãng xe
CREATE TABLE Brand (
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    brand_name NVARCHAR(50) UNIQUE NOT NULL
);

-- Bảng Dòng xe
-- FIX: REFERENCES Brand(brand_id) thay vì Brands(brand_id)
CREATE TABLE Model (
    model_id INT PRIMARY KEY IDENTITY(1,1),
    model_name NVARCHAR(50) NOT NULL,
    brand_id INT NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES Brand(brand_id) ON DELETE CASCADE
);

-- Bảng Xe
-- FIX: REFERENCES Model(model_id) thay vì Models(model_id)
-- FIX: Thêm custom_brand_name và custom_model_name để hỗ trợ hãng/dòng xe không có trong hệ thống
CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),
    plate_number NVARCHAR(20) UNIQUE NOT NULL,
    model_id INT NOT NULL,
    vehicle_type NVARCHAR(30),
    color NVARCHAR(20),
    manufacture_year INT,
    customer_id INT,
    is_active INT DEFAULT 1,
    vehicle_image_url NVARCHAR(255) DEFAULT NULL,
    custom_brand_name NVARCHAR(50) DEFAULT NULL,   -- Hãng xe tự nhập (khi brand không có trong hệ thống)
    custom_model_name NVARCHAR(50) DEFAULT NULL,   -- Dòng xe tự nhập (khi model không có trong hệ thống)
    FOREIGN KEY (model_id) REFERENCES Model(model_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Bảng Lịch sử điểm thưởng
CREATE TABLE LoyaltyPointHistory (
    point_history_id INT PRIMARY KEY IDENTITY(1,1),
    points_earned INT DEFAULT 0,
    points_used INT DEFAULT 0,
    transaction_type NVARCHAR(20), 
    description NVARCHAR(MAX),
    expired_date DATE NULL, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Bảng Thông báo
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

-- Bảng Khung giờ mặc định
CREATE TABLE Slot (
    slot_id INT PRIMARY KEY IDENTITY(1,1),
    time_value VARCHAR(20) NOT NULL,  
    start_time TIME NOT NULL,         
    end_time TIME NOT NULL,           
    max_capacity INT DEFAULT 3,       
    is_active INT DEFAULT 1  
);

-- Bảng Đặt lịch
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    booking_date DATE NOT NULL,       
    slot_id INT NOT NULL,             
    discount_amount BIGINT DEFAULT 0, 
    total_amount BIGINT NOT NULL,     
    points_earned INT DEFAULT 0,      
    status NVARCHAR(20),              
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT,
    vehicle_id INT,
    bay_id INT,
    promotion_id INT,
    FOREIGN KEY (slot_id) REFERENCES Slot(slot_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (bay_id) REFERENCES Bay(bay_id),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id)
);

-- Bảng Thanh toán
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    payment_method NVARCHAR(50), 
    payment_status NVARCHAR(20), 
    amount BIGINT NOT NULL,       
    paid_at DATETIME,
    transaction_id NVARCHAR(100),
    booking_id INT UNIQUE,
    checkin_image_url NVARCHAR(255) DEFAULT NULL,   -- Ảnh camera lúc xe vào cổng
    checkout_image_url NVARCHAR(255) DEFAULT NULL,  -- Ảnh camera lúc xe ra cổng
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Bảng Đánh giá phản hồi
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

-- Bảng Chi tiết dịch vụ đặt
CREATE TABLE BookingService (
    booking_service_id INT PRIMARY KEY IDENTITY(1,1),
    quantity INT DEFAULT 1,
    price BIGINT NOT NULL, 
    booking_id INT,
    service_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

-- Bảng Lịch sử dùng mã khuyến mãi
CREATE TABLE PromotionUsage (
    promotion_usage_id INT PRIMARY KEY IDENTITY(1,1),
    used_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    promotion_id INT,
    booking_id INT,
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Bảng Ví tiền thành viên
CREATE TABLE Wallet (
    wallet_id INT PRIMARY KEY IDENTITY(1,1),
    balance BIGINT DEFAULT 0, 
    customer_id INT UNIQUE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Bảng Lịch sử giao dịch ví
CREATE TABLE WalletTransaction (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    amount BIGINT NOT NULL, 
    type NVARCHAR(20), 
    description NVARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    wallet_id INT,
    booking_id INT NULL,
    FOREIGN KEY (wallet_id) REFERENCES Wallet(wallet_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);
GO

-- ========================================================
-- 2. ĐỊNH NGHĨA RÀNG BUỘC CHECK CONSTRAINTS
-- ========================================================

ALTER TABLE Role ADD CONSTRAINT CHK_Role_Name CHECK (role_name IN (N'Admin', N'Staff', N'Customer'));
ALTER TABLE Tiers ADD CONSTRAINT CHK_Tier_Name CHECK (tier_name IN (N'Member', N'Silver', N'Gold', N'Platinum'));
ALTER TABLE Tiers ADD CONSTRAINT CHK_Tier_MinWashes CHECK (min_washes >= 0);
ALTER TABLE Tiers ADD CONSTRAINT CHK_Tier_MinSpent CHECK (min_spent >= 0);
ALTER TABLE Service ADD CONSTRAINT CHK_Service_Price CHECK (price > 0);
ALTER TABLE Service ADD CONSTRAINT CHK_Service_Duration CHECK (duration_minutes > 0);
ALTER TABLE Booking ADD CONSTRAINT CHK_Booking_Amount CHECK (total_amount >= 0);
ALTER TABLE Wallet ADD CONSTRAINT CHK_Wallet_Balance CHECK (balance >= 0);
ALTER TABLE WalletTransaction ADD CONSTRAINT CHK_WT_Type CHECK (type IN (N'deposit', N'payment', N'refund'));
GO

-- ========================================================
-- 3. KỊCH BẢN LÀM SẠCH VÀ CHÈN DỮ LIỆU (DML)
-- ========================================================

DELETE FROM PromotionUsage;
DELETE FROM BookingService;
DELETE FROM Feedback;
DELETE FROM Payment;
DELETE FROM WalletTransaction;
DELETE FROM Wallet;
DELETE FROM Booking;
DELETE FROM Notifications;
DELETE FROM LoyaltyPointHistory;
DELETE FROM Vehicle;
-- FIX: Tên bảng đúng là Model và Brand (không phải Models, Brands)
DELETE FROM Model;
DELETE FROM Brand;
DELETE FROM Customer;
DELETE FROM [User];
DELETE FROM Service;
DELETE FROM Bay;
DELETE FROM Promotion;
DELETE FROM Tiers;
DELETE FROM Role;
DELETE FROM Slot;
GO

-- Nạp bảng Role
INSERT INTO Role (role_id, role_name, description) VALUES 
(1, N'Admin', N'Quản trị viên toàn quyền hệ thống'),
(2, N'Staff', N'Nhân viên vận hành khoang rửa xe'),
(3, N'Customer', N'Khách hàng sử dụng dịch vụ');

-- Nạp bảng Tiers
INSERT INTO Tiers (tier_id, tier_name, min_washes, min_spent, point_multiplier, discount_percent, booking_window_days, description) VALUES 
(1, N'Member',   0,  0,        1.00, 0.00,  7,  N'Thành viên mới đăng ký'),
(2, N'Silver',   5,  2000000,  1.10, 5.00,  10, N'Thành viên Bạc'),
(3, N'Gold',     15, 6000000,  1.20, 10.00, 12, N'Thành viên Vàng'),
(4, N'Platinum', 30, 15000000, 1.30, 15.00, 14, N'Thành viên Bạch Kim');

-- Nạp bảng Promotion
INSERT INTO Promotion (code, discount_type, discount_value, min_order_amount, usage_limit, start_date, end_date, is_active, target_tier_id) VALUES
(N'WELCOME50',   N'fixed',   50000, 0,      100, '2026-01-01', '2026-12-31', 1, NULL),
(N'GOLDPREMIUM', N'percent', 15,    100000, 50,  '2026-01-01', '2026-12-31', 1, 3);

-- Nạp bảng Bay
INSERT INTO Bay (bay_name, status, capacity_per_hour) VALUES
(N'Bay Tự Động 01', N'available',  6),
(N'Bay Tự Động 02', N'available',  6),
(N'Bay Tự động 03', N'maintenance', 0);

-- Nạp bảng Service
INSERT INTO Service (service_name, description, price, duration_minutes, is_active) VALUES
(N'Express Wash (Sedan)',       N'Rửa nhanh áp lực cao, bọt tuyết, sấy khô cho Sedan',            50000,  5,  1),
(N'Deluxe Wash (Sedan)',        N'Gói Express + làm sạch mâm lốp, dưỡng bóng lốp cho Sedan',       80000,  7,  1),
(N'Ultimate Wax Wash (Sedan)',  N'Gói Deluxe + xịt sáp bóng ceramic, khử mùi cabin cho Sedan',    120000, 10, 1),
(N'Express Wash (SUV/Truck)',   N'Rửa nhanh áp lực cao công suất lớn cho gầm cao SUV/Truck',       70000,  7,  1),
(N'Deluxe Wash (SUV/Truck)',    N'Gói Express + tẩy ố lazang chuyên sâu cho SUV/Truck',            100000, 10, 1),
(N'Ultimate Wax Wash (SUV/Truck)', N'Gói Deluxe + phủ bóng sáp bảo vệ sơn cho SUV/Truck',        150000, 13, 1);

-- Nạp bảng User
INSERT INTO [User] (full_name, email, phone, password, is_active, role_id) VALUES
(N'Nguyễn Admin',    'admin@autowash.com', '0900000001', 'password123', 1, 1),
(N'Trần Nhân Viên',  'staff@autowash.com', '0900000002', 'password123', 1, 2),
(N'Nguyễn Minh Hoàng', 'hoang@gmail.com', '0912345678', 'password123', 1, 3),
(N'Trần Thị Ngọc',  'ngoc@gmail.com',  '0987654321', 'password123', 1, 3),    
(N'Cao Minh Kỳ',    'ky@gmail.com',    '0905111222', 'password123', 1, 3),       
(N'Lê Hoàng Long',  'long@gmail.com',  '0933444555', 'password123', 1, 3);

-- Nạp bảng Customer
INSERT INTO Customer (address, total_points, total_spent, total_washes, join_date, date_of_birth, user_id, tier_id, last_review_date) VALUES
(N'Quận 9, TP. HCM',   3,  150000,   3,  '2026-01-15', '1998-05-20', 3, 1, '2026-05-01'),
(N'Quận 7, TP. HCM',   8,  2400000,  6,  '2026-02-10', '1995-11-12', 4, 2, '2026-05-01'),
(N'Thủ Đức, TP. HCM',  25, 7200000,  16, '2025-12-01', '1990-02-15', 5, 3, '2026-05-01'),
(N'Quận 1, TP. HCM',   45, 16500000, 32, '2025-08-20', '1988-08-08', 6, 4, '2026-05-01');

-- Nạp bảng Brand
-- FIX: Thêm dòng 'Other' (brand_id = 12) để hỗ trợ hãng xe tự nhập
INSERT INTO Brand (brand_name) VALUES 
(N'Honda'),          -- brand_id: 1
(N'Toyota'),         -- brand_id: 2
(N'Mazda'),          -- brand_id: 3
(N'Ford'),           -- brand_id: 4
(N'Hyundai'),        -- brand_id: 5
(N'Kia'),            -- brand_id: 6
(N'Mitsubishi'),     -- brand_id: 7
(N'VinFast'),        -- brand_id: 8
(N'Suzuki'),         -- brand_id: 9
(N'Mercedes-Benz'),  -- brand_id: 10
(N'BMW'),            -- brand_id: 11
(N'Other');          -- brand_id: 12 | Dành cho hãng xe không có trong danh sách
GO

-- Nạp bảng Model
-- FIX: Thêm dòng 'Other' thuộc brand Other (brand_id = 12) để hỗ trợ dòng xe tự nhập
INSERT INTO Model (model_name, brand_id) VALUES 
-- Honda (brand_id = 1)
(N'Civic', 1),            -- model_id: 1
(N'City', 1),             -- model_id: 2
(N'CR-V', 1),             -- model_id: 3
(N'HR-V', 1),             -- model_id: 4

-- Toyota (brand_id = 2)
(N'Vios', 2),             -- model_id: 5
(N'Camry', 2),            -- model_id: 6
(N'Innova', 2),           -- model_id: 7
(N'Corolla Cross', 2),    -- model_id: 8
(N'Veloz Cross', 2),      -- model_id: 9

-- Mazda (brand_id = 3)
(N'Mazda 3', 3),          -- model_id: 10
(N'CX-5', 3),             -- model_id: 11
(N'Mazda 6', 3),          -- model_id: 12
(N'CX-8', 3),             -- model_id: 13

-- Ford (brand_id = 4)
(N'Ranger', 4),           -- model_id: 14
(N'Everest', 4),          -- model_id: 15
(N'Territory', 4),        -- model_id: 16

-- Hyundai (brand_id = 5)
(N'Accent', 5),           -- model_id: 17
(N'Grand i10', 5),        -- model_id: 18
(N'Tucson', 5),           -- model_id: 19
(N'Santa Fe', 5),         -- model_id: 20
(N'Creta', 5),            -- model_id: 21

-- Kia (brand_id = 6)
(N'Morning', 6),          -- model_id: 22
(N'K3', 6),               -- model_id: 23
(N'Seltos', 6),           -- model_id: 24
(N'Sorento', 6),          -- model_id: 25
(N'Carnival', 6),         -- model_id: 26

-- Mitsubishi (brand_id = 7)
(N'Xpander', 7),          -- model_id: 27
(N'Outlander', 7),        -- model_id: 28
(N'Attrage', 7),          -- model_id: 29
(N'Triton', 7),           -- model_id: 30

-- VinFast (brand_id = 8)
(N'Fadil', 8),            -- model_id: 31
(N'VF 5', 8),             -- model_id: 32
(N'VF 8', 8),             -- model_id: 33
(N'VF 9', 8),             -- model_id: 34
(N'VF e34', 8),           -- model_id: 35

-- Suzuki (brand_id = 9)
(N'XL7', 9),              -- model_id: 36
(N'Swift', 9),            -- model_id: 37
(N'Ertiga', 9),           -- model_id: 38

-- Mercedes-Benz (brand_id = 10)
(N'C-Class', 10),         -- model_id: 39
(N'E-Class', 10),         -- model_id: 40
(N'GLC', 10),             -- model_id: 41

-- BMW (brand_id = 11)
(N'3 Series', 11),        -- model_id: 42
(N'5 Series', 11),        -- model_id: 43
(N'X5', 11),              -- model_id: 44

-- Other (brand_id = 12) | Dòng xe placeholder cho trường hợp tự nhập
(N'Other', 12);           -- model_id: 45
GO

-- Nạp bảng Vehicle
-- Ghi chú: Khi model_id = 45 (Other/Other), điền custom_brand_name và custom_model_name
INSERT INTO Vehicle (plate_number, model_id, vehicle_type, color, manufacture_year, customer_id, custom_brand_name, custom_model_name) VALUES
('51G-12345', 5,  'Sedan', N'White', 2021, 1, NULL, NULL),  -- Toyota Vios
('51H-67890', 11, 'SUV',   N'Red',   2022, 2, NULL, NULL),  -- Mazda CX-5
('51K-55555', 2,  'Sedan', N'Black', 2023, 3, NULL, NULL),  -- Honda City
('51L-99999', 14, 'Truck', N'Grey',  2022, 4, NULL, NULL);  -- Ford Ranger
GO

-- Nạp bảng Wallet
INSERT INTO Wallet (balance, customer_id) VALUES
(100000,  1),
(500000,  2),
(1200000, 3),
(2500000, 4);

-- Nạp bảng Slot
INSERT INTO Slot (time_value, start_time, end_time, max_capacity, is_active) VALUES  
('08:00 AM', '08:00:00', '09:30:00', 3, 1),
('09:30 AM', '09:30:00', '11:00:00', 3, 1),
('11:00 AM', '11:00:00', '12:30:00', 3, 1),
('02:00 PM', '14:00:00', '15:30:00', 3, 1),
('03:30 PM', '15:30:00', '17:00:00', 3, 1);

-- Nạp bảng Booking
INSERT INTO Booking (booking_date, slot_id, discount_amount, total_amount, points_earned, status, notes, customer_id, vehicle_id, bay_id, promotion_id) VALUES
('2026-05-24', 1, 0,     50000,  1, N'completed', N'Rửa nhanh sạch sẽ',                   1, 1, 1, NULL),
('2026-05-25', 2, 0,     100000, 2, N'completed', N'Rửa kỹ mâm lốp',                       2, 2, 2, NULL),
('2026-06-05', 4, 12000, 108000, 2, N'pending',   N'Khách hàng Gold đặt gói Premium Wax',  3, 3, 1, NULL);

-- Nạp bảng BookingService
INSERT INTO BookingService (quantity, price, booking_id, service_id) VALUES
(1, 50000,  1, 1),  -- Express Wash Sedan
(1, 100000, 2, 5),  -- Deluxe Wash SUV/Truck
(1, 120000, 3, 3);  -- Ultimate Wax Wash Sedan

-- Nạp bảng Payment
INSERT INTO Payment (payment_method, payment_status, amount, paid_at, transaction_id, booking_id, checkin_image_url, checkout_image_url) VALUES
(N'cash',   N'completed', 50000,  '2026-05-24 08:38:00', N'TXN-001', 1, N'/assets/images/mock/checkin_01.jpg', N'/assets/images/mock/checkout_01.jpg'),
(N'wallet', N'completed', 100000, '2026-05-25 10:13:00', N'TXN-002', 2, N'/assets/images/mock/checkin_02.jpg', N'/assets/images/mock/checkout_02.jpg');
GO

-- ========================================================
-- 4. VIEW HỖ TRỢ HIỂN THỊ THÔNG TIN XE (Brand/Model)
-- ========================================================
-- Dùng view này thay vì JOIN trực tiếp để tự động xử lý
-- trường hợp xe tự nhập (Other) vs xe có trong danh sách.

CREATE VIEW VehicleDetail AS
SELECT
    v.vehicle_id,
    v.plate_number,
    v.vehicle_type,
    v.color,
    v.manufacture_year,
    v.is_active,
    v.vehicle_image_url,
    v.customer_id,
    v.model_id,
    CASE 
        WHEN b.brand_name = N'Other' THEN v.custom_brand_name 
        ELSE b.brand_name 
    END AS brand_display,
    CASE 
        WHEN m.model_name = N'Other' THEN v.custom_model_name 
        ELSE m.model_name 
    END AS model_display
FROM Vehicle v
JOIN Model m ON v.model_id = m.model_id
JOIN Brand b ON m.brand_id  = b.brand_id;
GO