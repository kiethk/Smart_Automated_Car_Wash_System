<%@page import="dto.Notifications"%>
<%@page import="dto.User"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<%!
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }
        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

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

    // LOGIC ĐẾM THÔNG BÁO CHO CHẤM ĐỎ (JAVA THUÂN)
    int unreadCount = 0;
    List<Notifications> recentNotifications = Collections.emptyList();
    if (user != null) {
        Integer reqCount = (Integer) request.getAttribute("UNREAD_COUNT");
        if (reqCount != null) {
            unreadCount = reqCount;
        } else {
            try {
                // Tự động gọi DAO dự phòng nếu các Controller khác không truyền thuộc tính qua request
                dao.NotificationDAO notiDAO = new dao.NotificationDAO();
                unreadCount = notiDAO.countUnreadNotifications(user.getUserId());
                // LƯU Ý: Nếu trong class User.java của bạn đặt tên hàm lấy ID khác (vd: getId()), hãy sửa lại tên hàm trên nhé!
            } catch (Exception e) {
                unreadCount = 0;
            }
        }
        try {
            dao.NotificationDAO recentNotiDAO = new dao.NotificationDAO();
            recentNotifications = recentNotiDAO.getRecentNotificationsByUserId(user.getUserId(), 5);
        } catch (Exception e) {
            recentNotifications = Collections.emptyList();
        }
    }
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

                    <a href="${pageContext.request.contextPath}/MainController?action=loyaltyRewards"
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

                    <%-- ICON CHUÔNG THÔNG BÁO BẰNG SVG CAO CẤP --%>
                    <div class="relative flex items-center">
                        <button type="button"
                                onclick="toggleNotificationDropdown(event)"
                                class="text-slate-600 hover:text-primary p-2 rounded-full hover:bg-slate-100 transition-all duration-200 focus:outline-none group"
                                aria-label="Open notifications">

                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6 transition-transform group-hover:rotate-12">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
                            </svg>
                        </button>

                        <% if (unreadCount > 0) {%>
                        <span class="absolute top-1.5 right-1.5 bg-red-500 text-white text-[10px] font-bold rounded-full min-w-[16px] h-4 px-1 flex items-center justify-center border-2 border-[var(--surface-card)] select-none pointer-events-none animate-pulse">
                            <%= unreadCount%>
                        </span>
                        <% }%>
                        <div id="notification-dropdown" class="hidden absolute right-0 top-full mt-3 w-80 bg-white border border-surface-border rounded-xl shadow-xl overflow-hidden z-50">
                            <div class="px-4 py-3 border-b border-surface-border flex items-center justify-between">
                                <span class="text-sm font-bold text-slate-900">Notifications</span>
                                <% if (unreadCount > 0) {%>
                                <span class="text-[11px] font-bold text-primary"><%= unreadCount%> unread</span>
                                <% }%>
                            </div>

                            <div class="max-h-80 overflow-y-auto">
                                <% if (recentNotifications != null && !recentNotifications.isEmpty()) {
                                    for (Notifications noti : recentNotifications) {
                                        boolean notiUnread = noti.getIsRead() == 0;
                                %>
                                <div class="px-4 py-3 border-b border-slate-100 <%= notiUnread ? "bg-primary/5" : "bg-white"%>">
                                    <div class="flex gap-2">
                                        <span class="mt-1.5 w-2 h-2 rounded-full shrink-0 <%= notiUnread ? "bg-red-500" : "bg-slate-300"%>"></span>
                                        <div class="min-w-0 flex-1">
                                            <p class="text-sm font-bold text-slate-900 truncate"><%= escapeHtml(noti.getTitle())%></p>
                                            <p class="text-xs text-slate-500 mt-0.5 truncate"><%= escapeHtml(noti.getContent())%></p>
                                            <p class="text-[11px] text-slate-400 mt-1"><%= escapeHtml(noti.getCreatedAt())%></p>
                                        </div>
                                    </div>
                                </div>
                                <%  }
                                } else { %>
                                <div class="px-4 py-8 text-center text-sm text-slate-400">
                                    You do not have any notifications yet.
                                </div>
                                <% } %>
                            </div>

                            <a href="${pageContext.request.contextPath}/NotificationController"
                               class="block px-4 py-3 text-center text-sm font-bold text-primary hover:bg-slate-50 transition-colors">
                                View all notifications
                            </a>
                        </div>
                    </div>

                    <div class="relative">
                        <button onclick="toggleDropdown(event)" class="flex items-center space-x-3 hover:opacity-80 transition-opacity focus:outline-none">
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
