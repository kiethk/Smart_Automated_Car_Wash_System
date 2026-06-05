/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Slot;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

/**
 *
 * @author kieth
 */
public class SlotDAO {
    public List<Slot> getSlotsByDate(String bookingDate) {
    List<Slot> list = new ArrayList<>();
    // Câu lệnh SQL kiểm tra tổng số lượng booking theo từng slot trong ngày đã chọn
    String sql = "SELECT s.slot_id, s.time_value, s.max_capacity, COUNT(b.booking_id) AS total_booked " +
                 "FROM Slot s " +
                 "LEFT JOIN Booking b ON s.slot_id = b.slot_id AND b.booking_date = ? AND b.status != N'cancelled' " +
                 "WHERE s.status = 'active' " +
                 "GROUP BY s.slot_id, s.time_value, s.max_capacity";
                 
    try (Connection conn = DBUtils.getConnection(); // Hàm lấy kết nối DB của bạn
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, bookingDate);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Slot slot = new Slot();
            slot.setSlotId(rs.getInt("slot_id"));
            slot.setTimeValue(rs.getString("time_value"));
            
            int maxCapacity = rs.getInt("max_capacity");
            int totalBooked = rs.getInt("total_booked");
            
            // LOGIC QUAN TRỌNG: Nếu số lượng đặt lớn hơn hoặc bằng sức chứa -> Đầy!
            if (totalBooked >= maxCapacity) {
                slot.setFull(true);
            } else {
                slot.setFull(false);
            }
            
            list.add(slot);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}
