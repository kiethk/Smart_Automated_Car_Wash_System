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

    public List<Promotion> getAllPromotionsForAdmin() {
        List<Promotion> list = new ArrayList<>();

        String sql = "SELECT * FROM Promotion ORDER BY promotion_id DESC";

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
                p.setIsActive(rs.getInt("is_active"));
                p.setTargetTierId(rs.getObject("target_tier_id") != null ? rs.getInt("target_tier_id") : null);

                list.add(p);
            }

        } catch (Exception e) {
            System.out.println("Error at PromotionDAO.getAllPromotionsForAdmin(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public Promotion getPromotionById(int promotionId) {
        String sql = "SELECT * FROM Promotion WHERE promotion_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, promotionId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
                    p.setIsActive(rs.getInt("is_active"));
                    p.setTargetTierId(rs.getObject("target_tier_id") != null ? rs.getInt("target_tier_id") : null);

                    return p;
                }
            }

        } catch (Exception e) {
            System.out.println("Error at PromotionDAO.getPromotionById(): " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public int getPromotionUsageCount(int promotionId) {
        String sql = "SELECT COUNT(*) AS total_used FROM PromotionUsage WHERE promotion_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, promotionId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_used");
                }
            }

        } catch (Exception e) {
            System.out.println("Error at PromotionDAO.getPromotionUsageCount(): " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public boolean createPromotion(Promotion promotion) {
        String sql = "INSERT INTO Promotion "
                + "(code, title, description, image_url, discount_type, discount_value, "
                + "min_order_amount, usage_limit, start_date, end_date, is_active, target_tier_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, promotion.getCode());
            ps.setString(2, promotion.getTitle());
            ps.setString(3, promotion.getDescription());
            ps.setString(4, promotion.getImageUrl());
            ps.setString(5, promotion.getDiscountType());
            ps.setLong(6, promotion.getDiscountValue());
            ps.setLong(7, promotion.getMinOrderAmount());

            if (promotion.getUsageLimit() <= 0) {
                ps.setNull(8, java.sql.Types.INTEGER);
            } else {
                ps.setInt(8, promotion.getUsageLimit());
            }

            ps.setDate(9, promotion.getStartDate());
            ps.setDate(10, promotion.getEndDate());
            ps.setInt(11, promotion.getIsActive());

            if (promotion.getTargetTierId() == null || promotion.getTargetTierId() <= 0) {
                ps.setNull(12, java.sql.Types.INTEGER);
            } else {
                ps.setInt(12, promotion.getTargetTierId());
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at PromotionDAO.createPromotion(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updatePromotion(Promotion promotion) {
        String sql = "UPDATE Promotion "
                + "SET code = ?, title = ?, description = ?, image_url = ?, "
                + "discount_type = ?, discount_value = ?, min_order_amount = ?, "
                + "usage_limit = ?, start_date = ?, end_date = ?, is_active = ?, target_tier_id = ? "
                + "WHERE promotion_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, promotion.getCode());
            ps.setString(2, promotion.getTitle());
            ps.setString(3, promotion.getDescription());
            ps.setString(4, promotion.getImageUrl());
            ps.setString(5, promotion.getDiscountType());
            ps.setLong(6, promotion.getDiscountValue());
            ps.setLong(7, promotion.getMinOrderAmount());

            if (promotion.getUsageLimit() <= 0) {
                ps.setNull(8, java.sql.Types.INTEGER);
            } else {
                ps.setInt(8, promotion.getUsageLimit());
            }

            ps.setDate(9, promotion.getStartDate());
            ps.setDate(10, promotion.getEndDate());
            ps.setInt(11, promotion.getIsActive());

            if (promotion.getTargetTierId() == null || promotion.getTargetTierId() <= 0) {
                ps.setNull(12, java.sql.Types.INTEGER);
            } else {
                ps.setInt(12, promotion.getTargetTierId());
            }

            ps.setInt(13, promotion.getPromotionId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at PromotionDAO.updatePromotion(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean togglePromotionStatus(int promotionId, int isActive) {
        String sql = "UPDATE Promotion SET is_active = ? WHERE promotion_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, isActive);
            ps.setInt(2, promotionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at PromotionDAO.togglePromotionStatus(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}
