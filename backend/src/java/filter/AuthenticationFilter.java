/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package filter;

import dto.User;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author kieth
 */
@WebFilter(filterName = "AuthenticationFilter", servletNames = {"MainController"}, dispatcherTypes = {DispatcherType.REQUEST})
public class AuthenticationFilter implements Filter {

    private static final Set<String> PROTECTED_ACTIONS
            = new HashSet<>(Arrays.asList(
                    "booking",
                    "bookingSubmit",
                    "bookingHistory",
                    "profile",
                    "addVehicle",
                    "updateVehicle",
                    "loyaltyRewards"
            ));

    @Override
    public void doFilter(ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String action = req.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "home";
        }

        // Không cần đăng nhập
        if (!PROTECTED_ACTIONS.contains(action)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        User user = null;

        if (session != null) {
            user = (User) session.getAttribute("USER");
        }

        // Chưa đăng nhập
        if (user == null) {

            HttpSession newSession = req.getSession();

            String originalUrl = req.getRequestURI();

            if (req.getQueryString() != null) {
                originalUrl += "?" + req.getQueryString();
            }

            newSession.setAttribute(
                    "REDIRECT_AFTER_LOGIN",
                    originalUrl);

            resp.sendRedirect(
                    req.getContextPath()
                    + "/MainController?action=login");

            return;
        }

        // Đã đăng nhập
        chain.doFilter(request, response);
    }

}
