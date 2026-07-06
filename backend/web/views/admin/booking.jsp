<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.AdminBookingView"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
    List<AdminBookingView> bookings = (List<AdminBookingView>) request.getAttribute("BOOKINGS");
    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));

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
                                Booking Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                Manage booking status, payment confirmation and service completion.
                            </p>
                        </div>

                        <div class="px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-sm font-bold text-slate-700">
                            Total: <%= bookings != null ? bookings.size() : 0%> bookings
                        </div>
                    </div>

                    <% if (msg != null) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Booking action completed successfully.
                    </div>
                    <% } %>

                    <% if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Action failed. Please check booking status and payment status.
                    </div>
                    <% } %>

                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-slate-100 flex flex-col gap-4">
                            <div>
                                <h3 class="text-lg font-bold text-slate-900">
                                    Booking List
                                </h3>
                                <p class="text-sm text-slate-400">
                                    Search and filter all booking records.
                                </p>
                            </div>

                            <div class="w-full space-y-3">

                                <!-- Search + Status Filters -->
                                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-3">

                                    <input type="text"
                                           id="bookingSearch"
                                           placeholder="Search customer, phone, plate, service..."
                                           onkeyup="filterBookings()"
                                           class="xl:col-span-2 w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">

                                    <select id="bookingStatusFilter"
                                            onchange="filterBookings()"
                                            class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        <option value="all">All Booking Status</option>
                                        <option value="pending">Pending</option>
                                        <option value="accepted">Accepted</option>
                                        <option value="completed">Completed</option>
                                        <option value="cancelled">Cancelled</option>
                                    </select>

                                    <select id="paymentStatusFilter"
                                            onchange="filterBookings()"
                                            class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        <option value="all">All Payment</option>
                                        <option value="pending">Pending</option>
                                        <option value="paid">Paid</option>
                                        <option value="failed">Failed</option>
                                        <option value="cancelled">Cancelled</option>
                                    </select>

                                    <button type="button"
                                            onclick="clearBookingFilters()"
                                            class="w-full px-3 py-2.5 rounded-xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                        Clear Filters
                                    </button>
                                </div>

                                <!-- Date Range Filters -->
                                <div class="rounded-2xl bg-slate-50 border border-slate-200 p-3">
                                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-3 items-end">

                                        <div>
                                            <label for="dateFromFilter"
                                                   class="block text-xs font-bold text-slate-500 mb-1">
                                                From date
                                            </label>
                                            <input type="date"
                                                   id="dateFromFilter"
                                                   onchange="filterBookings()"
                                                   class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none bg-white focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>

                                        <div>
                                            <label for="dateToFilter"
                                                   class="block text-xs font-bold text-slate-500 mb-1">
                                                To date
                                            </label>
                                            <input type="date"
                                                   id="dateToFilter"
                                                   onchange="filterBookings()"
                                                   class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none bg-white focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>

                                        <div class="xl:col-span-2">
                                            <p class="text-xs text-slate-400 leading-relaxed">
                                                Choose <strong>From date</strong> only to filter from that date until now.
                                                Choose both <strong>From date</strong> and <strong>To date</strong> to filter a specific range.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold">
                                            <button type="button"
                                                    onclick="sortBookings('booking-id')"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Booking <span id="sort-booking-id">↕</span>
                                            </button>
                                        </th>

                                        <th class="px-5 py-3 text-left font-bold">
                                            <button type="button"
                                                    onclick="sortBookings('customer')"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Customer <span id="sort-customer">↕</span>
                                            </button>
                                        </th>

                                        <th class="px-5 py-3 text-left font-bold">
                                            <button type="button"
                                                    onclick="sortBookings('schedule')"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Schedule <span id="sort-schedule">↕</span>
                                            </button>
                                        </th>

                                        <th class="px-5 py-3 text-right font-bold">
                                            <button type="button"
                                                    onclick="sortBookings('total')"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Total <span id="sort-total">↕</span>
                                            </button>
                                        </th>

                                        <th class="px-5 py-3 text-center font-bold">
                                            Status
                                        </th>

                                        <th class="px-5 py-3 text-right font-bold">
                                            Actions
                                        </th>
                                    </tr>
                                </thead>

                                <tbody id="bookingTableBody" class="divide-y divide-slate-100">
                                    <% if (bookings == null || bookings.isEmpty()) { %>
                                    <tr>
                                        <td colspan="6" class="px-5 py-10 text-center text-slate-400">
                                            No bookings found.
                                        </td>
                                    </tr>
                                    <% } else { %>

                                    <% for (AdminBookingView b : bookings) {
                                            String bookingStatus = b.getBookingStatus() != null ? b.getBookingStatus().toLowerCase() : "pending";
                                            String paymentStatus = b.getPaymentStatus() != null ? b.getPaymentStatus().toLowerCase() : "pending";
                                            String paymentMethod = b.getPaymentMethod() != null ? b.getPaymentMethod() : "N/A";
                                            String bookingDate = b.getBookingDate() != null ? b.getBookingDate().toString() : "";
                                            String bookingSchedule = bookingDate + (b.getSlotTime() != null ? " " + b.getSlotTime() : "");
                                            String vehicleName = (b.getVehicleBrand() != null ? b.getVehicleBrand() : "Unknown Brand")
                                                    + " - "
                                                    + (b.getVehicleModel() != null ? b.getVehicleModel() : "Unknown Model");
                                            String serviceDetails = b.getServiceDetails() != null ? b.getServiceDetails() : "";
                                            String serviceNames = b.getServiceNames() != null ? b.getServiceNames() : "No service";
                                            String notes = b.getNotes() != null ? b.getNotes() : "";
                                            String promotionCode = b.getPromotionCode() != null ? b.getPromotionCode() : "";
                                    %>

                                    <tr class="booking-row cursor-pointer hover:bg-slate-50 transition-colors"
                                        onclick="openBookingDetailFromRow(this)"
                                        data-booking-status="<%= bookingStatus%>"
                                        data-payment-status="<%= paymentStatus%>"
                                        data-booking-date="<%= bookingDate%>"
                                        data-schedule-sort="<%= escapeHtml(bookingSchedule)%>"
                                        data-booking-id="<%= b.getBookingId()%>"
                                        data-customer="<%= b.getCustomerName() != null ? b.getCustomerName().toLowerCase() : ""%>"
                                        data-total="<%= b.getTotalAmount()%>"
                                        data-search="<%= escapeHtml((b.getBookingId() + " "
                                                + (b.getCustomerName() != null ? b.getCustomerName() : "") + " "
                                                + (b.getCustomerPhone() != null ? b.getCustomerPhone() : "") + " "
                                                + (b.getCustomerEmail() != null ? b.getCustomerEmail() : "") + " "
                                                + vehicleName + " "
                                                + (b.getPlateNumber() != null ? b.getPlateNumber() : "") + " "
                                                + (b.getVehicleType() != null ? b.getVehicleType() : "") + " "
                                                + serviceNames + " "
                                                + serviceDetails + " "
                                                + bookingSchedule + " "
                                                + paymentMethod + " "
                                                + paymentStatus + " "
                                                + promotionCode + " "
                                                + notes).toLowerCase())%>"
                                        data-customer-name="<%= escapeHtml(b.getCustomerName())%>"
                                        data-customer-phone="<%= escapeHtml(b.getCustomerPhone())%>"
                                        data-customer-email="<%= escapeHtml(b.getCustomerEmail())%>"
                                        data-vehicle-name="<%= escapeHtml(vehicleName)%>"
                                        data-plate-number="<%= escapeHtml(b.getPlateNumber())%>"
                                        data-vehicle-type="<%= escapeHtml(b.getVehicleType())%>"
                                        data-service-names="<%= escapeHtml(serviceNames)%>"
                                        data-service-details="<%= escapeHtml(serviceDetails)%>"
                                        data-service-total="<%= b.getServiceTotal()%>"
                                        data-payment-method="<%= escapeHtml(paymentMethod)%>"
                                        data-payment-amount="<%= b.getTotalAmount()%>"
                                        data-promotion-code="<%= escapeHtml(promotionCode)%>"
                                        data-notes="<%= escapeHtml(notes)%>"
                                        data-created-at="<%= escapeHtml(b.getCreatedAt() != null ? b.getCreatedAt().toString() : "")%>"
                                        data-payment-status-text="<%= escapeHtml(paymentStatus)%>"
                                        >

                                        <td class="px-5 py-4 min-w-[120px]">
                                            <p class="font-extrabold text-slate-900">
                                                #<%= b.getBookingId()%>
                                            </p>
                                            <p class="text-xs text-slate-400 mt-1">
                                                <%= b.getCreatedAt() != null ? b.getCreatedAt() : ""%>
                                            </p>
                                        </td>

                                        <td class="px-5 py-4 min-w-[220px]">
                                            <p class="booking-customer font-bold text-slate-900">
                                                <%= b.getCustomerName() != null ? b.getCustomerName() : "Unknown Customer"%>
                                            </p>
                                            <p class="booking-phone text-xs text-slate-500 mt-1">
                                                <%= b.getCustomerPhone() != null ? b.getCustomerPhone() : "No phone"%>
                                            </p>
                                            <p class="text-xs text-slate-400 mt-1">
                                                <%= b.getCustomerEmail() != null ? b.getCustomerEmail() : "No email"%>
                                            </p>
                                        </td>

                                        <td class="px-5 py-4 min-w-[160px]">
                                            <p class="font-bold text-slate-900">
                                                <%= bookingDate%>
                                            </p>
                                            <p class="text-xs text-slate-500 mt-1">
                                                <%= b.getSlotTime() != null ? b.getSlotTime() : "No slot"%>
                                            </p>
                                        </td>

                                        <td class="px-5 py-4 text-right min-w-[150px]">
                                            <p class="font-extrabold text-slate-900">
                                                <%= currencyFormat.format(b.getTotalAmount())%> VND
                                            </p>
                                            <% if (b.getDiscountAmount() > 0) {%>
                                            <p class="text-xs text-red-400 mt-1">
                                                -<%= currencyFormat.format(b.getDiscountAmount())%> VND
                                            </p>
                                            <% }%>
                                            <p class="text-xs text-slate-400 mt-1">
                                                +<%= b.getPointsEarned()%> pts
                                            </p>
                                        </td>

                                        <td class="px-5 py-4 text-center">
                                            <% if ("pending".equals(bookingStatus)) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">
                                                Pending
                                            </span>
                                            <% } else if ("accepted".equals(bookingStatus)) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-indigo-50 text-indigo-600 text-xs font-bold">
                                                Accepted
                                            </span>
                                            <% } else if ("completed".equals(bookingStatus)) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                Completed
                                            </span>
                                            <% } else if ("cancelled".equals(bookingStatus)) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-red-50 text-red-500 text-xs font-bold">
                                                Cancelled
                                            </span>
                                            <% } else {%>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-slate-100 text-slate-500 text-xs font-bold">
                                                <%= bookingStatus%>
                                            </span>
                                            <% }%>
                                        </td>

                                        <td class="px-5 py-4 text-right relative"
                                            onclick="event.stopPropagation()">

                                            <div class="relative inline-block">

                                                <button type="button"
                                                        onclick="event.stopPropagation();
                                                                toggleBookingDropdown('dropdown-<%= b.getBookingId()%>')"
                                                        class="w-9 h-9 rounded-xl bg-slate-100 hover:bg-slate-200 flex items-center justify-center">

                                                    ⋮
                                                </button>

                                                <div id="dropdown-<%= b.getBookingId()%>"
                                                     class="hidden absolute right-0 top-full mt-2
                                                     w-44 bg-white rounded-xl shadow-lg
                                                     border border-slate-100 z-50">

                                                    <!-- View Detail -->
                                                    <button type="button"
                                                            onclick="event.stopPropagation();
                                                                    openBookingDetailFromRow(this.closest('tr'))"
                                                            class="block w-full px-4 py-3 text-left hover:bg-slate-50">

                                                        View Detail
                                                    </button>

                                                    <% if ("pending".equalsIgnoreCase(bookingStatus)) {%>

                                                    <form action="<%=request.getContextPath()%>/admin/bookings"
                                                          method="post"
                                                          onclick="event.stopPropagation()">

                                                        <input type="hidden"
                                                               name="bookingId"
                                                               value="<%= b.getBookingId()%>">

                                                        <input type="hidden"
                                                               name="action"
                                                               value="accept">

                                                        <button type="submit"
                                                                class="block w-full px-4 py-3 text-left text-indigo-600 hover:bg-indigo-50">

                                                            Accept
                                                        </button>

                                                    </form>

                                                    <form action="<%=request.getContextPath()%>/AdminPaymentController"
                                                          method="get"
                                                          onclick="event.stopPropagation()">

                                                        <input type="hidden"
                                                               name="bookingId"
                                                               value="<%= b.getBookingId()%>">

                                                        <button type="submit"
                                                                class="block w-full px-4 py-3 text-left text-emerald-600 hover:bg-emerald-50">

                                                            Complete
                                                        </button>

                                                    </form>

                                                    <form action="<%=request.getContextPath()%>/admin/bookings"
                                                          method="post"
                                                          onclick="event.stopPropagation()">

                                                        <input type="hidden"
                                                               name="bookingId"
                                                               value="<%= b.getBookingId()%>">

                                                        <input type="hidden"
                                                               name="action"
                                                               value="cancel">

                                                        <button type="submit"
                                                                class="block w-full px-4 py-3 text-left text-red-600 hover:bg-red-50">

                                                            Cancel
                                                        </button>

                                                    </form>

                                                    <% } else if ("accepted".equalsIgnoreCase(bookingStatus)) {%>

                                                    <form action="<%=request.getContextPath()%>/admin/bookings"
                                                          method="post"
                                                          onclick="event.stopPropagation()">

                                                        <input type="hidden"
                                                               name="bookingId"
                                                               value="<%= b.getBookingId()%>">

                                                        <input type="hidden"
                                                               name="action"
                                                               value="deny">

                                                        <button type="submit"
                                                                class="block w-full px-4 py-3 text-left text-amber-600 hover:bg-amber-50">

                                                            Deny
                                                        </button>

                                                    </form>

                                                    <form action="<%=request.getContextPath()%>/AdminPaymentController"
                                                          method="get"
                                                          onclick="event.stopPropagation()">

                                                        <input type="hidden"
                                                               name="bookingId"
                                                               value="<%= b.getBookingId()%>">

                                                        <button type="submit"
                                                                class="block w-full px-4 py-3 text-left text-emerald-600 hover:bg-emerald-50">

                                                            Complete
                                                        </button>

                                                    </form>

                                                    <% } %>

                                                </div>
                                            </div>
                                        </td>
                                    </tr>

                                    <% } %>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <div id="bookingDetailModal"
             class="hidden fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4"
             onclick="closeBookingDetail(event)">
            <div class="w-full max-w-4xl max-h-[90vh] overflow-hidden rounded-2xl bg-white shadow-2xl"
                 onclick="event.stopPropagation()">
                <div class="flex items-start justify-between gap-4 border-b border-slate-200 px-6 py-5">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-400">Booking Detail</p>
                        <h3 class="mt-1 text-xl font-extrabold text-slate-900">
                            Booking #<span id="modalBookingId"></span>
                        </h3>
                        <p id="modalBookingMeta" class="mt-1 text-sm text-slate-500"></p>
                    </div>
                    <button type="button"
                            onclick="closeBookingDetail()"
                            class="inline-flex h-10 w-10 items-center justify-center rounded-xl bg-slate-100 text-slate-500 hover:bg-slate-200 hover:text-slate-700 transition-colors">
                        ×
                    </button>
                </div>

                <div class="max-h-[calc(90vh-92px)] overflow-y-auto p-6 space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Booking</p>
                            <p id="modalBookingSchedule" class="mt-2 text-sm font-semibold text-slate-900"></p>
                            <p id="modalBookingStatus" class="mt-2 inline-flex rounded-full px-3 py-1 text-xs font-bold"></p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Total</p>
                            <p id="modalBookingTotal" class="mt-2 text-2xl font-extrabold text-slate-900"></p>
                            <p id="modalBookingCreatedAt" class="mt-2 text-sm text-slate-500"></p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Payment</p>
                            <p id="modalPaymentMethod" class="mt-2 text-sm font-semibold text-slate-900 uppercase"></p>
                            <p id="modalPaymentStatus" class="mt-2 inline-flex rounded-full px-3 py-1 text-xs font-bold"></p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                        <section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                            <h4 class="text-sm font-extrabold text-slate-900">Customer Information</h4>
                            <div class="mt-4 space-y-3 text-sm">
                                <div class="flex items-start justify-between gap-4">
                                    <span class="text-slate-500">Name</span>
                                    <span id="modalCustomerName" class="text-right font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex items-start justify-between gap-4">
                                    <span class="text-slate-500">Phone</span>
                                    <span id="modalCustomerPhone" class="text-right font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex items-start justify-between gap-4">
                                    <span class="text-slate-500">Email</span>
                                    <span id="modalCustomerEmail" class="text-right font-semibold text-slate-900"></span>
                                </div>
                            </div>
                        </section>

                        <section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                            <h4 class="text-sm font-extrabold text-slate-900">Vehicle Information</h4>
                            <div class="mt-4 space-y-3 text-sm">
                                <div class="flex items-start justify-between gap-4">
                                    <span class="text-slate-500">Vehicle name</span>
                                    <span id="modalVehicleName" class="text-right font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex items-start justify-between gap-4">
                                    <span class="text-slate-500">Plate number</span>
                                    <span id="modalPlateNumber" class="text-right font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex items-start justify-between gap-4">
                                    <span class="text-slate-500">Vehicle type</span>
                                    <span id="modalVehicleType" class="text-right font-semibold text-slate-900"></span>
                                </div>
                            </div>
                        </section>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                        <section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                            <h4 class="text-sm font-extrabold text-slate-900">Service Information</h4>
                            <p id="modalServiceSummary" class="mt-3 text-sm text-slate-500"></p>
                            <ul id="modalServiceList" class="mt-4 space-y-2 text-sm"></ul>
                            <div class="mt-4 flex items-center justify-between rounded-xl bg-slate-50 px-4 py-3 text-sm">
                                <span class="font-semibold text-slate-500">Service total</span>
                                <span id="modalServiceTotal" class="font-bold text-slate-900"></span>
                            </div>
                        </section>

                        <section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm space-y-4">
                            <div>
                                <h4 class="text-sm font-extrabold text-slate-900">Promotion Information</h4>
                                <p id="modalPromotionCode" class="mt-3 rounded-xl bg-slate-50 px-4 py-3 text-sm text-slate-700"></p>
                            </div>
                            <div>
                                <h4 class="text-sm font-extrabold text-slate-900">Notes</h4>
                                <p id="modalNotes" class="mt-3 whitespace-pre-wrap rounded-xl bg-slate-50 px-4 py-3 text-sm text-slate-700"></p>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function filterBookings() {
                const keyword = document.getElementById("bookingSearch").value.toLowerCase();
                const bookingStatusFilter = document.getElementById("bookingStatusFilter").value;
                const paymentStatusFilter = document.getElementById("paymentStatusFilter").value;
                const dateFromFilter = document.getElementById("dateFromFilter").value;
                const dateToFilter = document.getElementById("dateToFilter").value;

                const rows = document.querySelectorAll(".booking-row");

                rows.forEach(row => {
                    const bookingStatus = row.getAttribute("data-booking-status");
                    const paymentStatus = row.getAttribute("data-payment-status");
                    const bookingDate = row.getAttribute("data-booking-date");
                    const searchableText = (row.getAttribute("data-search") || "").toLowerCase();

                    const matchesKeyword = searchableText.includes(keyword);

                    const matchesBookingStatus =
                            bookingStatusFilter === "all"
                            || bookingStatusFilter === bookingStatus;

                    const matchesPaymentStatus =
                            paymentStatusFilter === "all"
                            || paymentStatusFilter === paymentStatus;

                    let matchesDate = true;

                    if (dateFromFilter && !dateToFilter) {
                        matchesDate = bookingDate >= dateFromFilter;
                    } else if (!dateFromFilter && dateToFilter) {
                        matchesDate = bookingDate <= dateToFilter;
                    } else if (dateFromFilter && dateToFilter) {
                        matchesDate = bookingDate >= dateFromFilter && bookingDate <= dateToFilter;
                    }

                    row.style.display =
                            matchesKeyword
                            && matchesBookingStatus
                            && matchesPaymentStatus
                            && matchesDate
                            ? ""
                            : "none";
                });
            }

            let currentSortKey = "";
            let currentSortDirection = "asc";

            function sortBookings(key) {
                const tbody = document.getElementById("bookingTableBody");

                if (!tbody) {
                    return;
                }

                const rows = Array.from(tbody.querySelectorAll(".booking-row"));

                if (currentSortKey === key) {
                    currentSortDirection = currentSortDirection === "asc" ? "desc" : "asc";
                } else {
                    currentSortKey = key;
                    currentSortDirection = "asc";
                }

                rows.sort((a, b) => {
                    let valueA = getSortValue(a, key);
                    let valueB = getSortValue(b, key);

                    if (typeof valueA === "number" && typeof valueB === "number") {
                        return currentSortDirection === "asc"
                                ? valueA - valueB
                                : valueB - valueA;
                    }

                    valueA = String(valueA);
                    valueB = String(valueB);

                    return currentSortDirection === "asc"
                            ? valueA.localeCompare(valueB)
                            : valueB.localeCompare(valueA);
                });

                rows.forEach(row => tbody.appendChild(row));

                updateSortIcons(key);
            }

            function getSortValue(row, key) {
                switch (key) {
                    case "booking-id":
                        return Number(row.getAttribute("data-booking-id")) || 0;

                    case "customer":
                        return row.getAttribute("data-customer") || "";

                    case "schedule":
                        return row.getAttribute("data-schedule-sort") || row.getAttribute("data-booking-date") || "";

                    case "total":
                        return Number(row.getAttribute("data-total")) || 0;

                    default:
                        return "";
                }
            }

            function updateSortIcons(activeKey) {
                const keys = [
                    "booking-id",
                    "customer",
                    "schedule",
                    "total"
                ];

                keys.forEach(key => {
                    const icon = document.getElementById("sort-" + key);

                    if (!icon) {
                        return;
                    }

                    if (key === activeKey) {
                        icon.innerText = currentSortDirection === "asc" ? "↑" : "↓";
                    } else {
                        icon.innerText = "↕";
                    }
                });
            }

            function clearBookingFilters() {
                document.getElementById("bookingSearch").value = "";
                document.getElementById("bookingStatusFilter").value = "all";
                document.getElementById("paymentStatusFilter").value = "all";
                document.getElementById("dateFromFilter").value = "";
                document.getElementById("dateToFilter").value = "";

                filterBookings();
            }

            function toggleBookingMenu(event, bookingId) {
                event.stopPropagation();

                const menu = document.getElementById("booking-menu-" + bookingId);
                const icon = document.getElementById("booking-menu-icon-" + bookingId);
                const isHidden = menu && menu.classList.contains("hidden");

                closeAllBookingMenus();

                if (menu && isHidden) {
                    menu.classList.remove("hidden");
                    if (icon) {
                        icon.classList.add("rotate-180");
                    }
                }
            }

            function closeAllBookingMenus() {
                document.querySelectorAll(".booking-action-menu").forEach(menu => menu.classList.add("hidden"));
                document.querySelectorAll("[id^='booking-menu-icon-']").forEach(icon => icon.classList.remove("rotate-180"));
            }

            function openBookingDetailById(bookingId) {
                const row = document.querySelector('.booking-row[data-booking-id="' + bookingId + '"]');
                if (row) {
                    openBookingDetailFromRow(row);
                }
            }

            function openBookingDetailFromRow(row) {
                closeAllBookingMenus();

                const modal = document.getElementById("bookingDetailModal");
                if (!modal || !row) {
                    return;
                }

                const bookingId = row.getAttribute("data-booking-id") || "";
                const bookingDate = row.getAttribute("data-booking-date") || "N/A";
                const createdAt = row.getAttribute("data-created-at") || "N/A";
                const scheduleSort = row.getAttribute("data-schedule-sort") || bookingDate;
                const bookingStatus = row.getAttribute("data-booking-status") || "pending";
                const paymentStatus = row.getAttribute("data-payment-status") || "pending";
                const paymentMethod = row.getAttribute("data-payment-method") || "N/A";
                const totalAmount = Number(row.getAttribute("data-payment-amount") || row.getAttribute("data-total") || 0);
                const serviceTotal = Number(row.getAttribute("data-service-total") || 0);
                const serviceNames = row.getAttribute("data-service-names") || "No service";
                const serviceDetails = row.getAttribute("data-service-details") || "";
                const promotionCode = row.getAttribute("data-promotion-code") || "N/A";
                const notes = row.getAttribute("data-notes") || "No notes";

                const customerName = row.getAttribute("data-customer-name") || "N/A";
                const customerPhone = row.getAttribute("data-customer-phone") || "N/A";
                const customerEmail = row.getAttribute("data-customer-email") || "N/A";
                const vehicleName = row.getAttribute("data-vehicle-name") || "N/A";
                const plateNumber = row.getAttribute("data-plate-number") || "N/A";
                const vehicleType = row.getAttribute("data-vehicle-type") || "N/A";

                document.getElementById("modalBookingId").innerText = bookingId;
                document.getElementById("modalBookingMeta").innerText = "Created at: " + createdAt;
                document.getElementById("modalBookingSchedule").innerText = scheduleSort;
                document.getElementById("modalBookingTotal").innerText = formatCurrency(totalAmount) + " VND";
                document.getElementById("modalBookingCreatedAt").innerText = "Schedule: " + scheduleSort;

                document.getElementById("modalCustomerName").innerText = customerName;
                document.getElementById("modalCustomerPhone").innerText = customerPhone;
                document.getElementById("modalCustomerEmail").innerText = customerEmail;

                document.getElementById("modalVehicleName").innerText = vehicleName;
                document.getElementById("modalPlateNumber").innerText = plateNumber;
                document.getElementById("modalVehicleType").innerText = vehicleType;

                document.getElementById("modalServiceSummary").innerText = serviceNames;
                document.getElementById("modalServiceTotal").innerText = formatCurrency(serviceTotal) + " VND";
                document.getElementById("modalPromotionCode").innerText = promotionCode && promotionCode !== "N/A" ? promotionCode : "No promotion";
                document.getElementById("modalNotes").innerText = notes;

                setStatusBadge("modalBookingStatus", bookingStatus, true);
                setPaymentBadge("modalPaymentStatus", paymentStatus);
                document.getElementById("modalPaymentMethod").innerText = paymentMethod;

                renderServiceDetails(serviceDetails);

                modal.classList.remove("hidden");
            }

            function closeBookingDetail(event) {
                if (event && event.target !== event.currentTarget) {
                    return;
                }

                const modal = document.getElementById("bookingDetailModal");
                if (modal) {
                    modal.classList.add("hidden");
                }
            }

            function renderServiceDetails(serviceDetails) {
                const list = document.getElementById("modalServiceList");
                if (!list) {
                    return;
                }

                list.innerHTML = "";

                const items = (serviceDetails || "")
                        .split("||")
                        .map(item => item.trim())
                        .filter(Boolean);

                if (!items.length) {
                    const emptyItem = document.createElement("li");
                    emptyItem.className = "rounded-xl border border-dashed border-slate-200 px-4 py-3 text-sm text-slate-400";
                    emptyItem.innerText = "No service detail available.";
                    list.appendChild(emptyItem);
                    return;
                }

                items.forEach(item => {
                    const li = document.createElement("li");
                    li.className = "rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm font-semibold text-slate-700";
                    li.innerText = item;
                    list.appendChild(li);
                });
            }

            function setStatusBadge(elementId, status, compact) {
                const element = document.getElementById(elementId);
                if (!element) {
                    return;
                }

                const normalized = (status || "pending").toLowerCase();
                element.className = "mt-2 inline-flex rounded-full px-3 py-1 text-xs font-bold";

                if (normalized === "pending") {
                    element.classList.add("bg-amber-50", "text-amber-600");
                    element.innerText = compact ? "Pending" : "Pending";
                } else if (normalized === "accepted") {
                    element.classList.add("bg-indigo-50", "text-indigo-600");
                    element.innerText = compact ? "Accepted" : "Accepted";
                } else if (normalized === "completed") {
                    element.classList.add("bg-emerald-50", "text-emerald-600");
                    element.innerText = compact ? "Completed" : "Completed";
                } else if (normalized === "cancelled") {
                    element.classList.add("bg-red-50", "text-red-500");
                    element.innerText = compact ? "Cancelled" : "Cancelled";
                } else {
                    element.classList.add("bg-slate-100", "text-slate-500");
                    element.innerText = status || "Unknown";
                }
            }

            function setPaymentBadge(elementId, status) {
                const element = document.getElementById(elementId);
                if (!element) {
                    return;
                }

                const normalized = (status || "pending").toLowerCase();
                element.className = "mt-2 inline-flex rounded-full px-3 py-1 text-xs font-bold";

                if (normalized === "paid") {
                    element.classList.add("bg-emerald-50", "text-emerald-600");
                    element.innerText = "Paid";
                } else if (normalized === "cancelled") {
                    element.classList.add("bg-red-50", "text-red-500");
                    element.innerText = "Cancelled";
                } else {
                    element.classList.add("bg-amber-50", "text-amber-600");
                    element.innerText = "Pending";
                }
            }

            function formatCurrency(value) {
                return new Intl.NumberFormat("vi-VN").format(Number(value) || 0);
            }

            document.addEventListener("click", function () {
                closeAllBookingMenus();
            });

            document.addEventListener("keydown", function (event) {
                if (event.key === "Escape") {
                    closeAllBookingMenus();
                    closeBookingDetail();
                }
            });


// Add JavaScript to handle dropdown toggle
            document.addEventListener('DOMContentLoaded', function () {
                // Get all menu buttons
                const menuButtons = document.querySelectorAll('[id^="menu-button-"]');

                menuButtons.forEach(button => {
                    button.addEventListener('click', function (e) {
                        e.preventDefault();
                        const bookingId = this.id.split('-')[2];
                        const menu = document.getElementById('menu-' + bookingId);

                        // Close other menus
                        document.querySelectorAll('[id^="menu-"]').forEach(m => {
                            if (m.id !== menu.id) {
                                m.style.display = 'none';
                            }
                        });

                        // Toggle current menu
                        if (menu.style.display === 'none') {
                            menu.style.display = 'block';
                        } else {
                            menu.style.display = 'none';
                        }
                    });
                });

                // Close menu when clicking outside
                document.addEventListener('click', function (e) {
                    if (!e.target.closest('.inline-block')) {
                        document.querySelectorAll('[id^="menu-"]').forEach(menu => {
                            menu.style.display = 'none';
                        });
                    }
                });
            });

            function toggleBookingDropdown(id) {

                event.stopPropagation();

                document.querySelectorAll("[id^='dropdown-']")
                        .forEach(menu => {
                            if (menu.id !== id) {
                                menu.classList.add("hidden");
                            }
                        });

                document.getElementById(id)
                        .classList.toggle("hidden");
            }

            document.addEventListener("click", function () {

                document.querySelectorAll("[id^='dropdown-']")
                        .forEach(menu => {
                            menu.classList.add("hidden");
                        });

            });

            document.addEventListener("click", function () {

                document.querySelectorAll("[id^='dropdown-']")
                        .forEach(menu => {
                            menu.classList.add("hidden");
                        });

            });
        </script>
    </body>
</html>