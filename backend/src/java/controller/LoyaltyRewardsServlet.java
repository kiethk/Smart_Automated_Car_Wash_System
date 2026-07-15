package controller;

import dao.CustomerDAO;
import dao.LoyaltyPointHistoryDAO;
import dao.TiersDAO;
import dao.UserDAO;
import dto.Customer;
import dto.LoyaltyPointHistory;
import dto.Tiers;
import dto.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/loyalty-rewards")
public class LoyaltyRewardsServlet extends HttpServlet {

    private CustomerDAO customerDAO;
    private TiersDAO tiersDAO;
    private LoyaltyPointHistoryDAO loyaltyDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        customerDAO = new CustomerDAO();
        tiersDAO = new TiersDAO();
        loyaltyDAO = new LoyaltyPointHistoryDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        User loginedUser = (User) session.getAttribute("USER");

        try {
            Customer customer = customerDAO.getCustomerByUserId(loginedUser.getUserId());
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=home");
                return;
            }

            // Lấy fullName từ User và gán vào customer
            User user = userDAO.getUserById(loginedUser.getUserId());
            if (user != null) {
                customer.setFullName(user.getFullName());
            }

            // Lấy Tier hiện tại
            Tiers currentTier = tiersDAO.getTierById(customer.getTierId());
            if (currentTier != null) {
                customer.setTierName(currentTier.getTierName());
                customer.setPointMultiplier(currentTier.getPointMultiplier());
            }

            // Lấy tất cả Tiers
            List<Tiers> allTiers = tiersDAO.getAllTiers();

            // ===== PHẦN CẬP NHẬT: Lấy 3 loại lịch sử điểm =====
            // 1. Earn history - Lịch sử điểm được cộng
            List<LoyaltyPointHistory> earnHistory = loyaltyDAO.getEarnedHistory(customer.getCustomerId());

            // 2. Redeem history - Lịch sử điểm được sử dụng
            List<LoyaltyPointHistory> redeemHistory = loyaltyDAO.getRedeemedHistory(customer.getCustomerId());

            // 3. Expired history - Lịch sử điểm bị hết hạn
            List<LoyaltyPointHistory> expiredHistory = loyaltyDAO.getExpiredHistory(customer.getCustomerId());

            // Lấy tổng điểm earned, used và current points
            int totalEarned = loyaltyDAO.getTotalEarnedPoints(customer.getCustomerId());
            int totalUsed = loyaltyDAO.getTotalUsedPoints(customer.getCustomerId());

            // Tính tổng điểm hiện tại (đã trừ hết hạn)
            int currentPoints = customer.getTotalPoints();

            // Set attributes
            request.setAttribute("customer", customer);
            request.setAttribute("currentTier", currentTier);
            request.setAttribute("allTiers", allTiers);

            // 3 loại lịch sử
            request.setAttribute("earnHistory", earnHistory);
            request.setAttribute("redeemHistory", redeemHistory);
            request.setAttribute("expiredHistory", expiredHistory);

            // Thống kê
            request.setAttribute("totalEarned", totalEarned);
            request.setAttribute("totalUsed", totalUsed);
            request.setAttribute("currentPoints", currentPoints);

            request.getRequestDispatcher("views/auth/customer/loyalty-rewards.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "System error: " + e.getMessage());
            request.getRequestDispatcher("views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}