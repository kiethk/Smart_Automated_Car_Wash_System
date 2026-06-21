package dao;

import dto.LoyaltyPointHistory;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoyaltyPointHistoryDAO {

    /**
     * Lấy danh sách lịch sử điểm thưởng của customer
     */
    public List<LoyaltyPointHistory> getByCustomerId(int customerId) {
        List<LoyaltyPointHistory> list = new ArrayList<>();
        String sql = "SELECT point_history_id, points_earned, points_used, " +
                     "transaction_type, description, expired_date, created_at, customer_id " +
                     "FROM LoyaltyPointHistory " +
                     "WHERE customer_id = ? " +
                     "ORDER BY created_at DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LoyaltyPointHistory record = new LoyaltyPointHistory();
                    record.setPointHistoryId(rs.getInt("point_history_id"));
                    record.setPointsEarned(rs.getInt("points_earned"));
                    record.setPointsUsed(rs.getInt("points_used"));
                    record.setTransactionType(rs.getString("transaction_type"));
                    record.setDescription(rs.getString("description"));
                    record.setExpiredDate(rs.getDate("expired_date"));
                    record.setCreatedAt(rs.getTimestamp("created_at"));
                    record.setCustomerId(rs.getInt("customer_id"));
                    list.add(record);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy N giao dịch gần nhất
     */
    public List<LoyaltyPointHistory> getRecentByCustomerId(int customerId, int limit) {
        List<LoyaltyPointHistory> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " point_history_id, points_earned, points_used, " +
                     "transaction_type, description, expired_date, created_at, customer_id " +
                     "FROM LoyaltyPointHistory " +
                     "WHERE customer_id = ? " +
                     "ORDER BY created_at DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LoyaltyPointHistory record = new LoyaltyPointHistory();
                    record.setPointHistoryId(rs.getInt("point_history_id"));
                    record.setPointsEarned(rs.getInt("points_earned"));
                    record.setPointsUsed(rs.getInt("points_used"));
                    record.setTransactionType(rs.getString("transaction_type"));
                    record.setDescription(rs.getString("description"));
                    record.setExpiredDate(rs.getDate("expired_date"));
                    record.setCreatedAt(rs.getTimestamp("created_at"));
                    record.setCustomerId(rs.getInt("customer_id"));
                    list.add(record);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm mới giao dịch điểm
     */
    public boolean addTransaction(LoyaltyPointHistory record) {
        String sql = "INSERT INTO LoyaltyPointHistory (points_earned, points_used, " +
                     "transaction_type, description, expired_date, customer_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, record.getPointsEarned());
            ps.setInt(2, record.getPointsUsed());
            ps.setString(3, record.getTransactionType());
            ps.setString(4, record.getDescription());
            ps.setDate(5, record.getExpiredDate());
            ps.setInt(6, record.getCustomerId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cộng điểm cho customer (khi hoàn thành booking)
     */
    public boolean addEarnedPoints(int customerId, int points, String description, String transactionType) {
        LoyaltyPointHistory record = new LoyaltyPointHistory();
        record.setCustomerId(customerId);
        record.setPointsEarned(points);
        record.setPointsUsed(0);
        record.setTransactionType(transactionType != null ? transactionType : "earned");
        record.setDescription(description);
        record.setExpiredDate(null);

        return addTransaction(record);
    }

    /**
     * Trừ điểm (khi redeem voucher)
     */
    public boolean addUsedPoints(int customerId, int points, String description, String transactionType) {
        LoyaltyPointHistory record = new LoyaltyPointHistory();
        record.setCustomerId(customerId);
        record.setPointsEarned(0);
        record.setPointsUsed(points);
        record.setTransactionType(transactionType != null ? transactionType : "used");
        record.setDescription(description);
        record.setExpiredDate(null);

        return addTransaction(record);
    }

    /**
     * Lấy tổng điểm đã earned
     */
    public int getTotalEarnedPoints(int customerId) {
        String sql = "SELECT ISNULL(SUM(points_earned), 0) FROM LoyaltyPointHistory WHERE customer_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy tổng điểm đã used
     */
    public int getTotalUsedPoints(int customerId) {
        String sql = "SELECT ISNULL(SUM(points_used), 0) FROM LoyaltyPointHistory WHERE customer_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}