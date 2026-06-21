/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
import dto.Booking;
import dto.BookingHistoryDTO;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author QUOC HUY
 */
@WebServlet(name = "BookingHistory", urlPatterns = {"/BookingHistory"})
public class BookingHistory extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingHistory</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingHistory at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        try {
            Customer customer = (Customer) session.getAttribute("CUSTOMER");

            // ========================================================
            // XỬ LÝ HỦY BOOKING (nếu URL có tham số cancelId)
            // ví dụ: /BookingHistory?cancelId=12
            // ========================================================
            String cancelIdParam = request.getParameter("cancelId");
            if (cancelIdParam != null && !cancelIdParam.isEmpty()) {

                if (customer != null) {
                    try {
                        int bookingId = Integer.parseInt(cancelIdParam);
                        BookingDAO bookingDAO = new BookingDAO();
                        bookingDAO.cancelBooking(bookingId, customer.getCustomerId());
                    } catch (NumberFormatException nfe) {
                        System.out.println("Invalid cancelId: " + cancelIdParam);
                    }
                }

                // Redirect lại chính trang này (bỏ cancelId khỏi URL)
                // để tránh hủy lặp lại nếu người dùng bấm F5
                response.sendRedirect(request.getContextPath() + "/BookingHistory");
                return;
            }

            // ========================================================
            // HIỂN THỊ DANH SÁCH BOOKING (logic cũ, giữ nguyên)
            // ========================================================
            if (customer != null) {
                String status = request.getParameter("status");
                BookingDAO bookingDAO = new BookingDAO();
                List<BookingHistoryDTO> bookings = bookingDAO.getBookingHistoryByCustomerId(customer.getCustomerId(), status);
                request.setAttribute("BOOKINGS", bookings);
                request.setAttribute("CURRENT_STATUS", status);
            }

            request.getRequestDispatcher("views/auth/customer/BookingHistory.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
        }
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
