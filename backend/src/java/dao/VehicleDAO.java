package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.Vehicle;
import utils.DBUtils;

public class VehicleDAO {
    
    /**
     * Kiểm tra biển số xe đã tồn tại chưa
     */
    public boolean isPlateNumberExists(String plateNumber) {
        String sql = "SELECT 1 FROM Vehicle WHERE plate_number = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, plateNumber);
            ResultSet rs = ps.executeQuery();
            return rs.next();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return true;
        }
    }
    
    /**
     * Thêm xe mới
     */
    public boolean addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO Vehicle (plate_number, brand, model, vehicle_type, color, manufacture_year, customer_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, vehicle.getPlateNumber());
            ps.setString(2, vehicle.getBrand());
            ps.setString(3, vehicle.getModel());
            ps.setString(4, vehicle.getVehicleType());
            ps.setString(5, vehicle.getColor());
            ps.setInt(6, vehicle.getManufactureYear());
            ps.setInt(7, vehicle.getCustomerId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy danh sách xe theo customerId
     */
    public List<Vehicle> getVehiclesByCustomerId(int customerId) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM Vehicle WHERE customer_id = ? ORDER BY vehicle_id DESC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setVehicleId(rs.getInt("vehicle_id"));
                vehicle.setPlateNumber(rs.getString("plate_number"));
                vehicle.setBrand(rs.getString("brand"));
                vehicle.setModel(rs.getString("model"));
                vehicle.setVehicleType(rs.getString("vehicle_type"));
                vehicle.setColor(rs.getString("color"));
                vehicle.setManufactureYear(rs.getInt("manufacture_year"));
                vehicle.setCustomerId(rs.getInt("customer_id"));
                vehicles.add(vehicle);
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return vehicles;
    }
    
    /**
     * Lấy thông tin xe theo vehicleId
     */
    public Vehicle getVehicleById(int vehicleId) {
        String sql = "SELECT * FROM Vehicle WHERE vehicle_id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, vehicleId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setVehicleId(rs.getInt("vehicle_id"));
                vehicle.setPlateNumber(rs.getString("plate_number"));
                vehicle.setBrand(rs.getString("brand"));
                vehicle.setModel(rs.getString("model"));
                vehicle.setVehicleType(rs.getString("vehicle_type"));
                vehicle.setColor(rs.getString("color"));
                vehicle.setManufactureYear(rs.getInt("manufacture_year"));
                vehicle.setCustomerId(rs.getInt("customer_id"));
                return vehicle;
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Cập nhật thông tin xe
     */
    public boolean updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE Vehicle SET plate_number = ?, brand = ?, model = ?, "
                   + "vehicle_type = ?, color = ?, manufacture_year = ? "
                   + "WHERE vehicle_id = ? AND customer_id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, vehicle.getPlateNumber());
            ps.setString(2, vehicle.getBrand());
            ps.setString(3, vehicle.getModel());
            ps.setString(4, vehicle.getVehicleType());
            ps.setString(5, vehicle.getColor());
            ps.setInt(6, vehicle.getManufactureYear());
            ps.setInt(7, vehicle.getVehicleId());
            ps.setInt(8, vehicle.getCustomerId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra trùng biển số khi update (loại trừ xe hiện tại)
     */
    public boolean isPlateNumberExistsExcludeSelf(String plateNumber, int excludeVehicleId) {
        String sql = "SELECT 1 FROM Vehicle WHERE plate_number = ? AND vehicle_id != ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, plateNumber);
            ps.setInt(2, excludeVehicleId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return true;
        }
    }
    
    /**
     * Kiểm tra xe có thuộc về khách hàng không
     */
    public boolean isVehicleBelongsToCustomer(int vehicleId, int customerId) {
        String sql = "SELECT 1 FROM Vehicle WHERE vehicle_id = ? AND customer_id = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, vehicleId);
            ps.setInt(2, customerId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}