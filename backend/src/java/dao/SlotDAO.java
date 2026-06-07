package dao;

import dto.Slot;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class SlotDAO {

    public List<Slot> getSlotsByDate(String bookingDate) {
        List<Slot> list = new ArrayList<>();
        // Dùng is_active = 1 thay vì status = 'active' (không có cột status trong DB)
        String sql = "SELECT s.slot_id, s.time_value, s.start_time, s.end_time, s.max_capacity, s.is_active, "
                   + "       COUNT(b.booking_id) AS total_booked "
                   + "FROM Slot s "
                   + "LEFT JOIN Booking b ON s.slot_id = b.slot_id AND b.booking_date = ? AND b.status != N'cancelled' "
                   + "WHERE s.is_active = 1 "
                   + "GROUP BY s.slot_id, s.time_value, s.start_time, s.end_time, s.max_capacity, s.is_active "
                   + "ORDER BY s.start_time ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Slot slot = new Slot();
                    slot.setSlotId(rs.getInt("slot_id"));
                    slot.setTimeValue(rs.getString("time_value"));
                    slot.setStartTime(rs.getString("start_time"));
                    slot.setEndTime(rs.getString("end_time"));
                    slot.setMaxCapacity(rs.getInt("max_capacity"));
                    slot.setIsActive(rs.getInt("is_active"));
                    slot.setFull(rs.getInt("total_booked") >= rs.getInt("max_capacity"));
                    list.add(slot);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}