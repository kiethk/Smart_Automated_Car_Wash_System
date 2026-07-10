/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package filter;

import dto.User;
import java.io.IOException;
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
@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/admin/*"}, dispatcherTypes = {DispatcherType.REQUEST})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        User user = null;

        if (session != null) {
            user = (User) session.getAttribute("USER");
        }

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/MainController?action=login");

            return;
        }

        if (user.getRoleId() != 1) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/MainController?action=dashboard");

            return;
        }

        chain.doFilter(request, response);
    }
}
