package controller;

import dao.CustomerDAO;
import dao.VehicleDAO;
import dto.Customer;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/deleteVehicle")
public class DeleteVehicle extends HttpServlet {

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

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        String vehicleIdStr = request.getParameter("id");
        if (vehicleIdStr == null || vehicleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        try {
            int vehicleId = Integer.parseInt(vehicleIdStr);
            User currentUser = (User) session.getAttribute("USER");
            
            // Lấy customer_id từ user_id
            Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            // Kiểm tra xe có thuộc về customer không
            if (!vehicleDAO.isVehicleBelongsToCustomer(vehicleId, customer.getCustomerId())) {
                session.setAttribute("ERROR", "You don't have permission to delete this vehicle.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            // Xóa mềm (set is_active = 0)
            boolean success = vehicleDAO.softDeleteVehicle(vehicleId);
            
            if (success) {
                session.setAttribute("SUCCESS", "Vehicle deleted successfully!");
            } else {
                session.setAttribute("ERROR", "Failed to delete vehicle. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("ERROR", "Invalid vehicle ID.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ERROR", "System error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}