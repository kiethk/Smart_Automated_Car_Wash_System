package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.CustomerDAO;
import dao.VehicleDAO;
import dto.Customer;
import dto.User;
import dto.Vehicle;

@WebServlet("/addVehicle")
public class AddVehicle extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private VehicleDAO vehicleDAO;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        vehicleDAO = new VehicleDAO();
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        request.getRequestDispatcher("/views/auth/vehicle/AddVehicle.jsp").forward(request, response);
    }

 @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("USER");
        
        // Lấy customer từ userId
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
        if (customer == null) {
            // Sửa đường dẫn báo lỗi quay về form thông qua Servlet điều hướng hành động GET
            response.sendRedirect(request.getContextPath() + "/addVehicle?error=Customer profile not found");
            return;
        }
        
        // Lấy thông tin từ form
        String plateNumber = request.getParameter("plateNumber");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("color");
        String manufactureYearStr = request.getParameter("manufactureYear");
        
        // Validate biển số
        if (plateNumber == null || plateNumber.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/addVehicle?error=Plate number is required");
            return;
        }
        plateNumber = plateNumber.trim().toUpperCase();
        
        // Validate loại xe
        if (vehicleType == null || vehicleType.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/addVehicle?error=Vehicle type is required");
            return;
        }
        
        // Validate năm sản xuất
        int manufactureYear = 0;
        if (manufactureYearStr != null && !manufactureYearStr.trim().isEmpty()) {
            try {
                manufactureYear = Integer.parseInt(manufactureYearStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/addVehicle?error=Invalid manufacture year");
                return;
            }
        }
        
        // 🚨 Kiểm tra trùng biển số (Cần đảm bảo hàm này đã có trong VehicleDAO của bạn)
        // Lưu ý: Đoạn này redirect về "/profile.jsp" vì hệ thống chưa cấu hình "/vehicles" riêng
        if (vehicleDAO.isPlateNumberExists(plateNumber)) {
            session.setAttribute("ERROR", "Plate number already exists");
            response.sendRedirect(request.getContextPath() + "/views/auth/customer/profile.jsp");
            return;
        }

        // Tạo đối tượng Vehicle
        Vehicle vehicle = new Vehicle();
        vehicle.setPlateNumber(plateNumber);
        vehicle.setBrand(brand != null ? brand.trim() : "");
        vehicle.setModel(model != null ? model.trim() : "");
        vehicle.setVehicleType(vehicleType);
        vehicle.setColor(color != null ? color.trim() : "");
        vehicle.setManufactureYear(manufactureYear);
        vehicle.setCustomerId(customer.getCustomerId());

        // Thêm vào database
        boolean isAdded = vehicleDAO.addVehicle(vehicle);

        if (isAdded) {
            session.setAttribute("SUCCESS", "Vehicle added successfully!");
            // Đưa người dùng quay lại trang quản lý Profile để thấy xe mới cập nhật lập tức
            response.sendRedirect(request.getContextPath() + "/views/auth/customer/profile.jsp");
        } else {
            session.setAttribute("ERROR", "Failed to add vehicle");
            response.sendRedirect(request.getContextPath() + "/views/auth/customer/profile.jsp");
        }
    }

}
