package controller;

import dao.WalletDAO;
import dto.Customer;
import dto.Wallet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "Dashboard", urlPatterns = {"/dashboard"})
public class Dashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        // 1. KIỂM TRA BẢO MẬT: Nếu chưa đăng nhập, đá người dùng về trang chủ qua MainController
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        try {
            // 2. LẤY THÔNG TIN ĐỘNG: Lấy dữ liệu Customer hiện tại từ Session (đã set lúc Login)
            Customer customer = (Customer) session.getAttribute("CUSTOMER");

            if (customer != null) {
                // Khởi tạo DAO để lấy số dư ví mới nhất từ Database SQL Server
                WalletDAO walletDAO = new WalletDAO();
                Wallet wallet = walletDAO.getWalletByCustomerId(customer.getCustomerId());

                // Đè/Cập nhật dữ liệu ví mới nhất vào Session để file dashboard.jsp bốc ra hiển thị
                session.setAttribute("WALLET", wallet);
                
                // (Tùy chọn mở rộng tương lai): Lấy thêm lịch hẹn sắp tới tại đây nếu cần
                // dao.AppointmentDAO appDAO = new dao.AppointmentDAO();
                // dto.Appointment app = appDAO.getLatestAppointment(customer.getCustomerId());
                // request.setAttribute("UPCOMING_APPOINTMENT", app);
            }

            // 3. ĐIỀU PHỐI NGẦM (FORWARD): Gọi giao diện hiển thị, giấu kín đuôi file .jsp trên URL
            // Bỏ dấu gạch chéo ở đầu để khớp chuẩn xác đường dẫn tương đối trong project
            request.getRequestDispatcher("views/auth/customer/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi hệ thống xảy ra, đẩy an toàn về trang chủ
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trang Dashboard chủ yếu là hiển thị thông tin (GET). 
        // Nếu người dùng cố tình gửi POST method tới đây, ta chuyển hướng nạp lại cấu trúc GET ở trên cho an toàn.
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Customer Dashboard Controller";
    }
}