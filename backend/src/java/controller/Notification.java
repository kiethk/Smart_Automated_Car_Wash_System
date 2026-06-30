package controller;

import dao.NotificationDAO;
import dto.Notifications;
import dto.User; // Import lớp User từ package dto để lấy dữ liệu session
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "NotificationController", urlPatterns = {"/NotificationController", "/admin/notifications"})
public class Notification extends HttpServlet {

    private boolean isInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }
        try {
            Integer.parseInt(value.trim());
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy nguyên đối tượng USER từ Session đồng bộ với file header.jsp
            User user = (User) request.getSession().getAttribute("USER");
            
            // Nếu người dùng chưa đăng nhập, chuyển hướng ngay về trang đăng nhập
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=login");
                return;
            }

            // Lấy ID người dùng thực tế từ đối tượng User đã đăng nhập hợp lệ
            int userId = user.getUserId(); 
            
            String action = request.getParameter("action");
            String requestUri = request.getRequestURI();
            boolean isAdminNotificationPage = "admin-list".equals(action)
                    || requestUri.endsWith(request.getContextPath() + "/admin/notifications")
                    || requestUri.endsWith("/admin/notifications");
            NotificationDAO dao = new NotificationDAO();

            // LUÔN LUÔN CHẠY: Đếm số thông báo chưa đọc để phục vụ logic hiển thị CHẤM ĐỎ ở Header
            int unreadCount = dao.countUnreadNotifications(userId);
            request.setAttribute("UNREAD_COUNT", unreadCount);

            // 2. PHÂN NHÁNH XỬ LÝ THEO THAM SỐ ACTION ĐƯỢC GỬI LÊN
            if (isAdminNotificationPage) {
                if (user.getRoleId() != 1) {
                    request.setAttribute("ERROR_MSG", "You do not have permission to access this page.");
                    request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                    return;
                }

                // Luồng xử lý dành cho Admin: Xem danh sách tổng hợp, Tìm kiếm và Lọc dữ liệu
                String keyword = request.getParameter("search");
                String type = request.getParameter("type");
                String isReadParam = request.getParameter("isRead");
                
                Integer isRead = null;
                if (isReadParam != null && !isReadParam.trim().isEmpty()) {
                    if (!"0".equals(isReadParam) && !"1".equals(isReadParam)) {
                        response.sendRedirect(request.getContextPath() + "/admin/notifications");
                        return;
                    }
                    isRead = Integer.parseInt(isReadParam);
                }

                List<Notifications> list = dao.getNotificationsForAdmin(keyword, type, isRead);
                request.setAttribute("NOTIFICATION_LIST", list);
                request.setAttribute("totalNotifications", list != null ? list.size() : 0);
                
                // Đẩy ngược lại giá trị cũ lên request để giữ trạng thái hiển thị trên Form tìm kiếm
                request.setAttribute("oldSearch", keyword);
                request.setAttribute("oldType", type);
                request.setAttribute("oldIsRead", isReadParam);

                request.getRequestDispatcher("/views/admin/notifications.jsp").forward(request, response);

            } else if ("mark-read".equals(action)) {
                // Luồng xử lý khi click xem/đọc một thông báo cụ thể -> Cập nhật trạng thái để TẮT CHẤM ĐỎ
                String notiIdParam = request.getParameter("id");
                if (!isInteger(notiIdParam)) {
                    response.sendRedirect(request.getContextPath() + "/NotificationController");
                    return;
                }
                int notiId = Integer.parseInt(notiIdParam);
                dao.markAsRead(notiId, userId);
                
                // Sau khi cập nhật xong, chuyển hướng reload lại chính trang danh sách thông báo
                response.sendRedirect("NotificationController");

            } else if ("mark-all-read".equals(action)) {
                dao.markAllAsRead(userId);
                response.sendRedirect("NotificationController");

            } else {
                // Luồng xử lý mặc định (Customer): Lấy danh sách thông báo cá nhân đổ vào icon chuông
                List<Notifications> userNotifications = dao.getNotificationsByUserId(userId);
                request.setAttribute("USER_NOTIFICATIONS", userNotifications);
                
                request.getRequestDispatcher("/views/auth/customer/notifications.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "Unable to load notifications. Details: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    // Chuyển tiếp toàn bộ yêu cầu phương thức POST sang xử lý tập trung tại hàm doGet
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
