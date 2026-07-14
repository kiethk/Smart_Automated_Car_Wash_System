package controller;

import dao.NotificationDAO;
import dto.Notifications;
import dto.User; // Import lớp User từ package dto để lấy dữ liệu session
import java.io.IOException;
import java.sql.Date;
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

    private Date parseSqlDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Date.valueOf(value.trim());
        } catch (IllegalArgumentException e) {
            return null;
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
            boolean isCreateNotifications = "create-notifications".equals(action);
            boolean isAdminNotificationPage = "admin-list".equals(action)
                    || requestUri.endsWith(request.getContextPath() + "/admin/notifications")
                    || requestUri.endsWith("/admin/notifications");
            NotificationDAO dao = new NotificationDAO();

            // Luôn luôn chạy: Đếm số thông báo chưa đọc để phục vụ logic hiển thị chấm đỏ ở Header
            int unreadCount = dao.countUnreadNotifications(userId);
            request.setAttribute("UNREAD_COUNT", unreadCount);

            // 2. Phân nhánh xử lý theo tham số action được gửi lên
            if (isCreateNotifications) {
                if (user.getRoleId() != 1) {
                    request.setAttribute("ERROR_MSG", "You do not have permission to access this page.");
                    request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                    return;
                }

                String title = request.getParameter("notificationTitle");
                String content = request.getParameter("notificationContent");
                String recipientGroup = request.getParameter("recipientGroup");

                if (title == null || title.trim().isEmpty() || title.trim().length() > 200
                        || content == null || content.trim().isEmpty()
                        || recipientGroup == null
                        || (!"customers".equals(recipientGroup) && !"admins".equals(recipientGroup) && !"all".equals(recipientGroup))) {
                    response.sendRedirect(request.getContextPath() + "/admin/notifications?notificationStatus=invalid");
                    return;
                }

                int createdCount = dao.createNotifications(title.trim(), content.trim(), recipientGroup);
                response.sendRedirect(request.getContextPath() + "/admin/notifications?notificationStatus="
                        + (createdCount > 0 ? "created" : "failed")
                        + "&createdCount=" + createdCount);
                return;

            } else if (isAdminNotificationPage) {
                if (user.getRoleId() != 1) {
                    request.setAttribute("ERROR_MSG", "You do not have permission to access this page.");
                    request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                    return;
                }

                // Luồng xử lý dành cho Admin: Xem danh sách tổng hợp, tìm kiếm và lọc dữ liệu
                String keyword = request.getParameter("search");
                String type = request.getParameter("type");
                String isReadParam = request.getParameter("isRead");
                String fromDateParam = request.getParameter("fromDate");
                String toDateParam = request.getParameter("toDate");
                
                Integer isRead = null;
                if (isReadParam != null && !isReadParam.trim().isEmpty()) {
                    if (!"0".equals(isReadParam) && !"1".equals(isReadParam)) {
                        response.sendRedirect(request.getContextPath() + "/admin/notifications");
                        return;
                    }
                    isRead = Integer.parseInt(isReadParam);
                }

                Date fromDate = parseSqlDate(fromDateParam);
                Date toDate = parseSqlDate(toDateParam);
                if ((fromDateParam != null && !fromDateParam.trim().isEmpty() && fromDate == null)
                        || (toDateParam != null && !toDateParam.trim().isEmpty() && toDate == null)
                        || (fromDate != null && toDate != null && fromDate.after(toDate))) {
                    response.sendRedirect(request.getContextPath() + "/admin/notifications");
                    return;
                }

                List<Notifications> list = dao.getNotificationsForAdmin(keyword, type, isRead, fromDate, toDate);
                request.setAttribute("NOTIFICATION_LIST", list);
                request.setAttribute("totalNotifications", list != null ? list.size() : 0);
                
                // Đẩy ngược lại giá trị cũ lên request để giữ trạng thái hiển thị trên form tìm kiếm
                request.setAttribute("oldSearch", keyword);
                request.setAttribute("oldType", type);
                request.setAttribute("oldIsRead", isReadParam);
                request.setAttribute("oldFromDate", fromDateParam);
                request.setAttribute("oldToDate", toDateParam);

                request.getRequestDispatcher("/views/admin/notifications.jsp").forward(request, response);

            } else if ("mark-read".equals(action)) {
                // Luồng xử lý khi người dùng đánh dấu một thông báo là đã đọc
                if (!"POST".equalsIgnoreCase(request.getMethod())) {
                    response.sendRedirect(request.getContextPath() + "/NotificationController");
                    return;
                }

                String notiIdParam = request.getParameter("id");
                if (!isInteger(notiIdParam)) {
                    response.sendRedirect(request.getContextPath() + "/NotificationController");
                    return;
                }
                int notiId = Integer.parseInt(notiIdParam);
                dao.markAsRead(notiId, userId);
                
                // Sau khi cập nhật xong, chuyển hướng reload lại chính trang danh sách thông báo
                response.sendRedirect(request.getContextPath() + "/NotificationController");

            } else if ("mark-all-read".equals(action)) {
                if (!"POST".equalsIgnoreCase(request.getMethod())) {
                    response.sendRedirect(request.getContextPath() + "/NotificationController");
                    return;
                }

                dao.markAllAsRead(userId);
                response.sendRedirect(request.getContextPath() + "/NotificationController");

            } else {
                // Luồng xử lý mặc định của Customer: Lấy danh sách thông báo cá nhân
                List<Notifications> userNotifications = dao.getNotificationsByUserId(userId);
                request.setAttribute("USER_NOTIFICATIONS", userNotifications);
                
                request.getRequestDispatcher("/views/auth/customer/notifications.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "Unable to load notifications. Please try again later.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    // Chuyển tiếp toàn bộ yêu cầu POST sang xử lý tập trung tại hàm doGet
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
