package controller;

import dao.AdminBookingDAO;
import dao.NotificationDAO;
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

                if (success) {
                    User user = bookingDAO.getUserByBookingId(bookingId);
                    if (user != null) {
                        NotificationDAO notiDAO = new NotificationDAO();
                        boolean isNotificationCreated = notiDAO.createNotification(
                                user.getUserId(),
                                "Booking Accepted",
                                "Your booking has been accepted by the admin.",
                                "Customer",
                                bookingId);

                        if (!isNotificationCreated) {
                            System.out.println("Failed to create notification for accepted booking.");
                        }
                    } else {
                        System.out.println("User not found for booking ID: " + bookingId);
                    }
                }

            } else if ("cancel".equals(action)) {
                success = bookingDAO.cancelBooking(bookingId);
                successMsg = "cancelled";

                if (success) {
                    User user = bookingDAO.getUserByBookingId(bookingId);
                    if (user != null) {
                        NotificationDAO notiDAO = new NotificationDAO();
                        boolean isNotificationCreated = notiDAO.createNotification(
                                user.getUserId(),
                                "Booking Canceled",
                                "Your booking has been canceled by the admin.",
                                "Customer",
                                bookingId);

                        if (!isNotificationCreated) {
                            System.out.println("Failed to create notification for canceled booking.");
                        }
                    } else {
                        System.out.println("User not found for booking ID: " + bookingId);
                    }
                }
            } else if ("deny".equals(action)) {
                success = bookingDAO.denyBooking(bookingId);
                successMsg = "denied";
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
