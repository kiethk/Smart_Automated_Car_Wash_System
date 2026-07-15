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

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

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
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
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

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

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
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
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

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, record.getPointsEarned());
            ps.setInt(2, record.getPointsUsed());
            ps.setString(3, record.getTransactionType());
            ps.setString(4, record.getDescription());
            ps.setDate(5, record.getExpiredDate());
            ps.setInt(6, record.getCustomerId());

            return ps.executeUpdate() > 0;

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
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
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }

    /**
     * Lấy tổng điểm đã used
     */
    public int getTotalUsedPoints(int customerId) {
        String sql = "SELECT ISNULL(SUM(points_used), 0) FROM LoyaltyPointHistory WHERE customer_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }

    // ===================== PHẦN THÊM MỚI =====================

    /**
     * 1️⃣ Implement Point Expiration Logic
     * Kiểm tra và xóa điểm đã hết hạn (sau 12 tháng)
     * Rules: Points expire after 12 months
     */
    public void expirePoints() {
        String selectExpiredPoints = 
            "SELECT point_history_id, customer_id, points_earned, points_used " +
            "FROM LoyaltyPointHistory " +
            "WHERE expired_date <= GETDATE() " +
            "AND points_earned > points_used";
        
        String updatePoints = 
            "UPDATE LoyaltyPointHistory " +
            "SET points_used = points_earned " +
            "WHERE point_history_id = ?";
        
        String insertExpiredHistory = 
            "INSERT INTO LoyaltyPointHistory " +
            "(customer_id, points_earned, points_used, transaction_type, description, expired_date, created_at) " +
            "VALUES (?, 0, ?, 'expired', ?, GETDATE(), GETDATE())";
        
        String updateCustomerPoints = 
            "UPDATE Customer " +
            "SET total_points = ( " +
            "    SELECT ISNULL(SUM(points_earned - points_used), 0) " +
            "    FROM LoyaltyPointHistory " +
            "    WHERE customer_id = Customer.customer_id " +
            "    AND (expired_date IS NULL OR expired_date > GETDATE()) " +
            ") " +
            "WHERE customer_id = ?";

        Connection conn = null;
        PreparedStatement pstmtSelect = null;
        PreparedStatement pstmtUpdate = null;
        PreparedStatement pstmtInsert = null;
        PreparedStatement pstmtCustomer = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);

            System.out.println("=== Starting Point Expiration Job ===");

            pstmtSelect = conn.prepareStatement(selectExpiredPoints);
            rs = pstmtSelect.executeQuery();

            int totalExpired = 0;

            while (rs.next()) {
                int historyId = rs.getInt("point_history_id");
                int customerId = rs.getInt("customer_id");
                int pointsEarned = rs.getInt("points_earned");
                int pointsUsed = rs.getInt("points_used");
                int expiredPoints = pointsEarned - pointsUsed;

                if (expiredPoints > 0) {
                    // Update points_used to points_earned
                    pstmtUpdate = conn.prepareStatement(updatePoints);
                    pstmtUpdate.setInt(1, historyId);
                    pstmtUpdate.executeUpdate();

                    // Insert expired history record
                    pstmtInsert = conn.prepareStatement(insertExpiredHistory);
                    pstmtInsert.setInt(1, customerId);
                    pstmtInsert.setInt(2, expiredPoints);
                    pstmtInsert.setString(3, expiredPoints + " points expired after 12 months");
                    pstmtInsert.executeUpdate();

                    // Update customer total points
                    pstmtCustomer = conn.prepareStatement(updateCustomerPoints);
                    pstmtCustomer.setInt(1, customerId);
                    pstmtCustomer.executeUpdate();

                    totalExpired++;
                }
            }

            conn.commit();
            System.out.println("=== Point Expiration Job Completed. Total expired: " + totalExpired + " ===");

        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmtSelect != null) pstmtSelect.close();
                if (pstmtUpdate != null) pstmtUpdate.close();
                if (pstmtInsert != null) pstmtInsert.close();
                if (pstmtCustomer != null) pstmtCustomer.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 2️⃣ Improve LoyaltyPointHistory Functionality
     * Lấy lịch sử điểm được cộng (Earn history)
     */
    public List<LoyaltyPointHistory> getEarnedHistory(int customerId) {
        List<LoyaltyPointHistory> historyList = new ArrayList<>();
        String sql = 
            "SELECT point_history_id, points_earned, points_used, transaction_type, " +
            "description, expired_date, created_at, customer_id " +
            "FROM LoyaltyPointHistory " +
            "WHERE customer_id = ? AND transaction_type IN ('earned', 'earn', 'booking') " +
            "ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                LoyaltyPointHistory history = new LoyaltyPointHistory();
                history.setPointHistoryId(rs.getInt("point_history_id"));
                history.setPointsEarned(rs.getInt("points_earned"));
                history.setPointsUsed(rs.getInt("points_used"));
                history.setTransactionType(rs.getString("transaction_type"));
                history.setDescription(rs.getString("description"));
                history.setExpiredDate(rs.getDate("expired_date"));
                history.setCreatedAt(rs.getTimestamp("created_at"));
                history.setCustomerId(rs.getInt("customer_id"));
                historyList.add(history);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return historyList;
    }

    /**
     * 2️⃣ Improve LoyaltyPointHistory Functionality
     * Lấy lịch sử điểm được sử dụng (Redeem history)
     */
    public List<LoyaltyPointHistory> getRedeemedHistory(int customerId) {
        List<LoyaltyPointHistory> historyList = new ArrayList<>();
        String sql = 
            "SELECT point_history_id, points_earned, points_used, transaction_type, " +
            "description, expired_date, created_at, customer_id " +
            "FROM LoyaltyPointHistory " +
            "WHERE customer_id = ? AND transaction_type IN ('used', 'redeem') " +
            "ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                LoyaltyPointHistory history = new LoyaltyPointHistory();
                history.setPointHistoryId(rs.getInt("point_history_id"));
                history.setPointsEarned(rs.getInt("points_earned"));
                history.setPointsUsed(rs.getInt("points_used"));
                history.setTransactionType(rs.getString("transaction_type"));
                history.setDescription(rs.getString("description"));
                history.setExpiredDate(rs.getDate("expired_date"));
                history.setCreatedAt(rs.getTimestamp("created_at"));
                history.setCustomerId(rs.getInt("customer_id"));
                historyList.add(history);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return historyList;
    }

    /**
     * 2️⃣ Improve LoyaltyPointHistory Functionality
     * Lấy lịch sử điểm bị hết hạn (Expired history)
     */
    public List<LoyaltyPointHistory> getExpiredHistory(int customerId) {
        List<LoyaltyPointHistory> historyList = new ArrayList<>();
        String sql = 
            "SELECT point_history_id, points_earned, points_used, transaction_type, " +
            "description, expired_date, created_at, customer_id " +
            "FROM LoyaltyPointHistory " +
            "WHERE customer_id = ? AND transaction_type = 'expired' " +
            "ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                LoyaltyPointHistory history = new LoyaltyPointHistory();
                history.setPointHistoryId(rs.getInt("point_history_id"));
                history.setPointsEarned(rs.getInt("points_earned"));
                history.setPointsUsed(rs.getInt("points_used"));
                history.setTransactionType(rs.getString("transaction_type"));
                history.setDescription(rs.getString("description"));
                history.setExpiredDate(rs.getDate("expired_date"));
                history.setCreatedAt(rs.getTimestamp("created_at"));
                history.setCustomerId(rs.getInt("customer_id"));
                historyList.add(history);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return historyList;
    }
}