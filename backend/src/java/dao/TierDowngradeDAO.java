// Thêm vào AdminCustomerDAO hoặc tạo file TierDowngradeDAO.java
package dao;

import java.sql.Connection;
import java.sql.CallableStatement;
import utils.DBUtils;

public class TierDowngradeDAO {

    // Gọi procedure với tháng/năm cụ thể (dùng cho button thủ công)
    public boolean runMonthlyDowngrade(int year, int month) {
        String sql = "{CALL dbo.sp_ReviewMonthlyTierDowngrade(?, ?)}";
        try (Connection conn = DBUtils.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, year);
            cs.setInt(2, month);
            cs.execute();
            return true;
        } catch (Exception e) {
            System.out.println("Error at TierDowngradeDAO.runMonthlyDowngrade(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Gọi procedure không tham số — tự động lấy tháng trước
    public boolean runMonthlyDowngradeAuto() {
        String sql = "{CALL dbo.sp_ReviewMonthlyTierDowngrade}";
        try (Connection conn = DBUtils.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.execute();
            return true;
        } catch (Exception e) {
            System.out.println("Error at TierDowngradeDAO.runMonthlyDowngradeAuto(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}