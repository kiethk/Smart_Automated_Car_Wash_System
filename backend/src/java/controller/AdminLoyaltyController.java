package controller;

import dao.CustomerDAO;
import dao.LoyaltyPointHistoryDAO;
import dto.Customer;
import dto.LoyaltyPointHistory;
import dto.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/loyalty/*")
public class AdminLoyaltyController extends HttpServlet {

    private CustomerDAO customerDAO;
    private LoyaltyPointHistoryDAO loyaltyDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        customerDAO = new CustomerDAO();
        loyaltyDAO = new LoyaltyPointHistoryDAO();
    }

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

        String pathInfo = request.getPathInfo();

        // URL: /admin/loyalty/{customerId} - AJAX call for modal
        if (pathInfo != null && pathInfo.length() > 1) {
            try {
                String customerIdStr = pathInfo.substring(1);
                int customerId = Integer.parseInt(customerIdStr);

                Customer customer = customerDAO.getCustomerWithDetails(customerId);
                if (customer == null) {
                    response.setContentType("text/html;charset=UTF-8");
                    response.getWriter().write("<div class='text-center py-8 text-red-500'>Customer not found</div>");
                    return;
                }

                List<LoyaltyPointHistory> earnHistory = loyaltyDAO.getEarnedHistory(customerId);
                List<LoyaltyPointHistory> redeemHistory = loyaltyDAO.getRedeemedHistory(customerId);
                List<LoyaltyPointHistory> expiredHistory = loyaltyDAO.getExpiredHistory(customerId);

                request.setAttribute("customer", customer);
                request.setAttribute("earnHistory", earnHistory);
                request.setAttribute("redeemHistory", redeemHistory);
                request.setAttribute("expiredHistory", expiredHistory);

                request.getRequestDispatcher("/views/admin/loyalty-modal.jsp").forward(request, response);
                return;

            } catch (NumberFormatException e) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<div class='text-center py-8 text-red-500'>Invalid customer ID</div>");
                return;
            }
        }

        // URL: /admin/loyalty - Full page
        try {
            List<Customer> customers = customerDAO.getAllCustomersWithDetails();

            Map<Integer, List<LoyaltyPointHistory>> earnHistoryMap = new HashMap<>();
            Map<Integer, List<LoyaltyPointHistory>> redeemHistoryMap = new HashMap<>();
            Map<Integer, List<LoyaltyPointHistory>> expiredHistoryMap = new HashMap<>();

            if (customers != null) {
                for (Customer c : customers) {
                    int customerId = c.getCustomerId();
                    earnHistoryMap.put(customerId, loyaltyDAO.getEarnedHistory(customerId));
                    redeemHistoryMap.put(customerId, loyaltyDAO.getRedeemedHistory(customerId));
                    expiredHistoryMap.put(customerId, loyaltyDAO.getExpiredHistory(customerId));
                }
            }

            int totalEarned = 0;
            int totalRedeemed = 0;
            int totalExpired = 0;
            int totalCustomers = customers != null ? customers.size() : 0;

            if (customers != null) {
                for (Customer c : customers) {
                    totalEarned += loyaltyDAO.getTotalEarnedPoints(c.getCustomerId());
                    totalRedeemed += loyaltyDAO.getTotalUsedPoints(c.getCustomerId());
                    List<LoyaltyPointHistory> expiredList = loyaltyDAO.getExpiredHistory(c.getCustomerId());
                    if (expiredList != null) {
                        for (LoyaltyPointHistory h : expiredList) {
                            totalExpired += h.getPointsUsed();
                        }
                    }
                }
            }

            request.setAttribute("customers", customers);
            request.setAttribute("earnHistoryMap", earnHistoryMap);
            request.setAttribute("redeemHistoryMap", redeemHistoryMap);
            request.setAttribute("expiredHistoryMap", expiredHistoryMap);
            request.setAttribute("totalEarned", totalEarned);
            request.setAttribute("totalRedeemed", totalRedeemed);
            request.setAttribute("totalExpired", totalExpired);
            request.setAttribute("totalCustomers", totalCustomers);

            request.getRequestDispatcher("/views/admin/loyalty.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "System error: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}