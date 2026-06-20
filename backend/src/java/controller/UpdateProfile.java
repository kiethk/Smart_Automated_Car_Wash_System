/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import dto.Customer;
import dto.User;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author kieth
 */
@WebServlet(name = "UpdateProfile", urlPatterns = {"/updateProfile"})
public class UpdateProfile extends HttpServlet {

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
            out.println("<title>Servlet UpdateProfile</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProfile at " + request.getContextPath() + "</h1>");
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
        response.sendRedirect(request.getContextPath() + "/profile");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        // Kiểm tra session null
        if (session == null) {
            response.getWriter().write("error");
            return;
        }

        User user = (User) session.getAttribute("USER");
        Customer cust = (Customer) session.getAttribute("CUSTOMER");

        String field = request.getParameter("field");
        String value = request.getParameter("value");

        CustomerDAO cd = new CustomerDAO();
        UserDAO ud = new UserDAO();
        boolean success = false;

        try {
            switch (field) {
                case "phone":
                    if (user != null) {
                        success = ud.updatePhoneById(user.getUserId(), value);
                        if (success) {
                            user.setPhone(value);
                        }
                    }
                    break;

                case "address":
                    if (cust != null) {
                        success = cd.updateAddressById(cust.getCustomerId(), value);
                        if (success) {
                            cust.setAddress(value);
                        }
                    }
                    break;

                case "dob":
                    if (cust != null && value != null && !value.isEmpty()) {
                        success = cd.updateDobById(cust.getCustomerId(), value);
                        if (success) {
                            // Chuyển đổi String yyyy-mm-dd sang java.sql.Date
                            cust.setDateOfBirth(java.sql.Date.valueOf(value));
                        }
                    }
                    break;
                case "avatar":
                    if (user != null) {
                        success = ud.updateAvatarById(user.getUserId(), value);
                        if (success) {
                            user.setAvatarUrl(value);
                        }
                    }
                    break;

                default:
                    // Xử lý trường hợp field không hợp lệ (nếu cần)
                    System.out.println("Unknown field update attempt: " + field);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.getWriter().write(success ? "success" : "error");
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
