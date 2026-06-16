package dao;

import dto.Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Thêm model mới cho brand có sẵn
    public int addModel(String modelName, int brandId) {
        String sql = "INSERT INTO Model (model_name, brand_id) VALUES (?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, modelName);
            ps.setInt(2, brandId);
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                System.out.println("addModel: No rows affected");
                return -1;
            }
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int modelId = rs.getInt(1);
                    System.out.println("addModel: Created model ID = " + modelId);
                    return modelId;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    // Thêm cả brand mới và model mới (trả về model_id)
    public int addBrandAndModel(String brandName, String modelName) {
        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psBrand = null;
        PreparedStatement psModel = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);
            System.out.println("addBrandAndModel: Starting with brand=" + brandName + ", model=" + modelName);
            
            // 1. Kiểm tra brand đã tồn tại chưa
            String checkSql = "SELECT brand_id FROM Brand WHERE brand_name = ?";
            psCheck = conn.prepareStatement(checkSql);
            psCheck.setString(1, brandName);
            rs = psCheck.executeQuery();
            
            int brandId;
            if (rs.next()) {
                brandId = rs.getInt("brand_id");
                System.out.println("addBrandAndModel: Found existing brand ID = " + brandId);
            } else {
                // 2. Tạo brand mới
                rs.close();
                psCheck.close();
                
                String brandSql = "INSERT INTO Brand (brand_name) VALUES (?)";
                psBrand = conn.prepareStatement(brandSql, Statement.RETURN_GENERATED_KEYS);
                psBrand.setString(1, brandName);
                int affectedRows = psBrand.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Creating brand failed, no rows affected.");
                }
                
                rs = psBrand.getGeneratedKeys();
                if (rs.next()) {
                    brandId = rs.getInt(1);
                    System.out.println("addBrandAndModel: Created new brand ID = " + brandId);
                } else {
                    throw new SQLException("Creating brand failed, no ID obtained.");
                }
            }
            
            // Đóng ResultSet cũ
            if (rs != null) {
                rs.close();
            }
            
            // 3. Tạo model mới
            String modelSql = "INSERT INTO Model (model_name, brand_id) VALUES (?, ?)";
            psModel = conn.prepareStatement(modelSql, Statement.RETURN_GENERATED_KEYS);
            psModel.setString(1, modelName);
            psModel.setInt(2, brandId);
            int affectedRows = psModel.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating model failed, no rows affected.");
            }
            
            rs = psModel.getGeneratedKeys();
            int modelId = -1;
            if (rs.next()) {
                modelId = rs.getInt(1);
                System.out.println("addBrandAndModel: Created model ID = " + modelId);
            } else {
                throw new SQLException("Creating model failed, no ID obtained.");
            }
            
            conn.commit();
            System.out.println("addBrandAndModel: Success! Returning modelId=" + modelId);
            return modelId;
            
        } catch (Exception e) {
            System.out.println("addBrandAndModel: Error - " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                    System.out.println("addBrandAndModel: Transaction rolled back");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return -1;
        } finally {
            try {
                if (rs != null) rs.close();
                if (psCheck != null) psCheck.close();
                if (psBrand != null) psBrand.close();
                if (psModel != null) psModel.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}