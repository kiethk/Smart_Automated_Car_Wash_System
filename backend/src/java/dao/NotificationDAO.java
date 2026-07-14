package dao;

import dto.Notifications;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils; // Sử dụng DBUtils chung của dự án để lấy kết nối cơ sở dữ liệu

public class NotificationDAO {

    // 1. Tạo một thông báo mới cho một người dùng cụ thể
    public boolean createNotification(Notifications noti) {
        String sql = "INSERT INTO Notifications (title, content, type, is_read, reference_id, created_at, user_id) "
                   + "VALUES (?, ?, ?, 0, ?, CURRENT_TIMESTAMP, ?)";
        try (Connection conn = DBUtils.getConnection(); // Lấy kết nối cơ sở dữ liệu
            PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, noti.getTitle());
            ps.setString(2, noti.getContent());
            ps.setString(3, noti.getType());
            
            if (noti.getReferenceId() != null) {
                ps.setInt(4, noti.getReferenceId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            
            ps.setInt(5, noti.getUserId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Hàm hỗ trợ để các module khác gọi nhanh khi cần gửi thông báo
    public boolean createNotification(int userId, String title, String content, String type, Integer referenceId) {
        Notifications noti = new Notifications();
        noti.setUserId(userId);
        noti.setTitle(title);
        noti.setContent(content);
        noti.setType(type);
        noti.setReferenceId(referenceId);
        return createNotification(noti);
    }

    // 3. Tạo thông báo hàng loạt từ Admin cho một nhóm người nhận
    public int createNotifications(String title, String content, String recipientGroup) {
        String userSql = "SELECT user_id FROM [User] WHERE is_active = 1 ";
        String type = "System";

        if ("customers".equals(recipientGroup)) {
            userSql += "AND role_id = 3";
            type = "Customer";
        } else if ("admins".equals(recipientGroup)) {
            userSql += "AND role_id = 1";
            type = "Admin";
        } else if (!"all".equals(recipientGroup)) {
            return 0;
        }

        String insertSql = "INSERT INTO Notifications (title, content, type, is_read, reference_id, created_at, user_id) "
                + "VALUES (?, ?, ?, 0, NULL, CURRENT_TIMESTAMP, ?)";

        try (Connection conn = DBUtils.getConnection()) {

            conn.setAutoCommit(false);
            int createdCount = 0;

            try (PreparedStatement userPs = conn.prepareStatement(userSql);
                 PreparedStatement insertPs = conn.prepareStatement(insertSql);
                ResultSet rs = userPs.executeQuery()) {

                while (rs.next()) {
                    insertPs.setString(1, title);
                    insertPs.setString(2, content);
                    insertPs.setString(3, type);
                    insertPs.setInt(4, rs.getInt("user_id"));
                    insertPs.addBatch();
                    createdCount++;
                }

                if (createdCount > 0) {
                    insertPs.executeBatch();
                }
                conn.commit();
                return createdCount;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Notifications> getNotificationsByUserId(int userId) {
        List<Notifications> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection(); // Lấy kết nối cơ sở dữ liệu
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNotification(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Lấy một số thông báo gần nhất để hiển thị trong dropdown của chuông
    public List<Notifications> getRecentNotificationsByUserId(int userId, int limit) {
        List<Notifications> list = new ArrayList<>();
        int safeLimit = limit > 0 && limit <= 10 ? limit : 5;
        String sql = "SELECT TOP " + safeLimit + " * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNotification(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. Đếm số lượng thông báo chưa đọc của một người dùng
    public int countUnreadNotifications(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBUtils.getConnection(); // Lấy kết nối cơ sở dữ liệu
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
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

    // 6. Đánh dấu một thông báo cụ thể là đã đọc
    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE notification_id = ? AND user_id = ?";
        try (Connection conn = DBUtils.getConnection(); // Lấy kết nối cơ sở dữ liệu
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Đánh dấu tất cả thông báo của một người dùng là đã đọc
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBUtils.getConnection(); // Lấy kết nối cơ sở dữ liệu
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 8. Tìm kiếm và lọc thông báo dành riêng cho trang quản lý của Admin
    public List<Notifications> getNotificationsForAdmin(String searchKeyword, String type, Integer isRead) {
        return getNotificationsForAdmin(searchKeyword, type, isRead, null, null);
    }

    public List<Notifications> getNotificationsForAdmin(String searchKeyword, String type, Integer isRead, Date fromDate, Date toDate) {
        List<Notifications> list = new ArrayList<>();
        
        // Câu SQL nền, các điều kiện lọc sẽ được nối thêm bên dưới
        StringBuilder sql = new StringBuilder("SELECT * FROM Notifications WHERE 1=1 ");
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR content LIKE ?) ");
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND LOWER(type) = LOWER(?) ");
        }
        if (isRead != null) {
            sql.append("AND is_read = ? ");
        }
        if (fromDate != null) {
            sql.append("AND created_at >= ? ");
        }
        if (toDate != null) {
            sql.append("AND created_at < DATEADD(DAY, 1, ?) ");
        }
        
        sql.append("ORDER BY created_at DESC");

        try (Connection conn = DBUtils.getConnection(); // Lấy kết nối cơ sở dữ liệu
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword.trim() + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(paramIndex++, type);
            }
            if (isRead != null) {
                ps.setInt(paramIndex++, isRead);
            }
            if (fromDate != null) {
                ps.setDate(paramIndex++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(paramIndex++, toDate);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNotification(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 9. Xóa một thông báo nếu Admin cần dọn dẹp dữ liệu
    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM Notifications WHERE notification_id = ?";
        try (Connection conn = DBUtils.getConnection(); // Lấy kết nối cơ sở dữ liệu
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm hỗ trợ dùng để map dữ liệu từ ResultSet SQL sang DTO Notifications
    private Notifications mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notifications noti = new Notifications();
        noti.setNotificationId(rs.getInt("notification_id"));
        noti.setTitle(rs.getString("title"));
        noti.setContent(rs.getString("content"));
        noti.setType(rs.getString("type"));
        noti.setIsRead(rs.getInt("is_read"));
        
        // Xử lý trường reference_id có thể bị NULL trong cơ sở dữ liệu
        int refId = rs.getInt("reference_id");
        if (rs.wasNull()) {
            noti.setReferenceId(null);
        } else {
            noti.setReferenceId(refId);
        }
        
        noti.setCreatedAt(rs.getTimestamp("created_at"));
        noti.setUserId(rs.getInt("user_id"));
        return noti;
    }
}
