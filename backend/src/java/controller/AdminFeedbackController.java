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

    // ===== KIỂM TRA ADMIN =====
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

    // ===== LOAD FEEDBACK =====
    private void loadFeedbacks(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String rating = request.getParameter("rating");
        String service = request.getParameter("service");

        FeedbackDAO feedbackDAO = new FeedbackDAO();

        List<AdminFeedbackView> feedbacks
                = feedbackDAO.getAllFeedbacksForAdmin(keyword, rating, service);

        request.setAttribute("FEEDBACKS", feedbacks);

        request.setAttribute("SERVICE_NAMES",
                feedbackDAO.getDistinctServiceNames());

        request.setAttribute("CURRENT_KEYWORD",
                keyword != null ? keyword : "");

        request.setAttribute("CURRENT_RATING",
                rating != null ? rating : "all");

        request.setAttribute("CURRENT_SERVICE",
                service != null ? service : "all");

        request.getRequestDispatcher("/views/admin/feedback.jsp")
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        loadFeedbacks(request, response);
    }

}