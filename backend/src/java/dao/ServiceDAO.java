
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
        String sql = "SELECT service_id, service_name, description, price, duration_minutes, is_active " +
                     "FROM Service " +
                     "WHERE is_active = 1 " +
                     "ORDER BY price ASC";

        // Sử dụng Try-with-resources để tự động đóng kết nối (Connection, PreparedStatement, ResultSet)
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
}
