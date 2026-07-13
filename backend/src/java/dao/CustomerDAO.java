package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.Customer;
import java.sql.Date;
import utils.DBUtils;

public class CustomerDAO {

    /**
     * Lấy thông tin Customer theo UserId
     *
     * @param userId ID của User
     * @return Customer object hoặc null nếu không tìm thấy
     */
    public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT * FROM Customer WHERE user_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAddress(rs.getString("address"));
                customer.setTotalPoints(rs.getInt("total_points"));
                customer.setTotalSpent(rs.getLong("total_spent"));
                customer.setTotalWashes(rs.getInt("total_washes"));
                customer.setJoinDate(rs.getDate("join_date"));
                customer.setDateOfBirth(rs.getDate("date_of_birth"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setTierId(rs.getInt("tier_id"));
                customer.setLastReviewDate(rs.getDate("last_review_date"));
                return customer;
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy thông tin Customer trực tiếp bằng CustomerId phục vụ đồng bộ Dashboard
     *
     * @param customerId ID của Customer
     * @return Customer object hoặc null nếu không tìm thấy
     */
    public Customer getCustomerById(int customerId) {
        String sql = "SELECT * FROM Customer WHERE customer_id = ?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    customer.setAddress(rs.getString("address"));
                    customer.setTotalPoints(rs.getInt("total_points"));
                    customer.setTotalSpent(rs.getLong("total_spent"));
                    customer.setTotalWashes(rs.getInt("total_washes"));
                    customer.setJoinDate(rs.getDate("join_date"));
                    customer.setDateOfBirth(rs.getDate("date_of_birth"));
                    customer.setUserId(rs.getInt("user_id"));
                    customer.setTierId(rs.getInt("tier_id"));
                    customer.setLastReviewDate(rs.getDate("last_review_date"));
                    return customer;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createNewCustomer(Customer c) {

        int result = 0;

        Connection cn = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql = "INSERT INTO Customer "
                        + "(address, total_points, "
                        + "total_spent, total_washes, "
                        + "join_date, date_of_birth, "
                        + "user_id, tier_id, "
                        + "last_review_date) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement st
                        = cn.prepareStatement(sql);

                st.setString(1, c.getAddress());

                st.setInt(2, c.getTotalPoints());

                st.setLong(3, c.getTotalSpent());

                st.setInt(4, c.getTotalWashes());

                st.setDate(5,
                        (Date) c.getJoinDate());

                st.setDate(6,
                        (Date) c.getDateOfBirth());

                st.setInt(7, c.getUserId());

                st.setInt(8, c.getTierId());

                st.setDate(9,
                        (Date) c.getLastReviewDate());

                result = st.executeUpdate();
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

        return result;
    }

    public boolean updateAddressById(int customerId, String address) {
        String sql = "UPDATE Customer SET address = ? WHERE customer_id = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, address);
            ps.setInt(2, customerId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDobById(int customerId, String dob) {
        String sql = "UPDATE Customer SET date_of_birth = ? WHERE customer_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            java.sql.Date date = java.sql.Date.valueOf(dob);

            ps.setDate(1, date);
            ps.setInt(2, customerId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===================== PHẦN THÊM MỚI =====================

    /**
     * Lấy danh sách tất cả khách hàng với thông tin chi tiết kèm tier, wallet, user
     */
    public List<Customer> getAllCustomersWithDetails() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT c.customer_id, c.address, c.total_points, c.total_spent, c.total_washes, "
                   + "c.join_date, c.date_of_birth, c.user_id, c.tier_id, c.last_review_date, "
                   + "u.full_name, u.email, u.phone, u.is_active, u.avatar_url, "
                   + "t.tier_name, t.discount_percent, t.point_multiplier, "
                   + "w.balance as wallet_balance "
                   + "FROM Customer c "
                   + "JOIN [User] u ON c.user_id = u.user_id "
                   + "LEFT JOIN Tiers t ON c.tier_id = t.tier_id "
                   + "LEFT JOIN Wallet w ON c.customer_id = w.customer_id "
                   + "ORDER BY c.customer_id DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAddress(rs.getString("address"));
                customer.setTotalPoints(rs.getInt("total_points"));
                customer.setTotalSpent(rs.getLong("total_spent"));
                customer.setTotalWashes(rs.getInt("total_washes"));
                customer.setJoinDate(rs.getDate("join_date"));
                customer.setDateOfBirth(rs.getDate("date_of_birth"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setTierId(rs.getInt("tier_id"));
                customer.setLastReviewDate(rs.getDate("last_review_date"));

                // User info
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setIsActive(rs.getInt("is_active"));
                customer.setAvatarUrl(rs.getString("avatar_url"));

                // Tier info
                customer.setTierName(rs.getString("tier_name"));
                customer.setDiscountPercent(rs.getDouble("discount_percent"));
                customer.setPointMultiplier(rs.getDouble("point_multiplier"));

                // Wallet info
                customer.setWalletBalance(rs.getLong("wallet_balance"));

                customers.add(customer);
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
        return customers;
    }

    /**
     * Lấy thông tin Customer chi tiết kèm tier, wallet, user
     */
    public Customer getCustomerWithDetails(int customerId) {
        String sql = "SELECT c.customer_id, c.address, c.total_points, c.total_spent, c.total_washes, "
                   + "c.join_date, c.date_of_birth, c.user_id, c.tier_id, c.last_review_date, "
                   + "u.full_name, u.email, u.phone, u.is_active, u.avatar_url, "
                   + "t.tier_name, t.discount_percent, t.point_multiplier, "
                   + "w.balance as wallet_balance "
                   + "FROM Customer c "
                   + "JOIN [User] u ON c.user_id = u.user_id "
                   + "LEFT JOIN Tiers t ON c.tier_id = t.tier_id "
                   + "LEFT JOIN Wallet w ON c.customer_id = w.customer_id "
                   + "WHERE c.customer_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAddress(rs.getString("address"));
                customer.setTotalPoints(rs.getInt("total_points"));
                customer.setTotalSpent(rs.getLong("total_spent"));
                customer.setTotalWashes(rs.getInt("total_washes"));
                customer.setJoinDate(rs.getDate("join_date"));
                customer.setDateOfBirth(rs.getDate("date_of_birth"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setTierId(rs.getInt("tier_id"));
                customer.setLastReviewDate(rs.getDate("last_review_date"));

                // User info
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setIsActive(rs.getInt("is_active"));
                customer.setAvatarUrl(rs.getString("avatar_url"));

                // Tier info
                customer.setTierName(rs.getString("tier_name"));
                customer.setDiscountPercent(rs.getDouble("discount_percent"));
                customer.setPointMultiplier(rs.getDouble("point_multiplier"));

                // Wallet info
                customer.setWalletBalance(rs.getLong("wallet_balance"));

                return customer;
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
        return null;
    }

    /**
     * Tìm kiếm khách hàng theo keyword
     */
    public List<Customer> searchCustomers(String keyword) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT c.customer_id, c.address, c.total_points, c.total_spent, c.total_washes, "
                   + "c.join_date, c.date_of_birth, c.user_id, c.tier_id, c.last_review_date, "
                   + "u.full_name, u.email, u.phone, u.is_active, u.avatar_url, "
                   + "t.tier_name, t.discount_percent, t.point_multiplier, "
                   + "w.balance as wallet_balance "
                   + "FROM Customer c "
                   + "JOIN [User] u ON c.user_id = u.user_id "
                   + "LEFT JOIN Tiers t ON c.tier_id = t.tier_id "
                   + "LEFT JOIN Wallet w ON c.customer_id = w.customer_id "
                   + "WHERE u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ? OR c.address LIKE ? "
                   + "ORDER BY c.customer_id DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            rs = ps.executeQuery();

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAddress(rs.getString("address"));
                customer.setTotalPoints(rs.getInt("total_points"));
                customer.setTotalSpent(rs.getLong("total_spent"));
                customer.setTotalWashes(rs.getInt("total_washes"));
                customer.setJoinDate(rs.getDate("join_date"));
                customer.setDateOfBirth(rs.getDate("date_of_birth"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setTierId(rs.getInt("tier_id"));
                customer.setLastReviewDate(rs.getDate("last_review_date"));

                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setIsActive(rs.getInt("is_active"));
                customer.setAvatarUrl(rs.getString("avatar_url"));

                customer.setTierName(rs.getString("tier_name"));
                customer.setDiscountPercent(rs.getDouble("discount_percent"));
                customer.setPointMultiplier(rs.getDouble("point_multiplier"));

                customer.setWalletBalance(rs.getLong("wallet_balance"));

                customers.add(customer);
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
        return customers;
    }

    /**
     * Lọc khách hàng theo tier
     */
    public List<Customer> filterCustomersByTier(int tierId) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT c.customer_id, c.address, c.total_points, c.total_spent, c.total_washes, "
                   + "c.join_date, c.date_of_birth, c.user_id, c.tier_id, c.last_review_date, "
                   + "u.full_name, u.email, u.phone, u.is_active, u.avatar_url, "
                   + "t.tier_name, t.discount_percent, t.point_multiplier, "
                   + "w.balance as wallet_balance "
                   + "FROM Customer c "
                   + "JOIN [User] u ON c.user_id = u.user_id "
                   + "LEFT JOIN Tiers t ON c.tier_id = t.tier_id "
                   + "LEFT JOIN Wallet w ON c.customer_id = w.customer_id "
                   + "WHERE c.tier_id = ? "
                   + "ORDER BY c.customer_id DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, tierId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAddress(rs.getString("address"));
                customer.setTotalPoints(rs.getInt("total_points"));
                customer.setTotalSpent(rs.getLong("total_spent"));
                customer.setTotalWashes(rs.getInt("total_washes"));
                customer.setJoinDate(rs.getDate("join_date"));
                customer.setDateOfBirth(rs.getDate("date_of_birth"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setTierId(rs.getInt("tier_id"));
                customer.setLastReviewDate(rs.getDate("last_review_date"));

                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setIsActive(rs.getInt("is_active"));
                customer.setAvatarUrl(rs.getString("avatar_url"));

                customer.setTierName(rs.getString("tier_name"));
                customer.setDiscountPercent(rs.getDouble("discount_percent"));
                customer.setPointMultiplier(rs.getDouble("point_multiplier"));

                customer.setWalletBalance(rs.getLong("wallet_balance"));

                customers.add(customer);
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
        return customers;
    }

    /**
     * Lấy thống kê khách hàng
     */
    public CustomerStatistics getCustomerStatistics() {
        CustomerStatistics stats = new CustomerStatistics();
        String sql = "SELECT "
                   + "COUNT(*) as total_customers, "
                   + "SUM(CASE WHEN tier_id = 1 THEN 1 ELSE 0 END) as member_count, "
                   + "SUM(CASE WHEN tier_id = 2 THEN 1 ELSE 0 END) as silver_count, "
                   + "SUM(CASE WHEN tier_id = 3 THEN 1 ELSE 0 END) as gold_count, "
                   + "SUM(CASE WHEN tier_id = 4 THEN 1 ELSE 0 END) as platinum_count, "
                   + "AVG(CAST(total_points AS FLOAT)) as avg_points, "
                   + "AVG(CAST(total_spent AS FLOAT)) as avg_spent, "
                   + "AVG(CAST(total_washes AS FLOAT)) as avg_washes "
                   + "FROM Customer";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                stats.setTotalCustomers(rs.getInt("total_customers"));
                stats.setMemberCount(rs.getInt("member_count"));
                stats.setSilverCount(rs.getInt("silver_count"));
                stats.setGoldCount(rs.getInt("gold_count"));
                stats.setPlatinumCount(rs.getInt("platinum_count"));
                stats.setAvgPoints(rs.getDouble("avg_points"));
                stats.setAvgSpent(rs.getDouble("avg_spent"));
                stats.setAvgWashes(rs.getDouble("avg_washes"));
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
        return stats;
    }

    // Inner class cho thống kê
    public static class CustomerStatistics {
        private int totalCustomers;
        private int memberCount;
        private int silverCount;
        private int goldCount;
        private int platinumCount;
        private double avgPoints;
        private double avgSpent;
        private double avgWashes;

        public int getTotalCustomers() { return totalCustomers; }
        public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }
        public int getMemberCount() { return memberCount; }
        public void setMemberCount(int memberCount) { this.memberCount = memberCount; }
        public int getSilverCount() { return silverCount; }
        public void setSilverCount(int silverCount) { this.silverCount = silverCount; }
        public int getGoldCount() { return goldCount; }
        public void setGoldCount(int goldCount) { this.goldCount = goldCount; }
        public int getPlatinumCount() { return platinumCount; }
        public void setPlatinumCount(int platinumCount) { this.platinumCount = platinumCount; }
        public double getAvgPoints() { return avgPoints; }
        public void setAvgPoints(double avgPoints) { this.avgPoints = avgPoints; }
        public double getAvgSpent() { return avgSpent; }
        public void setAvgSpent(double avgSpent) { this.avgSpent = avgSpent; }
        public double getAvgWashes() { return avgWashes; }
        public void setAvgWashes(double avgWashes) { this.avgWashes = avgWashes; }
    }
}