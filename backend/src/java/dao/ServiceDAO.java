
package dao;

import dto.Service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class ServiceDAO {

    public List<Service> getActiveServices() {
        List<Service> list = new ArrayList<>();
        // Câu lệnh SQL lấy các dịch vụ đang hoạt động, sắp xếp theo giá tăng dần
        String sql = "SELECT service_id, service_name, description, price, duration_minutes, is_active "
                + "FROM Service "
                + "WHERE is_active = 1 "
                + "ORDER BY price ASC";

        // Sử dụng Try-with-resources để tự động đóng kết nối (Connection, PreparedStatement, ResultSet)
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();

                // Ánh xạ dữ liệu từ ResultSet vào đối tượng DTO Service
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setDescription(rs.getString("description"));
                service.setPrice(rs.getLong("price"));
                service.setDurationMinutes(rs.getInt("duration_minutes"));
                service.setIsActive(rs.getInt("is_active"));

                // Thêm dịch vụ vào danh sách trả về
                list.add(service);
            }

        } catch (Exception e) {
            // Log lỗi hệ thống ra console để dễ dàng debug trong quá trình làm đồ án
            System.out.println("Error at ServiceDAO.getActiveServices(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public List<Service> getAllServicesForAdmin() {
        List<Service> list = new ArrayList<>();

        String sql = "SELECT service_id, service_name, description, price, duration_minutes, is_active "
                + "FROM Service "
                + "ORDER BY service_id DESC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setDescription(rs.getString("description"));
                service.setPrice(rs.getLong("price"));
                service.setDurationMinutes(rs.getInt("duration_minutes"));
                service.setIsActive(rs.getInt("is_active"));

                list.add(service);
            }

        } catch (Exception e) {
            System.out.println("Error at ServiceDAO.getAllServicesForAdmin(): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public Service getServiceById(int serviceId) {
        String sql = "SELECT service_id, service_name, description, price, duration_minutes, is_active "
                + "FROM Service "
                + "WHERE service_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setDescription(rs.getString("description"));
                    service.setPrice(rs.getLong("price"));
                    service.setDurationMinutes(rs.getInt("duration_minutes"));
                    service.setIsActive(rs.getInt("is_active"));

                    return service;
                }
            }

        } catch (Exception e) {
            System.out.println("Error at ServiceDAO.getServiceById(): " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean createService(Service service) {
        String sql = "INSERT INTO Service (service_name, description, price, duration_minutes, is_active) "
                + "VALUES (?, ?, ?, ?, ?)";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setLong(3, service.getPrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setInt(5, service.getIsActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at ServiceDAO.createService(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateService(Service service) {
        String sql = "UPDATE Service "
                + "SET service_name = ?, description = ?, price = ?, duration_minutes = ?, is_active = ? "
                + "WHERE service_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setLong(3, service.getPrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setInt(5, service.getIsActive());
            ps.setInt(6, service.getServiceId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at ServiceDAO.updateService(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean toggleServiceStatus(int serviceId, int isActive) {
        String sql = "UPDATE Service SET is_active = ? WHERE service_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, isActive);
            ps.setInt(2, serviceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error at ServiceDAO.toggleServiceStatus(): " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}

