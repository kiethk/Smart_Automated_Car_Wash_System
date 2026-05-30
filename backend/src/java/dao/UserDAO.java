package dao;

import dto.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;

public class UserDAO {

    public User getUser(String email, String password) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Bỏ hoàn toàn bảng Customer, chỉ SELECT từ bảng [User]
        String query = "SELECT user_id, full_name, email, phone, password, is_active, created_at, role_id, avatar_url "
                     + "FROM [User] "
                     + "WHERE email = ? AND password = ? AND is_active = 1";

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(query);
                ps.setString(1, email);
                ps.setString(2, password);

                rs = ps.executeQuery();

                if (rs.next()) {
                    // Khởi tạo và trả về đối tượng User bằng Constructor có tham số
                    User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getInt("is_active"),
                        rs.getDate("created_at"), // Sẽ trả về java.sql.Date khớp với Constructor
                        rs.getInt("role_id"),
                        rs.getString("avatar_url")
                    );
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return null;
    }
}