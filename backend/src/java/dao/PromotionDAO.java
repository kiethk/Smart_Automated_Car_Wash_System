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
        String sql = "SELECT promotion_id, code, discount_type, discount_value, min_order_amount, "
                   + "       usage_limit, start_date, end_date, is_active, target_tier_id "
                   + "FROM Promotion "
                   + "WHERE is_active = 1 "
                   + "AND usage_limit > 0 "
                   + "AND CAST(GETDATE() AS DATE) BETWEEN start_date AND end_date";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromotionId(rs.getInt("promotion_id"));
                p.setCode(rs.getString("code"));
                p.setDiscountType(rs.getString("discount_type"));
                p.setDiscountValue(rs.getLong("discount_value"));
                p.setMinOrderAmount(rs.getLong("min_order_amount"));
                p.setUsageLimit(rs.getInt("usage_limit"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setIsActive(rs.getInt("is_active"));

                int targetTier = rs.getInt("target_tier_id");
                p.setTargetTierId(rs.wasNull() ? null : targetTier);

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}