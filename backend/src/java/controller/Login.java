package controller;

import dao.UserDAO;
import dto.User; // Import class User thay vì Customer
import java.io.IOException;

// Sử dụng các gói import của Java EE cũ (javax.servlet)
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

            // Chuyển hướng sang trang chủ index.jsp
            response.sendRedirect("profile.jsp");
            return; // <--- THÊM DÒNG NÀY ĐỂ DỪNG HÀM TẠI ĐÂY, KHÔNG CHẠY XUỐNG DƯỚI NỮA
        } else {
            // Đăng nhập thất bại
            request.setAttribute("ERROR", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            return; // <--- THÊM DÒNG NÀY ĐỂ ĐẢM BẢO AN TOÀN
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu người dùng cố tình truy cập link Servlet bằng phương thức GET, đưa họ về trang login
        response.sendRedirect("views/auth/login.jsp");
    }
}
