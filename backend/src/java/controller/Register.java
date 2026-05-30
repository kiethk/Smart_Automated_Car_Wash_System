package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import dto.Customer;
import dto.User;

import java.io.IOException;
import java.sql.Date;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "Register", urlPatterns = {"/register"})
public class Register extends HttpServlet {

    // ===== HANDLE GET: show register page =====
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp")
                .forward(request, response);
    }

    // ===== HANDLE POST: process registration =====
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ===== GET DATA =====
        String fullname = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // ===== VALIDATE: null / blank =====
        if (isNullOrBlank(fullname) || isNullOrBlank(email)
                || isNullOrBlank(password) || isNullOrBlank(confirmPassword)) {
            forwardWithError(request, response, "All fields are required!");
            return;
        }

        // ===== VALIDATE: email format =====
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            forwardWithError(request, response, "Invalid email format!");
            return;
        }

        // ===== VALIDATE: password length =====
        if (password.length() < 6) {
            forwardWithError(request, response,
                    "Password must be at least 6 characters!");
            return;
        }

        // ===== VALIDATE: confirm password =====
        if (!password.equals(confirmPassword)) {
            forwardWithError(request, response, "Passwords do not match!");
            return;
        }

        UserDAO userDAO = new UserDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        // ===== CHECK EMAIL DUPLICATE =====
        User foundUser = userDAO.getUserByEmail(email);
        if (foundUser != null) {
            forwardWithError(request, response, "Email already exists!");
            return;
        }

        // ===== HASH PASSWORD =====
        String hashedPassword;
        try {
            hashedPassword = hashSHA256(password);
        } catch (NoSuchAlgorithmException e) {
            forwardWithError(request, response,
                    "Server error, please try again!");
            return;
        }

        // ===== BUILD USER =====
        Date currentDate = new Date(System.currentTimeMillis());

        User u = new User();
        u.setFullName(fullname);
        u.setEmail(email);
        u.setPassword(hashedPassword);
        u.setPhone(null);
        u.setIsActive(1);
        u.setCreatedAt(currentDate);
        u.setRoleId(3);        // customer role
        u.setAvatarUrl(null);

// ===== INSERT USER =====
        int userResult = 0;
        try {
            userResult = userDAO.createNewUser(u);
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra Tomcat log
            forwardWithError(request, response, "DB Error: " + e.getMessage());
            return;
        }
        if (userResult <= 0) {
            forwardWithError(request, response, "Registration failed, please try again!");
            return;
        }

        // ===== GET INSERTED USER =====
        User insertedUser = userDAO.getUserByEmail(email);
        if (insertedUser == null) {
            forwardWithError(request, response, "Registration failed, please try again!");
            return;
        }

        // ===== BUILD CUSTOMER =====
        Customer c = new Customer();
        c.setUserId(insertedUser.getUserId());
        c.setAddress(null);
        c.setTotalPoints(0);
        c.setTotalSpent(0);
        c.setTotalWashes(0);
        c.setJoinDate(currentDate);
        c.setDateOfBirth(null);
        c.setTierId(1);
        c.setLastReviewDate(null);

        // ===== INSERT CUSTOMER =====
        int customerResult = customerDAO.createNewCustomer(c);
        if (customerResult <= 0) {
            // User đã insert thành công nhưng Customer thất bại
            // Cần rollback hoặc ít nhất báo lỗi rõ ràng
            forwardWithError(request, response,
                    "Registration failed at customer setup, please contact support!");
            return;
        }

        // ===== SUCCESS =====
        response.sendRedirect(
                request.getContextPath() + "/login"
        );
    }

    // ===== HELPER: forward với error message =====
    private void forwardWithError(HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/views/auth/register.jsp")
                .forward(request, response);
    }

    // ===== HELPER: check null or blank =====
    private boolean isNullOrBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    // ===== HELPER: hash SHA-256 =====
    private String hashSHA256(String input)
            throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashed = md.digest(input.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hashed) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
