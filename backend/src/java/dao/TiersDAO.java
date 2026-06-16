/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Tiers;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;

/**
 *
 * @author kieth
 */
public class TiersDAO {

    public Tiers getTierById(int id) {
        Tiers tiers = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT * FROM Tiers WHERE tier_id = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, id);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    int tierId = id;
                    String tierName = rs.getString("tier_name");
                    int minWashes = rs.getInt("min_washes");
                    long minSpent = rs.getLong("min_spent");
                    double pointMultiplier = rs.getDouble("point_multiplier");
                    double discountPercent = rs.getDouble("discount_percent");
                    int bookingWindowDays = rs.getInt("booking_window_days");
                    String description = rs.getString("description");

                    // Khởi tạo đối tượng truyền vào constructor
                    tiers = new Tiers(tierId, tierName, minWashes, minSpent, pointMultiplier, discountPercent, bookingWindowDays, description);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return tiers;
    }
}
