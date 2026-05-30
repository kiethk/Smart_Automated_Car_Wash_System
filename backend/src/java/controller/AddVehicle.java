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

@WebServlet(name = "AddVehicle", urlPatterns = {"/addVehicle"})
public class AddVehicle extends HttpServlet {

    private VehicleDAO vehicleDAO;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        vehicleDAO = new VehicleDAO();
        customerDAO = new CustomerDAO();
    }

    // ===== HANDLE GET: show add vehicle page =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.getRequestDispatcher("/views/auth/vehicle/AddVehicle.jsp")
                .forward(request, response);
    }

    // ===== HANDLE POST: process add vehicle =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");   //doi login
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
        if (customer == null) {
            forwardWithError(request, response, "Customer profile not found");
            return;
        }

        String plateNumber = request.getParameter("plateNumber");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("color");
        String manufactureYearStr = request.getParameter("manufactureYear");

        if (isNullOrBlank(plateNumber)) {
            forwardWithError(request, response, "Plate number is required");
            return;
        }
        plateNumber = plateNumber.trim().toUpperCase();

        if (isNullOrBlank(vehicleType)) {
            forwardWithError(request, response, "Vehicle type is required");
            return;
        }

        int manufactureYear = 0;
        if (!isNullOrBlank(manufactureYearStr)) {
            try {
                manufactureYear = Integer.parseInt(manufactureYearStr);
            } catch (NumberFormatException e) {
                forwardWithError(request, response, "Invalid manufacture year");
                return;
            }
        }

        if (vehicleDAO.isPlateNumberExists(plateNumber)) {
            session.setAttribute("errorMessage", "Plate number already exists");
            response.sendRedirect(request.getContextPath() + "/vehicles");
            return;
        }

        Vehicle vehicle = new Vehicle();
        vehicle.setPlateNumber(plateNumber);
        vehicle.setBrand(brand != null ? brand.trim() : "");
        vehicle.setModel(model != null ? model.trim() : "");
        vehicle.setVehicleType(vehicleType);
        vehicle.setColor(color != null ? color.trim() : "");
        vehicle.setManufactureYear(manufactureYear);
        vehicle.setCustomerId(customer.getCustomerId());

        boolean isAdded = vehicleDAO.addVehicle(vehicle);

        if (isAdded) {
            session.setAttribute("successMessage", "Vehicle added successfully!");
            response.sendRedirect(request.getContextPath() + "/vehicles");
        } else {
            session.setAttribute("errorMessage", "Failed to add vehicle");
            response.sendRedirect(request.getContextPath() + "/vehicles");
        }
    }

    private void forwardWithError(HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/auth/vehicle/AddVehicle.jsp")
                .forward(request, response);
    }

    private boolean isNullOrBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}