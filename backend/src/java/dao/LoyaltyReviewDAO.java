package dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import utils.DBUtils;

public class LoyaltyReviewDAO {

    public boolean runMonthlyTierDowngrade() {
        return runMonthlyTierDowngrade(null, null);
    }

    public boolean runMonthlyTierDowngrade(Integer reviewYear, Integer reviewMonth) {
        String sql = "{call dbo.sp_ReviewMonthlyTierDowngrade(?, ?)}";

        try (Connection conn = DBUtils.getConnection(); CallableStatement cs = conn.prepareCall(sql)) {
            if (reviewYear == null) {
                cs.setNull(1, java.sql.Types.INTEGER);
            } else {
                cs.setInt(1, reviewYear);
            }

            if (reviewMonth == null) {
                cs.setNull(2, java.sql.Types.INTEGER);
            } else {
                cs.setInt(2, reviewMonth);
            }

            cs.execute();
            return true;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return false;
    }
}
