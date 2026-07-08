package dao;

import dto.AdminPaymentView;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class AdminPaymentDAO {

    // ===== LẤY TẤT CẢ PAYMENT KÈM THÔNG TIN CHI TIẾT =====
    public List<AdminPaymentView> getAllPayments() {
        List<AdminPaymentView> list = new ArrayList<>();

        String sql = "SELECT p.payment_id, p.payment_method, p.payment_status, "
                + "p.amount, p.paid_at, p.transaction_id, p.booking_id, "
                + "p.checkin_image_url, p.checkout_image_url, "
                + "u.full_name, u.phone, u.email, "
                + "svc.service_names "
                + "FROM Payment p "
                + "LEFT JOIN Booking b ON p.booking_id = b.booking_id "
                + "LEFT JOIN Customer c ON b.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON c.user_id = u.user_id "
                + "LEFT JOIN ( "
                + "    SELECT bs.booking_id, "
                + "           STRING_AGG(s.service_name, ', ') AS service_names "
                + "    FROM BookingService bs "
                + "    JOIN Service s ON bs.service_id = s.service_id "
                + "    GROUP BY bs.booking_id "
                + ") svc ON p.booking_id = svc.booking_id "
                + "ORDER BY p.payment_id DESC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdminPaymentView p = new AdminPaymentView();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setAmount(rs.getLong("amount"));
                p.setPaidAt(rs.getTimestamp("paid_at"));
                p.setTransactionId(rs.getString("transaction_id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setCheckinImageUrl(rs.getString("checkin_image_url"));
                p.setCheckoutImageUrl(rs.getString("checkout_image_url"));
                p.setCustomerName(rs.getString("full_name"));
                p.setCustomerPhone(rs.getString("phone"));
                p.setCustomerEmail(rs.getString("email"));
                p.setServiceNames(rs.getString("service_names"));
                list.add(p);
            }

        } catch (Exception e) {
            System.out.println("Error at AdminPaymentDAO.getAllPayments(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // ===== SINH MÃ TRANSACTION THEO FORMAT TXN-001 =====
    private String generateTransactionId() {
        String sql = "SELECT COUNT(*) FROM Payment WHERE transaction_id IS NOT NULL";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int count = rs.getInt(1) + 1;
                return String.format("TXN-%03d", count);
            }

        } catch (Exception e) {
            System.out.println("Error at AdminPaymentDAO.generateTransactionId(): " + e.getMessage());
            e.printStackTrace();
        }

        return "TXN-001";
    }

    // ===== CẬP NHẬT STATUS + PAID_AT + TRANSACTION_ID =====
    public int updatePaymentStatus(int paymentId, String status) {
        String transactionId = generateTransactionId();

        String sql = "UPDATE Payment "
                + "SET payment_status = ?, "
                + "    paid_at = GETDATE(), "
                + "    transaction_id = ? "
                + "WHERE payment_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, transactionId);
            ps.setInt(3, paymentId);
            return ps.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error at AdminPaymentDAO.updatePaymentStatus(): " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // ===== CẬP NHẬT CHECKIN / CHECKOUT IMAGE =====
    public int updateCheckinCheckout(int bookingId, String checkinUrl, String checkoutUrl) {
        String sql = "UPDATE Payment "
                + "SET checkin_image_url = ?, checkout_image_url = ? "
                + "WHERE booking_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, checkinUrl);
            ps.setString(2, checkoutUrl);
            ps.setInt(3, bookingId);
            return ps.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error at AdminPaymentDAO.updateCheckinCheckout(): " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }
}