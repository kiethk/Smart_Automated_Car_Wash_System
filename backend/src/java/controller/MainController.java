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
        request.setCharacterEncoding("UTF-8"); // Đảm bảo không lỗi font tiếng Việt khi submit form

        try {
            String url = "views/error.jsp"; // File báo lỗi hệ thống chung
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
                        || "updateVehicle".equals(ac)) {

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
                    // ========================================================
                    // XỬ LÝ DỮ LIỆU ĐỘNG CHO TRANG CHỦ
                    // ========================================================
                    try {
                    // 1. Khởi tạo lớp xử lý dữ liệu ServiceDAO của bạn
                    ServiceDAO serviceDAO = new ServiceDAO();

                    // 2. Gọi hàm lấy danh sách dịch vụ đang hoạt động
                    List<Service> servicesList = serviceDAO.getActiveServices();

                    // 3. Đóng gói danh sách vào request dưới tên biến SERVICES_LIST
                    request.setAttribute("SERVICES_LIST", servicesList);
                } catch (Exception e) {
                    // Log lỗi cục bộ để nếu lỗi DB thì trang chủ vẫn không bị sập (vẫn hiển thị giao diện trống)
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

                // ========================================================
                // 2. CÁC ROUTE MỚI CHO WORKSHOP 2 (Nhiệm vụ JIRA-01 của bạn)
                // ========================================================
                case "dashboard":
                    url = "dashboard";
                    break;

                case "booking":
                    url = "booking";
                    break;

                case "bookingSubmit":
                    url = "bookingSubmit";
                    break;

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
