package controller;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/profile")
public class AdminProfileController extends HttpServlet {

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

        request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        User currentAdmin = (User) session.getAttribute("USER");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String avatarUrl = request.getParameter("avatarUrl");

        if (fullName == null || fullName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/profile?error=missing_name");
            return;
        }

        if (phone == null) {
            phone = "";
        }

        if (avatarUrl == null) {
            avatarUrl = "";
        }

        UserDAO userDAO = new UserDAO();

        boolean success = userDAO.updateAdminProfile(
                currentAdmin.getUserId(),
                fullName.trim(),
                phone.trim(),
                avatarUrl.trim()
        );

        if (success) {
            currentAdmin.setFullName(fullName.trim());
            currentAdmin.setPhone(phone.trim());
            currentAdmin.setAvatarUrl(avatarUrl.trim());

            session.setAttribute("USER", currentAdmin);

            response.sendRedirect(request.getContextPath() + "/admin/profile?msg=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/profile?error=update_failed");
        }
    }
}