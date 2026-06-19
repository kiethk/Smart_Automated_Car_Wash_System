<%@page import="dto.Bay"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Bay> bays = (List<Bay>) request.getAttribute("BAYS");
    Bay editBay = (Bay) request.getAttribute("EDIT_BAY");
    
boolean isEditMode = editBay != null;

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
    

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
                    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-2xl font-extrabold text-slate-900">
                                Bay Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                Manage washing bays and maintenance status.
                            </p>
                        </div>

                        <a href="${pageContext.request.contextPath}/admin/bays"
                           class="inline-flex items-center justify-center px-4 py-2.5 rounded-2xl bg-slate-900 text-white text-sm font-bold hover:bg-slate-700 transition-all">
                            Reset Form
                        </a>
                    </div>

                    <% if ("created".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Bay created successfully.
                    </div>
                    <% } else if ("updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Bay updated successfully.
                    </div>
                    <% } else if ("status_updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Bay status updated successfully.
                    </div>
                    <% } %>

                    <% if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Something went wrong. Please check your input and try again.
                    </div>
                    <% }%>

                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

                        <%-- FORM --%>
                        <section class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 h-fit">
                            <h3 class="text-lg font-bold text-slate-900">
                                <%= isEditMode ? "Edit Bay" : "Add New Bay"%>
                            </h3>
                            <p class="text-sm text-slate-400 mt-1 mb-5">
                                Available bays can be assigned to new bookings.
                            </p>

                            <form action="${pageContext.request.contextPath}/admin/bays" method="post" class="space-y-4">
                                <input type="hidden" name="action" value="<%= isEditMode ? "update" : "create"%>">

                                <% if (isEditMode) {%>
                                <input type="hidden" name="bayId" value="<%= editBay.getBayId()%>">
                                <% }%>

                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">
                                        Bay Name
                                    </label>
                                    <input type="text"
                                           name="bayName"
                                           value="<%= isEditMode ? editBay.getBayName() : ""%>"
                                           required
                                           maxlength="50"
                                           placeholder="Example: Bay 01"
                                           class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                </div>

                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">
                                        Status
                                    </label>
                                    <select name="status"
                                            class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        <option value="available" <%= isEditMode && "available".equalsIgnoreCase(editBay.getStatus()) ? "selected" : ""%>>
                                            Available
                                        </option>
                                        <option value="maintenance" <%= isEditMode && "maintenance".equalsIgnoreCase(editBay.getStatus()) ? "selected" : ""%>>
                                            Maintenance
                                        </option>
                                    </select>
                                </div>

                                <button type="submit"
                                        class="w-full px-4 py-3 rounded-2xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                    <%= isEditMode ? "Update Bay" : "Create Bay"%>
                                </button>

                                <% if (isEditMode) { %>
                                <a href="${pageContext.request.contextPath}/admin/bays"
                                   class="block text-center px-4 py-3 rounded-2xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                    Cancel Edit
                                </a>
                                <% }%>
                            </form>
                        </section>

                        <%-- TABLE --%>
                        <section class="xl:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="px-5 py-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                                <div>
                                    <h3 class="text-lg font-bold text-slate-900">
                                        Bay List
                                    </h3>
                                    <p class="text-sm text-slate-400">
                                        Total: <%= bays != null ? bays.size() : 0%> bays
                                    </p>
                                </div>

                                <input type="text"
                                       id="baySearch"
                                       placeholder="Search bay..."
                                       onkeyup="filterBays()"
                                       class="w-full md:w-72 px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                            </div>

                            <div class="overflow-x-auto">
                                <table class="w-full text-sm">
                                    <thead class="bg-slate-50 text-slate-500">
                                        <tr>
                                            <th class="px-5 py-3 text-left font-bold">ID</th>
                                            <th class="px-5 py-3 text-left font-bold">Bay Name</th>
                                            <th class="px-5 py-3 text-center font-bold">Status</th>
                                            <th class="px-5 py-3 text-right font-bold">Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody id="bayTableBody" class="divide-y divide-slate-100">
                                        <% if (bays == null || bays.isEmpty()) { %>
                                        <tr>
                                            <td colspan="4" class="px-5 py-10 text-center text-slate-400">
                                                No bays found.
                                            </td>
                                        </tr>
                                        <% } else { %>

                                        <% for (Bay b : bays) {%>
                                        <tr class="bay-row hover:bg-slate-50 transition-colors">
                                            <td class="px-5 py-4 font-semibold text-slate-500">
                                                #<%= b.getBayId()%>
                                            </td>

                                            <td class="px-5 py-4">
                                                <p class="bay-name font-bold text-slate-900">
                                                    <%= b.getBayName()%>
                                                </p>
                                                <p class="text-xs text-slate-400 mt-1">
                                                    Used for automatic bay assignment
                                                </p>
                                            </td>

                                            <td class="px-5 py-4 text-center">
                                                <% if ("available".equalsIgnoreCase(b.getStatus())) { %>
                                                <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                    Available
                                                </span>
                                                <% } else { %>
                                                <span class="inline-flex px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">
                                                    Maintenance
                                                </span>
                                                <% }%>
                                            </td>

                                            <td class="px-5 py-4">
                                                <div class="flex items-center justify-end gap-2">
                                                    <a href="${pageContext.request.contextPath}/admin/bays?editId=<%= b.getBayId()%>"
                                                       class="px-3 py-2 rounded-xl bg-indigo-50 text-indigo-600 text-xs font-bold hover:bg-indigo-100 transition-all">
                                                        Edit
                                                    </a>

                                                    <form action="${pageContext.request.contextPath}/admin/bays"
                                                          method="post"
                                                          onsubmit="return confirm('Are you sure you want to change this bay status?');">
                                                        <input type="hidden" name="action" value="toggle">
                                                        <input type="hidden" name="bayId" value="<%= b.getBayId()%>">
                                                        <input type="hidden" name="status" value="<%= "available".equalsIgnoreCase(b.getStatus()) ? "maintenance" : "available"%>">

                                                        <button type="submit"
                                                                class="px-3 py-2 rounded-xl <%= "available".equalsIgnoreCase(b.getStatus()) ? "bg-amber-50 text-amber-600 hover:bg-amber-100" : "bg-emerald-50 text-emerald-600 hover:bg-emerald-100"%> text-xs font-bold transition-all">
                                                            <%= "available".equalsIgnoreCase(b.getStatus()) ? "Set Maintenance" : "Set Available"%>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } %>

                                        <% }%>
                                    </tbody>
                                </table>
                            </div>
                        </section>
                    </div>
                </main>
            </div>
        </div>

        <script>
            function filterBays() {
                const keyword = document.getElementById("baySearch").value.toLowerCase();
                const rows = document.querySelectorAll(".bay-row");

                rows.forEach(row => {
                    const name = row.querySelector(".bay-name").innerText.toLowerCase();

                    if (name.includes(keyword)) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            }
        </script>
    </body>

</html>
