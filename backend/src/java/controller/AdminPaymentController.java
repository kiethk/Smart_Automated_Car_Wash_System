package controller;

import dao.AdminBookingDAO;
import dao.AdminPaymentDAO;
import dto.AdminPaymentView;
import dto.User;
import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/admin/payments")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10,
    fileSizeThreshold = 1024 * 1024
)
public class AdminPaymentController extends HttpServlet {

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

   //helper
    private void loadPayments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String method  = request.getParameter("method");
        String status  = request.getParameter("status");

        AdminPaymentDAO paymentDAO = new AdminPaymentDAO();
        List<AdminPaymentView> payments = paymentDAO.getAllPayments(keyword, method, status);
        request.setAttribute("PAYMENTS", payments);

     
        request.setAttribute("CURRENT_KEYWORD", keyword != null ? keyword : "");
        request.setAttribute("CURRENT_METHOD", method != null ? method : "all");
        request.setAttribute("CURRENT_STATUS", status != null ? status : "all");

        request.getRequestDispatcher("/views/admin/payment.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) return;

        String action    = request.getParameter("action");
        String bookingId = request.getParameter("bookingId");

        // ===== UPDATE STATUS =====
        if ("updateStatus".equals(action)) {
            String paymentIdStr = request.getParameter("paymentId");
            String newStatus    = request.getParameter("status");
            try {
                int paymentId = Integer.parseInt(paymentIdStr);
                AdminPaymentDAO paymentDAO = new AdminPaymentDAO();
                int result = paymentDAO.updatePaymentStatus(paymentId, newStatus);
                if (result > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/payments?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/payments?error=failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/payments?error=failed");
            }
            return;
        }

        // ===== CÓ BOOKING ID → HIỆN MODAL UPLOAD ẢNH =====
        if (bookingId != null) {
            request.setAttribute("UPLOAD_BOOKING_ID", bookingId);
            request.setAttribute("SHOW_UPLOAD_MODAL", true);
        }

        // ===== HIỂN THỊ DANH SÁCH VỚI DETAIL =====
        loadPayments(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdmin(request, response)) return;

        // ===== UPLOAD ẢNH + COMPLETE BOOKING =====
        if ("confirmComplete".equals(request.getParameter("action"))) {
            String bookingIdStr = request.getParameter("bookingId");
            try {
                int bookingId = Integer.parseInt(bookingIdStr);

                String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // Checkin image
                String checkinUrl = null;
                Part checkinPart = request.getPart("checkinImage");
                if (checkinPart != null && checkinPart.getSize() > 0) {
                    String fileName = "checkin_" + bookingId + "_" + System.currentTimeMillis() + ".jpg";
                    checkinPart.write(uploadPath + fileName);
                   checkinUrl = request.getContextPath() + "/uploads/" + fileName;
                }

                // Checkout image
                String checkoutUrl = null;
                Part checkoutPart = request.getPart("checkoutImage");
                if (checkoutPart != null && checkoutPart.getSize() > 0) {
                    String fileName = "checkout_" + bookingId + "_" + System.currentTimeMillis() + ".jpg";
                    checkoutPart.write(uploadPath + fileName);
                    checkoutUrl = request.getContextPath() + "/uploads/" + fileName;
                }

                // Lưu ảnh + complete booking
                AdminPaymentDAO paymentDAO = new AdminPaymentDAO();
                paymentDAO.updateCheckinCheckout(bookingId, checkinUrl, checkoutUrl);

                AdminBookingDAO bookingDAO = new AdminBookingDAO();
                bookingDAO.completeBooking(bookingId);

                response.sendRedirect(request.getContextPath() + "/admin/bookings?msg=completed");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/payments?error=failed");
            }
        }
    }
}