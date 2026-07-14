<%@page import="dto.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User adminUser = (User) session.getAttribute("USER");

    String adminName = adminUser != null && adminUser.getFullName() != null && !adminUser.getFullName().trim().isEmpty()
            ? adminUser.getFullName()
            : "Admin User";

    String adminEmail = adminUser != null && adminUser.getEmail() != null && !adminUser.getEmail().trim().isEmpty()
            ? adminUser.getEmail()
            : "admin@autowash.com";

    String adminAvatar = adminUser != null && adminUser.getAvatarUrl() != null && !adminUser.getAvatarUrl().trim().isEmpty()
            ? adminUser.getAvatarUrl()
            : request.getContextPath() + "/assets/images/avatar-placeholder.jpg";
%>

<header class="h-16 bg-white border-b border-slate-200 px-6 flex items-center justify-between sticky top-0 z-40">
    <div>
        <h1 class="text-lg font-bold text-slate-900">Admin Panel</h1>
        <p class="text-xs text-slate-400">Manage bookings, services, customers and promotions</p>
    </div>

    <div class="flex items-center gap-4">
        <jsp:include page="/components/notificationBell.jsp" />

        <a href="${pageContext.request.contextPath}/admin/profile"
           class="flex items-center gap-3 px-3 py-2 rounded-2xl hover:bg-slate-50 transition-all">

            <div class="text-right hidden sm:block">
                <p class="text-sm font-extrabold text-slate-900">
                    <%= adminName%>
                </p>
                <p class="text-xs text-slate-400">
                    <%= adminEmail%>
                </p>
            </div>

            <div class="w-11 h-11 rounded-full overflow-hidden bg-slate-100 border border-slate-200">
                <img src="<%= adminAvatar%>"
                     alt="Admin Avatar"
                     class="w-full h-full object-cover">
            </div>
        </a>
    </div>
</header>
