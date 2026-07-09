package dao;

import dto.Tiers;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class AdminTierDAO {

    public List<Tiers> getAllTiers() {
        List<Tiers> list = new ArrayList<>();
        String sql = "SELECT tier_id, tier_name, min_washes, min_spent, point_multiplier, "
                + "discount_percent, booking_window_days, description "
                + "FROM Tiers ORDER BY tier_id ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.out.println("Error at AdminTierDAO.getAllTiers(): " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public Tiers getTierById(int tierId) {
        String sql = "SELECT tier_id, tier_name, min_washes, min_spent, point_multiplier, "
                + "discount_percent, booking_window_days, description "
                + "FROM Tiers WHERE tier_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tierId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.out.println("Error at AdminTierDAO.getTierById(): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTier(Tiers tier) {
        // Chỉ cho update các thông số nghiệp vụ, không cho đổi tier_name vì trigger dùng tier_id
        String sql = "UPDATE Tiers SET "
                + "min_washes = ?, "
                + "min_spent = ?, "
                + "point_multiplier = ?, "
                + "discount_percent = ?, "
                + "booking_window_days = ?, "
                + "description = ? "
                + "WHERE tier_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tier.getMinWashes());
            ps.setLong(2, tier.getMinSpent());
            ps.setDouble(3, tier.getPointMultiplier());
            ps.setDouble(4, tier.getDiscountPercent());
            ps.setInt(5, tier.getBookingWindowDays());
            ps.setString(6, tier.getDescription());
            ps.setInt(7, tier.getTierId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error at AdminTierDAO.updateTier(): " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Đếm số customer đang ở tier này để hiển thị thông tin
    public int countCustomersByTierId(int tierId) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE tier_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tierId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error at AdminTierDAO.countCustomersByTierId(): " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    private Tiers mapRow(ResultSet rs) throws Exception {
        return new Tiers(
            rs.getInt("tier_id"),
            rs.getString("tier_name"),
            rs.getInt("min_washes"),
            rs.getLong("min_spent"),
            rs.getDouble("point_multiplier"),
            rs.getDouble("discount_percent"),
            rs.getInt("booking_window_days"),
            rs.getString("description")
        );
    }
}