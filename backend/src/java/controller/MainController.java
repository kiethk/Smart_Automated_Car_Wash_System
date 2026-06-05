package controller;

import java.io.IOException;
import java.io.PrintWriter;
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

            switch (ac) {
                case "home":
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
                    // Chuyển hướng đến trang Dashboard sau khi đăng nhập thành công
                    url = "dashboard";
                    break;

                case "booking":
                    url = "booking";
                    break;

                case "bookingSubmit":
                    // Khi khách ấn nút "Confirm Booking", form submit lên đây để xử lý tính toán,
                    // trừ tiền ví, cộng điểm và lưu vào DB
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
