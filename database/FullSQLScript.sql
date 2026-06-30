CREATE DATABASE CAR_WASH_DB
GO

USE CAR_WASH_DB
GO

-- ========================================================
-- 1. ĐỊNH NGHĨA CÁC BẢNG (DDL SCHEMA)
-- ========================================================

CREATE TABLE Role (
    role_id INT PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX)
);

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

CREATE TABLE Promotion (
    promotion_id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(50) UNIQUE NOT NULL,
    title NVARCHAR(100) NOT NULL,          -- MỚI: Tiêu đề Voucher hiển thị Carousel
    description NVARCHAR(MAX),             -- MỚI: Mô tả chi tiết khuyến mãi
    image_url NVARCHAR(500) NULL,          -- MỚI: Đường dẫn ảnh banner voucher (nếu có)
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

-- FIX: Bỏ capacity_per_hour vì không dùng trong logic
CREATE TABLE Bay (
    bay_id INT PRIMARY KEY IDENTITY(1,1),
    bay_name NVARCHAR(50) NOT NULL,
    status NVARCHAR(20)
);

CREATE TABLE Service (
    service_id INT PRIMARY KEY IDENTITY(1,1),
    service_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price BIGINT NOT NULL,
    duration_minutes INT,
    is_active INT
);

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

CREATE TABLE CustomerMonthlyStats (
    customer_id INT NOT NULL,
    stat_year INT NOT NULL,
    stat_month INT NOT NULL,
    monthly_spent BIGINT NOT NULL DEFAULT 0,
    monthly_washes INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CustomerMonthlyStats PRIMARY KEY (customer_id, stat_year, stat_month),
    CONSTRAINT FK_CustomerMonthlyStats_Customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT CK_CustomerMonthlyStats_Month CHECK (stat_month BETWEEN 1 AND 12),
    CONSTRAINT CK_CustomerMonthlyStats_Spent CHECK (monthly_spent >= 0),
    CONSTRAINT CK_CustomerMonthlyStats_Washes CHECK (monthly_washes >= 0)
);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_CustomerMonthlyStats_ReviewPeriod'
      AND object_id = OBJECT_ID('dbo.CustomerMonthlyStats')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_CustomerMonthlyStats_ReviewPeriod
    ON dbo.CustomerMonthlyStats (stat_year, stat_month, customer_id)
    INCLUDE (monthly_spent, monthly_washes, updated_at);
END
GO

CREATE TABLE Brand (
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    brand_name NVARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Model (
    model_id INT PRIMARY KEY IDENTITY(1,1),
    model_name NVARCHAR(50) NOT NULL,
    brand_id INT NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES Brand(brand_id) ON DELETE CASCADE
);

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
    custom_brand_name NVARCHAR(50) DEFAULT NULL,
    custom_model_name NVARCHAR(50) DEFAULT NULL,
    FOREIGN KEY (model_id) REFERENCES Model(model_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

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

CREATE TABLE Slot (
    slot_id INT PRIMARY KEY IDENTITY(1,1),
    time_value VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active INT DEFAULT 1
);

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

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(20),
    amount BIGINT NOT NULL,
    paid_at DATETIME,
    transaction_id NVARCHAR(100),
    booking_id INT UNIQUE,
    checkin_image_url NVARCHAR(255) DEFAULT NULL,
    checkout_image_url NVARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

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

CREATE TABLE BookingService (
    booking_service_id INT PRIMARY KEY IDENTITY(1,1),
    quantity INT DEFAULT 1,
    price BIGINT NOT NULL,
    booking_id INT,
    service_id INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

CREATE TABLE PromotionUsage (
    promotion_usage_id INT PRIMARY KEY IDENTITY(1,1),
    used_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    promotion_id INT,
    booking_id INT,
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE TABLE Wallet (
    wallet_id INT PRIMARY KEY IDENTITY(1,1),
    balance BIGINT DEFAULT 0,
    customer_id INT UNIQUE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

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
ALTER TABLE Booking ADD CONSTRAINT CHK_Booking_Status 
    CHECK (status IN (N'pending', N'accepted', N'completed', N'cancelled', N'no_show'));
ALTER TABLE Wallet ADD CONSTRAINT CHK_Wallet_Balance CHECK (balance >= 0);
ALTER TABLE WalletTransaction ADD CONSTRAINT CHK_WT_Type CHECK (type IN (N'deposit', N'payment'));
GO


-- ========================================================
-- 3. LOYALTY ENGINE: TRIGGER & PROCEDURE (BẢN CHUẨN ĐÃ TÍCH HỢP KHÔI PHỤC HẠNG)
-- ========================================================

CREATE OR ALTER TRIGGER trg_Customer_ReviewTier_OnStatsChange
ON Customer
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Admin metric edits are for correction/demo and should not be counted as real monthly activity.
    IF TRY_CAST(SESSION_CONTEXT(N'SkipLoyaltyStats') AS INT) = 1
        RETURN;

    -- Chỉ kích hoạt khi có sự thay đổi về tổng chi tiêu hoặc tổng số lần rửa xe trọn đời
    IF NOT (UPDATE(total_spent) OR UPDATE(total_washes))
        RETURN;

    DECLARE @reviewYear INT = YEAR(GETDATE());
    DECLARE @reviewMonth INT = MONTH(GETDATE());

    DECLARE @ChangedCustomers TABLE (
        customer_id INT PRIMARY KEY,
        previous_total_spent BIGINT NOT NULL,
        previous_total_washes INT NOT NULL,
        delta_spent BIGINT NOT NULL,
        delta_washes INT NOT NULL
    );

    -- Bước 1: Tính toán chênh lệch (Delta) từ bảng inserted và deleted
    INSERT INTO @ChangedCustomers (customer_id, previous_total_spent, previous_total_washes, delta_spent, delta_washes)
    SELECT
        i.customer_id,
        ISNULL(d.total_spent, 0) AS previous_total_spent,
        ISNULL(d.total_washes, 0) AS previous_total_washes,
        CASE 
    WHEN ISNULL(i.total_spent, 0) > ISNULL(d.total_spent, 0)
    THEN ISNULL(i.total_spent, 0) - ISNULL(d.total_spent, 0)
        ELSE 0
    END AS delta_spent,

    CASE 
        WHEN ISNULL(i.total_washes, 0) > ISNULL(d.total_washes, 0)
        THEN ISNULL(i.total_washes, 0) - ISNULL(d.total_washes, 0)
        ELSE 0
    END AS delta_washes
    FROM inserted i
    INNER JOIN deleted d ON i.customer_id = d.customer_id
    WHERE
        ISNULL(i.total_spent, 0) <> ISNULL(d.total_spent, 0)
        OR ISNULL(i.total_washes, 0) <> ISNULL(d.total_washes, 0);

    IF NOT EXISTS (SELECT 1 FROM @ChangedCustomers)
        RETURN;

    -- Bước 1b: Cập nhật tích lũy cuốn chiếu vào bảng thống kê của tháng hiện tại (CustomerMonthlyStats)
    MERGE CustomerMonthlyStats AS target
    USING (
        SELECT
            customer_id,
            @reviewYear AS stat_year,
            @reviewMonth AS stat_month,
            delta_spent,
            delta_washes
        FROM @ChangedCustomers
    ) AS src
    ON target.customer_id = src.customer_id
       AND target.stat_year = src.stat_year
       AND target.stat_month = src.stat_month
    WHEN MATCHED THEN
        UPDATE SET
            target.monthly_spent = target.monthly_spent + src.delta_spent,
            target.monthly_washes = target.monthly_washes + src.delta_washes,
            target.updated_at = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (customer_id, stat_year, stat_month, monthly_spent, monthly_washes, created_at, updated_at)
        VALUES (src.customer_id, src.stat_year, src.stat_month, src.delta_spent, src.delta_washes, GETDATE(), GETDATE());

    -- Bước 2: Tự động Thăng hạng (Real-time Upgrade) & Khôi phục hạng (Tier Recovery)
    ;WITH PerformanceData AS (
        SELECT
            cc.customer_id,
            c.tier_id AS current_tier_id,
            cc.previous_total_spent,
            cc.previous_total_washes,
            c.total_spent,
            c.total_washes,
            ISNULL(ms.monthly_spent, 0) AS monthly_spent,
            ISNULL(ms.monthly_washes, 0) AS monthly_washes
        FROM @ChangedCustomers cc
        INNER JOIN Customer c ON c.customer_id = cc.customer_id
        LEFT JOIN CustomerMonthlyStats ms
            ON ms.customer_id = cc.customer_id
           AND ms.stat_year = @reviewYear
           AND ms.stat_month = @reviewMonth
    ),
    TargetTier AS (
        SELECT
            pd.customer_id,
            pd.current_tier_id,
            COALESCE(lt.max_eligible_tier, pd.current_tier_id) AS target_tier_id
        FROM PerformanceData pd
        OUTER APPLY (
            SELECT TOP 1 t.tier_id AS max_eligible_tier
            FROM Tiers t
            WHERE 
                -- ĐIỀU KIỆN TIÊN QUYẾT: Tổng tích lũy trọn đời phải đạt mốc tối thiểu của Tier đó
                (pd.total_spent >= t.min_spent OR pd.total_washes >= t.min_washes)
                AND 
                (
                    -- TRƯỜNG HỢP A: THĂNG HẠNG MỚI chỉ khi lần update này vừa vượt mốc tier.
                    (
                        t.tier_id > pd.current_tier_id
                        AND (
                            (pd.previous_total_spent < t.min_spent AND pd.total_spent >= t.min_spent)
                            OR (pd.previous_total_washes < t.min_washes AND pd.total_washes >= t.min_washes)
                        )
                    )
                    
                    -- TRƯỜNG HỢP B: KHÔI PHỤC HẠNG CŨ (Đã đủ mốc trọn đời từ trước, từng bị hạ hạng, 
                    -- nhưng tháng này cày bù đủ 30% chỉ tiêu tháng của hạng đó -> Trả lại hạng VIP ngay lập tức)
                    OR pd.monthly_spent >= (t.min_spent * 0.30)
                    OR pd.monthly_washes >= (t.min_washes * 0.30)
                )
            ORDER BY t.tier_id DESC -- Ưu tiên lấy mức hạng cao nhất có thể đạt được
        ) lt
    )
    UPDATE c
    SET
        c.tier_id = tt.target_tier_id,
        c.last_review_date = CAST(GETDATE() AS DATE)
    FROM Customer c
    INNER JOIN TargetTier tt ON tt.customer_id = c.customer_id
    WHERE tt.target_tier_id > c.tier_id; -- Điều kiện chặn: Trigger chỉ đưa hạng đi lên, không bao giờ hạ hạng.
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ReviewMonthlyTierDowngrade
    @ReviewYear INT = NULL,
    @ReviewMonth INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Nếu không truyền tham số, hệ thống tự động quét và duyệt dữ liệu của THÁNG TRƯỚC LIỀN KỀ
    IF @ReviewYear IS NULL OR @ReviewMonth IS NULL
    BEGIN
        DECLARE @PrevMonthDate DATE = DATEADD(MONTH, -1, CAST(GETDATE() AS DATE));
        SET @ReviewYear = YEAR(@PrevMonthDate);
        SET @ReviewMonth = MONTH(@PrevMonthDate);
    END

    ;WITH ReviewScope AS (
        SELECT
            c.customer_id,
            c.tier_id AS current_tier_id,
            t.min_spent,
            t.min_washes,
            ISNULL(ms.monthly_spent, 0) AS monthly_spent,
            ISNULL(ms.monthly_washes, 0) AS monthly_washes
        FROM Customer c
        INNER JOIN Tiers t ON t.tier_id = c.tier_id
        LEFT JOIN CustomerMonthlyStats ms
            ON ms.customer_id = c.customer_id
           AND ms.stat_year = @ReviewYear
           AND ms.stat_month = @ReviewMonth
    ),
    ReviewDecision AS (
        SELECT
            rs.customer_id,
            rs.current_tier_id,
            CASE
                -- Nếu tháng trước tiêu đủ 30% tiền HOẶC rửa xe đủ 30% số lần của hạng hiện tại -> ĐẠT chỉ tiêu giữ hạng
                WHEN rs.monthly_spent >= (rs.min_spent * 0.30)
                  OR rs.monthly_washes >= (rs.min_washes * 0.30)
                THEN rs.current_tier_id 
                -- Nếu KHÔNG ĐẠT chỉ tiêu tháng: Hạ đúng 1 cấp bậc thang (Luật nhân văn kiểu Shopee)
                ELSE CASE
                    WHEN rs.current_tier_id > 1 THEN rs.current_tier_id - 1
                    ELSE 1 -- Hạng 1 (Member) là tầng đáy, không thể thấp hơn
                END 
            END AS target_tier_id
        FROM ReviewScope rs
    )
    UPDATE c
    SET
        c.tier_id = rd.target_tier_id,
        c.last_review_date = CAST(GETDATE() AS DATE)
    FROM Customer c
    INNER JOIN ReviewDecision rd ON rd.customer_id = c.customer_id;
END
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

INSERT INTO Role (role_id, role_name, description) VALUES
(1, N'Admin',    N'Quản trị viên toàn quyền hệ thống'),
(2, N'Staff',    N'Nhân viên vận hành khoang rửa xe'),
(3, N'Customer', N'Khách hàng sử dụng dịch vụ');

INSERT INTO Tiers (tier_id, tier_name, min_washes, min_spent, point_multiplier, discount_percent, booking_window_days, description) VALUES
(1, N'Member',   0,  0,        1.00, 0.00,  7,  N'Thành viên mới đăng ký'),
(2, N'Silver',   5,  2000000,  1.10, 5.00,  10, N'Thành viên Bạc'),
(3, N'Gold',     15, 6000000,  1.20, 10.00, 12, N'Thành viên Vàng'),
(4, N'Platinum', 30, 15000000, 1.30, 15.00, 14, N'Thành viên Bạch Kim');

INSERT INTO Promotion (
    code, 
    title, 
    description, 
    image_url, 
    discount_type, 
    discount_value, 
    min_order_amount, 
    usage_limit, 
    start_date, 
    end_date, 
    is_active, 
    target_tier_id
) VALUES
-- Your original 2 vouchers updated with the new structural columns
(N'WELCOME50', N'Welcome New Member', N'Get an instant 50,000 VND discount for your first booking on our system.', N'/assets/images/promotions/welcome50.jpg', N'fixed', 50000, 0, 100, '2026-01-01', '2026-12-31', 1, NULL),
(N'GOLDPREMIUM', N'Gold Tier Reward', N'Exclusive for Gold members - Get 15% off your total booking bill.', N'/assets/images/promotions/gold.jpg', N'percent', 15, 100000, 50, '2026-01-01', '2026-12-31', 1, 3),

-- 5 Diverse new promotional vouchers
(N'SAVINGS30', N'Happy Hour Special', N'Save 30,000 VND on any car care service invoice.', N'/assets/images/promotions/tietkiem30.jpg', N'fixed', 30000, 50000, 200, '2026-06-01', '2026-08-31', 1, NULL),
(N'MEGA10', N'10% Mega Discount', N'Enjoy 10% off your entire booking. Keep your ride fresh and shiny.', N'/assets/images/promotions/sieuviet10.jpg', N'percent', 10, 150000, 150, '2026-06-01', '2026-12-31', 1, NULL),
(N'DIAMONDMAX', N'Diamond Privilege', N'Massive 25% discount exclusively tailored for Diamond tier members.', N'/assets/images/promotions/diamond.jpg', N'percent', 25, 200000, 30, '2026-01-01', '2026-12-31', 1, 4), 
(N'CARCARE100', N'Grand Car Care Feast', N'Flat 100,000 VND off for premium service packages with a minimum order of 300,000 VND.', N'/assets/images/promotions/chamsocxe.jpg', N'fixed', 100000, 300000, 80, '2026-06-15', '2026-07-15', 1, NULL),
(N'SILVERSTART', N'Silver Tier Kickoff', N'Get 5% off to celebrate your rank up to Silver tier membership.', N'/assets/images/promotions/silver.jpg', N'percent', 5, 80000, 120, '2026-01-01', '2026-12-31', 1, 2);

-- FIX: Bỏ capacity_per_hour
INSERT INTO Bay (bay_name, status) VALUES
(N'Automated Bay 01', N'available'),
(N'Automated Bay 02', N'available'),
(N'Automated Bay 03', N'maintenance');

INSERT INTO Service (service_name, description, price, duration_minutes, is_active) VALUES
(N'Express Wash (Sedan)',        N'High-pressure express wash, Triple foam conditioner, Heated air blow dry for Sedan',            50000,  5,  1),
(N'Deluxe Wash (Sedan)',         N'Express wash features, Wheel & rim deep clean, Tire shine & dressing for Sedan',               80000,  7,  1),
(N'Ultimate Wax Wash (Sedan)',   N'Deluxe wash features, Ceramic wax coating, Cabin deodorization & freshener for Sedan',    120000, 10, 1),
(N'Express Wash (SUV/Truck)',    N'Heavy-duty express wash, Underbody high-pressure rinse, High-clearance frame prep',             70000,  7,  1),
(N'Deluxe Wash (SUV/Truck)',     N'Express wash features, Deep rim de-ironing, Wheel hub restoration treatment',                 100000, 10,  1),
(N'Ultimate Wax Wash (SUV/Truck)', N'Deluxe wash features, Premium protective paint wax, Hydro-shield surface coat',              150000, 12,  1);

INSERT INTO [User] (full_name, email, phone, password, is_active, role_id) VALUES
(N'Nguyễn Admin',      'admin@autowash.com', '0900000001', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 1, 1),
(N'Trần Nhân Viên',    'staff@autowash.com', '0900000002', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 1, 2),
(N'Nguyễn Minh Hoàng', 'hoang@gmail.com',   '0912345678', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 1, 3),
(N'Trần Thị Ngọc',     'ngoc@gmail.com',    '0987654321', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 1, 3),
(N'Cao Minh Kỳ',       'ky@gmail.com',      '0905111222', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 1, 3),
(N'Lê Hoàng Long',     'long@gmail.com',    '0933444555', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 1, 3);

INSERT INTO Customer (address, total_points, total_spent, total_washes, join_date, date_of_birth, user_id, tier_id, last_review_date) VALUES
(N'Quận 9, TP. HCM',  3,  150000,   3,  '2026-01-15', '1998-05-20', 3, 1, '2026-05-01'),
(N'Quận 7, TP. HCM',  8,  2400000,  6,  '2026-02-10', '1995-11-12', 4, 2, '2026-05-01'),
(N'Thủ Đức, TP. HCM', 25, 7200000,  16, '2025-12-01', '1990-02-15', 5, 3, '2026-05-01'),
(N'Quận 1, TP. HCM',  45, 16500000, 32, '2025-08-20', '1988-08-08', 6, 4, '2026-05-01');

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
(N'Other');          -- brand_id: 12
GO

INSERT INTO Model (model_name, brand_id) VALUES
(N'Civic', 1), (N'City', 1), (N'CR-V', 1), (N'HR-V', 1),                          -- Honda:      1-4
(N'Vios', 2), (N'Camry', 2), (N'Innova', 2), (N'Corolla Cross', 2), (N'Veloz Cross', 2), -- Toyota: 5-9
(N'Mazda 3', 3), (N'CX-5', 3), (N'Mazda 6', 3), (N'CX-8', 3),                    -- Mazda:     10-13
(N'Ranger', 4), (N'Everest', 4), (N'Territory', 4),                                -- Ford:      14-16
(N'Accent', 5), (N'Grand i10', 5), (N'Tucson', 5), (N'Santa Fe', 5), (N'Creta', 5), -- Hyundai: 17-21
(N'Morning', 6), (N'K3', 6), (N'Seltos', 6), (N'Sorento', 6), (N'Carnival', 6),  -- Kia:      22-26
(N'Xpander', 7), (N'Outlander', 7), (N'Attrage', 7), (N'Triton', 7),             -- Mitsubishi:27-30
(N'Fadil', 8), (N'VF 5', 8), (N'VF 8', 8), (N'VF 9', 8), (N'VF e34', 8),        -- VinFast:  31-35
(N'XL7', 9), (N'Swift', 9), (N'Ertiga', 9),                                       -- Suzuki:   36-38
(N'C-Class', 10), (N'E-Class', 10), (N'GLC', 10),                                 -- Mercedes: 39-41
(N'3 Series', 11), (N'5 Series', 11), (N'X5', 11),                                -- BMW:      42-44
(N'Other', 12);                                                                     -- Other:    45
GO

INSERT INTO Vehicle (plate_number, model_id, vehicle_type, color, manufacture_year, customer_id, custom_brand_name, custom_model_name) VALUES
('51G-12345', 5,  'Sedan', N'White', 2021, 1, NULL, NULL),  -- Toyota Vios
('51H-67890', 11, 'SUV',   N'Red',   2022, 2, NULL, NULL),  -- Mazda CX-5
('51K-55555', 2,  'Sedan', N'Black', 2023, 3, NULL, NULL),  -- Honda City
('51L-99999', 14, 'Truck', N'Grey',  2022, 4, NULL, NULL);  -- Ford Ranger
GO

INSERT INTO Wallet (balance, customer_id) VALUES
(100000,  1),
(500000,  2),
(1200000, 3),
(2500000, 4);

-- FIX: Bỏ max_capacity
INSERT INTO Slot (time_value, start_time, end_time, is_active) VALUES
('08:00 AM', '08:00:00', '09:30:00', 1),
('09:30 AM', '09:30:00', '11:00:00', 1),
('11:00 AM', '11:00:00', '12:30:00', 1),
('02:00 PM', '14:00:00', '15:30:00', 1),
('03:30 PM', '15:30:00', '17:00:00', 1);

INSERT INTO Booking (booking_date, slot_id, discount_amount, total_amount, points_earned, status, notes, customer_id, vehicle_id, bay_id, promotion_id) VALUES
('2026-05-24', 1, 0,     50000,  1, N'completed', N'Rửa nhanh sạch sẽ',                  1, 1, 1, NULL),
('2026-05-25', 2, 0,     100000, 2, N'completed', N'Rửa kỹ mâm lốp',                      2, 2, 2, NULL),
('2026-06-05', 4, 12000, 108000, 2, N'pending',   N'Khách hàng Gold đặt gói Premium Wax', 3, 3, 1, NULL);

INSERT INTO BookingService (quantity, price, booking_id, service_id) VALUES
(1, 50000,  1, 1),
(1, 100000, 2, 5),
(1, 120000, 3, 3);

INSERT INTO Payment (payment_method, payment_status, amount, paid_at, transaction_id, booking_id, checkin_image_url, checkout_image_url) VALUES
(N'cash',   N'paid', 50000,  '2026-05-24 08:38:00', N'TXN-001', 1, N'/assets/images/mock/checkin_01.jpg', N'/assets/images/mock/checkout_01.jpg'),
(N'wallet', N'paid', 100000, '2026-05-25 10:13:00', N'TXN-002', 2, N'/assets/images/mock/checkin_02.jpg', N'/assets/images/mock/checkout_02.jpg');
GO

-- ========================================================
-- 4. VIEW VehicleDetail
-- ========================================================

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
    v.custom_brand_name,
    v.custom_model_name,
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
JOIN Brand b ON m.brand_id = b.brand_id;
GO
