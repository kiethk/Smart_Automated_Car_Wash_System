package dao;

import dto.Notifications;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils; // Sử dụng đúng DBUtils theo dự án của bạn

public class NotificationDAO {

    // 1. Hàm tạo thông báo mới (Để các module khác gọi khi có sự kiện)
    public boolean createNotification(Notifications noti) {
        String sql = "INSERT INTO Notifications (title, content, type, is_read, reference_id, created_at, user_id) "
                   + "VALUES (?, ?, ?, 0, ?, CURRENT_TIMESTAMP, ?)";
        try (Connection conn = DBUtils.getConnection(); // Sửa thành DBUtils
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

    // 2. Lấy danh sách thông báo của một User cụ thể (Hiển thị ở icon chuông)
    // Helper cho cac module khac goi nhanh khi can gui thong bao.
    public boolean createNotification(int userId, String title, String content, String type, Integer referenceId) {
        Notifications noti = new Notifications();
        noti.setUserId(userId);
        noti.setTitle(title);
        noti.setContent(content);
        noti.setType(type);
        noti.setReferenceId(referenceId);
        return createNotification(noti);
    }

    public List<Notifications> getNotificationsByUserId(int userId) {
        List<Notifications> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection(); // Sửa thành DBUtils
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

    // 3. Đếm số lượng thông báo CHƯA ĐỌC của User (Phục vụ logic hiển thị CHẤM ĐỎ)
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

    public int countUnreadNotifications(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBUtils.getConnection(); // Sửa thành DBUtils
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

    // 4. Đánh dấu một thông báo cụ thể là ĐÃ ĐỌC (Khi click vào thông báo để mất chấm đỏ)
    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE notification_id = ? AND user_id = ?";
        try (Connection conn = DBUtils.getConnection(); // Sửa thành DBUtils
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Đánh dấu ĐÃ ĐỌC TẤT CẢ thông báo của một User
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBUtils.getConnection(); // Sửa thành DBUtils
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Hàm tìm kiếm, lọc và phân trang thông báo (Dành riêng cho trang quản lý của Admin)
    public List<Notifications> getNotificationsForAdmin(String searchKeyword, String type, Integer isRead) {
        List<Notifications> list = new ArrayList<>();
        
        // Base SQL query
        StringBuilder sql = new StringBuilder("SELECT * FROM Notifications WHERE 1=1 ");
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR content LIKE ?) ");
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND type = ? ");
        }
        if (isRead != null) {
            sql.append("AND is_read = ? ");
        }
        
        sql.append("ORDER BY created_at DESC");

        try (Connection conn = DBUtils.getConnection(); // Đã chuẩn DBUtils
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

    // 7. Xóa thông báo (Nếu Admin cần tính năng dọn dẹp hệ thống)
    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM Notifications WHERE notification_id = ?";
        try (Connection conn = DBUtils.getConnection(); // Sửa thành DBUtils
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm Helper dùng để map dữ liệu từ ResultSet SQL sang Object Java DTO nhằm tránh lặp code
    private Notifications mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notifications noti = new Notifications();
        noti.setNotificationId(rs.getInt("notification_id"));
        noti.setTitle(rs.getString("title"));
        noti.setContent(rs.getString("content"));
        noti.setType(rs.getString("type"));
        noti.setIsRead(rs.getInt("is_read"));
        
        // Xử lý trường reference_id có thể bị NULL trong database
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
