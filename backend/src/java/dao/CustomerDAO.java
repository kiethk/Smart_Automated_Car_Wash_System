package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

                PreparedStatement st = cn.prepareStatement(sql);

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
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
}
