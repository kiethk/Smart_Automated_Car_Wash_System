package controller;

import dao.LoyaltyReviewDAO;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/loyalty-review")
public class AdminLoyaltyReviewController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


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
