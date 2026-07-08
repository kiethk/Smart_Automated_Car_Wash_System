package controller;

import dao.AdminTierDAO;
import dto.Tiers;
import dto.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/tiers")
public class AdminTierController extends HttpServlet {

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

        if (!isAdmin(request, response)) return;

        AdminTierDAO dao = new AdminTierDAO();
        List<Tiers> tierList = dao.getAllTiers();

        // Gắn thêm số lượng customer cho mỗi tier
        List<Integer> customerCounts = new ArrayList<>();
        for (Tiers t : tierList) {
            customerCounts.add(dao.countCustomersByTierId(t.getTierId()));
        }

        request.setAttribute("TIER_LIST", tierList);
        request.setAttribute("CUSTOMER_COUNTS", customerCounts);
        request.getRequestDispatcher("/views/admin/tier.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) return;

        String action = request.getParameter("action");

        if (!"update".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/admin/tiers?error=invalid_action");
            return;
        }

        try {
            int tierId = Integer.parseInt(request.getParameter("tierId"));
            int minWashes = Integer.parseInt(request.getParameter("minWashes"));
            long minSpent = Long.parseLong(request.getParameter("minSpent"));
            double pointMultiplier = Double.parseDouble(request.getParameter("pointMultiplier"));
            double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
            int bookingWindowDays = Integer.parseInt(request.getParameter("bookingWindowDays"));
            String description = request.getParameter("description");

            Tiers tier = new Tiers();
            tier.setTierId(tierId);
            tier.setMinWashes(minWashes);
            tier.setMinSpent(minSpent);
            tier.setPointMultiplier(pointMultiplier);
            tier.setDiscountPercent(discountPercent);
            tier.setBookingWindowDays(bookingWindowDays);
            tier.setDescription(description);

            AdminTierDAO dao = new AdminTierDAO();
            boolean success = dao.updateTier(tier);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/tiers?msg=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/tiers?error=update_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tiers?error=invalid_input");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/tiers?error=system_error");
        }
    }
}