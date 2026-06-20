package dao;

import dto.Wallet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;

public class WalletDAO {

    public Wallet getWalletByCustomerId(int customerId) {
        Wallet wallet = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT * FROM Wallet WHERE customer_id = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, customerId);
                rs = st.executeQuery();
                if (rs.next()) {
                    wallet = new Wallet();
                    wallet.setWalletId(rs.getInt("wallet_id"));
                    wallet.setBalance(rs.getLong("balance"));
                    wallet.setCustomerId(rs.getInt("customer_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return wallet;
    }

    public boolean createWalletForCustomer(int customerId) {
        // Giả sử bảng của bạn là Wallet, cột là userId và balance
        String sql = "INSERT INTO Wallet (balance, customer_id) VALUES (0, ?)";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu insert thành công

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
