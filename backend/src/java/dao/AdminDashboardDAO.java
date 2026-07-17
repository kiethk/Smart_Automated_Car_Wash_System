package dao;

import dto.AdminDashboardBookingView;
import dto.AdminDashboardStats;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class AdminDashboardDAO {

    public AdminDashboardStats getDashboardStats() {
        AdminDashboardStats stats = new AdminDashboardStats();

        String sql = ""
                + "SELECT "
                + "    (SELECT ISNULL(SUM(amount), 0) "
                + "     FROM Payment "
                + "     WHERE payment_status = N'paid' "
                + "     AND CAST(paid_at AS DATE) = CAST(GETDATE() AS DATE)) AS today_revenue, "
                + " "
                + "    (SELECT ISNULL(SUM(b.total_amount), 0) "
                + "     FROM Booking b "
                + "     WHERE b.status = N'completed' "
                + "     AND YEAR(b.booking_date) = YEAR(GETDATE()) "
                + "     AND MONTH(b.booking_date) = MONTH(GETDATE())) AS month_revenue, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Booking "
                + "     WHERE booking_date = CAST(GETDATE() AS DATE)) AS today_bookings, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Booking "
                + "     WHERE status = N'pending') AS pending_bookings, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Booking b "
                + "     LEFT JOIN Payment p ON b.booking_id = p.booking_id "
                + "     WHERE b.status IN (N'pending', N'accepted') "
                + "     AND ISNULL(p.payment_status, N'pending') <> N'paid') AS unpaid_bookings, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Booking "
                + "     WHERE status = N'completed' "
                + "     AND YEAR(booking_date) = YEAR(GETDATE()) "
                + "     AND MONTH(booking_date) = MONTH(GETDATE())) AS completed_this_month, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM [User] "
                + "     WHERE role_id = 3 AND is_active = 1) AS active_customers, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Bay "
                + "     WHERE status = N'available') AS available_bays, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Bay "
                + "     WHERE status = N'maintenance') AS maintenance_bays, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Service "
                + "     WHERE is_active = 1) AS active_services, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Promotion "
                + "     WHERE is_active = 1 "
                + "     AND CAST(GETDATE() AS DATE) BETWEEN start_date AND end_date) AS active_promotions, "
                + " "
                + "    (SELECT COUNT(*) "
                + "     FROM Slot "
                + "     WHERE is_active = 1) AS active_slots";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.setTodayRevenue(rs.getLong("today_revenue"));
                stats.setMonthRevenue(rs.getLong("month_revenue"));

                stats.setTodayBookings(rs.getInt("today_bookings"));
                stats.setPendingBookings(rs.getInt("pending_bookings"));
                stats.setUnpaidBookings(rs.getInt("unpaid_bookings"));
                stats.setCompletedThisMonth(rs.getInt("completed_this_month"));

                stats.setActiveCustomers(rs.getInt("active_customers"));
                stats.setAvailableBays(rs.getInt("available_bays"));
                stats.setMaintenanceBays(rs.getInt("maintenance_bays"));

                stats.setActiveServices(rs.getInt("active_services"));
                stats.setActivePromotions(rs.getInt("active_promotions"));
                stats.setActiveSlots(rs.getInt("active_slots"));
            }

        } catch (Exception e) {
            System.out.println("Error at AdminDashboardDAO.getDashboardStats(): " + e.getMessage());
            e.printStackTrace();
        }

        loadBookingStatusCounts(stats);
        loadMonthlyRevenue(stats);
        loadDailyBookings(stats);
        loadServiceRevenue(stats);
        loadTierDistribution(stats);

        return stats;
    }

    private void loadBookingStatusCounts(AdminDashboardStats stats) {
        String sql = "SELECT status, COUNT(*) AS cnt FROM Booking GROUP BY status";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                int cnt = rs.getInt("cnt");
                if ("accepted".equalsIgnoreCase(status)) {
                    stats.setAcceptedBookings(cnt);
                }
                if ("completed".equalsIgnoreCase(status)) {
                    stats.setCompletedBookings(cnt);
                }
                if ("cancelled".equalsIgnoreCase(status)) {
                    stats.setCancelledBookings(cnt);
                }
            }
        } catch (Exception e) {
            System.out.println("Error loadBookingStatusCounts: " + e.getMessage());
        }
    }

    private void loadMonthlyRevenue(AdminDashboardStats stats) {
        String sql = "SELECT MONTH(booking_date) AS m, ISNULL(SUM(total_amount), 0) AS rev "
                + "FROM Booking "
                + "WHERE status = N'completed' AND YEAR(booking_date) = YEAR(GETDATE()) "
                + "GROUP BY MONTH(booking_date) ORDER BY m ASC";

        java.util.Map<Integer, Long> map = new java.util.LinkedHashMap<>();
        for (int i = 1; i <= 12; i++) {
            map.put(i, 0L);
        }

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("m"), rs.getLong("rev"));
            }
        } catch (Exception e) {
            System.out.println("Error loadMonthlyRevenue: " + e.getMessage());
        }

        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Long> values = new java.util.ArrayList<>();
        for (int i = 1; i <= 12; i++) {
            labels.add(months[i - 1]);
            values.add(map.get(i));
        }
        stats.setMonthlyLabels(labels);
        stats.setMonthlyRevenue(values);
    }

    private void loadDailyBookings(AdminDashboardStats stats) {
        String sql = "SELECT CAST(booking_date AS DATE) AS d, COUNT(*) AS cnt "
                + "FROM Booking "
                + "WHERE booking_date >= DATEADD(DAY, -29, CAST(GETDATE() AS DATE)) "
                + "GROUP BY CAST(booking_date AS DATE) ORDER BY d ASC";

        java.util.Map<String, Integer> map = new java.util.LinkedHashMap<>();
        java.time.LocalDate today = java.time.LocalDate.now();
        for (int i = 29; i >= 0; i--) {
            map.put(today.minusDays(i).toString(), 0);
        }

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String d = rs.getDate("d").toString();
                if (map.containsKey(d)) {
                    map.put(d, rs.getInt("cnt"));
                }
            }
        } catch (Exception e) {
            System.out.println("Error loadDailyBookings: " + e.getMessage());
        }

        stats.setDailyLabels(new java.util.ArrayList<>(map.keySet()));
        stats.setDailyBookings(new java.util.ArrayList<>(map.values()));
    }

    private void loadServiceRevenue(AdminDashboardStats stats) {
        String sql = "SELECT TOP 6 s.service_name, ISNULL(SUM(bs.price * bs.quantity), 0) AS rev "
                + "FROM BookingService bs "
                + "JOIN Service s ON bs.service_id = s.service_id "
                + "JOIN Booking b ON bs.booking_id = b.booking_id "
                + "WHERE b.status = N'completed' "
                + "GROUP BY s.service_name ORDER BY rev DESC";

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Long> values = new java.util.ArrayList<>();

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                labels.add(rs.getString("service_name"));
                values.add(rs.getLong("rev"));
            }
        } catch (Exception e) {
            System.out.println("Error loadServiceRevenue: " + e.getMessage());
        }

        stats.setServiceLabels(labels);
        stats.setServiceRevenue(values);
    }

    private void loadTierDistribution(AdminDashboardStats stats) {
        String sql = "SELECT t.tier_name, COUNT(c.customer_id) AS cnt "
                + "FROM Tiers t LEFT JOIN Customer c ON t.tier_id = c.tier_id "
                + "GROUP BY t.tier_id, t.tier_name ORDER BY t.tier_id ASC";

        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Integer> values = new java.util.ArrayList<>();

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                labels.add(rs.getString("tier_name"));
                values.add(rs.getInt("cnt"));
            }
        } catch (Exception e) {
            System.out.println("Error loadTierDistribution: " + e.getMessage());
        }

        stats.setTierLabels(labels);
        stats.setTierCounts(values);
    }

    public List<AdminDashboardBookingView> getTodayBookings() {
        List<AdminDashboardBookingView> list = new ArrayList<>();

        String sql = getBookingListBaseSql()
                + "WHERE b.booking_date = CAST(GETDATE() AS DATE) "
                + "ORDER BY sl.start_time ASC, b.booking_id DESC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapBooking(rs));
            }

        } catch (Exception e) {
            System.out.println("Error at AdminDashboardDAO.getTodayBookings(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public List<AdminDashboardBookingView> getRecentBookings() {
        List<AdminDashboardBookingView> list = new ArrayList<>();

        String sql = "SELECT TOP 8 * FROM ( "
                + getBookingListBaseSqlWithoutOrder()
                + ") x "
                + "ORDER BY x.booking_id DESC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapBooking(rs));
            }

        } catch (Exception e) {
            System.out.println("Error at AdminDashboardDAO.getRecentBookings(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    private String getBookingListBaseSql() {
        return getBookingListBaseSqlWithoutOrder();
    }

    private String getBookingListBaseSqlWithoutOrder() {
        return "SELECT "
                + "b.booking_id, b.booking_date, b.status AS booking_status, b.total_amount, "
                + "u.full_name AS customer_name, u.phone AS customer_phone, "
                + "v.plate_number, "
                + "sl.time_value AS slot_time, "
                + "pay.payment_status, "
                + "svc.service_names "
                + "FROM Booking b "
                + "LEFT JOIN Customer c ON b.customer_id = c.customer_id "
                + "LEFT JOIN [User] u ON c.user_id = u.user_id "
                + "LEFT JOIN Vehicle v ON b.vehicle_id = v.vehicle_id "
                + "LEFT JOIN Slot sl ON b.slot_id = sl.slot_id "
                + "LEFT JOIN Payment pay ON b.booking_id = pay.booking_id "
                + "LEFT JOIN ( "
                + "    SELECT "
                + "        bs.booking_id, "
                + "        STRING_AGG(s.service_name, ', ') AS service_names "
                + "    FROM BookingService bs "
                + "    JOIN Service s ON bs.service_id = s.service_id "
                + "    GROUP BY bs.booking_id "
                + ") svc ON b.booking_id = svc.booking_id ";
    }

    private AdminDashboardBookingView mapBooking(ResultSet rs) throws Exception {
        AdminDashboardBookingView booking = new AdminDashboardBookingView();

        booking.setBookingId(rs.getInt("booking_id"));
        booking.setBookingDate(rs.getDate("booking_date"));
        booking.setBookingStatus(rs.getString("booking_status"));
        booking.setTotalAmount(rs.getLong("total_amount"));

        booking.setCustomerName(rs.getString("customer_name"));
        booking.setCustomerPhone(rs.getString("customer_phone"));

        booking.setPlateNumber(rs.getString("plate_number"));
        booking.setSlotTime(rs.getString("slot_time"));
        booking.setPaymentStatus(rs.getString("payment_status"));
        booking.setServiceNames(rs.getString("service_names"));

        return booking;
    }
}
