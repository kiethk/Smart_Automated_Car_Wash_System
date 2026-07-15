package controller;

import dao.AdminDashboardDAO;
import dto.AdminDashboardBookingView;
import dto.AdminDashboardStats;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();

        AdminDashboardStats stats = dashboardDAO.getDashboardStats();
        List<AdminDashboardBookingView> todayBookings = dashboardDAO.getTodayBookings();
        List<AdminDashboardBookingView> recentBookings = dashboardDAO.getRecentBookings();

        request.setAttribute("STATS", stats);
        request.setAttribute("TODAY_BOOKINGS", todayBookings);
        request.setAttribute("RECENT_BOOKINGS", recentBookings);

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
