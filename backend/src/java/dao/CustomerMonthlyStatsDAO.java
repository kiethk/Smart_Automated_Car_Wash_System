package dao;

import dto.CustomerMonthlyStats;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class CustomerMonthlyStatsDAO {

    public CustomerMonthlyStats getByCustomerAndMonth(int customerId, int statYear, int statMonth) {
        String sql = "SELECT customer_id, stat_year, stat_month, monthly_spent, monthly_washes, created_at, updated_at "
                + "FROM CustomerMonthlyStats "
                + "WHERE customer_id = ? AND stat_year = ? AND stat_month = ?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, statYear);
            ps.setInt(3, statMonth);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public CustomerMonthlyStats getCurrentMonthByCustomerId(int customerId) {
        String sql = "SELECT customer_id, stat_year, stat_month, monthly_spent, monthly_washes, created_at, updated_at "
                + "FROM CustomerMonthlyStats "
                + "WHERE customer_id = ? AND stat_year = YEAR(GETDATE()) AND stat_month = MONTH(GETDATE())";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<CustomerMonthlyStats> getByMonth(int statYear, int statMonth) {
        List<CustomerMonthlyStats> list = new ArrayList<>();
        String sql = "SELECT customer_id, stat_year, stat_month, monthly_spent, monthly_washes, created_at, updated_at "
                + "FROM CustomerMonthlyStats "
                + "WHERE stat_year = ? AND stat_month = ? "
                + "ORDER BY monthly_spent DESC, monthly_washes DESC, customer_id ASC";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, statYear);
            ps.setInt(2, statMonth);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countByMonth(int statYear, int statMonth) {
        String sql = "SELECT COUNT(*) FROM CustomerMonthlyStats WHERE stat_year = ? AND stat_month = ?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, statYear);
            ps.setInt(2, statMonth);

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

    private CustomerMonthlyStats mapResultSet(ResultSet rs) throws Exception {
        CustomerMonthlyStats stats = new CustomerMonthlyStats();
        stats.setCustomerId(rs.getInt("customer_id"));
        stats.setStatYear(rs.getInt("stat_year"));
        stats.setStatMonth(rs.getInt("stat_month"));
        stats.setMonthlySpent(rs.getLong("monthly_spent"));
        stats.setMonthlyWashes(rs.getInt("monthly_washes"));
        stats.setCreatedAt(rs.getTimestamp("created_at"));
        stats.setUpdatedAt(rs.getTimestamp("updated_at"));
        return stats;
    }
}