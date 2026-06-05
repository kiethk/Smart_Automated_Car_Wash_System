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

@WebServlet(name = "UpdateVehicle", urlPatterns = {"/updateVehicle"})
public class UpdateVehicle extends HttpServlet {

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

        User currentUser = (User) session.getAttribute("USER");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

        String vehicleIdStr = request.getParameter("id");
        if (isNullOrBlank(vehicleIdStr)) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
            return;
        }

        try {
            int vehicleId = Integer.parseInt(vehicleIdStr);
            if (customer == null || !vehicleDAO.isVehicleBelongsToCustomer(vehicleId, customer.getCustomerId())) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
                return;
            }

            Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);
            request.setAttribute("vehicle", vehicle);

            request.getRequestDispatcher("views/auth/vehicle/UpdateVehicle.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
        }
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

        User currentUser = (User) session.getAttribute("USER");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

        // Lấy thông tin từ form
        String vehicleIdStr = request.getParameter("vehicleId");
        int vehicleId = Integer.parseInt(vehicleIdStr);

        // Tạo object tạm để hứng dữ liệu nếu có lỗi (UX)
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(vehicleId);
        vehicle.setPlateNumber(request.getParameter("plateNumber"));
        vehicle.setBrand(request.getParameter("brand"));
        vehicle.setModel(request.getParameter("model"));
        vehicle.setVehicleType(request.getParameter("vehicleType"));
        vehicle.setColor(request.getParameter("color"));

        String manufactureYearStr = request.getParameter("manufactureYear");
        int manufactureYear = 0;

        // Validation
        if (isNullOrBlank(vehicle.getPlateNumber())) {
            forwardWithError(request, response, vehicle, "Plate number is required");
            return;
        }

        if (vehicleDAO.isPlateNumberExistsExcludeSelf(vehicle.getPlateNumber().trim().toUpperCase(), vehicleId)) {
            forwardWithError(request, response, vehicle, "Plate number already exists");
            return;
        }

        try {
            if (!isNullOrBlank(manufactureYearStr)) {
                manufactureYear = Integer.parseInt(manufactureYearStr);
            }
        } catch (NumberFormatException e) {
            forwardWithError(request, response, vehicle, "Invalid year format");
            return;
        }

        // Cập nhật thông tin
        vehicle.setManufactureYear(manufactureYear);
        vehicle.setCustomerId(customer.getCustomerId());

        if (vehicleDAO.updateVehicle(vehicle)) {
            session.setAttribute("SUCCESS", "Vehicle updated successfully!");
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
        } else {
            forwardWithError(request, response, vehicle, "Database error, please try again");
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, Vehicle vehicle, String message)
            throws ServletException, IOException {
        request.setAttribute("ERROR", message);
        request.setAttribute("vehicle", vehicle); // Giữ lại thông tin người dùng vừa nhập
        request.getRequestDispatcher("/views/auth/vehicle/UpdateVehicle.jsp").forward(request, response);
    }

    private boolean isNullOrBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
