package dao;

import dto.Promotion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class PromotionDAO {

    public List<Promotion> getAllActivePromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT * FROM Promotion WHERE is_active = 1 AND GETDATE() BETWEEN start_date AND end_date";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromotionId(rs.getInt("promotion_id"));
                p.setCode(rs.getString("code"));
                p.setTitle(rs.getString("title"));             
                p.setDescription(rs.getString("description")); 
                p.setImageUrl(rs.getString("image_url"));       
                p.setDiscountType(rs.getString("discount_type"));
                p.setDiscountValue(rs.getLong("discount_value"));
                p.setMinOrderAmount(rs.getLong("min_order_amount"));
                p.setUsageLimit(rs.getInt("usage_limit"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setTargetTierId(rs.getObject("target_tier_id") != null ? rs.getInt("target_tier_id") : null);
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Promotion> getAvailablePromotionsForCustomer(int customerId, int tierId) {
        List<Promotion> list = new ArrayList<>();

        String sql = "SELECT p.* "
                + "FROM Promotion p "
                + "WHERE p.is_active = 1 "
                + "AND CAST(GETDATE() AS DATE) BETWEEN p.start_date AND p.end_date "
                + "AND (p.target_tier_id IS NULL OR p.target_tier_id = ?) "
                + "AND ( "
                + "    p.usage_limit IS NULL "
                + "    OR p.usage_limit > ( "
                + "        SELECT COUNT(*) "
                + "        FROM PromotionUsage pu "
                + "        WHERE pu.promotion_id = p.promotion_id "
                + "    ) "
                + ") "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 "
                + "    FROM PromotionUsage pu "
                + "    JOIN Booking b ON pu.booking_id = b.booking_id "
                + "    WHERE pu.promotion_id = p.promotion_id "
                + "    AND b.customer_id = ? "
                + ") "
                + "ORDER BY p.end_date ASC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tierId);
            ps.setInt(2, customerId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Promotion p = new Promotion();
                    p.setPromotionId(rs.getInt("promotion_id"));
                    p.setCode(rs.getString("code"));
                    p.setTitle(rs.getString("title"));
                    p.setDescription(rs.getString("description"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setDiscountType(rs.getString("discount_type"));
                    p.setDiscountValue(rs.getLong("discount_value"));
                    p.setMinOrderAmount(rs.getLong("min_order_amount"));
                    p.setUsageLimit(rs.getInt("usage_limit"));
                    p.setStartDate(rs.getDate("start_date"));
                    p.setEndDate(rs.getDate("end_date"));
                    p.setTargetTierId(rs.getObject("target_tier_id") != null ? rs.getInt("target_tier_id") : null);
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}