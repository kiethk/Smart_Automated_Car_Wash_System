<%@page import="dto.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User admin = (User) session.getAttribute("USER");

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");

    String avatarUrl = admin != null && admin.getAvatarUrl() != null && !admin.getAvatarUrl().trim().isEmpty()
            ? admin.getAvatarUrl()
            : request.getContextPath() + "/assets/images/avatar-placeholder.jpg";

    String createdAtText = "N/A";
    if (admin != null && admin.getCreatedAt() != null) {
        createdAtText = new SimpleDateFormat("dd/MM/yyyy").format(admin.getCreatedAt());
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/components/admin/adminHead.jsp" />
    </head>

    <body class="bg-slate-50 text-slate-900">
        <div class="flex min-h-screen">

            <jsp:include page="/components/admin/adminSidebar.jsp" />

            <div class="flex-1 min-w-0">
                <jsp:include page="/components/admin/adminTopbar.jsp" />

                <main class="p-6">
                    <div class="mb-6">
                        <h2 class="text-2xl font-extrabold text-slate-900">
                            Admin Profile
                        </h2>
                        <p class="text-sm text-slate-500 mt-1">
                            Manage your administrator account information.
                        </p>
                    </div>

                    <% if ("updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Profile updated successfully.
                    </div>
                    <% } %>

                    <% if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Could not update profile. Please check your input.
                    </div>
                    <% }%>

                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

                        <section class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 xl:col-span-1">
                            <div class="flex flex-col items-center text-center">
                                <div class="w-28 h-28 rounded-full overflow-hidden bg-slate-100 border border-slate-200">
                                    <img src="<%= avatarUrl%>"
                                         alt="Admin Avatar"
                                         class="w-full h-full object-cover">
                                </div>

                                <h3 class="text-xl font-extrabold text-slate-900 mt-4">
                                    <%= admin != null ? admin.getFullName() : "Admin User"%>
                                </h3>

                                <p class="text-sm text-slate-400 mt-1">
                                    <%= admin != null ? admin.getEmail() : "admin@autowash.com"%>
                                </p>

                                <div class="mt-5 inline-flex px-4 py-2 rounded-full bg-indigo-50 text-indigo-600 text-sm font-bold">
                                    Administrator
                                </div>
                            </div>

                            <div class="mt-6 space-y-3">
                                <div class="flex items-center justify-between rounded-2xl bg-slate-50 px-4 py-3">
                                    <span class="text-sm font-semibold text-slate-500">User ID</span>
                                    <span class="text-sm font-bold text-slate-900">
                                        #<%= admin != null ? admin.getUserId() : 0%>
                                    </span>
                                </div>

                                <div class="flex items-center justify-between rounded-2xl bg-slate-50 px-4 py-3">
                                    <span class="text-sm font-semibold text-slate-500">Role</span>
                                    <span class="text-sm font-bold text-slate-900">
                                        Admin
                                    </span>
                                </div>

                                <div class="flex items-center justify-between rounded-2xl bg-slate-50 px-4 py-3">
                                    <span class="text-sm font-semibold text-slate-500">Created</span>
                                    <span class="text-sm font-bold text-slate-900">
                                        <%= createdAtText%>
                                    </span>
                                </div>

                                <div class="flex items-center justify-between rounded-2xl bg-slate-50 px-4 py-3">
                                    <span class="text-sm font-semibold text-slate-500">Status</span>
                                    <% if (admin != null && admin.getIsActive() == 1) { %>
                                    <span class="text-sm font-bold text-emerald-600">
                                        Active
                                    </span>
                                    <% } else { %>
                                    <span class="text-sm font-bold text-red-500">
                                        Disabled
                                    </span>
                                    <% }%>
                                </div>
                            </div>
                        </section>

                        <section class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 xl:col-span-2">
                            <div class="mb-5">
                                <h3 class="text-lg font-bold text-slate-900">
                                    Profile Information
                                </h3>
                                <p class="text-sm text-slate-400 mt-1">
                                    Update basic admin account details.
                                </p>
                            </div>

                            <form action="${pageContext.request.contextPath}/admin/profile"
                                  method="post"
                                  class="space-y-5">

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Full Name
                                        </label>
                                        <input type="text"
                                               name="fullName"
                                               value="<%= admin != null && admin.getFullName() != null ? admin.getFullName() : ""%>"
                                               required
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Email
                                        </label>
                                        <input type="email"
                                               value="<%= admin != null && admin.getEmail() != null ? admin.getEmail() : ""%>"
                                               disabled
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm bg-slate-50 text-slate-400 outline-none">
                                        <p class="text-xs text-slate-400 mt-2">
                                            Email is used for login and cannot be changed here.
                                        </p>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Phone
                                        </label>
                                        <input type="text"
                                               name="phone"
                                               value="<%= admin != null && admin.getPhone() != null ? admin.getPhone() : ""%>"
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Avatar URL
                                        </label>
                                        <input type="text"
                                               name="avatarUrl"
                                               value="<%= admin != null && admin.getAvatarUrl() != null ? admin.getAvatarUrl() : ""%>"
                                               placeholder="https://..."
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>
                                </div>

                                <div class="flex justify-end gap-3 pt-3">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                                       class="inline-flex items-center justify-center px-5 py-3 rounded-2xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                        Back to Dashboard
                                    </a>

                                    <button type="submit"
                                            class="inline-flex items-center justify-center px-5 py-3 rounded-2xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                        Save Changes
                                    </button>
                                </div>
                            </form>
                        </section>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>