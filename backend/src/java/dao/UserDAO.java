package dao;
import dto.User;
import utils.DBUtils;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    // =========================
    // GET USER BY EMAIL
    // =========================
    public User getUserByEmail(String email) {
        User user = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // ✅ Bọc [User] trong ngoặc vuông
                String sql = "SELECT * FROM [User] WHERE email = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setPassword(rs.getString("password"));
                    user.setIsActive(rs.getInt("is_active"));
                    user.setCreatedAt(rs.getDate("created_at"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setAvatarUrl(rs.getString("avatar_url"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }

    // =========================
    // CREATE NEW USER
    // =========================
    public int createNewUser(User u) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // ✅ Bọc [User] trong ngoặc vuông
                String sql = "INSERT INTO [User] "
                        + "(full_name, email, phone, "
                        + "password, is_active, "
                        + "created_at, role_id, avatar_url) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, u.getFullName());
                st.setString(2, u.getEmail());
                st.setString(3, u.getPhone());
                st.setString(4, u.getPassword());
                st.setInt(5, u.getIsActive());
                st.setDate(6, new Date(u.getCreatedAt().getTime()));
                st.setInt(7, u.getRoleId());
                st.setString(8, u.getAvatarUrl());
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
}