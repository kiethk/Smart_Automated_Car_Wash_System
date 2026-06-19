package dao;

import dto.AdminBookingView;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class AdminBookingDAO {

    public List<AdminBookingView> getAllBookingsForAdmin() {
        List<AdminBookingView> list = new ArrayList<>();

        String sql = "SELECT "
                + "b.booking_id, b.booking_date, b.status AS booking_status, "
                + "b.discount_amount, b.total_amount, b.points_earned, b.created_at, b.notes, "
                + "u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone, "
                + "v.plate_number, v.vehicle_type, "
                + "COALESCE(NULLIF(v.custom_brand_name, ''), br.brand_name) AS vehicle_brand, "
                + "COALESCE(NULLIF(v.custom_model_name, ''), m.model_name) AS vehicle_model, "
                + "sl.time_value AS slot_time, "
                + "bay.bay_name, "
                + "p.code AS promotion_code, "
                + "svc.service_names, "
                + "ISNULL(svc.service_total, 0) AS service_total, "
                + "pay.payment_method, pay.payment_status, pay.paid_at "
                + "FROM Booking b "
                + "LEFT JOIN Customer c ON b.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON c.user_id = u.user_id "
                + "LEFT JOIN Vehicle v ON b.vehicle_id = v.vehicle_id "
                + "LEFT JOIN Model m ON v.model_id = m.model_id "
                + "LEFT JOIN Brand br ON m.brand_id = br.brand_id "
                + "LEFT JOIN Slot sl ON b.slot_id = sl.slot_id "
                + "LEFT JOIN Bay bay ON b.bay_id = bay.bay_id "
                + "LEFT JOIN Promotion p ON b.promotion_id = p.promotion_id "
                + "LEFT JOIN Payment pay ON b.booking_id = pay.booking_id "
                + "LEFT JOIN ( "
                + "    SELECT "
                + "        bs.booking_id, "
                + "        STRING_AGG(s.service_name, ', ') AS service_names, "
                + "        SUM(bs.price * ISNULL(bs.quantity, 1)) AS service_total "
                + "    FROM BookingService bs "
                + "    JOIN Service s ON bs.service_id = s.service_id "
                + "    GROUP BY bs.booking_id "
                + ") svc ON b.booking_id = svc.booking_id "
                + "ORDER BY b.created_at DESC, b.booking_id DESC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdminBookingView booking = mapBookingView(rs);
                list.add(booking);
            }

        } catch (Exception e) {
            System.out.println("Error at AdminBookingDAO.getAllBookingsForAdmin(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public boolean acceptBooking(int bookingId) {
        String sql = "UPDATE Booking "
                + "SET status = N'accepted' "
                + "WHERE booking_id = ? AND status = N'pending'";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at AdminBookingDAO.acceptBooking(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean markPaymentPaidOnly(int bookingId) {
        String sql = "UPDATE Payment "
                + "SET payment_status = N'paid', "
                + "    paid_at = CASE WHEN paid_at IS NULL THEN GETDATE() ELSE paid_at END, "
                + "    transaction_id = CASE "
                + "        WHEN transaction_id IS NULL THEN CONCAT('ADMIN_PAID_', booking_id, '_', DATEDIFF_BIG(MILLISECOND, '1970-01-01', SYSUTCDATETIME())) "
                + "        ELSE transaction_id "
                + "    END "
                + "WHERE booking_id = ? "
                + "AND ISNULL(payment_status, N'pending') <> N'paid'";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at AdminBookingDAO.markPaymentPaidOnly(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean completeBooking(int bookingId) {
        if (!canCompleteBooking(bookingId)) {
            return false;
        }

        BookingDAO bookingDAO = new BookingDAO();
        return bookingDAO.finishBookingAndCheckTier(bookingId);
    }

    public boolean cancelBooking(int bookingId) {
        String sql = "UPDATE Booking "
                + "SET status = N'cancelled' "
                + "WHERE booking_id = ? "
                + "AND status IN (N'pending', N'accepted')";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at AdminBookingDAO.cancelBooking(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private boolean canCompleteBooking(int bookingId) {
        String sql = "SELECT b.status, p.payment_status "
                + "FROM Booking b "
                + "LEFT JOIN Payment p ON b.booking_id = p.booking_id "
                + "WHERE b.booking_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String bookingStatus = rs.getString("status");
                    String paymentStatus = rs.getString("payment_status");

                    return "accepted".equalsIgnoreCase(bookingStatus)
                            && "paid".equalsIgnoreCase(paymentStatus);
                }
            }

        } catch (Exception e) {
            System.out.println("Error at AdminBookingDAO.canCompleteBooking(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private AdminBookingView mapBookingView(ResultSet rs) throws Exception {
        AdminBookingView booking = new AdminBookingView();

        booking.setBookingId(rs.getInt("booking_id"));
        booking.setBookingDate(rs.getDate("booking_date"));
        booking.setBookingStatus(rs.getString("booking_status"));
        booking.setDiscountAmount(rs.getLong("discount_amount"));
        booking.setTotalAmount(rs.getLong("total_amount"));
        booking.setPointsEarned(rs.getInt("points_earned"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        booking.setCreatedAt(createdAt);

        booking.setNotes(rs.getString("notes"));

        booking.setCustomerName(rs.getString("customer_name"));
        booking.setCustomerEmail(rs.getString("customer_email"));
        booking.setCustomerPhone(rs.getString("customer_phone"));

        booking.setPlateNumber(rs.getString("plate_number"));
        booking.setVehicleType(rs.getString("vehicle_type"));
        booking.setVehicleBrand(rs.getString("vehicle_brand"));
        booking.setVehicleModel(rs.getString("vehicle_model"));

        booking.setSlotTime(rs.getString("slot_time"));
        booking.setBayName(rs.getString("bay_name"));

        booking.setPromotionCode(rs.getString("promotion_code"));

        booking.setServiceNames(rs.getString("service_names"));
        booking.setServiceTotal(rs.getLong("service_total"));

        booking.setPaymentMethod(rs.getString("payment_method"));
        booking.setPaymentStatus(rs.getString("payment_status"));
        booking.setPaidAt(rs.getTimestamp("paid_at"));

        return booking;
    }
}
