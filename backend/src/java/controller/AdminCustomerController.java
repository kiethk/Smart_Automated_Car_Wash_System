package controller;

import dao.AdminCustomerDAO;
import dao.TiersDAO;
import dto.AdminCustomerView;
import dto.Tiers;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/customers")
public class AdminCustomerController extends HttpServlet {

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

        AdminCustomerDAO customerDAO = new AdminCustomerDAO();
        TiersDAO tiersDAO = new TiersDAO();

        String editCustomerIdRaw = request.getParameter("editCustomerId");

        if (editCustomerIdRaw != null && !editCustomerIdRaw.trim().isEmpty()) {
            try {
                int editCustomerId = Integer.parseInt(editCustomerIdRaw);
                AdminCustomerView editCustomer = customerDAO.getCustomerViewByCustomerId(editCustomerId);
                request.setAttribute("EDIT_CUSTOMER", editCustomer);
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR_MSG", "Invalid customer ID.");
            }
        }

        List<AdminCustomerView> customers = customerDAO.getAllCustomersForAdmin();
        List<Tiers> tiers = tiersDAO.getAllTiers();

        request.setAttribute("CUSTOMERS", customers);
        request.setAttribute("TIERS", tiers);

        request.getRequestDispatcher("/views/admin/customer.jsp").forward(request, response);
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
        AdminCustomerDAO customerDAO = new AdminCustomerDAO();

        try {
            if ("updateAdminFields".equals(action)) {
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                int tierId = Integer.parseInt(request.getParameter("tierId"));
                long totalSpent = Long.parseLong(request.getParameter("totalSpent"));
                int totalWashes = Integer.parseInt(request.getParameter("totalWashes"));
                int totalPoints = Integer.parseInt(request.getParameter("totalPoints"));
                long walletBalance = Long.parseLong(request.getParameter("walletBalance"));

                if (tierId <= 0 || totalSpent < 0 || totalWashes < 0 || totalPoints < 0 || walletBalance < 0) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/customers?editCustomerId=" + customerId + "&error=invalid_input");
                    return;
                }

                boolean success = customerDAO.updateCustomerAdminFields(
                        customerId,
                        tierId,
                        totalSpent,
                        totalWashes,
                        totalPoints,
                        walletBalance
                );

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/customers?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/customers?editCustomerId=" + customerId + "&error=update_failed");
                }

                return;
            }
            if ("toggleStatus".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                boolean success = customerDAO.updateCustomerAccountStatus(userId, isActive);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/customers?msg=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/customers?error=status_failed");
                }

                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/customers");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/customers?error=invalid_input");
        }
    }
}
