<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.AdminBookingView"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
                                            Vehicle
                                        </th>

                                        <th class="px-5 py-3 text-left font-bold">
                                            <button type="button"
                                                    onclick="sortBookings('date')"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Schedule <span id="sort-date">↕</span>
                                            </button>
                                        </th>

                                        <th class="px-5 py-3 text-left font-bold">
                                            Services
                                        </th>

                                        <th class="px-5 py-3 text-center font-bold">
                                            Payment
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
                                        <td colspan="9" class="px-5 py-10 text-center text-slate-400">
                                            No bookings found.
                                        </td>
                                    </tr>
                                    <% } else { %>

                                    <% for (AdminBookingView b : bookings) {
                                            String bookingStatus = b.getBookingStatus() != null ? b.getBookingStatus().toLowerCase() : "pending";
                                            String paymentStatus = b.getPaymentStatus() != null ? b.getPaymentStatus().toLowerCase() : "pending";
                                            String paymentMethod = b.getPaymentMethod() != null ? b.getPaymentMethod() : "N/A";
                                            String bookingDate = b.getBookingDate() != null ? b.getBookingDate().toString() : "";
                                    %>

                                    <tr class="booking-row hover:bg-slate-50 transition-colors"
                                        data-booking-status="<%= bookingStatus%>"
                                        data-payment-status="<%= paymentStatus%>"
                                        data-booking-date="<%= bookingDate%>"
                                        data-booking-id="<%= b.getBookingId()%>"
                                        data-customer="<%= b.getCustomerName() != null ? b.getCustomerName().toLowerCase() : ""%>"
                                        data-total="<%= b.getTotalAmount()%>">

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

                                        <td class="px-5 py-4 min-w-[220px]">
                                            <p class="booking-plate font-bold text-slate-900">
                                                <%= b.getPlateNumber() != null ? b.getPlateNumber() : "No plate"%>
                                            </p>
                                            <p class="text-xs text-slate-500 mt-1">
                                                <%= b.getVehicleBrand() != null ? b.getVehicleBrand() : "Unknown Brand"%>
                                                -
                                                <%= b.getVehicleModel() != null ? b.getVehicleModel() : "Unknown Model"%>
                                            </p>
                                            <p class="text-xs text-slate-400 mt-1">
                                                <%= b.getVehicleType() != null ? b.getVehicleType() : "Unknown type"%>
                                            </p>
                                        </td>

                                        <td class="px-5 py-4 min-w-[160px]">
                                            <p class="font-bold text-slate-900">
                                                <%= bookingDate%>
                                            </p>
                                            <p class="text-xs text-slate-500 mt-1">
                                                <%= b.getSlotTime() != null ? b.getSlotTime() : "No slot"%>
                                            </p>
                                            <p class="text-xs text-slate-400 mt-1">
                                                Bay: <%= b.getBayName() != null ? b.getBayName() : "N/A"%>
                                            </p>
                                        </td>

                                        <td class="px-5 py-4 min-w-[220px]">
                                            <p class="booking-service font-bold text-slate-900">
                                                <%= b.getServiceNames() != null ? b.getServiceNames() : "No service"%>
                                            </p>
                                            <p class="text-xs text-slate-500 mt-1">
                                                Service total: <%= currencyFormat.format(b.getServiceTotal())%> VND
                                            </p>
                                            <% if (b.getPromotionCode() != null) {%>
                                            <p class="text-xs text-indigo-500 font-bold mt-1">
                                                Promo: <%= b.getPromotionCode()%>
                                            </p>
                                            <% }%>
                                        </td>

                                        <td class="px-5 py-4 text-center min-w-[150px]">
                                            <p class="font-bold text-slate-700 uppercase text-xs">
                                                <%= paymentMethod%>
                                            </p>

                                            <% if ("paid".equals(paymentStatus)) { %>
                                            <span class="inline-flex mt-2 px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                Paid
                                            </span>
                                            <% } else { %>
                                            <span class="inline-flex mt-2 px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">
                                                Pending
                                            </span>
                                            <% }%>
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
                                            <% } %>
                                        </td>

                                        <td class="px-5 py-4 min-w-[260px]">
                                            <div class="flex items-center justify-end gap-2 flex-wrap">

                                                <% if ("pending".equals(bookingStatus)) {%>
                                                <form action="${pageContext.request.contextPath}/admin/bookings"
                                                      method="post"
                                                      onsubmit="return confirm('Accept this booking?');">
                                                    <input type="hidden" name="action" value="accept">
                                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId()%>">
                                                    <button type="submit"
                                                            class="px-3 py-2 rounded-xl bg-indigo-50 text-indigo-600 text-xs font-bold hover:bg-indigo-100 transition-all">
                                                        Accept
                                                    </button>
                                                </form>
                                                <% } %>

                                                <% if ("accepted".equals(bookingStatus) && !"paid".equals(paymentStatus)) {%>
                                                <form action="${pageContext.request.contextPath}/admin/bookings"
                                                      method="post"
                                                      onsubmit="return confirm('Confirm this payment as paid?');">
                                                    <input type="hidden" name="action" value="confirmPaid">
                                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId()%>">
                                                    <button type="submit"
                                                            class="px-3 py-2 rounded-xl bg-emerald-50 text-emerald-600 text-xs font-bold hover:bg-emerald-100 transition-all">
                                                        Confirm Paid
                                                    </button>
                                                </form>
                                                <% } %>

                                                <% if ("accepted".equals(bookingStatus) && "paid".equals(paymentStatus)) {%>
                                                <form action="${pageContext.request.contextPath}/admin/bookings"
                                                      method="post"
                                                      onsubmit="return confirm('Complete this booking? Customer stats and tier may be updated.');">
                                                    <input type="hidden" name="action" value="complete">
                                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId()%>">
                                                    <button type="submit"
                                                            class="px-3 py-2 rounded-xl bg-blue-50 text-blue-600 text-xs font-bold hover:bg-blue-100 transition-all">
                                                        Complete
                                                    </button>
                                                </form>
                                                <% } %>

                                                <% if ("pending".equals(bookingStatus) || "accepted".equals(bookingStatus)) {%>
                                                <form action="${pageContext.request.contextPath}/admin/bookings"
                                                      method="post"
                                                      onsubmit="return confirm('Cancel this booking?');">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId()%>">
                                                    <button type="submit"
                                                            class="px-3 py-2 rounded-xl bg-red-50 text-red-500 text-xs font-bold hover:bg-red-100 transition-all">
                                                        Cancel
                                                    </button>
                                                </form>
                                                <% } %>

                                                <% if ("completed".equals(bookingStatus) || "cancelled".equals(bookingStatus)) { %>
                                                <span class="px-3 py-2 rounded-xl bg-slate-100 text-slate-400 text-xs font-bold">
                                                    No Action
                                                </span>
                                                <% } %>
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

        <script>
            function filterBookings() {
                const keyword = document.getElementById("bookingSearch").value.toLowerCase();
                const bookingStatusFilter = document.getElementById("bookingStatusFilter").value;
                const paymentStatusFilter = document.getElementById("paymentStatusFilter").value;
                const dateFromFilter = document.getElementById("dateFromFilter").value;
                const dateToFilter = document.getElementById("dateToFilter").value;

                const rows = document.querySelectorAll(".booking-row");

                rows.forEach(row => {
                    const customer = row.querySelector(".booking-customer").innerText.toLowerCase();
                    const phone = row.querySelector(".booking-phone").innerText.toLowerCase();
                    const plate = row.querySelector(".booking-plate").innerText.toLowerCase();
                    const service = row.querySelector(".booking-service").innerText.toLowerCase();

                    const bookingStatus = row.getAttribute("data-booking-status");
                    const paymentStatus = row.getAttribute("data-payment-status");
                    const bookingDate = row.getAttribute("data-booking-date");

                    const matchesKeyword =
                            customer.includes(keyword)
                            || phone.includes(keyword)
                            || plate.includes(keyword)
                            || service.includes(keyword);

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

                    case "date":
                        return row.getAttribute("data-booking-date") || "";

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
                    "date",
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
        </script>
    </body>
</html>