<%@page import="dto.Notifications"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }
        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Notification Management - Admin</title>
        <jsp:include page="/components/admin/adminHead.jsp" />
    </head>
    <body class="bg-slate-50 text-slate-900">
        <div class="flex min-h-screen">

            <jsp:include page="/components/admin/adminSidebar.jsp" />

            <div class="flex-1 min-w-0">
                <jsp:include page="/components/admin/adminTopbar.jsp" />

                <main class="p-6">
                    <div class="max-w-7xl mx-auto">
                        <div class="mb-8">
                            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">
                                Notification Management
                            </h1>
                            <p class="text-sm text-slate-500 mt-1">
                                View, search, and monitor all notifications sent by the system.
                            </p>
                        </div>

                        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm mb-6">
                            <form action="${pageContext.request.contextPath}/admin/notifications" method="GET" class="flex flex-wrap items-end gap-4">

                                <div class="flex-1 min-w-[260px]">
                                    <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1.5">
                                        Search keyword
                                    </label>
                                    <% String oldSearch = (String) request.getAttribute("oldSearch"); %>
                                    <input type="text"
                                           name="search"
                                           placeholder="Search by title or notification content..."
                                           value="<%= escapeHtml(oldSearch)%>"
                                           class="w-full text-sm border border-slate-200 rounded-xl px-4 py-2.5 bg-slate-50/50 focus:outline-none focus:border-primary focus:bg-white transition-colors"/>
                                </div>

                                <div class="w-48">
                                    <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1.5">
                                        Recipient type
                                    </label>
                                    <% String oldType = (String) request.getAttribute("oldType"); %>
                                    <select name="type" class="w-full text-sm border border-slate-200 rounded-xl px-3 py-2.5 focus:outline-none focus:border-primary bg-white transition-colors cursor-pointer">
                                        <option value="">All types</option>
                                        <option value="Customer" <%= "Customer".equals(oldType) ? "selected" : ""%>>Customer</option>
                                        <option value="Admin" <%= "Admin".equals(oldType) ? "selected" : ""%>>Admin</option>
                                    </select>
                                </div>

                                <div class="w-44">
                                    <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1.5">
                                        Read status
                                    </label>
                                    <% String oldIsRead = (String) request.getAttribute("oldIsRead"); %>
                                    <select name="isRead" class="w-full text-sm border border-slate-200 rounded-xl px-3 py-2.5 focus:outline-none focus:border-primary bg-white transition-colors cursor-pointer">
                                        <option value="">All statuses</option>
                                        <option value="0" <%= "0".equals(oldIsRead) ? "selected" : ""%>>Unread</option>
                                        <option value="1" <%= "1".equals(oldIsRead) ? "selected" : ""%>>Read</option>
                                    </select>
                                </div>

                                <div class="flex gap-2">
                                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold text-sm px-6 py-2.5 rounded-xl transition-colors shadow-sm shadow-blue-100">
                                        Search
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/notifications"
                                       class="bg-slate-100 hover:bg-slate-200 text-slate-600 font-semibold text-sm px-4 py-2.5 rounded-xl transition-colors inline-flex items-center">
                                        Clear filters
                                    </a>
                                </div>
                            </form>
                        </div>

                        <%
                            List<Notifications> adminList = (List<Notifications>) request.getAttribute("NOTIFICATION_LIST");
                            int totalNotifications = adminList != null ? adminList.size() : 0;
                        %>

                        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 px-6 py-4 border-b border-slate-100 bg-white">
                                <p class="text-sm text-slate-500">
                                    Total <span class="font-semibold text-slate-900"><%= totalNotifications%></span> notifications
                                </p>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full border-collapse text-left text-sm text-slate-600">
                                    <thead class="bg-slate-50 border-b border-slate-200 text-slate-700 font-bold tracking-wide">
                                        <tr>
                                            <th class="px-6 py-4">ID</th>
                                            <th class="px-6 py-4">User ID</th>
                                            <th class="px-6 py-4">Title</th>
                                            <th class="px-6 py-4">Content</th>
                                            <th class="px-6 py-4">Type</th>
                                            <th class="px-6 py-4">Status</th>
                                            <th class="px-6 py-4">Ref ID</th>
                                            <th class="px-6 py-4">Created at</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-100">
                                        <%
                                            if (adminList != null && !adminList.isEmpty()) {
                                                for (Notifications noti : adminList) {
                                        %>
                                        <tr class="hover:bg-slate-50/60 transition-colors">
                                            <td class="px-6 py-4 font-mono text-xs text-slate-400"><%= noti.getNotificationId()%></td>
                                            <td class="px-6 py-4 font-semibold text-slate-900"><%= noti.getUserId()%></td>
                                            <td class="px-6 py-4 font-bold text-slate-900 whitespace-nowrap"><%= escapeHtml(noti.getTitle())%></td>
                                            <td class="px-6 py-4 max-w-xs truncate text-slate-500" title="<%= escapeHtml(noti.getContent())%>">
                                                <%= escapeHtml(noti.getContent())%>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold <%= "Admin".equals(noti.getType()) ? "bg-amber-50 text-amber-700 border border-amber-200" : "bg-sky-50 text-sky-700 border border-sky-200"%>">
                                                    <%= escapeHtml(noti.getType())%>
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <% if (noti.getIsRead() == 1) { %>
                                                <span class="inline-flex items-center text-emerald-600 text-xs font-bold gap-1.5">
                                                    <span class="w-2 h-2 rounded-full bg-emerald-500"></span> Read
                                                </span>
                                                <% } else { %>
                                                <span class="inline-flex items-center text-rose-600 text-xs font-bold gap-1.5">
                                                    <span class="w-2 h-2 rounded-full bg-rose-500"></span> Unread
                                                </span>
                                                <% } %>
                                            </td>
                                            <td class="px-6 py-4 font-mono text-xs text-slate-400">
                                                <%= noti.getReferenceId() != null ? noti.getReferenceId() : "NULL"%>
                                            </td>
                                            <td class="px-6 py-4 text-xs text-slate-400 whitespace-nowrap"><%= escapeHtml(noti.getCreatedAt())%></td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="8" class="text-center py-14 text-slate-400 bg-slate-50/50">
                                                No notifications matched your filters.
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </main>
            </div>
        </div>

    </body>
</html>
