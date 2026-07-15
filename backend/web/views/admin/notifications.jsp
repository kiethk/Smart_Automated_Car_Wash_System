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
                    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-2xl font-extrabold text-slate-900">
                                Notification Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                View, search, and monitor all notifications sent by the system.
                            </p>
                        </div>

                        <a href="${pageContext.request.contextPath}/admin/notifications"
                           class="inline-flex items-center justify-center px-4 py-2.5 rounded-2xl bg-slate-900 text-white text-sm font-bold hover:bg-slate-700 transition-all">
                            Reset Form
                        </a>
                    </div>

                    <div class="max-w-7xl mx-auto">

                        <%
                            String notificationStatus = request.getParameter("notificationStatus");
                            String createdCount = request.getParameter("createdCount");
                            boolean showNotificationForm = "invalid".equals(notificationStatus) || "failed".equals(notificationStatus);
                            String oldSearch = (String) request.getAttribute("oldSearch");
                            String oldType = (String) request.getAttribute("oldType");
                            String oldIsRead = (String) request.getAttribute("oldIsRead");
                            String oldFromDate = (String) request.getAttribute("oldFromDate");
                            String oldToDate = (String) request.getAttribute("oldToDate");
                            boolean showFilterPanel = (oldSearch != null && !oldSearch.trim().isEmpty())
                                    || (oldType != null && !oldType.trim().isEmpty())
                                    || (oldIsRead != null && !oldIsRead.trim().isEmpty())
                                    || (oldFromDate != null && !oldFromDate.trim().isEmpty())
                                    || (oldToDate != null && !oldToDate.trim().isEmpty());
                            if ("created".equals(notificationStatus)) {
                        %>
                        <div class="mb-6 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-700">
                            Notifications were sent successfully<%= createdCount != null ? " to " + escapeHtml(createdCount) + " recipient(s)" : ""%>.
                        </div>
                        <% } else if ("invalid".equals(notificationStatus)) { %>
                        <div class="mb-6 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm font-semibold text-amber-700">
                            Please enter a title, content, and valid recipient group. Title must be 200 characters or fewer.
                        </div>
                        <% } else if ("failed".equals(notificationStatus)) { %>
                        <div class="mb-6 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-semibold text-rose-700">
                            Notifications could not be sent. Please check whether active users exist for the selected group.
                        </div>
                        <% } %>

                        <div id="notification-form-panel" class="<%= showNotificationForm ? "" : "hidden "%>bg-white p-5 rounded-2xl border border-slate-200 shadow-sm mb-6">
                            <form action="${pageContext.request.contextPath}/admin/notifications" method="POST" class="space-y-4">
                                <input type="hidden" name="action" value="create-notifications" />

                                <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
                                    <div class="lg:col-span-2">
                                        <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1.5">
                                            Title
                                        </label>
                                        <input type="text"
                                               name="notificationTitle"
                                               maxlength="200"
                                               required
                                               placeholder="Important system notification"
                                               class="w-full text-sm border border-slate-200 rounded-xl px-4 py-2.5 bg-slate-50/50 focus:outline-none focus:border-primary focus:bg-white transition-colors"/>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1.5">
                                            Send to
                                        </label>
                                        <select name="recipientGroup"
                                                required
                                                class="w-full text-sm border border-slate-200 rounded-xl px-3 py-2.5 focus:outline-none focus:border-primary bg-white transition-colors cursor-pointer">
                                            <option value="customers">All Customers</option>
                                            <option value="admins">All Admins</option>
                                            <option value="all">All Users</option>
                                        </select>
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-1.5">
                                        Content
                                    </label>
                                    <textarea name="notificationContent"
                                              rows="4"
                                              required
                                              placeholder="Write the notification content..."
                                              class="w-full text-sm border border-slate-200 rounded-xl px-4 py-2.5 bg-slate-50/50 focus:outline-none focus:border-primary focus:bg-white transition-colors resize-y"></textarea>
                                </div>

                                <div class="flex flex-wrap justify-end gap-2">
                                    <button type="button"
                                            onclick="toggleNotificationForm()"
                                            class="bg-slate-100 hover:bg-slate-200 text-slate-600 font-semibold text-sm px-4 py-2.5 rounded-xl transition-colors">
                                        Cancel
                                    </button>
                                    <button type="submit"
                                            class="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm px-5 py-2.5 rounded-xl transition-colors shadow-sm shadow-indigo-100">
                                        Send Notifications
                                    </button>
                                </div>
                            </form>
                        </div>

                        <div id="notification-filter-panel" class="<%= showFilterPanel ? "" : "hidden "%>bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden mb-6">
                            <div class="px-5 py-4 border-b border-slate-100 flex flex-col gap-4">
                                <div>
                                    <h3 class="text-lg font-bold text-slate-900">
                                        Filter Notifications
                                    </h3>
                                    <p class="text-sm text-slate-400">
                                        Search and filter all notification records.
                                    </p>
                                </div>

                                <form action="${pageContext.request.contextPath}/admin/notifications" method="GET" class="w-full space-y-3">
                                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-3">
                                    <input type="text"
                                           name="search"
                                           placeholder="Search by title or notification content..."
                                           value="<%= escapeHtml(oldSearch)%>"
                                           oninput="submitNotificationFilterWithDelay(this.form)"
                                           class="xl:col-span-2 w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50"/>

                                    <select name="type"
                                            onchange="submitNotificationFilter(this.form)"
                                            class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        <option value="">All types</option>
                                        <option value="Customer" <%= "Customer".equals(oldType) ? "selected" : ""%>>Customer</option>
                                        <option value="Admin" <%= "Admin".equals(oldType) ? "selected" : ""%>>Admin</option>
                                        <option value="System" <%= "System".equals(oldType) ? "selected" : ""%>>System</option>
                                    </select>

                                    <select name="isRead"
                                            onchange="submitNotificationFilter(this.form)"
                                            class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        <option value="">All statuses</option>
                                        <option value="0" <%= "0".equals(oldIsRead) ? "selected" : ""%>>Unread</option>
                                        <option value="1" <%= "1".equals(oldIsRead) ? "selected" : ""%>>Read</option>
                                    </select>

                                    <a href="${pageContext.request.contextPath}/admin/notifications"
                                       class="inline-flex items-center justify-center w-full px-3 py-2.5 rounded-xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                        Clear Filters
                                    </a>
                                    </div>

                                    <div class="rounded-2xl bg-slate-50 border border-slate-200 p-3">
                                        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-3 items-end">
                                            <div>
                                                <label class="block text-xs font-bold text-slate-500 mb-1">
                                                    From date
                                                </label>
                                                <input type="date"
                                                       name="fromDate"
                                                       value="<%= escapeHtml(oldFromDate)%>"
                                                       onchange="submitNotificationFilter(this.form)"
                                                       class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none bg-white focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50"/>
                                            </div>

                                            <div>
                                                <label class="block text-xs font-bold text-slate-500 mb-1">
                                                    To date
                                                </label>
                                                <input type="date"
                                                       name="toDate"
                                                       value="<%= escapeHtml(oldToDate)%>"
                                                       onchange="submitNotificationFilter(this.form)"
                                                       class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none bg-white focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50"/>
                                            </div>

                                            <div class="xl:col-span-2">
                                                <p class="text-xs text-slate-400 leading-relaxed flex-1">
                                                    Choose <strong>From date</strong> only to filter from that date until now.
                                                    Choose both <strong>From date</strong> and <strong>To date</strong> to filter a specific range.
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <%
                            List<Notifications> adminList = (List<Notifications>) request.getAttribute("NOTIFICATION_LIST");
                            int totalNotifications = adminList != null ? adminList.size() : 0;
                        %>

                        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 px-6 py-4 border-b border-slate-100 bg-white">
                                <p class="text-sm text-slate-500">
                                    Total <span class="font-semibold text-slate-900"><%= totalNotifications%></span> notifications
                                </p>
                                <div class="flex flex-col sm:flex-row gap-2 w-full sm:w-auto">
                                    <button type="button"
                                            onclick="toggleNotificationForm()"
                                            class="inline-flex items-center justify-center bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm px-4 py-2.5 rounded-xl transition-colors shadow-sm shadow-indigo-100">
                                        Create Notifications
                                    </button>
                                    <button type="button"
                                            onclick="toggleNotificationFilter()"
                                            class="inline-flex items-center justify-center bg-white hover:bg-slate-50 text-slate-700 border border-slate-200 font-semibold text-sm px-4 py-2.5 rounded-xl transition-colors">
                                        Filter
                                    </button>
                                </div>
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
                                                <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold <%= "Admin".equals(noti.getType()) ? "bg-amber-50 text-amber-700 border border-amber-200" : ("System".equals(noti.getType()) ? "bg-violet-50 text-violet-700 border border-violet-200" : "bg-sky-50 text-sky-700 border border-sky-200")%>">
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

        <script>
            function toggleNotificationForm() {
                var panel = document.getElementById('notification-form-panel');
                if (panel) {
                    panel.classList.toggle('hidden');
                }
            }

            function toggleNotificationFilter() {
                var panel = document.getElementById('notification-filter-panel');
                if (panel) {
                    panel.classList.toggle('hidden');
                }
            }

            var notificationFilterTimer;

            function submitNotificationFilter(form) {
                if (form) {
                    form.submit();
                }
            }

            function submitNotificationFilterWithDelay(form) {
                clearTimeout(notificationFilterTimer);
                notificationFilterTimer = setTimeout(function () {
                    submitNotificationFilter(form);
                }, 500);
            }
        </script>
    </body>
</html>
