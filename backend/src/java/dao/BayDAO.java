package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;

public class BayDAO {

    public Integer getAvailableBayId(String bookingDate, int slotId) {
        String sql = "SELECT b.bay_id FROM Bay b "
                + "WHERE b.status = N'available' "
                + "AND b.bay_id NOT IN ( "
                + "    SELECT bk.bay_id FROM Booking bk "
                + "    WHERE bk.booking_date = ? AND bk.slot_id = ? "
                + "    AND bk.status != N'cancelled' AND bk.bay_id IS NOT NULL "
                + ") "
                + "ORDER BY b.bay_id ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingDate);
            ps.setInt(2, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("bay_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // null = hết bay available = slot full
    }
}