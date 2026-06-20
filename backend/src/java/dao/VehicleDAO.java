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

    public boolean isPlateNumberExists(String plateNumber) {
        String sql = "SELECT 1 FROM Vehicle WHERE plate_number = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, plateNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    // INSERT đã bao gồm vehicle_image_url, custom_brand_name, custom_model_name
    public boolean addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO Vehicle (plate_number, model_id, vehicle_type, color, manufacture_year, customer_id, is_active, custom_brand_name, custom_model_name, vehicle_image_url) "
                   + "VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicle.getPlateNumber());
            ps.setInt(2, vehicle.getModelId());
            ps.setString(3, vehicle.getVehicleType());
            ps.setString(4, vehicle.getColor());
            ps.setInt(5, vehicle.getManufactureYear());
            ps.setInt(6, vehicle.getCustomerId());
            ps.setString(7, vehicle.getCustomBrandName());
            ps.setString(8, vehicle.getCustomModelName());
            ps.setString(9, vehicle.getVehicleImageUrl());
            return ps.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách xe của khách hàng (sử dụng VIEW VehicleDetail)
    public List<Vehicle> getVehiclesByCustomerId(int customerId) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT vehicle_id, plate_number, model_id, vehicle_type, color, "
                   + "       manufacture_year, customer_id, is_active, vehicle_image_url, "
                   + "       custom_brand_name, custom_model_name, brand_display, model_display "
                   + "FROM VehicleDetail "
                   + "WHERE customer_id = ? AND is_active = 1 "
                   + "ORDER BY vehicle_id DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vehicles.add(mapRow(rs));
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return vehicles;
    }

    public Vehicle getVehicleById(int vehicleId) {
        String sql = "SELECT vehicle_id, plate_number, model_id, vehicle_type, color, "
                   + "       manufacture_year, customer_id, is_active, vehicle_image_url, "
                   + "       custom_brand_name, custom_model_name, brand_display, model_display "
                   + "FROM VehicleDetail "
                   + "WHERE vehicle_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE đã bao gồm vehicle_image_url
    public boolean updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE Vehicle SET plate_number = ?, model_id = ?, vehicle_type = ?, "
                   + "color = ?, manufacture_year = ?, custom_brand_name = ?, custom_model_name = ?, vehicle_image_url = ? "
                   + "WHERE vehicle_id = ? AND customer_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicle.getPlateNumber());
            ps.setInt(2, vehicle.getModelId());
            ps.setString(3, vehicle.getVehicleType());
            ps.setString(4, vehicle.getColor());
            ps.setInt(5, vehicle.getManufactureYear());
            ps.setString(6, vehicle.getCustomBrandName());
            ps.setString(7, vehicle.getCustomModelName());
            ps.setString(8, vehicle.getVehicleImageUrl());
            ps.setInt(9, vehicle.getVehicleId());
            ps.setInt(10, vehicle.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isPlateNumberExistsExcludeSelf(String plateNumber, int excludeVehicleId) {
        String sql = "SELECT 1 FROM Vehicle WHERE plate_number = ? AND vehicle_id != ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, plateNumber);
            ps.setInt(2, excludeVehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    public boolean isVehicleBelongsToCustomer(int vehicleId, int customerId) {
        String sql = "SELECT 1 FROM Vehicle WHERE vehicle_id = ? AND customer_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper map ResultSet -> Vehicle
    private Vehicle mapRow(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setVehicleId(rs.getInt("vehicle_id"));
        v.setPlateNumber(rs.getString("plate_number"));
        v.setModelId(rs.getInt("model_id"));
        v.setVehicleType(rs.getString("vehicle_type"));
        v.setColor(rs.getString("color"));
        v.setManufactureYear(rs.getInt("manufacture_year"));
        v.setCustomerId(rs.getInt("customer_id"));
        v.setIsActive(rs.getInt("is_active"));
        v.setVehicleImageUrl(rs.getString("vehicle_image_url"));
        v.setCustomBrandName(rs.getString("custom_brand_name"));
        v.setCustomModelName(rs.getString("custom_model_name"));
        v.setBrandDisplay(rs.getString("brand_display"));
        v.setModelDisplay(rs.getString("model_display"));
        return v;
    }
}