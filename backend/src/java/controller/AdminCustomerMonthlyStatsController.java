package controller;

import dao.CustomerMonthlyStatsDAO;
import dto.CustomerMonthlyStats;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/monthly-stats")
public class AdminCustomerMonthlyStatsController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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