package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import dao.WalletDAO;
import dto.Customer;
import dto.User;
import dto.Wallet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "Login", urlPatterns = {"/login"})
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        WalletDAO walletDAO = new WalletDAO();

        User user = userDAO.getUserByEmail(email);

        try {
            String hashedInputPassword = utils.PasswordUtils.hashSHA256(password);

            if (user != null && user.getPassword().equals(hashedInputPassword)) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("USER", user);

                // QUAN TRỌNG: Lấy thông tin Customer và lưu vào Session
                Customer customer = customerDAO.getCustomerByUserId(user.getUserId());
                if (customer != null) {
                    session.setAttribute("CUSTOMER", customer);
                }

                // Khi User login thành công
                Wallet wallet = walletDAO.getWalletByCustomerId(customer.getCustomerId());
                session.setAttribute("WALLET", wallet);

                response.sendRedirect(request.getContextPath() + "/MainController?action=dashboard");
            } else {
                request.setAttribute("ERROR_MSG", "Invalid email or password.");
                request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("ERROR_MSG", "System error: " + e.getMessage());
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
    }
}
