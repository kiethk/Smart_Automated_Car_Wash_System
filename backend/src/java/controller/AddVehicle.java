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
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }
        request.getRequestDispatcher("views/auth/vehicle/AddVehicle.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        // 1. Thu thập dữ liệu vào một đối tượng "tạm"
        Vehicle vehicle = new Vehicle();
        vehicle.setPlateNumber(request.getParameter("plateNumber"));
        vehicle.setBrand(request.getParameter("brand"));
        vehicle.setModel(request.getParameter("model"));
        vehicle.setVehicleType(request.getParameter("vehicleType"));
        vehicle.setColor(request.getParameter("color"));

        String manufactureYearStr = request.getParameter("manufactureYear");
        int manufactureYear = 0;

        // 2. Validate dữ liệu
        String errorMsg = null;
        try {
            if (vehicle.getPlateNumber() == null || vehicle.getPlateNumber().trim().isEmpty()) {
                errorMsg = "Plate number is required";
            } else if (vehicle.getVehicleType() == null || vehicle.getVehicleType().trim().isEmpty()) {
                errorMsg = "Vehicle type is required";
            } else if (manufactureYearStr != null && !manufactureYearStr.trim().isEmpty()) {
                manufactureYear = Integer.parseInt(manufactureYearStr);
            }

            if (errorMsg == null && vehicleDAO.isPlateNumberExists(vehicle.getPlateNumber().trim().toUpperCase())) {
                errorMsg = "Plate number already exists";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Invalid manufacture year";
        }

        // 3. Nếu có lỗi: Đẩy đối tượng vehicle cũ và thông báo lỗi về JSP
        if (errorMsg != null) {
            request.setAttribute("ERROR", errorMsg);
            request.setAttribute("vehicle", vehicle); // Gửi đối tượng vehicle để điền lại form
            request.setAttribute("manufactureYear", manufactureYearStr);
            request.getRequestDispatcher("views/auth/vehicle/AddVehicle.jsp").forward(request, response);
            return;
        }

        // 4. Xử lý logic nghiệp vụ khi không có lỗi
        User currentUser = (User) session.getAttribute("USER");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

        vehicle.setPlateNumber(vehicle.getPlateNumber().trim().toUpperCase());
        vehicle.setManufactureYear(manufactureYear);
        vehicle.setCustomerId(customer.getCustomerId());

        if (vehicleDAO.addVehicle(vehicle)) {
            session.setAttribute("SUCCESS", "Vehicle added successfully!");
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
        } else {
            request.setAttribute("ERROR", "System error: Could not add vehicle.");
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("views/auth/vehicle/AddVehicle.jsp").forward(request, response);
        }
    }

}
