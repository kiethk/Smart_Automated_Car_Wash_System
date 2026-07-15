package controller;

import dao.CustomerDAO;
import dao.FeedbackDAO;
import dto.Customer;
import dto.Feedback;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/feedback")
public class FeedbackController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("USER");

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByUserId(user.getUserId());
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/BookingHistory?error=notfound");
            return;
        }

        String ratingStr  = request.getParameter("rating");
        String comment    = request.getParameter("comment");
        String bookingStr = request.getParameter("bookingId");

        if (ratingStr == null || ratingStr.equals("0")) {
            response.sendRedirect(request.getContextPath() + "/BookingHistory?error=norating");
            return;
        }

        try {
            int rating    = Integer.parseInt(ratingStr);
            int bookingId = Integer.parseInt(bookingStr);

            Feedback f = new Feedback();
            f.setRating(rating);
            f.setComment(comment);
            f.setBookingId(bookingId);
            f.setCustomerId(customer.getCustomerId());

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            int result = feedbackDAO.insertFeedback(f);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/BookingHistory?msg=feedback_submitted");
            } else {
                response.sendRedirect(request.getContextPath() + "/BookingHistory?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/BookingHistory   ?error=failed");
        }
    }
}   