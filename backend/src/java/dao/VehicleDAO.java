package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dto.Vehicle;
import utils.DBUtils;

public class VehicleDAO {

    public boolean isPlateNumberExists(String plateNumber) {
        String sql = "SELECT 1 FROM Vehicle WHERE plate_number = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, plateNumber);
            rs = ps.executeQuery();
            return rs.next();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO Vehicle (plate_number, model_id, vehicle_type, color, " +
                     "manufacture_year, customer_id, is_active, custom_brand_name, " +
                     "custom_model_name, vehicle_image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
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
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Vehicle> getVehiclesByCustomerId(int customerId) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT vehicle_id, plate_number, model_id, vehicle_type, color, " +
                     "manufacture_year, customer_id, is_active, vehicle_image_url, " +
                     "custom_brand_name, custom_model_name, brand_display, model_display " +
                     "FROM VehicleDetail " +
                     "WHERE customer_id = ? AND is_active = 1 " +
                     "ORDER BY vehicle_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            while (rs.next()) {
                vehicles.add(mapRow(rs));
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return vehicles;
    }

    public Vehicle getVehicleById(int vehicleId) {
        String sql = "SELECT vehicle_id, plate_number, model_id, vehicle_type, color, " +
                     "manufacture_year, customer_id, is_active, vehicle_image_url, " +
                     "custom_brand_name, custom_model_name, brand_display, model_display " +
                     "FROM VehicleDetail " +
                     "WHERE vehicle_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, vehicleId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public boolean updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE Vehicle SET plate_number = ?, model_id = ?, vehicle_type = ?, " +
                     "color = ?, manufacture_year = ?, custom_brand_name = ?, " +
                     "custom_model_name = ?, vehicle_image_url = ? " +
                     "WHERE vehicle_id = ? AND customer_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
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
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean isPlateNumberExistsExcludeSelf(String plateNumber, int excludeVehicleId) {
        String sql = "SELECT 1 FROM Vehicle WHERE plate_number = ? AND vehicle_id != ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, plateNumber);
            ps.setInt(2, excludeVehicleId);
            rs = ps.executeQuery();
            return rs.next();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean isVehicleBelongsToCustomer(int vehicleId, int customerId) {
        String sql = "SELECT 1 FROM Vehicle WHERE vehicle_id = ? AND customer_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, vehicleId);
            ps.setInt(2, customerId);
            rs = ps.executeQuery();
            return rs.next();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean softDeleteVehicle(int vehicleId) {
        String sql = "UPDATE Vehicle SET is_active = 0 WHERE vehicle_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, vehicleId);
            return ps.executeUpdate() > 0;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean restoreVehicle(int vehicleId) {
        String sql = "UPDATE Vehicle SET is_active = 1 WHERE vehicle_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, vehicleId);
            return ps.executeUpdate() > 0;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // ===================== PHẦN THÊM MỚI CHO VEHICLE ADMIN =====================

    /**
     * 3️⃣ Improve Vehicle Admin Module - Vehicle list
     * Lấy tất cả xe với thông tin chi tiết
     */
    public List<Vehicle> getAllVehiclesWithDetails() {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT vehicle_id, plate_number, model_id, vehicle_type, color, " +
                     "manufacture_year, customer_id, is_active, vehicle_image_url, " +
                     "custom_brand_name, custom_model_name, brand_display, model_display " +
                     "FROM VehicleDetail " +
                     "ORDER BY vehicle_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                vehicles.add(mapRow(rs));
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return vehicles;
    }

    /**
     * 3️⃣ Improve Vehicle Admin Module - Search/filter vehicle
     * Tìm kiếm xe theo keyword
     */
    public List<Vehicle> searchVehicles(String keyword) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT v.vehicle_id, v.plate_number, v.model_id, v.vehicle_type, v.color, " +
                     "v.manufacture_year, v.customer_id, v.is_active, v.vehicle_image_url, " +
                     "v.custom_brand_name, v.custom_model_name, vd.brand_display, vd.model_display " +
                     "FROM Vehicle v " +
                     "JOIN VehicleDetail vd ON v.vehicle_id = vd.vehicle_id " +
                     "WHERE v.plate_number LIKE ? " +
                     "OR vd.brand_display LIKE ? " +
                     "OR vd.model_display LIKE ? " +
                     "OR v.vehicle_type LIKE ? " +
                     "OR v.color LIKE ? " +
                     "ORDER BY v.vehicle_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);

            rs = ps.executeQuery();

            while (rs.next()) {
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
                vehicles.add(v);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return vehicles;
    }

    /**
     * 3️⃣ Improve Vehicle Admin Module - Filter by type
     * Lọc xe theo loại
     */
    public List<Vehicle> filterVehiclesByType(String type) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT vehicle_id, plate_number, model_id, vehicle_type, color, " +
                     "manufacture_year, customer_id, is_active, vehicle_image_url, " +
                     "custom_brand_name, custom_model_name, brand_display, model_display " +
                     "FROM VehicleDetail " +
                     "WHERE vehicle_type = ? " +
                     "ORDER BY vehicle_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, type);
            rs = ps.executeQuery();

            while (rs.next()) {
                vehicles.add(mapRow(rs));
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return vehicles;
    }

    /**
     * 3️⃣ Improve Vehicle Admin Module - Filter by status
     * Lọc xe theo trạng thái
     */
    public List<Vehicle> filterVehiclesByStatus(int status) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT vehicle_id, plate_number, model_id, vehicle_type, color, " +
                     "manufacture_year, customer_id, is_active, vehicle_image_url, " +
                     "custom_brand_name, custom_model_name, brand_display, model_display " +
                     "FROM VehicleDetail " +
                     "WHERE is_active = ? " +
                     "ORDER BY vehicle_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
            rs = ps.executeQuery();

            while (rs.next()) {
                vehicles.add(mapRow(rs));
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return vehicles;
    }

    /**
     * 3️⃣ Improve Vehicle Admin Module - Statistics
     * Lấy thống kê xe
     */
    public VehicleStatistics getVehicleStatistics() {
        VehicleStatistics stats = new VehicleStatistics();
        String sql = "SELECT " +
                     "COUNT(*) as total_vehicles, " +
                     "SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_vehicles, " +
                     "SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) as inactive_vehicles, " +
                     "COUNT(DISTINCT customer_id) as customers_with_vehicles, " +
                     "COUNT(DISTINCT model_id) as total_models " +
                     "FROM Vehicle";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                stats.setTotalVehicles(rs.getInt("total_vehicles"));
                stats.setActiveVehicles(rs.getInt("active_vehicles"));
                stats.setInactiveVehicles(rs.getInt("inactive_vehicles"));
                stats.setCustomersWithVehicles(rs.getInt("customers_with_vehicles"));
                stats.setTotalModels(rs.getInt("total_models"));
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Lấy phân bố theo loại xe
        String typeSql = "SELECT vehicle_type, COUNT(*) as count " +
                         "FROM Vehicle " +
                         "WHERE vehicle_type IS NOT NULL " +
                         "GROUP BY vehicle_type " +
                         "ORDER BY count DESC";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(typeSql);
            rs = ps.executeQuery();

            while (rs.next()) {
                stats.getTypeDistribution().put(
                    rs.getString("vehicle_type"),
                    rs.getInt("count")
                );
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return stats;
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

    // Inner class cho thống kê
    public static class VehicleStatistics {
        private int totalVehicles;
        private int activeVehicles;
        private int inactiveVehicles;
        private int customersWithVehicles;
        private int totalModels;
        private Map<String, Integer> typeDistribution = new HashMap<>();

        public int getTotalVehicles() { return totalVehicles; }
        public void setTotalVehicles(int totalVehicles) { this.totalVehicles = totalVehicles; }
        public int getActiveVehicles() { return activeVehicles; }
        public void setActiveVehicles(int activeVehicles) { this.activeVehicles = activeVehicles; }
        public int getInactiveVehicles() { return inactiveVehicles; }
        public void setInactiveVehicles(int inactiveVehicles) { this.inactiveVehicles = inactiveVehicles; }
        public int getCustomersWithVehicles() { return customersWithVehicles; }
        public void setCustomersWithVehicles(int customersWithVehicles) { this.customersWithVehicles = customersWithVehicles; }
        public int getTotalModels() { return totalModels; }
        public void setTotalModels(int totalModels) { this.totalModels = totalModels; }
        public Map<String, Integer> getTypeDistribution() { return typeDistribution; }
        public void setTypeDistribution(Map<String, Integer> typeDistribution) { this.typeDistribution = typeDistribution; }
    }
}