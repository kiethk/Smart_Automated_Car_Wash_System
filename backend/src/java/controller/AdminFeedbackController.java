package controller;

import dao.FeedbackDAO;
import dto.AdminFeedbackView;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/feedbacks")
public class AdminFeedbackController extends HttpServlet {

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        User user = (User) session.getAttribute("USER");
        if (user.getRoleId() != 1) {
            request.setAttribute("ERROR_MSG", "You do not have permission.");
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

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<AdminFeedbackView> feedbacks = feedbackDAO.getAllFeedbacksForAdmin();

        request.setAttribute("FEEDBACKS", feedbacks);
        // Lấy danh sách service name unique để filter
        List<String> serviceNames = feedbackDAO.getDistinctServiceNames();
        request.setAttribute("SERVICE_NAMES", serviceNames);
        request.setAttribute("FEEDBACKS", feedbacks);
        request.getRequestDispatcher("/views/admin/feedback.jsp")
                .forward(request, response);
    }
}
