<%@page import="dto.User"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.AdminDashboardStats"%>
<%@page import="dto.AdminDashboardBookingView"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User admin = (User) session.getAttribute("USER");

    AdminDashboardStats stats = (AdminDashboardStats) request.getAttribute("STATS");
    List<AdminDashboardBookingView> todayBookings = (List<AdminDashboardBookingView>) request.getAttribute("TODAY_BOOKINGS");
    List<AdminDashboardBookingView> recentBookings = (List<AdminDashboardBookingView>) request.getAttribute("RECENT_BOOKINGS");

    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));

    if (stats == null) {
        stats = new AdminDashboardStats();
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
                            Dashboard
                        </h2>
                        <p class="text-sm text-slate-500 mt-1">
                            Welcome back, <%= admin != null ? admin.getFullName() : "Admin"%>. Here is your system overview.
                        </p>
                    </div>

                    <%-- SUMMARY CARDS --%>
                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5 mb-6">
                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Today Revenue</p>
                            <h3 class="text-2xl font-extrabold text-emerald-600 mt-3">
                                <%= currencyFormat.format(stats.getTodayRevenue())%> VND
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Paid payments today</p>
                        </div>

                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Today Bookings</p>
                            <h3 class="text-3xl font-extrabold text-slate-900 mt-3">
                                <%= stats.getTodayBookings()%>
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Scheduled bookings today</p>
                        </div>

                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Pending Bookings</p>
                            <h3 class="text-3xl font-extrabold text-amber-500 mt-3">
                                <%= stats.getPendingBookings()%>
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Need admin confirmation</p>
                        </div>

                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Unpaid Bookings</p>
                            <h3 class="text-3xl font-extrabold text-red-500 mt-3">
                                <%= stats.getUnpaidBookings()%>
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Pending or accepted but unpaid</p>
                        </div>

                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Month Revenue</p>
                            <h3 class="text-2xl font-extrabold text-indigo-600 mt-3">
                                <%= currencyFormat.format(stats.getMonthRevenue())%> VND
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Completed bookings this month</p>
                        </div>

                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Completed This Month</p>
                            <h3 class="text-3xl font-extrabold text-emerald-600 mt-3">
                                <%= stats.getCompletedThisMonth()%>
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Finished booking records</p>
                        </div>

                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Active Customers</p>
                            <h3 class="text-3xl font-extrabold text-blue-600 mt-3">
                                <%= stats.getActiveCustomers()%>
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Active customer accounts</p>
                        </div>

                        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Available Bays</p>
                            <h3 class="text-3xl font-extrabold text-slate-900 mt-3">
                                <%= stats.getAvailableBays()%>
                            </h3>
                            <p class="text-xs text-slate-400 mt-2">Ready for operation</p>
                        </div>
                    </div>


                    <%-- Today’s Bookings --%>
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden mb-6">
                        <div class="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
                            <div>
                                <h3 class="text-base font-bold text-slate-900">Today’s Bookings</h3>
                                <p class="text-xs text-slate-400 mt-1">Bookings scheduled for today</p>
                            </div>

                            <a href="${pageContext.request.contextPath}/admin/bookings"
                               class="text-sm font-semibold text-indigo-600 hover:text-indigo-700">
                                Manage
                            </a>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold">Time</th>
                                        <th class="px-5 py-3 text-left font-bold">Customer</th>
                                        <th class="px-5 py-3 text-left font-bold">Vehicle</th>
                                        <th class="px-5 py-3 text-left font-bold">Services</th>
                                        <th class="px-5 py-3 text-center font-bold">Payment</th>
                                        <th class="px-5 py-3 text-center font-bold">Status</th>
                                        <th class="px-5 py-3 text-right font-bold">Total</th>
                                    </tr>
                                </thead>

                                <tbody class="divide-y divide-slate-100">
                                    <% if (todayBookings == null || todayBookings.isEmpty()) { %>
                                    <tr>
                                        <td colspan="7" class="px-5 py-10 text-center text-slate-400">
                                            No bookings scheduled for today.
                                        </td>
                                    </tr>
                                    <% } else { %>
                                    <% for (AdminDashboardBookingView b : todayBookings) {
                                            String bookingStatus = b.getBookingStatus() != null ? b.getBookingStatus().toLowerCase() : "pending";
                                            String paymentStatus = b.getPaymentStatus() != null ? b.getPaymentStatus().toLowerCase() : "pending";
                                    %>
                                    <tr class="hover:bg-slate-50">
                                        <td class="px-5 py-4 font-bold text-slate-900">
                                            <%= b.getSlotTime() != null ? b.getSlotTime() : "No slot"%>
                                        </td>

                                        <td class="px-5 py-4">
                                            <p class="font-bold text-slate-900">
                                                <%= b.getCustomerName() != null ? b.getCustomerName() : "Unknown"%>
                                            </p>
                                            <p class="text-xs text-slate-400 mt-1">
                                                <%= b.getCustomerPhone() != null ? b.getCustomerPhone() : "No phone"%>
                                            </p>
                                        </td>

                                        <td class="px-5 py-4 font-semibold text-slate-700">
                                            <%= b.getPlateNumber() != null ? b.getPlateNumber() : "No plate"%>
                                        </td>

                                        <td class="px-5 py-4 text-slate-700">
                                            <%= b.getServiceNames() != null ? b.getServiceNames() : "No service"%>
                                        </td>

                                        <td class="px-5 py-4 text-center">
                                            <% if ("paid".equals(paymentStatus)) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                Paid
                                            </span>
                                            <% } else { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">
                                                Pending
                                            </span>
                                            <% }%>
                                        </td>

                                        <td class="px-5 py-4 text-center">
                                            <span class="inline-flex px-3 py-1 rounded-full bg-slate-100 text-slate-600 text-xs font-bold">
                                                <%= bookingStatus%>
                                            </span>
                                        </td>

                                        <td class="px-5 py-4 text-right font-extrabold text-slate-900">
                                            <%= currencyFormat.format(b.getTotalAmount())%> VND
                                        </td>
                                    </tr>
                                    <% } %>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <%-- CONTENT GRID --%>
                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
                        <section class="xl:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
                                <div>
                                    <h3 class="text-base font-bold text-slate-900">Recent Bookings</h3>
                                    <p class="text-xs text-slate-400 mt-1">Latest booking activities</p>
                                </div>

                                <a href="${pageContext.request.contextPath}/admin/bookings"
                                   class="text-sm font-semibold text-indigo-600 hover:text-indigo-700">
                                    View all
                                </a>
                            </div>

                            <div class="overflow-x-auto">
                                <table class="w-full text-sm">
                                    <thead class="bg-slate-50 text-slate-500">
                                        <tr>
                                            <th class="px-5 py-3 text-left font-bold">Booking ID</th>
                                            <th class="px-5 py-3 text-left font-bold">Customer</th>
                                            <th class="px-5 py-3 text-left font-bold">Date</th>
                                            <th class="px-5 py-3 text-left font-bold">Status</th>
                                            <th class="px-5 py-3 text-right font-bold">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-100">
                                        <% if (recentBookings == null || recentBookings.isEmpty()) { %>
                                        <tr>
                                            <td colspan="5" class="px-5 py-10 text-center text-slate-400">
                                                No recent bookings found.
                                            </td>
                                        </tr>
                                        <% } else { %>
                                        <% for (AdminDashboardBookingView b : recentBookings) {
                                                String bookingStatus = b.getBookingStatus() != null ? b.getBookingStatus().toLowerCase() : "pending";
                                        %>
                                        <tr class="hover:bg-slate-50">
                                            <td class="px-5 py-4 font-extrabold text-slate-900">
                                                #<%= b.getBookingId()%>
                                            </td>

                                            <td class="px-5 py-4">
                                                <p class="font-bold text-slate-900">
                                                    <%= b.getCustomerName() != null ? b.getCustomerName() : "Unknown"%>
                                                </p>
                                                <p class="text-xs text-slate-400 mt-1">
                                                    <%= b.getCustomerPhone() != null ? b.getCustomerPhone() : "No phone"%>
                                                </p>
                                            </td>

                                            <td class="px-5 py-4 text-slate-600">
                                                <%= b.getBookingDate() != null ? b.getBookingDate() : ""%>
                                            </td>

                                            <td class="px-5 py-4">
                                                <span class="inline-flex px-3 py-1 rounded-full bg-slate-100 text-slate-600 text-xs font-bold">
                                                    <%= bookingStatus%>
                                                </span>
                                            </td>

                                            <td class="px-5 py-4 text-right font-extrabold text-slate-900">
                                                <%= currencyFormat.format(b.getTotalAmount())%> VND
                                            </td>
                                        </tr>
                                        <% } %>
                                        <% }%>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                        <section class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 mt-6">
                            <h3 class="text-base font-bold text-slate-900">System Overview</h3>
                            <p class="text-xs text-slate-400 mt-1 mb-4">Current operational resources</p>

                            <div class="space-y-3">
                                <div class="flex items-center justify-between px-4 py-3 rounded-2xl bg-slate-50">
                                    <span class="text-sm font-semibold text-slate-600">Active Services</span>
                                    <span class="text-sm font-extrabold text-slate-900"><%= stats.getActiveServices()%></span>
                                </div>

                                <div class="flex items-center justify-between px-4 py-3 rounded-2xl bg-slate-50">
                                    <span class="text-sm font-semibold text-slate-600">Active Promotions</span>
                                    <span class="text-sm font-extrabold text-slate-900"><%= stats.getActivePromotions()%></span>
                                </div>

                                <div class="flex items-center justify-between px-4 py-3 rounded-2xl bg-slate-50">
                                    <span class="text-sm font-semibold text-slate-600">Active Slots</span>
                                    <span class="text-sm font-extrabold text-slate-900"><%= stats.getActiveSlots()%></span>
                                </div>

                                <div class="flex items-center justify-between px-4 py-3 rounded-2xl bg-slate-50">
                                    <span class="text-sm font-semibold text-slate-600">Maintenance Bays</span>
                                    <span class="text-sm font-extrabold text-red-500"><%= stats.getMaintenanceBays()%></span>
                                </div>
                            </div>
                        </section>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>