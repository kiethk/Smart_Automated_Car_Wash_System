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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        // Lấy customer từ userId
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/addVehicle.jsp?error=Customer profile not found");
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
            response.sendRedirect(request.getContextPath() + "/addVehicle.jsp?error=Plate number is required");
            return;
        }
        plateNumber = plateNumber.trim().toUpperCase();
        
        // Validate loại xe
        if (vehicleType == null || vehicleType.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/addVehicle.jsp?error=Vehicle type is required");
            return;
        }
        
        // Validate năm sản xuất
        int manufactureYear = 0;
        if (manufactureYearStr != null && !manufactureYearStr.trim().isEmpty()) {
            try {
                manufactureYear = Integer.parseInt(manufactureYearStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/addVehicle.jsp?error=Invalid manufacture year");
                return;
            }
        }
        
// Kiểm tra trùng biển số
if (vehicleDAO.isPlateNumberExists(plateNumber)) {
    // Sửa: redirect về trang vehicles kèm error message
    session.setAttribute("errorMessage", "Plate number already exists");
    response.sendRedirect(request.getContextPath() + "/vehicles");
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
    session.setAttribute("successMessage", "Vehicle added successfully!");
    response.sendRedirect(request.getContextPath() + "/vehicles");
} else {
    session.setAttribute("errorMessage", "Failed to add vehicle");
    response.sendRedirect(request.getContextPath() + "/vehicles");
}
    }
}