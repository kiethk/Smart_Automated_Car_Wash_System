/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import utils.DBUtils;

/**
 *
 * @author kieth
 */
public class BookingDAO {
    // HÀM MỚI BỔ SUNG: Xử lý Hoàn thành đơn hàng, tính điểm, cộng dồn tích lũy và tự động check thăng hạng
    public boolean finishBookingAndCheckTier(int bookingId) {
        String sqlGetInfo = "SELECT b.total_amount, b.customer_id, c.tier_id, t.point_multiplier "
                          + "FROM Booking b "
                          + "JOIN Customer c ON b.customer_id = c.customer_id "
                          + "JOIN Tiers t ON c.tier_id = t.tier_id "
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
            // Sử dụng đúng DBUtils của nhóm bạn để lấy Connection
            conn = utils.DBUtils.getConnection();
            if (conn == null) return false;
            
            // BẮT ĐẦU TRANSACTION: Đảm bảo toàn bộ các bước phải thành công, hoặc cùng thất bại
            conn.setAutoCommit(false);

            // Bước 1: Lấy thông tin booking hiện tại & tier_id hiện tại của khách
            ps = conn.prepareStatement(sqlGetInfo);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            long totalAmount = 0;
            int customerId = 0;
            int currentTierId = 1;
            double pointMultiplier = 1.0;

            if (rs.next()) {
                totalAmount = rs.getLong("total_amount");
                customerId = rs.getInt("customer_id");
                currentTierId = rs.getInt("tier_id");
                pointMultiplier = rs.getDouble("point_multiplier");
            } else {
                return false; // Không tìm thấy đơn hàng tương ứng
            }
            rs.close(); ps.close();

            // Bước 2: Tính toán điểm thưởng thực tế (Quy tắc: 1.000 VNĐ = 1 điểm gốc * hệ số nhân của hạng)
            // Lưu ý: Ép kiểu sang int vì trường total_points và points_earned trong DB của bạn là INT
            int pointsEarned = (int) ((totalAmount / 1000) * pointMultiplier);

            // Bước 3: Cập nhật trạng thái Booking sang 'completed' (đúng với trạng thái trong DB của bạn) và lưu số điểm kiếm được
            ps = conn.prepareStatement(sqlUpdateBooking);
            ps.setInt(1, pointsEarned);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
            ps.close();

            // Bước 4: Cộng dồn số tiền chi tiêu, số lần rửa và số điểm thưởng vừa nhận vào bảng Customer
            ps = conn.prepareStatement(sqlUpdateCustomerStats);
            ps.setLong(1, totalAmount);
            ps.setInt(2, pointsEarned);
            ps.setInt(3, customerId);
            ps.executeUpdate();
            ps.close();

            // Bước 5: Lấy số liệu tổng chi tiêu và tổng số lần rửa mới nhất sau khi vừa cộng dồn
            ps = conn.prepareStatement(sqlGetNewStats);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();
            long updatedSpent = 0;
            int updatedWashes = 0;
            if (rs.next()) {
                updatedSpent = rs.getLong("total_spent");
                updatedWashes = rs.getInt("total_washes");
            }
            rs.close(); ps.close();

            // Bước 6: Lấy danh sách toàn bộ các hạng (Tiers) xếp giảm dần từ cao xuống thấp để so sánh mốc
            ps = conn.prepareStatement(sqlGetTiers);
            rs = ps.executeQuery();
            
            int targetTierId = currentTierId; // Mặc định nếu không đủ điều kiện thăng hạng thì giữ hạng cũ
            
            while (rs.next()) {
                int tierId = rs.getInt("tier_id");
                int minWashes = rs.getInt("min_washes");
                long minSpent = rs.getLong("min_spent");
                
                // Logic kiểm tra thăng hạng (Thỏa mãn điều kiện Hoặc - OR: đạt đủ số tiền HOẶC đạt đủ số lần rửa)
                if (updatedSpent >= minSpent || updatedWashes >= minWashes) {
                    targetTierId = tierId;
                    break; // Tìm thấy hạng cao nhất thỏa mãn điều kiện thì dừng vòng lặp ngay lập tức
                }
            }
            rs.close(); ps.close();

            // Bước 7: Nếu tìm thấy hạng mới cao hơn hạng cũ hiện tại -> Tiến hành UPDATE thăng hạng cho khách
            if (targetTierId > currentTierId) {
                String sqlUpgrade = "UPDATE Customer SET tier_id = ?, last_review_date = CAST(GETDATE() AS DATE) WHERE customer_id = ?";
                ps = conn.prepareStatement(sqlUpgrade);
                ps.setInt(1, targetTierId);
                ps.setInt(2, customerId);
                ps.executeUpdate();
                ps.close();
            }

            // Mọi bước chạy hoàn hảo không phát sinh lỗi -> Thực thi xác nhận thay đổi dữ liệu xuống DB
            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Error at BookingDAO.finishBookingAndCheckTier(): " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback(); // Có bất kỳ lỗi gì xảy ra sẽ hủy toàn bộ các bước, đưa dữ liệu về ban đầu
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            // Đóng tài nguyên an toàn đề phòng rò rỉ bộ nhớ hệ thống
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
    
    public boolean insertBooking(Booking booking) {
        String sql = "INSERT INTO Booking (booking_date, slot_id, discount_amount, total_amount, " +
                     "points_earned, status, notes, customer_id, vehicle_id, bay_id, promotion_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Sử dụng Try-with-resources để tự động giải phóng tài nguyên hệ thống
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // 1. Truyền các tham số bắt buộc không được NULL
            ps.setString(1, booking.getBookingDate()); // Chuỗi định dạng 'YYYY-MM-DD'
            ps.setInt(2, booking.getSlotId());
            ps.setLong(3, booking.getDiscountAmount());
            ps.setLong(4, booking.getTotalAmount());
            ps.setInt(5, booking.getPointsEarned());
            ps.setString(6, booking.getStatus()); // Thường là 'pending' khi mới tạo
            
            // 2. Xử lý các trường có thể mang giá trị NULL (Ghi chú, Khóa ngoại)
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
            
            // Đơn mới tạo thì khoang rửa xe (bay_id) luôn luôn là NULL (Chờ Staff gán sau)
            if (booking.getBayId() != null) {
                ps.setInt(10, booking.getBayId());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            
            // Khuyến mãi (promotion_id) có thể có hoặc không tùy đơn hàng
            if (booking.getPromotionId() != null) {
                ps.setInt(11, booking.getPromotionId());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            
            // Thực thi câu lệnh chèn dữ liệu
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Nếu số dòng bị tác động > 0 tức là insert thành công
            
        } catch (Exception e) {
            System.out.println("Error at BookingDAO.insertBooking(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}
