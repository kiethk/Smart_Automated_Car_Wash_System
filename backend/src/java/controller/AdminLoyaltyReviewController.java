package controller;

import dao.LoyaltyReviewDAO;
import dto.User;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/loyalty-review")
public class AdminLoyaltyReviewController extends HttpServlet {

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        LocalDate previousMonth = LocalDate.now().minusMonths(1);
        boolean success = new LoyaltyReviewDAO().runMonthlyTierDowngrade(
                previousMonth.getYear(),
                previousMonth.getMonthValue()
        );

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/customers?msg=loyalty_reviewed");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/customers?error=loyalty_review_failed");
        }
    }
}
