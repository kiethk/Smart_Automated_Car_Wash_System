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
