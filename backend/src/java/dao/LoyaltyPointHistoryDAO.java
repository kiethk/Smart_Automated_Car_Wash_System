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
     * expired_date = 1 năm sau
     */
    public boolean addEarnedPoints(int customerId, int points, String description, String transactionType) {
        String sql = "INSERT INTO LoyaltyPointHistory (customer_id, points_earned, points_used, transaction_type, description, expired_date, created_at) "
                   + "VALUES (?, ?, 0, ?, ?, DATEADD(YEAR, 1, GETDATE()), GETDATE())";
        
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, customerId);
            ps.setInt(2, points);
            ps.setString(3, transactionType != null ? transactionType : "earned");
            ps.setString(4, description);

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
     * Trừ điểm (khi redeem voucher) - SỬ DỤNG FIFO
     */
    public boolean addUsedPoints(int customerId, int points, String description, String transactionType) {
        // Sử dụng redeemPointsFIFO để cập nhật points_used đúng cách
        return redeemPointsFIFO(customerId, points, description, transactionType);
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
     * Lấy tổng điểm khả dụng (chưa hết hạn)
     */
    public int getAvailablePoints(int customerId) {
        String sql = "SELECT ISNULL(SUM(points_earned - points_used), 0) " +
                     "FROM LoyaltyPointHistory " +
                     "WHERE customer_id = ? " +
                     "AND (expired_date IS NULL OR expired_date > GETDATE())";
        
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
     * Trừ điểm theo FIFO (First In First Out) - trừ điểm mới nhất trước
     */
    public boolean redeemPointsFIFO(int customerId, int pointsToRedeem, String description, String transactionType) {
        
        Connection conn = null;
        PreparedStatement psSelect = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdateCustomer = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Kiểm tra tổng điểm khả dụng
            int availablePoints = getAvailablePoints(customerId);
            if (availablePoints < pointsToRedeem) {
                System.out.println("Not enough points. Available: " + availablePoints + ", Requested: " + pointsToRedeem);
                return false;
            }
            
            // 2. Lấy danh sách điểm theo FIFO (mới nhất trước)
            String selectPoints = 
                "SELECT point_history_id, points_earned, points_used " +
                "FROM LoyaltyPointHistory " +
                "WHERE customer_id = ? " +
                "AND points_earned > points_used " +
                "AND (expired_date IS NULL OR expired_date > GETDATE()) " +
                "ORDER BY created_at DESC";
            
            psSelect = conn.prepareStatement(selectPoints);
            psSelect.setInt(1, customerId);
            rs = psSelect.executeQuery();
            
            int remainingPoints = pointsToRedeem;
            int totalRedeemed = 0;
            
            while (rs.next() && remainingPoints > 0) {
                int historyId = rs.getInt("point_history_id");
                int pointsEarned = rs.getInt("points_earned");
                int pointsUsed = rs.getInt("points_used");
                int available = pointsEarned - pointsUsed;
                
                int pointsToUse = Math.min(available, remainingPoints);
                int newPointsUsed = pointsUsed + pointsToUse;
                
                // 3. Cập nhật points_used cho điểm đó
                String updatePoints = "UPDATE LoyaltyPointHistory SET points_used = ? WHERE point_history_id = ?";
                psUpdate = conn.prepareStatement(updatePoints);
                psUpdate.setInt(1, newPointsUsed);
                psUpdate.setInt(2, historyId);
                psUpdate.executeUpdate();
                
                remainingPoints -= pointsToUse;
                totalRedeemed += pointsToUse;
                
                System.out.println("Redeemed " + pointsToUse + " points from history ID " + historyId);
            }
            
            if (remainingPoints > 0) {
                conn.rollback();
                System.out.println("Not enough available points. Remaining: " + remainingPoints);
                return false;
            }
            
            // 4. Ghi lại lịch sử redeem
            String insertRedeem = 
                "INSERT INTO LoyaltyPointHistory " +
                "(customer_id, points_earned, points_used, transaction_type, description, expired_date, created_at) " +
                "VALUES (?, 0, ?, ?, ?, DATEADD(YEAR, 1, GETDATE()), GETDATE())";
            
            psInsert = conn.prepareStatement(insertRedeem);
            psInsert.setInt(1, customerId);
            psInsert.setInt(2, totalRedeemed);
            psInsert.setString(3, transactionType != null ? transactionType : "redeem");
            psInsert.setString(4, description + " - Redeemed " + totalRedeemed + " points");
            psInsert.executeUpdate();
            
            // 5. Tính lại total_points từ LoyaltyPointHistory
            String updateCustomer = 
                "UPDATE Customer " +
                "SET total_points = ( " +
                "    SELECT ISNULL(SUM(points_earned - points_used), 0) " +
                "    FROM LoyaltyPointHistory " +
                "    WHERE customer_id = Customer.customer_id " +
                "    AND (expired_date IS NULL OR expired_date > GETDATE()) " +
                ") " +
                "WHERE customer_id = ?";
            
            psUpdateCustomer = conn.prepareStatement(updateCustomer);
            psUpdateCustomer.setInt(1, customerId);
            psUpdateCustomer.executeUpdate();
            
            conn.commit();
            System.out.println("=== Redeem completed. Total redeemed: " + totalRedeemed + " points ===");
            return true;
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (psSelect != null) psSelect.close();
                if (psUpdate != null) psUpdate.close();
                if (psInsert != null) psInsert.close();
                if (psUpdateCustomer != null) psUpdateCustomer.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Reset lại total_points của customer dựa trên LoyaltyPointHistory
     */
    public boolean resetCustomerPoints(int customerId) {
        String sql = "UPDATE Customer " +
                     "SET total_points = ( " +
                     "    SELECT ISNULL(SUM(points_earned - points_used), 0) " +
                     "    FROM LoyaltyPointHistory " +
                     "    WHERE customer_id = Customer.customer_id " +
                     "    AND (expired_date IS NULL OR expired_date > GETDATE()) " +
                     ") " +
                     "WHERE customer_id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            int rows = ps.executeUpdate();
            System.out.println("Reset points for customer " + customerId + ", rows affected: " + rows);
            return rows > 0;
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

    // ===================== PHẦN XÓA ĐIỂM =====================

    /**
     * Xóa 1 điểm cụ thể theo point_history_id
     */
    public boolean deletePointById(int pointHistoryId) {
        Connection conn = null;
        PreparedStatement psDelete = null;
        PreparedStatement psGetCustomer = null;
        PreparedStatement psUpdateCustomer = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);
            
            String getCustomerSql = "SELECT customer_id FROM LoyaltyPointHistory WHERE point_history_id = ?";
            psGetCustomer = conn.prepareStatement(getCustomerSql);
            psGetCustomer.setInt(1, pointHistoryId);
            rs = psGetCustomer.executeQuery();
            
            int customerId = 0;
            if (rs.next()) {
                customerId = rs.getInt("customer_id");
            } else {
                System.out.println("Point history ID " + pointHistoryId + " not found.");
                return false;
            }
            rs.close();
            psGetCustomer.close();
            
            String deleteSql = "DELETE FROM LoyaltyPointHistory WHERE point_history_id = ?";
            psDelete = conn.prepareStatement(deleteSql);
            psDelete.setInt(1, pointHistoryId);
            psDelete.executeUpdate();
            
            String updateCustomer = 
                "UPDATE Customer " +
                "SET total_points = ( " +
                "    SELECT ISNULL(SUM(points_earned - points_used), 0) " +
                "    FROM LoyaltyPointHistory " +
                "    WHERE customer_id = Customer.customer_id " +
                "    AND (expired_date IS NULL OR expired_date > GETDATE()) " +
                ") " +
                "WHERE customer_id = ?";
            
            psUpdateCustomer = conn.prepareStatement(updateCustomer);
            psUpdateCustomer.setInt(1, customerId);
            psUpdateCustomer.executeUpdate();
            
            conn.commit();
            System.out.println("=== Deleted point history ID " + pointHistoryId + " ===");
            return true;
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (psGetCustomer != null) psGetCustomer.close();
                if (psDelete != null) psDelete.close();
                if (psUpdateCustomer != null) psUpdateCustomer.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Xóa điểm theo customerId và pointHistoryId (có kiểm tra quyền sở hữu)
     */
    public boolean deletePointByCustomerAndId(int customerId, int pointHistoryId) {
        Connection conn = null;
        PreparedStatement psSelect = null;
        PreparedStatement psDelete = null;
        PreparedStatement psUpdateCustomer = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);
            
            String checkSql = "SELECT customer_id, points_earned, points_used FROM LoyaltyPointHistory WHERE point_history_id = ?";
            psSelect = conn.prepareStatement(checkSql);
            psSelect.setInt(1, pointHistoryId);
            rs = psSelect.executeQuery();
            
            if (!rs.next()) {
                System.out.println("Point history ID " + pointHistoryId + " not found.");
                return false;
            }
            
            int dbCustomerId = rs.getInt("customer_id");
            if (dbCustomerId != customerId) {
                System.out.println("Point does not belong to customer " + customerId);
                return false;
            }
            
            rs.close();
            psSelect.close();
            
            String deleteSql = "DELETE FROM LoyaltyPointHistory WHERE point_history_id = ?";
            psDelete = conn.prepareStatement(deleteSql);
            psDelete.setInt(1, pointHistoryId);
            psDelete.executeUpdate();
            
            String updateCustomer = 
                "UPDATE Customer " +
                "SET total_points = ( " +
                "    SELECT ISNULL(SUM(points_earned - points_used), 0) " +
                "    FROM LoyaltyPointHistory " +
                "    WHERE customer_id = Customer.customer_id " +
                "    AND (expired_date IS NULL OR expired_date > GETDATE()) " +
                ") " +
                "WHERE customer_id = ?";
            
            psUpdateCustomer = conn.prepareStatement(updateCustomer);
            psUpdateCustomer.setInt(1, customerId);
            psUpdateCustomer.executeUpdate();
            
            conn.commit();
            System.out.println("=== Deleted point history ID " + pointHistoryId + " for customer " + customerId + " ===");
            return true;
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (psSelect != null) psSelect.close();
                if (psDelete != null) psDelete.close();
                if (psUpdateCustomer != null) psUpdateCustomer.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Xóa tất cả điểm của 1 customer
     */
    public boolean deleteAllPointsByCustomerId(int customerId) {
        Connection conn = null;
        PreparedStatement psDelete = null;
        PreparedStatement psUpdateCustomer = null;
        
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);
            
            String deleteSql = "DELETE FROM LoyaltyPointHistory WHERE customer_id = ?";
            psDelete = conn.prepareStatement(deleteSql);
            psDelete.setInt(1, customerId);
            psDelete.executeUpdate();
            
            String updateCustomer = "UPDATE Customer SET total_points = 0 WHERE customer_id = ?";
            psUpdateCustomer = conn.prepareStatement(updateCustomer);
            psUpdateCustomer.setInt(1, customerId);
            psUpdateCustomer.executeUpdate();
            
            conn.commit();
            System.out.println("=== Deleted all points for customer " + customerId + " ===");
            return true;
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            try {
                if (psDelete != null) psDelete.close();
                if (psUpdateCustomer != null) psUpdateCustomer.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 1️⃣ Implement Point Expiration Logic
     * - Điểm hết hạn sau 1 năm nếu không sử dụng
     * - Nếu có sử dụng, gia hạn thêm 1 năm
     */
    public void expirePoints() {
        
        // ===== BƯỚC 1: Tìm điểm đã hết hạn (KHÔNG fix NULL) =====
        String selectExpiredPoints = 
            "SELECT point_history_id, customer_id, points_earned, points_used " +
            "FROM LoyaltyPointHistory " +
            "WHERE expired_date <= GETDATE() " +
            "AND points_earned > points_used";
        
        // ===== BƯỚC 2: Đánh dấu điểm đã hết hạn =====
        String updatePoints = 
            "UPDATE LoyaltyPointHistory " +
            "SET points_used = points_earned " +
            "WHERE point_history_id = ?";
        
        // ===== BƯỚC 3: Ghi lại lịch sử hết hạn =====
        String insertExpiredHistory = 
            "INSERT INTO LoyaltyPointHistory " +
            "(customer_id, points_earned, points_used, transaction_type, description, expired_date, created_at) " +
            "VALUES (?, 0, ?, 'expired', ?, GETDATE(), GETDATE())";
        
        // ===== BƯỚC 4: Cập nhật tổng điểm =====
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
            System.out.println("Current time: " + new java.util.Date());

            // ===== BƯỚC 1: Tìm điểm đã hết hạn =====
            pstmtSelect = conn.prepareStatement(selectExpiredPoints);
            rs = pstmtSelect.executeQuery();

            int totalExpired = 0;

            while (rs.next()) {
                int historyId = rs.getInt("point_history_id");
                int customerId = rs.getInt("customer_id");
                int pointsEarned = rs.getInt("points_earned");
                int pointsUsed = rs.getInt("points_used");
                int expiredPoints = pointsEarned - pointsUsed;

                System.out.println("Found expired: historyId=" + historyId + 
                                   ", customerId=" + customerId + 
                                   ", pointsEarned=" + pointsEarned + 
                                   ", pointsUsed=" + pointsUsed + 
                                   ", expiredPoints=" + expiredPoints);

                if (expiredPoints > 0) {
                    // ===== BƯỚC 2: Đánh dấu điểm đã hết hạn =====
                    pstmtUpdate = conn.prepareStatement(updatePoints);
                    pstmtUpdate.setInt(1, historyId);
                    int updated = pstmtUpdate.executeUpdate();
                    System.out.println("Updated history ID " + historyId + ", rows: " + updated);

                    // ===== BƯỚC 3: Ghi lại lịch sử hết hạn =====
                    pstmtInsert = conn.prepareStatement(insertExpiredHistory);
                    pstmtInsert.setInt(1, customerId);
                    pstmtInsert.setInt(2, expiredPoints);
                    pstmtInsert.setString(3, expiredPoints + " points expired after 12 months");
                    int inserted = pstmtInsert.executeUpdate();
                    System.out.println("Inserted expired record for customer " + customerId + ", rows: " + inserted);

                    // ===== BƯỚC 4: Cập nhật tổng điểm =====
                    pstmtCustomer = conn.prepareStatement(updateCustomerPoints);
                    pstmtCustomer.setInt(1, customerId);
                    int customerUpdated = pstmtCustomer.executeUpdate();
                    System.out.println("Updated customer " + customerId + " total points, rows: " + customerUpdated);

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