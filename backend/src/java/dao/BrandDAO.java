package dao;

import dto.Brand;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class BrandDAO {

    public List<Brand> getAllBrands() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT brand_id, brand_name FROM Brand WHERE brand_name != N'Other' ORDER BY brand_name ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Brand brand = new Brand();
                brand.setBrandId(rs.getInt("brand_id"));
                brand.setBrandName(rs.getString("brand_name"));
                list.add(brand);
                System.out.println("=== BrandDAO: loaded brand = " + brand.getBrandName());
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("=== BrandDAO ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("=== BrandDAO: total brands = " + list.size());
        return list;
    }
    
    public Brand getBrandByName(String brandName) {
        String sql = "SELECT brand_id, brand_name FROM Brand WHERE brand_name = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, brandName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Brand brand = new Brand();
                    brand.setBrandId(rs.getInt("brand_id"));
                    brand.setBrandName(rs.getString("brand_name"));
                    return brand;
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("=== BrandDAO.getBrandByName ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}