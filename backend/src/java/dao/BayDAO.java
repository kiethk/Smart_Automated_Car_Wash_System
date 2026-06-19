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
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingDate);
            ps.setInt(2, slotId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("bay_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // null = hết bay available = slot full
    }

    public java.util.List<dto.Bay> getAllBaysForAdmin() {
        java.util.List<dto.Bay> list = new java.util.ArrayList<>();

        String sql = "SELECT bay_id, bay_name, status "
                + "FROM Bay "
                + "ORDER BY bay_id ASC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                dto.Bay bay = new dto.Bay();
                bay.setBayId(rs.getInt("bay_id"));
                bay.setBayName(rs.getString("bay_name"));
                bay.setStatus(rs.getString("status"));

                list.add(bay);
            }

        } catch (Exception e) {
            System.out.println("Error at BayDAO.getAllBaysForAdmin(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;

    }

    public dto.Bay getBayById(int bayId) {
        String sql = "SELECT bay_id, bay_name, status "
                + "FROM Bay "
                + "WHERE bay_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bayId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto.Bay bay = new dto.Bay();
                    bay.setBayId(rs.getInt("bay_id"));
                    bay.setBayName(rs.getString("bay_name"));
                    bay.setStatus(rs.getString("status"));

                    return bay;
                }
            }

        } catch (Exception e) {
            System.out.println("Error at BayDAO.getBayById(): " + e.getMessage());
            e.printStackTrace();
        }

        return null;

    }

    public boolean createBay(dto.Bay bay) {
        String sql = "INSERT INTO Bay (bay_name, status) "
                + "VALUES (?, ?)";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bay.getBayName());
            ps.setString(2, bay.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at BayDAO.createBay(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;

    }

    public boolean updateBay(dto.Bay bay) {
        String sql = "UPDATE Bay "
                + "SET bay_name = ?, status = ? "
                + "WHERE bay_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bay.getBayName());
            ps.setString(2, bay.getStatus());
            ps.setInt(3, bay.getBayId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at BayDAO.updateBay(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;

    }

    public boolean updateBayStatus(int bayId, String status) {
        String sql = "UPDATE Bay SET status = ? WHERE bay_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, bayId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at BayDAO.updateBayStatus(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;

    }

}
