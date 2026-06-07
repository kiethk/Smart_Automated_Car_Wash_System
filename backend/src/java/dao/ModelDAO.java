package dao;

import dto.Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class ModelDAO {

    public List<Model> getModelsByBrandId(int brandId) {
        List<Model> list = new ArrayList<>();
        String sql = "SELECT model_id, model_name, brand_id FROM Model WHERE brand_id = ? ORDER BY model_name ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, brandId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Model model = new Model();
                    model.setModelId(rs.getInt("model_id"));
                    model.setModelName(rs.getString("model_name"));
                    model.setBrandId(rs.getInt("brand_id"));
                    list.add(model);
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}