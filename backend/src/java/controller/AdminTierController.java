package controller;

import dao.AdminTierDAO;
import dto.Tiers;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/tiers")
public class AdminTierController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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