package dao;

import dto.Feedback;
import dto.AdminFeedbackView;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class FeedbackDAO {

    // ===== CUSTOMER: INSERT feedback mới =====
    public int insertFeedback(Feedback f) {
        String sql = "INSERT INTO Feedback (rating, comment, created_at, booking_id, customer_id) "
                + "VALUES (?, ?, GETDATE(), ?, ?)";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, f.getRating());
            ps.setString(2, f.getComment());
            ps.setInt(3, f.getBookingId());
            ps.setInt(4, f.getCustomerId());
            return ps.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error at FeedbackDAO.insertFeedback(): " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // ===== ADMIN: LẤY TẤT CẢ FEEDBACK kèm tên customer và tên service =====
    public List<AdminFeedbackView> getAllFeedbacksForAdmin() {
        List<AdminFeedbackView> list = new ArrayList<>();

        String sql = "SELECT "
                + "f.feedback_id, f.rating, f.comment, f.created_at, f.booking_id, "
                + "u.full_name AS customer_name, "
                + "svc.service_names "
                + "FROM Feedback f "
                + "LEFT JOIN Customer c ON f.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON c.user_id = u.user_id "
                + "LEFT JOIN ( "
                + "    SELECT bs.booking_id, "
                + "           STRING_AGG(s.service_name, ', ') AS service_names "
                + "    FROM BookingService bs "
                + "    JOIN Service s ON bs.service_id = s.service_id "
                + "    GROUP BY bs.booking_id "
                + ") svc ON f.booking_id = svc.booking_id "
                + "ORDER BY f.created_at DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
               AdminFeedbackView fv = new AdminFeedbackView();
                fv.setFeedbackId(rs.getInt("feedback_id"));
                fv.setRating(rs.getInt("rating"));
                fv.setComment(rs.getString("comment"));
                fv.setCreatedAt(rs.getTimestamp("created_at"));
                fv.setBookingId(rs.getInt("booking_id"));
                fv.setCustomerName(rs.getString("customer_name"));
                fv.setServiceNames(rs.getString("service_names"));
                list.add(fv);
            }

        } catch (Exception e) {
            System.out.println("Error at FeedbackDAO.getAllFeedbacksForAdmin(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }
    
    
    // IS FEEDBACK
public boolean hasFeedback(int bookingId) {
    String sql = "SELECT COUNT(*) FROM Feedback WHERE booking_id = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
//lấy service để filter
public List<String> getDistinctServiceNames() {
    List<String> list = new ArrayList<>();

    String sql = "SELECT DISTINCT s.service_name "
               + "FROM Feedback f "
               + "JOIN BookingService bs ON f.booking_id = bs.booking_id "
               + "JOIN Service s ON bs.service_id = s.service_id "
               + "ORDER BY s.service_name";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            list.add(rs.getString("service_name"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
}
