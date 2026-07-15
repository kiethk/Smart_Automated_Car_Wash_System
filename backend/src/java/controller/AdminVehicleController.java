package controller;

import dao.VehicleDAO;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/vehicles")
public class AdminVehicleController extends HttpServlet {

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return false;
        }

        User user = (User) session.getAttribute("USER");

        if (user.getRoleId() != 1) {
            request.setAttribute("ERROR_MSG", "You do not have permission to access this page.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        VehicleDAO vehicleDAO = new VehicleDAO();

        // Lấy parameters
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String vehicleIdParam = request.getParameter("vehicleId");

        // 3️⃣ Vehicle details - Xử lý view detail
        if (vehicleIdParam != null && !vehicleIdParam.trim().isEmpty()) {
            try {
                int vehicleId = Integer.parseInt(vehicleIdParam);
                Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);
                if (vehicle != null) {
                    request.setAttribute("VEHICLE_DETAIL", vehicle);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR_MSG", "Invalid vehicle ID.");
            }
        }

        // 3️⃣ Vehicle list + Search/filter - Lấy danh sách xe
        List<Vehicle> vehicles;
        if (keyword != null && !keyword.trim().isEmpty()) {
            vehicles = vehicleDAO.searchVehicles(keyword);
        } else if (type != null && !type.isEmpty()) {
            vehicles = vehicleDAO.filterVehiclesByType(type);
        } else if (status != null && !status.isEmpty()) {
            vehicles = vehicleDAO.filterVehiclesByStatus(Integer.parseInt(status));
        } else {
            vehicles = vehicleDAO.getAllVehiclesWithDetails();
        }

        // Lấy thống kê
        VehicleDAO.VehicleStatistics stats = vehicleDAO.getVehicleStatistics();

        request.setAttribute("VEHICLES", vehicles);
        request.setAttribute("STATISTICS", stats);
        request.getRequestDispatcher("/views/admin/vehicle.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        VehicleDAO vehicleDAO = new VehicleDAO();

        try {
            if ("toggleStatus".equals(action)) {
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                int currentStatus = Integer.parseInt(request.getParameter("currentStatus"));
                int newStatus = currentStatus == 1 ? 0 : 1;

                boolean success;
                if (newStatus == 1) {
                    success = vehicleDAO.restoreVehicle(vehicleId);
                } else {
                    success = vehicleDAO.softDeleteVehicle(vehicleId);
                }

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/vehicles?msg=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/vehicles?error=status_failed");
                }
                return;
            }

            if ("delete".equals(action)) {
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                boolean success = vehicleDAO.softDeleteVehicle(vehicleId);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/vehicles?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/vehicles?error=delete_failed");
                }
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/vehicles");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/vehicles?error=invalid_input");
        }
    }
}