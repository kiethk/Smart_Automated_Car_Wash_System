
package dao;

import dto.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.HashMap;
import java.util.Map;
import utils.DBUtils;

/**
 * @author kieth
 */
public class BookingDAO {

    // =========================================================================
    // THỜI ĐIỂM 1: TRANSACTION TẠO BOOKING, PAYMENT & CỘNG ĐIỂM LIỀN NẾU TRẢ VÍ
    // =========================================================================
    public boolean insertBookingWithPayment(Booking booking, String paymentMethod, int redeemPoints, int serviceId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sqlBooking = "INSERT INTO Booking (booking_date, slot_id, discount_amount, total_amount, "
                + "points_earned, status, notes, customer_id, vehicle_id, bay_id, promotion_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlPayment = "INSERT INTO Payment (payment_method, payment_status, amount, paid_at, transaction_id, booking_id) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        String sqlGetServicePrice = "SELECT price FROM Service WHERE service_id = ? AND is_active = 1";

        String sqlInsertBookingService = "INSERT INTO BookingService (quantity, price, booking_id, service_id) "
                + "VALUES (?, ?, ?, ?)";

        String sqlUpdateWallet
                = "UPDATE Wallet SET balance = balance - ? WHERE customer_id = ? AND balance >= ?";

        String sqlGetWalletId
                = "SELECT wallet_id FROM Wallet WHERE customer_id = ?";

        String sqlWalletLog = "INSERT INTO WalletTransaction (wallet_id, amount, type, description, created_at, booking_id) "
                + "VALUES (?, ?, N'payment', ?, GETDATE(), ?)";

        String sqlInsertPromotionUsage = "INSERT INTO PromotionUsage (promotion_id, booking_id, used_at) "
                + "VALUES (?, ?, GETDATE())";

        String sqlDeductPoints = "UPDATE Customer SET total_points = total_points - ? WHERE customer_id = ?";

        String sqlInsertPointHistory = "INSERT INTO LoyaltyPointHistory "
                + "(points_earned, points_used, transaction_type, description, expired_date, created_at, customer_id) "
                + "VALUES (?, ?, ?, ?, NULL, GETDATE(), ?)";

        // Câu lệnh cộng điểm thưởng trực tiếp vào Customer (Chỉ dùng khi TRẢ VÍ THÀNH CÔNG liền)
        String sqlUpdateCustomerStatsPaid = "UPDATE Customer "
                + "SET total_spent = total_spent + ?, "
                + "    total_washes = total_washes + 1, "
                + "    total_points = total_points + ? "
                + "WHERE customer_id = ?";

        try {
            conn = DBUtils.getConnection();
            if (conn == null) {
                return false;
            }

            conn.setAutoCommit(false);

            // 1. Xác định trạng thái ban đầu dựa vào phương thức thanh toán
            String bookingStatus = "pending";
            String paymentStatus = "pending";
            boolean isPaidImmediately = false;

            if ("wallet".equalsIgnoreCase(paymentMethod)) {
                bookingStatus = "accepted";
                paymentStatus = "paid";
                isPaidImmediately = true; // Đánh dấu là đã thu tiền xong
            }

            // 2. TÍNH TOÁN ĐIỂM THƯỞNG GỐC DỰ KIẾN (1.000đ = 1 điểm)
            // Lấy tổng tiền phải trả cộng lại số điểm đã đổi để ra giá trị gốc trước khi giảm giá
            long originalAmount = booking.getTotalAmount() + redeemPoints;
            int pointsToEarn = (int) (originalAmount / 1000);

            // 3. INSERT BẢNG BOOKING
            ps = conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, booking.getBookingDate());
            ps.setInt(2, booking.getSlotId());
            ps.setLong(3, booking.getDiscountAmount());
            ps.setLong(4, booking.getTotalAmount());
            ps.setInt(5, pointsToEarn); // Lưu số điểm dự kiến kiếm được vào Booking
            ps.setString(6, bookingStatus);

            if (booking.getNotes() != null) {
                ps.setString(7, booking.getNotes());
            } else {
                ps.setNull(7, Types.NVARCHAR);
            }

            if (booking.getCustomerId() != null) {
                ps.setInt(8, booking.getCustomerId());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            if (booking.getVehicleId() != null) {
                ps.setInt(9, booking.getVehicleId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            if (booking.getBayId() != null && booking.getBayId() > 0) {
                ps.setInt(10, booking.getBayId()); // Gán đúng ID khoang rửa trống tìm được từ Controller
            } else {
                ps.setNull(10, Types.INTEGER);
            }

            if (booking.getPromotionId() != null && booking.getPromotionId() > 0) {
                ps.setInt(11, booking.getPromotionId());
            } else {
                ps.setNull(11, Types.INTEGER);
            }

            ps.executeUpdate();

            int generatedBookingId = 0;
            try ( ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    generatedBookingId = generatedKeys.getInt(1);
                } else {
                    throw new Exception("Inserting booking failed, no ID obtained.");
                }
            }
            ps.close();

            // 3.1. Lấy giá service từ DB và lưu vào BookingService
            long servicePrice = 0;

            ps = conn.prepareStatement(sqlGetServicePrice);
            ps.setInt(1, serviceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                servicePrice = rs.getLong("price");
            } else {
                throw new Exception("Invalid or inactive service selected.");
            }

            rs.close();
            ps.close();

            ps = conn.prepareStatement(sqlInsertBookingService);
            ps.setInt(1, 1); // quantity
            ps.setLong(2, servicePrice);
            ps.setInt(3, generatedBookingId);
            ps.setInt(4, serviceId);
            ps.executeUpdate();
            ps.close();

            // 3.1. Nếu khách có dùng promotion -> ghi nhận vào PromotionUsage
            if (booking.getPromotionId() != null && booking.getPromotionId() > 0) {
                ps = conn.prepareStatement(sqlInsertPromotionUsage);
                ps.setInt(1, booking.getPromotionId());
                ps.setInt(2, generatedBookingId);
                ps.executeUpdate();
                ps.close();
            }

            // 4. XỬ LÝ TRỪ TIỀN VÍ & CỘNG ĐIỂM THƯỞNG LIỀN (NẾU CHỌN WALLET)
            if (isPaidImmediately) {
                // Lấy wallet_id trước
                int walletId = 0;
                ps = conn.prepareStatement(sqlGetWalletId);
                ps.setInt(1, booking.getCustomerId());
                rs = ps.executeQuery();

                if (rs.next()) {
                    walletId = rs.getInt("wallet_id");
                } else {
                    throw new Exception("Customer does not have a wallet.");
                }

                rs.close();
                ps.close();

                // Trừ tiền ví, có check đủ số dư ngay trong DB
                ps = conn.prepareStatement(sqlUpdateWallet);
                ps.setLong(1, booking.getTotalAmount());
                ps.setInt(2, booking.getCustomerId());
                ps.setLong(3, booking.getTotalAmount());

                int walletRows = ps.executeUpdate();
                ps.close();

                if (walletRows == 0) {
                    throw new Exception("Insufficient wallet balance.");
                }

                // Log giao dịch ví
                ps = conn.prepareStatement(sqlWalletLog);
                ps.setInt(1, walletId);
                ps.setLong(2, booking.getTotalAmount());
                ps.setString(3, "Pay for Booking #" + generatedBookingId);
                ps.setInt(4, generatedBookingId);
                ps.executeUpdate();
                ps.close();

                // Vì Wallet đã thanh toán thành công ngay -> cộng spent, washes, points luôn
                ps = conn.prepareStatement(sqlUpdateCustomerStatsPaid);
                ps.setLong(1, booking.getTotalAmount());
                ps.setInt(2, pointsToEarn);
                ps.setInt(3, booking.getCustomerId());
                ps.executeUpdate();
                ps.close();

                if (pointsToEarn > 0) {
                    ps = conn.prepareStatement(sqlInsertPointHistory);
                    ps.setInt(1, pointsToEarn);
                    ps.setInt(2, 0);
                    ps.setString(3, "earn");
                    ps.setString(4, "Earn points from wallet payment for Booking #" + generatedBookingId);
                    ps.setInt(5, booking.getCustomerId());
                    ps.executeUpdate();
                    ps.close();
                }
            }

            // 5. TRỪ ĐIỂM THƯỞNG CŨ NẾU KHÁCH CÓ ĐỔI ĐIỂM ĐỂ GIẢM GIÁ
            if (redeemPoints > 0) {
                ps = conn.prepareStatement(sqlDeductPoints);
                ps.setInt(1, redeemPoints);
                ps.setInt(2, booking.getCustomerId());
                ps.executeUpdate();
                ps.close();

                ps = conn.prepareStatement(sqlInsertPointHistory);
                ps.setInt(1, 0);
                ps.setInt(2, redeemPoints);
                ps.setString(3, "use");
                ps.setString(4, "Use points for Booking #" + generatedBookingId);
                ps.setInt(5, booking.getCustomerId());
                ps.executeUpdate();
                ps.close();
            }

            // 6. INSERT BẢNG PAYMENT
            ps = conn.prepareStatement(sqlPayment);
            ps.setString(1, paymentMethod.toLowerCase());
            ps.setString(2, paymentStatus);
            ps.setLong(3, booking.getTotalAmount());

            if (isPaidImmediately) {
                ps.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
                ps.setString(5, "TXN_W_" + generatedBookingId + "_" + System.currentTimeMillis() / 1000);
            } else {
                ps.setNull(4, Types.TIMESTAMP);
                ps.setNull(5, Types.VARCHAR);
            }
            ps.setInt(6, generatedBookingId);

            ps.executeUpdate();
            ps.close();

            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Error at BookingDAO.insertBookingWithPayment(): " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // =========================================================================
    // THỜI ĐIỂM 2: NHÂN VIÊN XÁC NHẬN ĐÃ THU TIỀN -> ĐỔI PAYMENT THÀNH PAID & CỘNG ĐIỂM
    // =========================================================================
    public boolean confirmPaymentSuccess(int bookingId) {
        // Lấy thông tin điểm thưởng đã tính sẵn và customer_id của booking
        String sqlGetBooking = "SELECT customer_id, points_earned FROM Booking WHERE booking_id = ?";

        String sqlUpdatePayment = "UPDATE Payment SET payment_status = N'paid', paid_at = GETDATE() WHERE booking_id = ?";

        String sqlAddPoints = "UPDATE Customer SET total_points = total_points + ? WHERE customer_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn == null) {
                return false;
            }

            conn.setAutoCommit(false);

            // Bước 1: Lấy thông tin điểm dự kiến lưu trong đơn
            ps = conn.prepareStatement(sqlGetBooking);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            int customerId = 0;
            int pointsToEarn = 0;
            if (rs.next()) {
                customerId = rs.getInt("customer_id");
                pointsToEarn = rs.getInt("points_earned");
            } else {
                return false; // Không tìm thấy đơn hàng
            }
            rs.close();
            ps.close();

            // Bước 2: Cập nhật trạng thái Payment thành 'paid'
            ps = conn.prepareStatement(sqlUpdatePayment);
            ps.setInt(1, bookingId);
            ps.executeUpdate();
            ps.close();

            // Bước 3: CHÍNH THỨC CỘNG ĐIỂM VÀO TÀI KHOẢN KHÁCH HÀNG
            if (pointsToEarn > 0) {
                ps = conn.prepareStatement(sqlAddPoints);
                ps.setInt(1, pointsToEarn);
                ps.setInt(2, customerId);
                ps.executeUpdate();
                ps.close();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            System.out.println("Error at BookingDAO.confirmPaymentSuccess(): " + e.getMessage());
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
        return false;
    }

    // =========================================================================
    // HÀM CŨ: Xử lý Hoàn thành đơn hàng, tính điểm và tự động check thăng hạng
    // =========================================================================
    public boolean finishBookingAndCheckTier(int bookingId) {
        String sqlInsertPointHistory = "INSERT INTO LoyaltyPointHistory "
                + "(points_earned, points_used, transaction_type, description, expired_date, created_at, customer_id) "
                + "VALUES (?, ?, ?, ?, NULL, GETDATE(), ?)";

        String sqlGetInfo = "SELECT b.total_amount, b.customer_id, b.status, p.payment_method, p.payment_status, "
                + "c.tier_id, t.point_multiplier "
                + "FROM Booking b "
                + "JOIN Customer c ON b.customer_id = c.customer_id "
                + "JOIN Tiers t ON c.tier_id = t.tier_id "
                + "LEFT JOIN Payment p ON b.booking_id = p.booking_id "
                + "WHERE b.booking_id = ?";

        String sqlUpdateBooking = "UPDATE Booking SET status = N'completed', points_earned = ? WHERE booking_id = ?";

        String sqlUpdateCustomerStats = "UPDATE Customer "
                + "SET total_spent = total_spent + ?, "
                + "    total_washes = total_washes + 1, "
                + "    total_points = total_points + ? "
                + "WHERE customer_id = ?";

        String sqlGetNewStats = "SELECT total_spent, total_washes FROM Customer WHERE customer_id = ?";

        String sqlGetTiers = "SELECT tier_id, tier_name, min_washes, min_spent FROM Tiers ORDER BY min_spent DESC, min_washes DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        java.sql.ResultSet rs = null;

        try {
            conn = utils.DBUtils.getConnection();
            if (conn == null) {
                return false;
            }

            conn.setAutoCommit(false);

            ps = conn.prepareStatement(sqlGetInfo);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            long totalAmount = 0;
            int customerId = 0;
            int currentTierId = 1;
            double pointMultiplier = 1.0;
            String currentStatus = "";
            String paymentMethod = "";
            String paymentStatus = "";

            if (rs.next()) {
                totalAmount = rs.getLong("total_amount");
                customerId = rs.getInt("customer_id");
                currentTierId = rs.getInt("tier_id");
                pointMultiplier = rs.getDouble("point_multiplier");
                currentStatus = rs.getString("status");
                paymentMethod = rs.getString("payment_method");
                paymentStatus = rs.getString("payment_status");
            } else {
                return false;
            }
            rs.close();
            ps.close();

            int pointsEarned = (int) ((totalAmount / 1000) * pointMultiplier);

            boolean alreadyPaidByWallet = "wallet".equalsIgnoreCase(paymentMethod)
                    && "paid".equalsIgnoreCase(paymentStatus);

            boolean alreadyCompleted = "completed".equalsIgnoreCase(currentStatus);

            ps = conn.prepareStatement(sqlUpdateBooking);
            ps.setInt(1, pointsEarned);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
            ps.close();

            if (!alreadyPaidByWallet && !alreadyCompleted) {
                ps = conn.prepareStatement(sqlUpdateCustomerStats);
                ps.setLong(1, totalAmount);
                ps.setInt(2, pointsEarned);
                ps.setInt(3, customerId);
                ps.executeUpdate();
                ps.close();

                if (pointsEarned > 0) {
                    ps = conn.prepareStatement(sqlInsertPointHistory);
                    ps.setInt(1, pointsEarned);
                    ps.setInt(2, 0);
                    ps.setString(3, "earn");
                    ps.setString(4, "Earn points from completed Booking #" + bookingId);
                    ps.setInt(5, customerId);
                    ps.executeUpdate();
                    ps.close();
                }
            }

            ps = conn.prepareStatement(sqlGetNewStats);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();
            long updatedSpent = 0;
            int updatedWashes = 0;
            if (rs.next()) {
                updatedSpent = rs.getLong("total_spent");
                updatedWashes = rs.getInt("total_washes");
            }
            rs.close();
            ps.close();

            ps = conn.prepareStatement(sqlGetTiers);
            rs = ps.executeQuery();

            int targetTierId = currentTierId;

            while (rs.next()) {
                int tierId = rs.getInt("tier_id");
                int minWashes = rs.getInt("min_washes");
                long minSpent = rs.getLong("min_spent");

                if (updatedSpent >= minSpent || updatedWashes >= minWashes) {
                    targetTierId = tierId;
                    break;
                }
            }
            rs.close();
            ps.close();

            if (targetTierId > currentTierId) {
                String sqlUpgrade = "UPDATE Customer SET tier_id = ?, last_review_date = CAST(GETDATE() AS DATE) WHERE customer_id = ?";
                ps = conn.prepareStatement(sqlUpgrade);
                ps.setInt(1, targetTierId);
                ps.setInt(2, customerId);
                ps.executeUpdate();
                ps.close();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Error at BookingDAO.finishBookingAndCheckTier(): " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
    
    /**
     * Lấy 1 lịch hẹn gần nhất đang sắp diễn ra của khách hàng (Pending hoặc Accepted)
     * Kết hợp View VehicleDetail để lấy chuẩn xác thông tin xe tự nhập (Other)
     */
    public Map<String, Object> getUpcomingAppointmentByCustomerId(int customerId) {
        Map<String, Object> appointment = null;
        
        // Truy vấn bốc lịch hẹn gần nhất, trạng thái chưa hủy/hoàn thành, ngày hẹn từ hôm nay trở đi
        String sql = "SELECT TOP 1 b.booking_date, b.status, s.time_value, vd.plate_number, vd.brand_display, vd.model_display, bay.bay_name "
                   + "FROM Booking b "
                   + "JOIN Slot s ON b.slot_id = s.slot_id "
                   + "JOIN VehicleDetail vd ON b.vehicle_id = vd.vehicle_id "
                   + "LEFT JOIN Bay bay ON b.bay_id = bay.bay_id "
                   + "WHERE b.customer_id = ? AND b.status IN (N'pending', N'accepted') AND b.booking_date >= CAST(GETDATE() AS DATE) "
                   + "ORDER BY b.booking_date ASC, s.start_time ASC";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    appointment = new HashMap<>();
                    appointment.put("bookingDate", rs.getDate("booking_date").toString());
                    appointment.put("status", rs.getString("status"));
                    appointment.put("timeValue", rs.getString("time_value"));
                    appointment.put("plateNumber", rs.getString("plate_number"));
                    appointment.put("brandDisplay", rs.getString("brand_display"));
                    appointment.put("modelDisplay", rs.getString("model_display"));
                    appointment.put("bayName", rs.getString("bay_name"));
                }
            }
        } catch (Exception e) {
            System.out.println("Error at getUpcomingAppointmentByCustomerId: " + e.getMessage());
            e.printStackTrace();
        }
        return appointment;
    }
}

