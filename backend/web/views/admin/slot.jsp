<%@page import="dto.Slot"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Slot> slots = (List<Slot>) request.getAttribute("SLOTS");
    Slot editSlot = (Slot) request.getAttribute("EDIT_SLOT");

    boolean isEditMode = editSlot != null;

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
                                Slot Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                Manage booking time slots for customers.
                            </p>
                        </div>

                        <a href="${pageContext.request.contextPath}/admin/slots"
                           class="inline-flex items-center justify-center px-4 py-2.5 rounded-2xl bg-slate-900 text-white text-sm font-bold hover:bg-slate-700 transition-all">
                            Reset Form
                        </a>
                    </div>

                    <% if ("created".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Slot created successfully.
                    </div>
                    <% } else if ("updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Slot updated successfully.
                    </div>
                    <% } else if ("status_updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Slot status updated successfully.
                    </div>
                    <% } %>

                    <% if ("invalid_time".equals(error)) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Invalid time range. End time must be later than start time.
                    </div>
                    <% } else if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Something went wrong. Please check your input and try again.
                    </div>
                    <% }%>

                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

                        <%-- FORM --%>
                        <section class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 h-fit">
                            <h3 class="text-lg font-bold text-slate-900">
                                <%= isEditMode ? "Edit Slot" : "Add New Slot"%>
                            </h3>
                            <p class="text-sm text-slate-400 mt-1 mb-5">
                                Active slots will be shown on the customer booking page.
                            </p>

                            <form action="${pageContext.request.contextPath}/admin/slots" method="post" class="space-y-4">
                                <input type="hidden" name="action" value="<%= isEditMode ? "update" : "create"%>">

                                <% if (isEditMode) {%>
                                <input type="hidden" name="slotId" value="<%= editSlot.getSlotId()%>">
                                <% }%>

                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">
                                        Start Time
                                    </label>
                                    <input type="time"
                                           name="startTime"
                                           value="<%= isEditMode ? editSlot.getStartTime().substring(0, 5) : ""%>"
                                           required
                                           class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                </div>

                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">
                                        End Time
                                    </label>
                                    <input type="time"
                                           name="endTime"
                                           value="<%= isEditMode ? editSlot.getEndTime().substring(0, 5) : ""%>"
                                           required
                                           class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                </div>

                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">
                                        Status
                                    </label>
                                    <select name="isActive"
                                            class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        <option value="1" <%= isEditMode && editSlot.getIsActive() == 1 ? "selected" : ""%>>
                                            Active
                                        </option>
                                        <option value="0" <%= isEditMode && editSlot.getIsActive() == 0 ? "selected" : ""%>>
                                            Inactive
                                        </option>
                                    </select>
                                </div>

                                <button type="submit"
                                        class="w-full px-4 py-3 rounded-2xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                    <%= isEditMode ? "Update Slot" : "Create Slot"%>
                                </button>

                                <% if (isEditMode) { %>
                                <a href="${pageContext.request.contextPath}/admin/slots"
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
                                        Slot List
                                    </h3>
                                    <p class="text-sm text-slate-400">
                                        Total: <%= slots != null ? slots.size() : 0%> slots
                                    </p>
                                </div>

                                <input type="text"
                                       id="slotSearch"
                                       placeholder="Search slot..."
                                       onkeyup="filterSlots()"
                                       class="w-full md:w-72 px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                            </div>

                            <div class="overflow-x-auto">
                                <table class="w-full text-sm">
                                    <thead class="bg-slate-50 text-slate-500">
                                        <tr>
                                            <th class="px-5 py-3 text-left font-bold">ID</th>
                                            <th class="px-5 py-3 text-left font-bold">Time Range</th>
                                            <th class="px-5 py-3 text-center font-bold">Duration</th>
                                            <th class="px-5 py-3 text-center font-bold">Status</th>
                                            <th class="px-5 py-3 text-right font-bold">Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody id="slotTableBody" class="divide-y divide-slate-100">
                                        <% if (slots == null || slots.isEmpty()) { %>
                                        <tr>
                                            <td colspan="5" class="px-5 py-10 text-center text-slate-400">
                                                No slots found.
                                            </td>
                                        </tr>
                                        <% } else { %>

                                        <% for (Slot s : slots) {
                                                String displayStart = s.getStartTime() != null && s.getStartTime().length() >= 5
                                                        ? s.getStartTime().substring(0, 5)
                                                        : s.getStartTime();

                                                String displayEnd = s.getEndTime() != null && s.getEndTime().length() >= 5
                                                        ? s.getEndTime().substring(0, 5)
                                                        : s.getEndTime();

                                                String displayRange = displayStart + " - " + displayEnd;

                                                int durationMinutes = 0;
                                                try {
                                                    String[] startParts = displayStart.split(":");
                                                    String[] endParts = displayEnd.split(":");

                                                    int startTotalMinutes = Integer.parseInt(startParts[0]) * 60 + Integer.parseInt(startParts[1]);
                                                    int endTotalMinutes = Integer.parseInt(endParts[0]) * 60 + Integer.parseInt(endParts[1]);

                                                    durationMinutes = endTotalMinutes - startTotalMinutes;
                                                } catch (Exception ex) {
                                                    durationMinutes = 0;
                                                }
                                        %>

                                        <tr class="slot-row hover:bg-slate-50 transition-colors">
                                            <td class="px-5 py-4 font-semibold text-slate-500">
                                                #<%= s.getSlotId()%>
                                            </td>

                                            <td class="px-5 py-4">
                                                <div class="flex items-center gap-3">

                                                    <div>
                                                        <p class="slot-name font-extrabold text-slate-900">
                                                            <%= displayRange%>
                                                        </p>
                                                        <p class="text-xs text-slate-400 mt-1">
                                                            Booking slot
                                                        </p>
                                                    </div>
                                                </div>
                                            </td>

                                            <td class="px-5 py-4 text-center">
                                                <span class="inline-flex px-3 py-1 rounded-full bg-slate-100 text-slate-600 text-xs font-bold">
                                                    <%= durationMinutes > 0 ? durationMinutes + " min" : "N/A"%>
                                                </span>
                                            </td>

                                            <td class="px-5 py-4 text-center">
                                                <% if (s.getIsActive() == 1) { %>
                                                <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                    Active
                                                </span>
                                                <% } else { %>
                                                <span class="inline-flex px-3 py-1 rounded-full bg-slate-100 text-slate-500 text-xs font-bold">
                                                    Inactive
                                                </span>
                                                <% }%>
                                            </td>

                                            <td class="px-5 py-4">
                                                <div class="flex items-center justify-end gap-2">
                                                    <a href="${pageContext.request.contextPath}/admin/slots?editId=<%= s.getSlotId()%>"
                                                       class="px-3 py-2 rounded-xl bg-indigo-50 text-indigo-600 text-xs font-bold hover:bg-indigo-100 transition-all">
                                                        Edit
                                                    </a>

                                                    <form action="${pageContext.request.contextPath}/admin/slots"
                                                          method="post"
                                                          onsubmit="return confirm('Are you sure you want to change this slot status?');">
                                                        <input type="hidden" name="action" value="toggle">
                                                        <input type="hidden" name="slotId" value="<%= s.getSlotId()%>">
                                                        <input type="hidden" name="isActive" value="<%= s.getIsActive() == 1 ? 0 : 1%>">

                                                        <button type="submit"
                                                                class="px-3 py-2 rounded-xl <%= s.getIsActive() == 1 ? "bg-red-50 text-red-500 hover:bg-red-100" : "bg-emerald-50 text-emerald-600 hover:bg-emerald-100"%> text-xs font-bold transition-all">
                                                            <%= s.getIsActive() == 1 ? "Disable" : "Enable"%>
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
            function filterSlots() {
                const keyword = document.getElementById("slotSearch").value.toLowerCase();
                const rows = document.querySelectorAll(".slot-row");

                rows.forEach(row => {
                    const name = row.querySelector(".slot-name").innerText.toLowerCase();

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