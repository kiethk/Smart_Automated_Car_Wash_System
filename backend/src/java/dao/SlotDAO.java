
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
        // Bỏ max_capacity, dùng available_bays để tính isFull
        String sql = "SELECT s.slot_id, s.time_value, s.start_time, s.end_time, s.is_active, "
                + "       COUNT(b.booking_id) AS total_booked, "
                + "       (SELECT COUNT(*) FROM Bay WHERE status = N'available') AS available_bays "
                + "FROM Slot s "
                + "LEFT JOIN Booking b ON s.slot_id = b.slot_id AND b.booking_date = ? AND b.status != N'cancelled' "
                + "WHERE s.is_active = 1 "
                + "GROUP BY s.slot_id, s.time_value, s.start_time, s.end_time, s.is_active "
                + "ORDER BY s.start_time ASC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingDate);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Slot slot = new Slot();
                    slot.setSlotId(rs.getInt("slot_id"));
                    slot.setTimeValue(rs.getString("time_value"));
                    slot.setStartTime(rs.getString("start_time"));
                    slot.setEndTime(rs.getString("end_time"));
                    slot.setIsActive(rs.getInt("is_active"));
                    slot.setFull(rs.getInt("total_booked") >= rs.getInt("available_bays"));
                    list.add(slot);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Slot> getAllSlots() {
        List<Slot> list = new ArrayList<>();
        // Bỏ max_capacity
        String sql = "SELECT slot_id, time_value, start_time, end_time, is_active "
                + "FROM Slot WHERE is_active = 1 ORDER BY start_time ASC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Slot slot = new Slot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setTimeValue(rs.getString("time_value"));
                slot.setStartTime(rs.getString("start_time"));
                slot.setEndTime(rs.getString("end_time"));
                slot.setIsActive(rs.getInt("is_active"));
                list.add(slot);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Slot> getAllSlotsForAdmin() {
        List<Slot> list = new ArrayList<>();

        String sql = "SELECT slot_id, time_value, start_time, end_time, is_active "
                + "FROM Slot "
                + "ORDER BY start_time ASC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Slot slot = new Slot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setTimeValue(rs.getString("time_value"));
                slot.setStartTime(rs.getString("start_time"));
                slot.setEndTime(rs.getString("end_time"));
                slot.setIsActive(rs.getInt("is_active"));

                list.add(slot);
            }

        } catch (Exception e) {
            System.out.println("Error at SlotDAO.getAllSlotsForAdmin(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public Slot getSlotById(int slotId) {
        String sql = "SELECT slot_id, time_value, start_time, end_time, is_active "
                + "FROM Slot "
                + "WHERE slot_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, slotId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Slot slot = new Slot();
                    slot.setSlotId(rs.getInt("slot_id"));
                    slot.setTimeValue(rs.getString("time_value"));
                    slot.setStartTime(rs.getString("start_time"));
                    slot.setEndTime(rs.getString("end_time"));
                    slot.setIsActive(rs.getInt("is_active"));

                    return slot;
                }
            }

        } catch (Exception e) {
            System.out.println("Error at SlotDAO.getSlotById(): " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean createSlot(Slot slot) {
        String sql = "INSERT INTO Slot (time_value, start_time, end_time, is_active) "
                + "VALUES (?, ?, ?, ?)";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slot.getTimeValue());
            ps.setString(2, slot.getStartTime());
            ps.setString(3, slot.getEndTime());
            ps.setInt(4, slot.getIsActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at SlotDAO.createSlot(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateSlot(Slot slot) {
        String sql = "UPDATE Slot "
                + "SET time_value = ?, start_time = ?, end_time = ?, is_active = ? "
                + "WHERE slot_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slot.getTimeValue());
            ps.setString(2, slot.getStartTime());
            ps.setString(3, slot.getEndTime());
            ps.setInt(4, slot.getIsActive());
            ps.setInt(5, slot.getSlotId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at SlotDAO.updateSlot(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean toggleSlotStatus(int slotId, int isActive) {
        String sql = "UPDATE Slot SET is_active = ? WHERE slot_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, isActive);
            ps.setInt(2, slotId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at SlotDAO.toggleSlotStatus(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

}

