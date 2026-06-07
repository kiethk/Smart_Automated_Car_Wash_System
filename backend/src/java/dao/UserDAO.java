package dao;

import dto.User;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;

public class UserDAO {

    public User getUserByEmail(String email) {
        String sql = "SELECT user_id, full_name, email, phone, password, is_active, created_at, role_id, avatar_url "
                + "FROM [User] WHERE email = ? AND is_active = 1";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("password"),
                            rs.getInt("is_active"),
                            rs.getDate("created_at"),
                            rs.getInt("role_id"),
                            rs.getString("avatar_url")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===================================================
    // GET USER BY EMAIL AND PASSWORD (PASSWORD ĐÃ BĂM SẴN)
    // ===================================================
    public User getUserByEmailAndPassword(String email, String hashedPassword) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Câu lệnh SQL giữ nguyên để check cả email, password và trạng thái active
        String query = "SELECT user_id, full_name, email, phone, password, is_active, created_at, role_id, avatar_url "
                + "FROM [User] "
                + "WHERE email = ? AND password = ? AND is_active = 1";

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(query);
                ps.setString(1, email);

                // 🔑 VÌ LOGIN.JAVA ĐÃ BĂM MẬT KHẨU RỒI, NÊN Ở ĐÂY CHỈ CẦN TRUYỀN THẲNG VÀO SQL
                ps.setString(2, hashedPassword);

                rs = ps.executeQuery();

                if (rs.next()) {
                    User u = new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("password"),
                            rs.getInt("is_active"),
                            rs.getDate("created_at"),
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

    // ===================================================
    // CÁC HÀM KHÁC (CREATE, UPDATE...) GIỮ NGUYÊN KHÔNG ĐỔI
    // ===================================================
    public int createNewUser(User u) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO [User] (full_name, email, phone, password, is_active, created_at, role_id, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
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
            return ps.executeUpdate() > 0;
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
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
