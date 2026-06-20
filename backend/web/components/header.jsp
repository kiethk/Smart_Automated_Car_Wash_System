<%@page import="dto.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<%
    User user = (User) session.getAttribute("USER");
    boolean isAdmin = user != null && user.getRoleId() == 1;

    String currentAction = request.getParameter("action");
    if (currentAction == null) {
        currentAction = "";
    }

    String dashboardClass = "dashboard".equals(currentAction)
            ? "text-primary after:w-full"
            : "text-on-surface-variant after:w-0 hover:text-primary hover:after:w-full";

    String bookingClass = "booking".equals(currentAction)
            ? "text-primary after:w-full"
            : "text-on-surface-variant after:w-0 hover:text-primary hover:after:w-full";

    String bookingHistoryClass = "bookingHistory".equals(currentAction)
            ? "text-primary after:w-full"
            : "text-on-surface-variant after:w-0 hover:text-primary hover:after:w-full";

    String loyaltyPointClass = "loyaltyPoint".equals(currentAction)
            ? "text-primary after:w-full"
            : "text-on-surface-variant after:w-0 hover:text-primary hover:after:w-full";
%>

<html lang="en" class="scroll-smooth">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoWash Pro</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">

        <jsp:include page="/components/head.jsp" />

    </head>
    <body class="bg-background text-on-background antialiased font-sans">
        <nav class="bg-[var(--surface-card)] border-b border-[var(--surface-border)] py-4 shadow-sm sticky top-0 z-50">
            <div class="max-w-[1280px] mx-auto px-4 md:px-16 flex justify-between items-center">

                <jsp:include page="/components/logo.jsp" />

                <%-- CENTER NAV LINKS --%>
                <%-- CENTER NAV LINKS - ONLY SHOW WHEN LOGGED IN --%>
                <% if (user != null && !isAdmin) {%>
                <div class="hidden lg:flex items-center gap-7">
                    <a href="${pageContext.request.contextPath}/MainController?action=dashboard"
                       class="relative text-sm font-semibold transition-all duration-200 after:content-[''] after:absolute after:left-0 after:-bottom-1.5 after:h-0.5 after:bg-primary after:rounded-full after:transition-all after:duration-200 <%= dashboardClass%>">
                        Dashboard
                    </a>

                    <a href="${pageContext.request.contextPath}/MainController?action=booking"
                       class="relative text-sm font-semibold transition-all duration-200 after:content-[''] after:absolute after:left-0 after:-bottom-1.5 after:h-0.5 after:bg-primary after:rounded-full after:transition-all after:duration-200 <%= bookingClass%>">
                        Booking
                    </a>

                    <a href="${pageContext.request.contextPath}/MainController?action=bookingHistory"
                       class="relative text-sm font-semibold transition-all duration-200 after:content-[''] after:absolute after:left-0 after:-bottom-1.5 after:h-0.5 after:bg-primary after:rounded-full after:transition-all after:duration-200 <%= bookingHistoryClass%>">
                        Booking History
                    </a>

                    <a href="${pageContext.request.contextPath}/MainController?action=loyaltyPoint"
                       class="relative text-sm font-semibold transition-all duration-200 after:content-[''] after:absolute after:left-0 after:-bottom-1.5 after:h-0.5 after:bg-primary after:rounded-full after:transition-all after:duration-200 <%= loyaltyPointClass%>">
                        Loyalty Point
                    </a>
                </div>
                <% } %>

                <div class="flex items-center space-x-6 relative">
                    <% if (user == null) { %>

                    <a href="${pageContext.request.contextPath}/MainController?action=register" class="text-sm font-medium text-primary">
                        Sign up
                    </a>

                    <a href="${pageContext.request.contextPath}/MainController?action=login" class="btn-primary py-2 px-4 text-sm">
                        Login
                    </a>

                    <% } else {%>

                    <div class="relative">
                        <button onclick="toggleDropdown()" class="flex items-center space-x-3 hover:opacity-80 transition-opacity focus:outline-none">
                            <span class="text-sm font-semibold text-on-background">
                                <%= user.getFullName() != null ? user.getFullName() : "User"%>
                            </span>
                            <div class="w-9 h-9 rounded-full border-2 border-primary/20 overflow-hidden bg-primary/10">
                                <img src="<%= (user.getAvatarUrl() != null && !user.getAvatarUrl().trim().isEmpty()) ? user.getAvatarUrl() : request.getContextPath() + "/assets/images/avatar-placeholder.jpg"%>" 
                                     alt="Avatar" 
                                     class="w-full h-full object-cover">
                            </div>
                        </button>

                        <div id="user-dropdown" class="overflow-hidden hidden absolute right-0 mt-2 w-48 bg-white border border-surface-border rounded-xl shadow-lg py-2 z-50">
                            <% if (isAdmin) { %>
                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                               class="block px-4 py-2 text-sm text-on-background hover:bg-slate-50 transition-colors">
                                Admin Dashboard
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/profile"
                               class="block px-4 py-2 text-sm text-on-background hover:bg-slate-50 transition-colors">
                                Admin Profile
                            </a>
                            <% } else { %>
                            <a href="${pageContext.request.contextPath}/profile"
                               class="block px-4 py-2 text-sm text-on-background hover:bg-slate-50 transition-colors">
                                My Profile
                            </a>
                            <% } %>
                            <hr class="my-1 border-surface-border">
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-error hover:bg-red-50 transition-colors">
                                Logout
                            </a>
                        </div>
                    </div>

                    <% }%>
                </div>
            </div>
        </nav>