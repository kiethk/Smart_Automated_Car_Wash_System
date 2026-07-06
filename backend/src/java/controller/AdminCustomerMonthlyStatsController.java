package controller;

import dao.CustomerMonthlyStatsDAO;
import dto.CustomerMonthlyStats;
import dto.User;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/monthly-stats")
public class AdminCustomerMonthlyStatsController extends HttpServlet {

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

        LocalDate now = LocalDate.now();

        // Đọc year/month từ query param, mặc định là tháng hiện tại
        int selectedYear;
        int selectedMonth;

        try {
            selectedYear = Integer.parseInt(request.getParameter("year"));
        } catch (Exception e) {
            selectedYear = now.getYear();
        }

        try {
            selectedMonth = Integer.parseInt(request.getParameter("month"));
            if (selectedMonth < 1 || selectedMonth > 12) selectedMonth = now.getMonthValue();
        } catch (Exception e) {
            selectedMonth = now.getMonthValue();
        }

        CustomerMonthlyStatsDAO dao = new CustomerMonthlyStatsDAO();
        List<CustomerMonthlyStats> statsList = dao.getByMonth(selectedYear, selectedMonth);
        int totalRecords = dao.countByMonth(selectedYear, selectedMonth);

        request.setAttribute("STATS_LIST", statsList);
        request.setAttribute("TOTAL_RECORDS", totalRecords);
        request.setAttribute("SELECTED_YEAR", selectedYear);
        request.setAttribute("SELECTED_MONTH", selectedMonth);
        request.setAttribute("CURRENT_YEAR", now.getYear());
        request.setAttribute("CURRENT_MONTH", now.getMonthValue());

        request.getRequestDispatcher("/views/admin/monthly-stats.jsp").forward(request, response);
    }
}