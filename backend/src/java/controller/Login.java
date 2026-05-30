package controller;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "Login", urlPatterns = {"/Login"})
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUser(email, password);

        if (user != null) {
            // Đăng nhập thành công -> Lưu vào Session
            HttpSession session = request.getSession();
            session.setAttribute("USER", user);

            // Chuyển hướng sang trang profile
            response.sendRedirect(request.getContextPath() + "/views/auth/customer/profile.jsp");
            return; 
        } else {
            // Đăng nhập thất bại -> Đồng bộ gửi tên ERROR_MSG về cho JSP nhận diện
            request.setAttribute("ERROR_MSG", "Invalid email or password. Please try again.");
            
            // Thêm dấu / phía trước để đảm bảo chạy từ root của ứng dụng
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return; 
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu truy cập bằng GET, chuyển hướng thẳng về trang đăng nhập
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    }
}