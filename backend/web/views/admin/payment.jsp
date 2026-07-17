<%@page import="dto.AdminPaymentView"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<AdminPaymentView> payments = (List<AdminPaymentView>) request.getAttribute("PAYMENTS");
    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");

    String uploadBookingId = (String) request.getAttribute("UPLOAD_BOOKING_ID");
    boolean showUploadModal = request.getAttribute("SHOW_UPLOAD_MODAL") != null;

    String currentKeyword = (String) request.getAttribute("CURRENT_KEYWORD");
    String currentMethod  = (String) request.getAttribute("CURRENT_METHOD");
    String currentStatus  = (String) request.getAttribute("CURRENT_STATUS");
    if (currentKeyword == null) currentKeyword = "";
    if (currentMethod == null) currentMethod = "all";
    if (currentStatus == null) currentStatus = "all";
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/components/admin/adminHead.jsp" />
        <title>Payment Management | AutoWash Pro</title>
    </head>

    <body class="bg-slate-50 text-slate-900">
        <div class="flex min-h-screen">

            <jsp:include page="/components/admin/adminSidebar.jsp" />

            <div class="flex-1 min-w-0">
                <jsp:include page="/components/admin/adminTopbar.jsp" />

                <main class="p-6">

                    <!-- Header -->
                    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-2xl font-extrabold text-slate-900">Payment Management</h2>
                            <p class="text-sm text-slate-500 mt-1">Monitor revenue, transaction history, and payment statuses.</p>
                        </div>
                        <div class="px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-sm font-bold text-slate-700">
                            Total: <%= payments != null ? payments.size() : 0 %> payments
                        </div>
                    </div>

                    <!-- Success / Error -->
                    <% if ("updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Payment updated successfully.
                    </div>
                    <% } %>
                    <% if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Action failed. Please try again.
                    </div>
                    <% } %>

                    <!-- Table Section -->
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">

                        <!-- Filter Row -->
                        <div class="px-5 py-4 border-b border-slate-100 flex flex-col gap-4">
                            <div>
                                <h3 class="text-lg font-bold text-slate-900">Payment List</h3>
                                <p class="text-sm text-slate-400">Search and filter all payment records.</p>
                            </div>
                            <form method="get" action="${pageContext.request.contextPath}/admin/payments"
                                  class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-3">
                                <input type="text" name="keyword" value="<%= currentKeyword %>"
                                       placeholder="Search booking ID, transaction ID, customer..."
                                       class="xl:col-span-2 w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                <select name="method"
                                        class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <option value="all" <%= "all".equals(currentMethod) ? "selected" : "" %>>All Methods</option>
                                    <option value="cash" <%= "cash".equals(currentMethod) ? "selected" : "" %>>Cash</option>
                                    <option value="wallet" <%= "wallet".equals(currentMethod) ? "selected" : "" %>>Wallet</option>
                                    <option value="qrcode" <%= "qrcode".equals(currentMethod) ? "selected" : "" %>>QR Code</option>
                                </select>
                                <select name="status"
                                        class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <option value="all" <%= "all".equals(currentStatus) ? "selected" : "" %>>All Status</option>
                                    <option value="pending" <%= "pending".equals(currentStatus) ? "selected" : "" %>>Pending</option>
                                    <option value="paid" <%= "paid".equals(currentStatus) ? "selected" : "" %>>Paid</option>
                                </select>
                                <div class="flex gap-2">
                                    <button type="submit"
                                            class="w-full px-3 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                        Search
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/payments"
                                       class="w-full flex items-center justify-center px-3 py-2.5 rounded-xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                        Clear
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Table -->
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold">Payment ID</th>
                                        <th class="px-5 py-3 text-left font-bold">Booking ID</th>
                                        <th class="px-5 py-3 text-left font-bold">Customer</th>
                                        <th class="px-5 py-3 text-left font-bold">Amount (VND)</th>
                                        <th class="px-5 py-3 text-left font-bold">Method</th>
                                        <th class="px-5 py-3 text-center font-bold">Status</th>
                                        <th class="px-5 py-3 text-left font-bold">Paid At</th>
                                        <th class="px-5 py-3 text-left font-bold">Transaction ID</th>
                                        <th class="px-5 py-3 text-right font-bold whitespace-nowrap">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="paymentTableBody" class="divide-y divide-slate-100">
                                    <% if (payments == null || payments.isEmpty()) { %>
                                    <tr>
                                        <td colspan="9" class="px-5 py-10 text-center text-slate-400">No payment records found.</td>
                                    </tr>
                                    <% } else { %>
                                    <% for (AdminPaymentView p : payments) {
                                        String status = p.getPaymentStatus() != null ? p.getPaymentStatus().toLowerCase() : "pending";
                                        String method = p.getPaymentMethod() != null ? p.getPaymentMethod().toLowerCase() : "";
                                    %>
                                    <tr class="payment-row hover:bg-slate-50 transition-colors cursor-pointer"
                                        data-status="<%= status %>"
                                        data-method="<%= method %>"
                                        data-payment-id="<%= p.getPaymentId() %>"
                                        data-booking-id="<%= p.getBookingId() %>"
                                        data-customer="<%= p.getCustomerName() != null ? p.getCustomerName() : "" %>"
                                        data-phone="<%= p.getCustomerPhone() != null ? p.getCustomerPhone() : "" %>"
                                        data-email="<%= p.getCustomerEmail() != null ? p.getCustomerEmail() : "" %>"
                                        data-service="<%= p.getServiceNames() != null ? p.getServiceNames() : "" %>"
                                        data-amount="<%= currencyFormat.format(p.getAmount()) %>"
                                        data-method-display="<%= p.getPaymentMethod() != null ? p.getPaymentMethod().toUpperCase() : "N/A" %>"
                                        data-paid-at="<%= p.getPaidAt() != null ? sdf.format(p.getPaidAt()) : "—" %>"
                                        data-transaction="<%= p.getTransactionId() != null ? p.getTransactionId() : "—" %>"
                                        data-checkin="<%= p.getCheckinImageUrl() != null ? p.getCheckinImageUrl() : "" %>"
                                        data-checkout="<%= p.getCheckoutImageUrl() != null ? p.getCheckoutImageUrl() : "" %>">

                                        <td class="px-5 py-4 font-extrabold text-slate-900">#<%= p.getPaymentId() %></td>
                                        <td class="px-5 py-4 text-slate-700">#<%= p.getBookingId() %></td>
                                        <td class="px-5 py-4 font-semibold text-slate-900">
                                            <%= p.getCustomerName() != null ? p.getCustomerName() : "N/A" %>
                                        </td>
                                        <td class="px-5 py-4 font-bold text-slate-900">
                                            <%= currencyFormat.format(p.getAmount()) %>
                                        </td>
                                        <td class="px-5 py-4 text-slate-700 uppercase text-xs font-bold">
                                            <%= p.getPaymentMethod() != null ? p.getPaymentMethod() : "N/A" %>
                                        </td>
                                        <td class="px-5 py-4 text-center">
                                            <% if ("paid".equals(status)) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">Paid</span>
                                            <% } else { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">Pending</span>
                                            <% } %>
                                        </td>
                                        <td class="px-5 py-4 text-slate-500 text-xs">
                                            <%= p.getPaidAt() != null ? sdf.format(p.getPaidAt()) : "—" %>
                                        </td>
                                        <td class="px-5 py-4 text-slate-500 text-xs">
                                            <%= p.getTransactionId() != null ? p.getTransactionId() : "—" %>
                                        </td>

                                        <!-- Actions dropdown -->
                                        <td class="px-5 py-4 text-right relative" onclick="event.stopPropagation()">
                                            <div class="relative inline-block">
                                                <button type="button"
                                                        onclick="event.stopPropagation(); togglePaymentDropdown('pdropdown-<%= p.getPaymentId() %>')"
                                                        class="w-9 h-9 rounded-xl bg-slate-100 hover:bg-slate-200 flex items-center justify-center font-bold">
                                                    ⋮
                                                </button>
                                                <div id="pdropdown-<%= p.getPaymentId() %>"
                                                     class="hidden absolute right-0 top-full mt-2 w-44 bg-white rounded-xl shadow-lg border border-slate-100 z-50">

                                                    <!-- View Detail -->
                                                    <button type="button"
                                                            onclick="event.stopPropagation(); openPaymentDetail(this.closest('tr'))"
                                                            class="block w-full px-4 py-3 text-left hover:bg-slate-50 text-sm">
                                                        View Detail
                                                    </button>

                                                    <% if ("pending".equals(status)) { %>
                                                    <!-- Mark Paid -->
                                                    <button type="button"
                                                            onclick="event.stopPropagation(); openMarkPaidConfirm(<%= p.getPaymentId() %>)"
                                                            class="block w-full px-4 py-3 text-left text-emerald-600 hover:bg-emerald-50 text-sm">
                                                        Mark Paid
                                                    </button>
                                                    <% } %>

                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <!-- ===== MARK PAID CONFIRM MODAL ===== -->
        <div id="markPaidConfirmModal"
             class="hidden fixed inset-0 z-[60] flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4"
             onclick="closeMarkPaidConfirm(event)">
            <div class="w-[380px] max-w-full rounded-2xl bg-white shadow-2xl p-6 text-center"
                 onclick="event.stopPropagation()">
                <div class="w-12 h-12 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center mx-auto mb-4 text-2xl">
                    ✓
                </div>
                <h3 class="text-base font-bold text-slate-800 mb-2">Mark this payment as paid?</h3>
                <p class="text-sm text-slate-500 mb-6">This will update the payment status to "Paid". Are you sure?</p>

                <div class="flex gap-3">
                    <button type="button" onclick="closeMarkPaidConfirm()"
                            class="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-sm font-bold rounded-xl transition-colors">
                        Cancel
                    </button>
                    <a id="markPaidConfirmLink" href="#"
                       class="flex-1 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-bold rounded-xl transition-colors">
                        Yes, Mark Paid
                    </a>
                </div>
            </div>
        </div>

        <!-- ===== PAYMENT DETAIL MODAL ===== -->
        <div id="paymentDetailModal"
             class="hidden fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4"
             onclick="closePaymentDetail(event)">
            <div class="w-full max-w-3xl max-h-[90vh] overflow-hidden rounded-2xl bg-white shadow-2xl"
                 onclick="event.stopPropagation()">

                <!-- Modal Header -->
                <div class="flex items-start justify-between gap-4 border-b border-slate-200 px-6 py-5">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-400">Payment Detail</p>
                        <h3 class="mt-1 text-xl font-extrabold text-slate-900">
                            Payment #<span id="modalPaymentId"></span>
                        </h3>
                    </div>
                    <button type="button" onclick="closePaymentDetail()"
                            class="inline-flex h-10 w-10 items-center justify-center rounded-xl bg-slate-100 text-slate-500 hover:bg-slate-200 transition-colors">
                        ×
                    </button>
                </div>

                <!-- Modal Body -->
                <div class="max-h-[calc(90vh-92px)] overflow-y-auto p-6 space-y-4">

                    <!-- KPI Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Amount</p>
                            <p id="modalAmount" class="mt-2 text-2xl font-extrabold text-slate-900"></p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Method</p>
                            <p id="modalMethod" class="mt-2 text-sm font-bold text-slate-900 uppercase"></p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Status</p>
                            <p id="modalStatus" class="mt-2"></p>
                        </div>
                    </div>

                    <!-- Payment Info + Customer Info -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                        <section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                            <h4 class="text-sm font-extrabold text-slate-900">Payment Information</h4>
                            <div class="mt-4 space-y-3 text-sm">
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Booking ID</span>
                                    <span id="modalBookingId" class="font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Transaction ID</span>
                                    <span id="modalTransactionId" class="font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Paid At</span>
                                    <span id="modalPaidAt" class="font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Service</span>
                                    <span id="modalService" class="font-semibold text-slate-900 text-right max-w-[60%]"></span>
                                </div>
                            </div>
                        </section>

                        <section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                            <h4 class="text-sm font-extrabold text-slate-900">Customer Information</h4>
                            <div class="mt-4 space-y-3 text-sm">
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Name</span>
                                    <span id="modalCustomerName" class="font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Phone</span>
                                    <span id="modalCustomerPhone" class="font-semibold text-slate-900"></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Email</span>
                                    <span id="modalCustomerEmail" class="font-semibold text-slate-900"></span>
                                </div>
                            </div>
                        </section>
                    </div>

                    <!-- Vehicle Images -->
                    <section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                        <h4 class="text-sm font-extrabold text-slate-900 mb-4">Vehicle Images</h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <p class="text-xs font-bold text-slate-400 uppercase mb-2">Checkin (Before Wash)</p>
                                <div id="checkinContainer" class="rounded-xl overflow-hidden bg-slate-100 h-48 flex items-center justify-center">
                                    <img id="modalCheckinImg" src="" alt="Checkin" class="w-full h-full object-cover hidden">
                                    <span id="noCheckin" class="text-slate-400 text-sm">No image</span>
                                </div>
                            </div>
                            <div>
                                <p class="text-xs font-bold text-slate-400 uppercase mb-2">Checkout (After Wash)</p>
                                <div id="checkoutContainer" class="rounded-xl overflow-hidden bg-slate-100 h-48 flex items-center justify-center">
                                    <img id="modalCheckoutImg" src="" alt="Checkout" class="w-full h-full object-cover hidden">
                                    <span id="noCheckout" class="text-slate-400 text-sm">No image</span>
                                </div>
                            </div>
                        </div>
                    </section>

                </div>
            </div>
        </div>

        <!-- ===== UPLOAD IMAGES MODAL ===== -->
        <div id="uploadModal"
             class="<%= showUploadModal ? "" : "hidden" %> fixed inset-0 z-50 flex items-center justify-center bg-black/40">
            <div class="bg-white rounded-2xl border border-slate-200 shadow-xl p-8 w-full max-w-md mx-4">
                <div class="mb-6">
                    <h3 class="text-xl font-extrabold text-slate-900">Upload Vehicle Images</h3>
                    <p class="text-sm text-slate-400 mt-1">
                        Booking #<%= uploadBookingId != null ? uploadBookingId : "" %>
                    </p>
                </div>
                <form action="${pageContext.request.contextPath}/admin/payments"
                      method="post"
                      enctype="multipart/form-data"
                      class="space-y-5">
                    <input type="hidden" name="action" value="confirmComplete">
                    <input type="hidden" name="bookingId" value="<%= uploadBookingId != null ? uploadBookingId : "" %>">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">
                            Checkin Image <span class="text-xs text-slate-400">(before wash)</span>
                        </label>
                        <input type="file" name="checkinImage" accept="image/*"
                               class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">
                            Checkout Image <span class="text-xs text-slate-400">(after wash)</span>
                        </label>
                        <input type="file" name="checkoutImage" accept="image/*"
                               class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm">
                    </div>
                    <div class="flex items-center gap-3 pt-2">
                        <a href="${pageContext.request.contextPath}/admin/payments"
                           class="flex-1 py-2.5 text-center bg-slate-100 hover:bg-slate-200 text-slate-700 text-sm font-bold rounded-xl transition-colors">
                            Cancel
                        </a>
                        <button type="submit"
                                class="flex-1 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-bold rounded-xl transition-colors">
                            Confirm Complete
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // ===== MARK PAID CONFIRM MODAL =====
            function openMarkPaidConfirm(paymentId) {
                const link = document.getElementById("markPaidConfirmLink");
                link.href = "${pageContext.request.contextPath}/admin/payments?action=updateStatus&paymentId=" + paymentId + "&status=paid";
                document.getElementById("markPaidConfirmModal").classList.remove("hidden");
            }

            function closeMarkPaidConfirm(e) {
                if (!e || e.target === document.getElementById("markPaidConfirmModal")) {
                    document.getElementById("markPaidConfirmModal").classList.add("hidden");
                }
            }

            // ===== DROPDOWN =====
            function togglePaymentDropdown(id) {
                event.stopPropagation();
                document.querySelectorAll("[id^='pdropdown-']")
                        .forEach(menu => { if (menu.id !== id) menu.classList.add("hidden"); });
                document.getElementById(id).classList.toggle("hidden");
            }

            document.addEventListener("click", function() {
                document.querySelectorAll("[id^='pdropdown-']")
                        .forEach(menu => menu.classList.add("hidden"));
            });

            // ===== PAYMENT DETAIL MODAL =====
            function openPaymentDetail(row) {
                document.getElementById("modalPaymentId").textContent   = row.getAttribute("data-payment-id");
                document.getElementById("modalBookingId").textContent   = "#" + row.getAttribute("data-booking-id");
                document.getElementById("modalAmount").textContent      = row.getAttribute("data-amount") + " VND";
                document.getElementById("modalMethod").textContent      = row.getAttribute("data-method-display");
                document.getElementById("modalTransactionId").textContent = row.getAttribute("data-transaction");
                document.getElementById("modalPaidAt").textContent     = row.getAttribute("data-paid-at");
                document.getElementById("modalService").textContent    = row.getAttribute("data-service") || "—";
                document.getElementById("modalCustomerName").textContent  = row.getAttribute("data-customer") || "—";
                document.getElementById("modalCustomerPhone").textContent = row.getAttribute("data-phone") || "—";
                document.getElementById("modalCustomerEmail").textContent = row.getAttribute("data-email") || "—";

                // Status badge
                const status = row.getAttribute("data-status");
                const statusEl = document.getElementById("modalStatus");
                if (status === "paid") {
                    statusEl.innerHTML = '<span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">Paid</span>';
                } else {
                    statusEl.innerHTML = '<span class="inline-flex px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">Pending</span>';
                }

                // Checkin image
                const checkinUrl = row.getAttribute("data-checkin");
                if (checkinUrl) {
                    document.getElementById("modalCheckinImg").src = checkinUrl;
                    document.getElementById("modalCheckinImg").classList.remove("hidden");
                    document.getElementById("noCheckin").classList.add("hidden");
                } else {
                    document.getElementById("modalCheckinImg").classList.add("hidden");
                    document.getElementById("noCheckin").classList.remove("hidden");
                }

                // Checkout image
                const checkoutUrl = row.getAttribute("data-checkout");
                if (checkoutUrl) {
                    document.getElementById("modalCheckoutImg").src = checkoutUrl;
                    document.getElementById("modalCheckoutImg").classList.remove("hidden");
                    document.getElementById("noCheckout").classList.add("hidden");
                } else {
                    document.getElementById("modalCheckoutImg").classList.add("hidden");
                    document.getElementById("noCheckout").classList.remove("hidden");
                }

                document.getElementById("paymentDetailModal").classList.remove("hidden");
                document.body.style.overflow = "hidden";
            }

            function closePaymentDetail(e) {
                if (!e || e.target === document.getElementById("paymentDetailModal")) {
                    document.getElementById("paymentDetailModal").classList.add("hidden");
                    document.body.style.overflow = "auto";
                }
            }
        </script>

    </body>
</html>
