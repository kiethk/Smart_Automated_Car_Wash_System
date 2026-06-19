package controller;

import dao.BayDAO;
import dto.Bay;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/bays")
public class AdminBayController extends HttpServlet {

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

    private boolean isValidStatus(String status) {
        return "available".equalsIgnoreCase(status)
                || "maintenance".equalsIgnoreCase(status);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) {
            return;
        }

        BayDAO bayDAO = new BayDAO();

        String editIdRaw = request.getParameter("editId");
        if (editIdRaw != null && !editIdRaw.trim().isEmpty()) {
            try {
                int editId = Integer.parseInt(editIdRaw);
                Bay editBay = bayDAO.getBayById(editId);
                request.setAttribute("EDIT_BAY", editBay);
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR_MSG", "Invalid bay ID.");
            }
        }

        List<Bay> bays = bayDAO.getAllBaysForAdmin();
        request.setAttribute("BAYS", bays);

        request.getRequestDispatcher("/views/admin/bay.jsp").forward(request, response);
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
        BayDAO bayDAO = new BayDAO();

        try {
            if ("create".equals(action)) {
                String bayName = request.getParameter("bayName");
                String status = request.getParameter("status");

                if (bayName == null || bayName.trim().isEmpty() || !isValidStatus(status)) {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?error=invalid_input");
                    return;
                }

                Bay bay = new Bay();
                bay.setBayName(bayName.trim());
                bay.setStatus(status.toLowerCase());

                boolean success = bayDAO.createBay(bay);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?msg=created");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?error=create_failed");
                }

                return;
            }

            if ("update".equals(action)) {
                int bayId = Integer.parseInt(request.getParameter("bayId"));
                String bayName = request.getParameter("bayName");
                String status = request.getParameter("status");

                if (bayName == null || bayName.trim().isEmpty() || !isValidStatus(status)) {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?error=invalid_input");
                    return;
                }

                Bay bay = new Bay();
                bay.setBayId(bayId);
                bay.setBayName(bayName.trim());
                bay.setStatus(status.toLowerCase());

                boolean success = bayDAO.updateBay(bay);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?error=update_failed");
                }

                return;
            }

            if ("toggle".equals(action)) {
                int bayId = Integer.parseInt(request.getParameter("bayId"));
                String status = request.getParameter("status");

                if (!isValidStatus(status)) {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?error=invalid_status");
                    return;
                }

                boolean success = bayDAO.updateBayStatus(bayId, status.toLowerCase());

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?msg=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/bays?error=status_failed");
                }

                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/bays");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/bays?error=invalid_input");
        }
    }

}
