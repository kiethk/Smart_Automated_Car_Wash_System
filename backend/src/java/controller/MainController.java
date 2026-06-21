package controller;

import dao.ServiceDAO;
import dto.Service;
import java.io.IOException;
import java.util.List;
import dto.User;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            String url = "views/error.jsp";
            String ac = request.getParameter("action");

            if (ac == null || ac.isEmpty()) {
                ac = "home";
            }

            HttpSession session = request.getSession(false);
            User currentUser = null;

            if (session != null && session.getAttribute("USER") != null) {
                currentUser = (User) session.getAttribute("USER");
            }

            boolean isAdmin = currentUser != null && currentUser.getRoleId() == 1;

            if (isAdmin) {
                if ("dashboard".equals(ac)
                        || "booking".equals(ac)
                        || "bookingSubmit".equals(ac)
                        || "profile".equals(ac)
                        || "addVehicle".equals(ac)
                        || "updateVehicle".equals(ac)
                        || "loyaltyPoint".equals(ac)) {  // <-- THÊM loyaltyPoint VÀO ĐÂY

                    if ("profile".equals(ac)) {
                        response.sendRedirect(request.getContextPath() + "/admin/profile");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    }
                    return;
                }
            }

            switch (ac) {
                case "home":
                    try {
                        ServiceDAO serviceDAO = new ServiceDAO();
                        List<Service> servicesList = serviceDAO.getActiveServices();
                        request.setAttribute("SERVICES_LIST", servicesList);
                    } catch (Exception e) {
                        System.out.println("Error loading services at MainController: " + e.getMessage());
                    }
                    url = "index.jsp";
                    break;

                case "login":
                    url = "login";
                    break;
                case "logout":
                    url = "logout";
                    break;
                case "register":
                    url = "register";
                    break;
                case "profile":
                    url = "profile";
                    break;
                case "addVehicle":
                    url = "addVehicle";
                    break;
                case "updateVehicle":
                    url = "updateVehicle";
                    break;

                case "dashboard":
                    url = "dashboard";
                    break;

                case "booking":
                    url = "booking";
                    break;

                case "bookingSubmit":
                    url = "bookingSubmit";
                    break;

                // ========================================================
                // THÊM CASE LOYALTYPOINT
                // ========================================================
                case "loyaltyPoint":
                    // Chuyển hướng đến LoyaltyRewardsServlet
                    response.sendRedirect(request.getContextPath() + "/loyalty-rewards");
                    return;  // Không forward, dùng redirect

                default:
                    request.setAttribute("ERROR_MESSAGE", "Your action can not be handled now.");
                    url = "views/error.jsp";
                    break;
            }

            request.getRequestDispatcher(url).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Main Controller handling routing and context initialization";
    }
}