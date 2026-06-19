package controller;

import dao.AdminBookingDAO;
import dto.AdminBookingView;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/bookings")
public class AdminBookingController extends HttpServlet {

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

        AdminBookingDAO bookingDAO = new AdminBookingDAO();
        List<AdminBookingView> bookings = bookingDAO.getAllBookingsForAdmin();

        request.setAttribute("BOOKINGS", bookings);
        request.getRequestDispatcher("/views/admin/booking.jsp").forward(request, response);
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
        String bookingIdRaw = request.getParameter("bookingId");

        if (bookingIdRaw == null || bookingIdRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=invalid_booking");
            return;
        }

        AdminBookingDAO bookingDAO = new AdminBookingDAO();

        try {
            int bookingId = Integer.parseInt(bookingIdRaw);
            boolean success = false;
            String successMsg = "updated";

            if ("accept".equals(action)) {
                success = bookingDAO.acceptBooking(bookingId);
                successMsg = "accepted";
            } else if ("confirmPaid".equals(action)) {
                success = bookingDAO.markPaymentPaidOnly(bookingId);
                successMsg = "paid";
            } else if ("complete".equals(action)) {
                success = bookingDAO.completeBooking(bookingId);
                successMsg = "completed";
            } else if ("cancel".equals(action)) {
                success = bookingDAO.cancelBooking(bookingId);
                successMsg = "cancelled";
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?error=invalid_action");
                return;
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?msg=" + successMsg);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/bookings?error=action_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/bookings?error=invalid_input");
        }
    }
}