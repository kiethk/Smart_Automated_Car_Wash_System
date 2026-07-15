<%@page import="dao.NotificationDAO"%>
<%@page import="dto.Notifications"%>
<%@page import="dto.User"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    private String escapeNotificationHtml(Object value) {
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
    User notificationUser = (User) session.getAttribute("USER");
    int notificationUnreadCount = 0;
    List<Notifications> notificationRecentList = Collections.emptyList();

    if (notificationUser != null) {
        Integer requestUnreadCount = (Integer) request.getAttribute("UNREAD_COUNT");
        if (requestUnreadCount != null) {
            notificationUnreadCount = requestUnreadCount;
        } else {
            try {
                NotificationDAO notificationDAO = new NotificationDAO();
                notificationUnreadCount = notificationDAO.countUnreadNotifications(notificationUser.getUserId());
            } catch (Exception e) {
                notificationUnreadCount = 0;
            }
        }

        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationRecentList = notificationDAO.getRecentNotificationsByUserId(notificationUser.getUserId(), 5);
        } catch (Exception e) {
            notificationRecentList = Collections.emptyList();
        }
    }

    boolean notificationUserIsAdmin = notificationUser != null && notificationUser.getRoleId() == 1;
    String notificationViewAllUrl = request.getContextPath()
            + (notificationUserIsAdmin ? "/admin/notifications" : "/NotificationController");
%>

<% if (notificationUser != null) { %>
<div class="relative flex items-center">
    <button type="button"
            onclick="toggleNotificationDropdown(event)"
            class="text-slate-600 hover:text-primary p-2 rounded-full hover:bg-slate-100 transition-all duration-200 focus:outline-none group"
            aria-label="Open notifications">

        <svg xmlns="http://www.w3.org/2000/svg"
             fill="none"
             viewBox="0 0 24 24"
             stroke-width="2"
             stroke="currentColor"
             class="w-6 h-6 transition-transform group-hover:rotate-12">
        <path stroke-linecap="round"
              stroke-linejoin="round"
              d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
        </svg>
    </button>

    <% if (notificationUnreadCount > 0) { %>
    <span class="absolute top-1.5 right-1.5 bg-red-500 text-white text-[10px] font-bold rounded-full min-w-[16px] h-4 px-1 flex items-center justify-center border-2 border-white select-none pointer-events-none animate-pulse">
        <%= notificationUnreadCount%>
    </span>
    <% } %>

    <div id="notification-dropdown" class="hidden absolute right-0 top-full mt-3 w-80 bg-white border border-surface-border rounded-xl shadow-xl overflow-hidden z-50">
        <div class="px-4 py-3 border-b border-surface-border flex items-center justify-between">
            <span class="text-sm font-bold text-slate-900">Notifications</span>
            <% if (notificationUnreadCount > 0) { %>
            <span class="text-[11px] font-bold text-primary"><%= notificationUnreadCount%> unread</span>
            <% } %>
        </div>

        <div class="max-h-80 overflow-y-auto">
            <% if (notificationRecentList != null && !notificationRecentList.isEmpty()) {
                for (Notifications noti : notificationRecentList) {
                    boolean notiUnread = noti.getIsRead() == 0;
            %>
            <div class="px-4 py-3 border-b border-slate-100 <%= notiUnread ? "bg-primary/5" : "bg-white"%>">
                <div class="flex gap-2">
                    <span class="mt-1.5 w-2 h-2 rounded-full shrink-0 <%= notiUnread ? "bg-red-500" : "bg-slate-300"%>"></span>
                    <div class="min-w-0 flex-1">
                        <p class="text-sm font-bold text-slate-900 truncate"><%= escapeNotificationHtml(noti.getTitle())%></p>
                        <p class="text-xs text-slate-500 mt-0.5 truncate"><%= escapeNotificationHtml(noti.getContent())%></p>
                        <p class="text-[11px] text-slate-400 mt-1"><%= escapeNotificationHtml(noti.getCreatedAt())%></p>
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

        <a href="<%= notificationViewAllUrl%>"
           class="block px-4 py-3 text-center text-sm font-bold text-primary hover:bg-slate-50 transition-colors">
            View all notifications
        </a>
    </div>
</div>

<script>
    window.toggleNotificationDropdown = window.toggleNotificationDropdown || function (event) {
        if (event) {
            event.stopPropagation();
        }

        var dropdown = document.getElementById('notification-dropdown');
        var userDropdown = document.getElementById('user-dropdown');

        if (userDropdown && !userDropdown.classList.contains('hidden')) {
            userDropdown.classList.add('hidden');
        }

        if (dropdown) {
            dropdown.classList.toggle('hidden');
        }
    };

    if (!window.notificationDropdownOutsideClickInitialized) {
        window.notificationDropdownOutsideClickInitialized = true;
        document.addEventListener('click', function (event) {
            var notificationDropdown = document.getElementById('notification-dropdown');
            if (notificationDropdown
                    && !notificationDropdown.classList.contains('hidden')
                    && !event.target.closest('#notification-dropdown')
                    && !event.target.closest('button')) {
                notificationDropdown.classList.add('hidden');
            }
        });
    }
</script>
<% } %>
