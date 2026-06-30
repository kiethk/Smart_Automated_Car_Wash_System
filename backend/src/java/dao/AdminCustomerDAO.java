package dao;

import dto.AdminCustomerView;
import dto.Tiers;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class AdminCustomerDAO {

    public List<AdminCustomerView> getAllCustomersForAdmin() {
        List<AdminCustomerView> list = new ArrayList<>();

        String sql = "SELECT "
                + "u.user_id, u.full_name, u.email, u.phone, u.avatar_url, u.is_active, "
                + "c.customer_id, c.address, c.total_points, c.total_spent, c.total_washes, "
                + "c.join_date, c.date_of_birth, c.tier_id, "
                + "t.tier_name, "
                + "ISNULL(w.balance, 0) AS wallet_balance "
                + "FROM Customer c "
                + "JOIN [User] u ON c.user_id = u.user_id "
                + "LEFT JOIN Tiers t ON c.tier_id = t.tier_id "
                + "LEFT JOIN Wallet w ON c.customer_id = w.customer_id "
                + "WHERE u.role_id = 3 "
                + "ORDER BY c.customer_id DESC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdminCustomerView customer = new AdminCustomerView();

                customer.setUserId(rs.getInt("user_id"));
                customer.setCustomerId(rs.getInt("customer_id"));

                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setAvatarUrl(rs.getString("avatar_url"));
                customer.setIsActive(rs.getInt("is_active"));

                customer.setAddress(rs.getString("address"));
                customer.setTotalPoints(rs.getInt("total_points"));
                customer.setTotalSpent(rs.getLong("total_spent"));
                customer.setTotalWashes(rs.getInt("total_washes"));
                customer.setJoinDate(rs.getDate("join_date"));
                customer.setDateOfBirth(rs.getDate("date_of_birth"));

                customer.setTierId(rs.getInt("tier_id"));
                customer.setTierName(rs.getString("tier_name"));

                customer.setWalletBalance(rs.getLong("wallet_balance"));

                list.add(customer);
            }

        } catch (Exception e) {
            System.out.println("Error at AdminCustomerDAO.getAllCustomersForAdmin(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateCustomerAccountStatus(int userId, int isActive) {
        String sql = "UPDATE [User] SET is_active = ? WHERE user_id = ? AND role_id = 3";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, isActive);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at AdminCustomerDAO.updateCustomerAccountStatus(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public AdminCustomerView getCustomerViewByCustomerId(int customerId) {
        String sql = "SELECT "
                + "u.user_id, u.full_name, u.email, u.phone, u.avatar_url, u.is_active, "
                + "c.customer_id, c.address, c.total_points, c.total_spent, c.total_washes, "
                + "c.join_date, c.date_of_birth, c.tier_id, "
                + "t.tier_name, "
                + "ISNULL(w.balance, 0) AS wallet_balance "
                + "FROM Customer c "
                + "JOIN [User] u ON c.user_id = u.user_id "
                + "LEFT JOIN Tiers t ON c.tier_id = t.tier_id "
                + "LEFT JOIN Wallet w ON c.customer_id = w.customer_id "
                + "WHERE c.customer_id = ? AND u.role_id = 3";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdminCustomerView customer = new AdminCustomerView();

                    customer.setUserId(rs.getInt("user_id"));
                    customer.setCustomerId(rs.getInt("customer_id"));

                    customer.setFullName(rs.getString("full_name"));
                    customer.setEmail(rs.getString("email"));
                    customer.setPhone(rs.getString("phone"));
                    customer.setAvatarUrl(rs.getString("avatar_url"));
                    customer.setIsActive(rs.getInt("is_active"));

                    customer.setAddress(rs.getString("address"));
                    customer.setTotalPoints(rs.getInt("total_points"));
                    customer.setTotalSpent(rs.getLong("total_spent"));
                    customer.setTotalWashes(rs.getInt("total_washes"));
                    customer.setJoinDate(rs.getDate("join_date"));
                    customer.setDateOfBirth(rs.getDate("date_of_birth"));

                    customer.setTierId(rs.getInt("tier_id"));
                    customer.setTierName(rs.getString("tier_name"));

                    customer.setWalletBalance(rs.getLong("wallet_balance"));

                    return customer;
                }
            }

        } catch (Exception e) {
            System.out.println("Error at AdminCustomerDAO.getCustomerViewByCustomerId(): " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateCustomerAdminFields(int customerId, int tierId, long totalSpent,
            int totalWashes, int totalPoints, long walletBalance) {

        Tiers targetTier = new TiersDAO().getApplicableTierByStats(totalSpent, totalWashes);
        int resolvedTierId = targetTier != null ? targetTier.getTierId() : tierId;

        String sqlSkipLoyaltyTrigger = "EXEC sp_set_session_context @key=N'SkipLoyaltyStats', @value=?";

        String sqlResetCurrentMonthStats = "DELETE FROM CustomerMonthlyStats "
                + "WHERE customer_id = ? "
                + "AND stat_year = YEAR(GETDATE()) "
                + "AND stat_month = MONTH(GETDATE())";

        String sqlUpdateCustomer = "UPDATE Customer "
                + "SET tier_id = ?, total_spent = ?, total_washes = ?, total_points = ? "
                + "WHERE customer_id = ?";

        String sqlCheckWallet = "SELECT wallet_id FROM Wallet WHERE customer_id = ?";

        String sqlUpdateWallet = "UPDATE Wallet SET balance = ? WHERE customer_id = ?";

        String sqlCreateWallet = "INSERT INTO Wallet (balance, customer_id) VALUES (?, ?)";

        Connection conn = null;

        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);

            try ( PreparedStatement ps = conn.prepareStatement(sqlSkipLoyaltyTrigger)) {
                ps.setInt(1, 1);
                ps.executeUpdate();
            }

            try ( PreparedStatement ps = conn.prepareStatement(sqlResetCurrentMonthStats)) {
                ps.setInt(1, customerId);
                ps.executeUpdate();
            }

            try ( PreparedStatement ps = conn.prepareStatement(sqlUpdateCustomer)) {
                ps.setInt(1, resolvedTierId);
                ps.setLong(2, totalSpent);
                ps.setInt(3, totalWashes);
                ps.setInt(4, totalPoints);
                ps.setInt(5, customerId);
                ps.executeUpdate();
            }

            boolean walletExists = false;

            try ( PreparedStatement ps = conn.prepareStatement(sqlCheckWallet)) {
                ps.setInt(1, customerId);

                try ( ResultSet rs = ps.executeQuery()) {
                    walletExists = rs.next();
                }
            }

            if (walletExists) {
                try ( PreparedStatement ps = conn.prepareStatement(sqlUpdateWallet)) {
                    ps.setLong(1, walletBalance);
                    ps.setInt(2, customerId);
                    ps.executeUpdate();
                }
            } else {
                try ( PreparedStatement ps = conn.prepareStatement(sqlCreateWallet)) {
                    ps.setLong(1, walletBalance);
                    ps.setInt(2, customerId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Error at AdminCustomerDAO.updateCustomerAdminFields(): " + e.getMessage());
            e.printStackTrace();

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }

        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception closeEx) {
                closeEx.printStackTrace();
            }
        }

        return false;
    }
}
