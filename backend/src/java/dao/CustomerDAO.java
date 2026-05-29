package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dto.Customer;
import utils.DBUtils;

public class CustomerDAO {
    
    /**
     * Lấy thông tin Customer theo UserId
     * @param userId ID của User
     * @return Customer object hoặc null nếu không tìm thấy
     */
    public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT * FROM Customer WHERE user_id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
}