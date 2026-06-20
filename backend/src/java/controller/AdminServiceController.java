package controller;

import dao.ServiceDAO;
import dto.Service;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/services")
public class AdminServiceController extends HttpServlet {

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

        ServiceDAO serviceDAO = new ServiceDAO();

        String editIdRaw = request.getParameter("editId");
        if (editIdRaw != null && !editIdRaw.trim().isEmpty()) {
            try {
                int editId = Integer.parseInt(editIdRaw);
                Service editService = serviceDAO.getServiceById(editId);
                request.setAttribute("EDIT_SERVICE", editService);
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR_MSG", "Invalid service ID.");
            }
        }

        List<Service> services = serviceDAO.getAllServicesForAdmin();
        request.setAttribute("SERVICES", services);

        request.getRequestDispatcher("/views/admin/service.jsp").forward(request, response);
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
        ServiceDAO serviceDAO = new ServiceDAO();

        try {
            if ("create".equals(action)) {
                String serviceName = request.getParameter("serviceName");
                String description = request.getParameter("description");
                long price = Long.parseLong(request.getParameter("price"));
                int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                Service service = new Service();
                service.setServiceName(serviceName);
                service.setDescription(description);
                service.setPrice(price);
                service.setDurationMinutes(durationMinutes);
                service.setIsActive(isActive);

                boolean success = serviceDAO.createService(service);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/services?msg=created");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/services?error=create_failed");
                }

                return;
            }

            if ("update".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                String serviceName = request.getParameter("serviceName");
                String description = request.getParameter("description");
                long price = Long.parseLong(request.getParameter("price"));
                int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                Service service = new Service();
                service.setServiceId(serviceId);
                service.setServiceName(serviceName);
                service.setDescription(description);
                service.setPrice(price);
                service.setDurationMinutes(durationMinutes);
                service.setIsActive(isActive);

                boolean success = serviceDAO.updateService(service);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/services?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/services?error=update_failed");
                }

                return;
            }

            if ("toggle".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                int isActive = Integer.parseInt(request.getParameter("isActive"));

                boolean success = serviceDAO.toggleServiceStatus(serviceId, isActive);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/services?msg=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/services?error=status_failed");
                }

                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/services");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/services?error=invalid_input");
        }
    }
}