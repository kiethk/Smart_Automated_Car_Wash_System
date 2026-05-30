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

    // ===== HANDLE GET: show update vehicle page =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp"); // doi login
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Customer not found");
            return;
        }

        String vehicleIdStr = request.getParameter("id");
        if (isNullOrBlank(vehicleIdStr)) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Vehicle ID required");
            return;
        }

        int vehicleId;
        try {
            vehicleId = Integer.parseInt(vehicleIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Invalid vehicle ID");
            return;
        }

        if (!vehicleDAO.isVehicleBelongsToCustomer(vehicleId, customer.getCustomerId())) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Access denied");
            return;
        }

        Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);
        request.setAttribute("vehicle", vehicle);
        request.getRequestDispatcher("/views/auth/vehicle/UpdateVehicle.jsp")
                .forward(request, response);
    }

    // ===== HANDLE POST: process update vehicle =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Customer not found");
            return;
        }

        String vehicleIdStr = request.getParameter("vehicleId");
        String plateNumber = request.getParameter("plateNumber");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("color");
        String manufactureYearStr = request.getParameter("manufactureYear");

        if (isNullOrBlank(vehicleIdStr)) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Vehicle ID required");
            return;
        }

        int vehicleId;
        try {
            vehicleId = Integer.parseInt(vehicleIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Invalid vehicle ID");
            return;
        }

        if (!vehicleDAO.isVehicleBelongsToCustomer(vehicleId, customer.getCustomerId())) {
            response.sendRedirect(request.getContextPath() + "/vehicles?error=Access denied");
            return;
        }

        if (isNullOrBlank(plateNumber)) {
            forwardWithError(request, response, vehicleId, "Plate number required");
            return;
        }
        plateNumber = plateNumber.trim().toUpperCase();

        if (vehicleDAO.isPlateNumberExistsExcludeSelf(plateNumber, vehicleId)) {
            session.setAttribute("errorMessage", "Plate number already exists");
            response.sendRedirect(request.getContextPath() + "/vehicles");
            return;
        }

        int manufactureYear = 0;
        if (!isNullOrBlank(manufactureYearStr)) {
            try {
                manufactureYear = Integer.parseInt(manufactureYearStr);
            } catch (NumberFormatException e) {
                forwardWithError(request, response, vehicleId, "Invalid year");
                return;
            }
        }

        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(vehicleId);
        vehicle.setPlateNumber(plateNumber);
        vehicle.setBrand(brand != null ? brand.trim() : "");
        vehicle.setModel(model != null ? model.trim() : "");
        vehicle.setVehicleType(vehicleType);
        vehicle.setColor(color != null ? color.trim() : "");
        vehicle.setManufactureYear(manufactureYear);
        vehicle.setCustomerId(customer.getCustomerId());

        boolean isUpdated = vehicleDAO.updateVehicle(vehicle);

        if (isUpdated) {
            session.setAttribute("successMessage", "Vehicle updated successfully!");
            response.sendRedirect(request.getContextPath() + "/vehicles");
        } else {
            session.setAttribute("errorMessage", "Failed to update vehicle");
            response.sendRedirect(request.getContextPath() + "/vehicles");
        }
    }

    private void forwardWithError(HttpServletRequest request,
            HttpServletResponse response,
            int vehicleId,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/auth/vehicle/UpdateVehicle.jsp?id=" + vehicleId)
                .forward(request, response);
    }

    private boolean isNullOrBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}