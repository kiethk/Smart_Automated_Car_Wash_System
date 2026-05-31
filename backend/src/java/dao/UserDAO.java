package dao;

import dto.User;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;

public class UserDAO {

    public User getUserByEmailAndPassword(String email, String password) {
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
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return null;
    }

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
                if (cn != null) {
                    cn.close();
                }
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
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public boolean updatePhoneById(int userId, String phone) {
        String sql = "UPDATE [User] SET phone = ? WHERE user_id = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvatarById(int userId, String avatarUrl) {
        String sql = "UPDATE [User] SET avatar_url = ? WHERE user_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
