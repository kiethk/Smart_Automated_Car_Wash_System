<%@page import="dto.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.BookingHistoryDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%!
    private String tabClass(String tabStatus, String currentStatus) {
        if (tabStatus.equals(currentStatus)) {
            return "px-4 py-2.5 text-xs md:text-sm font-semibold rounded-xl whitespace-nowrap transition-all duration-200 bg-primary text-white shadow-sm";
        } else {
            return "px-4 py-2.5 text-xs md:text-sm font-semibold rounded-xl whitespace-nowrap transition-all duration-200 text-slate-500 hover:bg-slate-100 hover:text-primary border border-slate-200";
        }
    }
%>
<%
    List<BookingHistoryDTO> bookings = (List<BookingHistoryDTO>) request.getAttribute("BOOKINGS");
    User currentUser = (User) session.getAttribute("USER");
    String currentStatus = (String) request.getAttribute("CURRENT_STATUS");
    String successmessage = (String) request.getParameter("msg");
    if (currentStatus == null) {
        currentStatus = "";
    }

    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<jsp:include page="/components/header.jsp" />

<style>
    .modal-overlay {
        background-color: rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(2px);
    }
</style>

<main class="flex-grow max-w-[1280px] mx-auto w-full px-4 md:px-16 py-12">
    <%
        if (successmessage != null) {
    %>
    <p><%=successmessage%></p>
    <%
        }
    %>
    <!-- Tiêu đề trang -->
    <div class="mb-10">
        <h1 class="text-2xl md:text-3xl font-black text-on-background mb-2 tracking-tight">Booking History</h1>
        <p class="text-sm text-slate-500 font-normal">Review your past and upcoming service appointments.</p>
    </div>

    <!-- Bộ lọc trạng thái -->
    <div class="flex items-center gap-3 pb-4 mb-8 border-b border-surface-border">

        <a href="${pageContext.request.contextPath}/BookingHistory"
           class="<%= tabClass("", currentStatus)%>">
            All Bookings
        </a>

        <div class="relative">
            <button id="filterBtn"
                    class="px-4 py-2.5 text-xs md:text-sm font-semibold rounded-xl whitespace-nowrap transition-all duration-200 text-slate-500 hover:bg-slate-100 hover:text-primary border border-slate-200 flex items-center gap-2">
                <% if (!currentStatus.isEmpty()) {%>
                <%= currentStatus.substring(0, 1).toUpperCase() + currentStatus.substring(1)%>
                <% } else { %>
                Filter
                <% }%>
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                </svg>
            </button>

            <div id="filterMenu"
                 class="hidden absolute left-0 mt-2 w-56 bg-white rounded-xl shadow-lg border border-slate-200 z-50 overflow-hidden">
                <a href="${pageContext.request.contextPath}/BookingHistory?status=pending"
                   class="block px-4 py-3 text-sm hover:bg-slate-100 <%= "pending".equals(currentStatus) ? "font-bold text-primary" : ""%>">
                    Pending
                </a>
                <a href="${pageContext.request.contextPath}/BookingHistory?status=accepted"
                   class="block px-4 py-3 text-sm hover:bg-slate-100 <%= "Accepted".equals(currentStatus) ? "font-bold text-primary" : ""%>">
                    Accepted
                </a>
                <a href="${pageContext.request.contextPath}/BookingHistory?status=completed"
                   class="block px-4 py-3 text-sm hover:bg-slate-100 <%= "completed".equals(currentStatus) ? "font-bold text-primary" : ""%>">
                    Completed
                </a>
                <a href="${pageContext.request.contextPath}/BookingHistory?status=cancelled"
                   class="block px-4 py-3 text-sm hover:bg-slate-100 <%= "cancelled".equals(currentStatus) ? "font-bold text-primary" : ""%>">
                    Cancelled
                </a>
                <a href="${pageContext.request.contextPath}/BookingHistory?status=no_show"
                   class="block px-4 py-3 text-sm hover:bg-slate-100 <%= "no_show".equals(currentStatus) ? "font-bold text-primary" : ""%>">
                    No Show
                </a>
            </div>
        </div>
    </div>

    <!-- Danh sách thẻ Booking -->
    <div id="bookings-grid" class="grid grid-cols-1 md:grid-cols-2 gap-6">

        <%
            if (bookings == null || bookings.isEmpty()) {
        %>
        <div class="col-span-2 text-center text-slate-400 py-10">
            Bạn chưa có lịch đặt nào.
        </div>
        <%
        } else {
            for (BookingHistoryDTO bk : bookings) {
                String status = (bk.getStatus() != null) ? bk.getStatus() : "";
                String badgeClass;
                String dotClass;
                String label;

                if (status.equalsIgnoreCase("completed")) {
                    badgeClass = "bg-emerald-50 text-success border border-emerald-200";
                    dotClass = "bg-success";
                    label = "Completed";
                } else if (status.equalsIgnoreCase("pending")) {
                    badgeClass = "bg-amber-50 text-[#f59e0b] border border-amber-200";
                    dotClass = "bg-[#f59e0b]";
                    label = "Pending";
                } else if (status.equalsIgnoreCase("Accepted")) {
                    badgeClass = "bg-blue-50 text-[#0060ac] border border-blue-200";
                    dotClass = "bg-[#0060ac]";
                    label = "Accepted";
                } else if (status.equalsIgnoreCase("cancelled")) {
                    badgeClass = "bg-red-50 text-error border border-red-200";
                    dotClass = "bg-error";
                    label = "Cancelled";
                } else if (status.equalsIgnoreCase("no_show")) {
                    badgeClass = "bg-purple-50 text-purple-600 border border-purple-200";
                    dotClass = "bg-purple-600";
                    label = "No Show";
                } else {
                    badgeClass = "bg-slate-100 text-slate-500 border border-slate-200";
                    dotClass = "bg-slate-400";
                    label = status;
                }

                // Card cancelled sẽ bị làm mờ (opacity-60), vẫn xem được nội dung
                String cardOpacityClass = status.equalsIgnoreCase("cancelled") ? "opacity-60" : "";
        %>
        <!-- CARD -->
        <div class="booking-card bg-white border border-surface-border rounded-2xl p-6 shadow-sm flex flex-col hover:shadow-md transition-all duration-200 <%= cardOpacityClass%>">
            <div>
                <div class="flex justify-between items-start mb-4">
                    <div>
                        <span class="text-sm font-extrabold font-mono text-primary tracking-wide block mb-1">Booking ID: <%= bk.getBookingId()%></span>
                        <span class="text-[11px] font-semibold text-slate-400 font-mono tracking-tight block">Booking Date: <%= bk.getBookingDate()%></span>
                    </div>
                    <div class="flex items-center gap-1.5 px-3 py-1 <%= badgeClass%> rounded-full">
                        <span class="w-1.5 h-1.5 rounded-full <%= dotClass%>"></span>
                        <span class="text-[10px] uppercase font-mono font-bold tracking-wider"><%= label%></span>
                    </div>
                </div>

                <div class="py-4 border-y border-slate-100 mb-4 grid grid-cols-2 gap-y-4 gap-x-2">
                    <!-- Model Name và Plate Number -->
                    <div>
                        <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-0.5">Model</span>
                        <span class="text-xs font-bold text-on-background block"><%= bk.getModelName() != null ? bk.getModelName() : "N/A"%></span>
                    </div>
                    <div>
                        <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-0.5">Plate Number</span>
                        <span class="text-xs font-bold text-on-background block"><%= bk.getPlateNumber() != null ? bk.getPlateNumber() : "N/A"%></span>
                    </div>
                    <div>
                        <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-0.5">Customer ID</span>
                        <span class="text-xs font-bold text-on-background block">#<%= bk.getCustomerId()%></span>
                    </div>
                    <div class="col-span-2">
                        <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-0.5">Created At</span>
                        <span class="text-xs text-slate-600 block">
                            <%= bk.getCreatedAt() != null ? dateTimeFormat.format(bk.getCreatedAt()) : "N/A"%>
                        </span>
                    </div>
                </div>

                <!-- Khối ghi chú - LUÔN HIỂN THỊ cho mọi status, nội dung đổi theo status -->
                <div class="mb-4">
                    <% if (status.equalsIgnoreCase("pending") || status.equalsIgnoreCase("Accepted")) {
                            String paymentMethod = bk.getPaymentMethod();
                            if (paymentMethod == null) {
                                paymentMethod = "cash";
                            }
                    %>
                    <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-1">Payment Instructions</span>
                    <% if ("cash".equalsIgnoreCase(paymentMethod)) { %>
                    <div class="bg-amber-50 border border-amber-200 rounded-lg p-2 text-xs text-amber-700">
                        <strong>💵 Cash Payment:</strong> Please prepare exact amount and pay at the counter upon arrival.
                    </div>
                    <% } else if ("wallet".equalsIgnoreCase(paymentMethod)) { %>
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-2 text-xs text-blue-700">
                        <strong>💳 Wallet Payment:</strong> Payment has been deducted from your wallet successfully.
                    </div>
                    <% } else if ("qrcode".equalsIgnoreCase(paymentMethod) || "bank".equalsIgnoreCase(paymentMethod)) { %>
                    <div class="bg-green-50 border border-green-200 rounded-lg p-2 text-xs text-green-700">
                        <strong>📱 QR/Bank Transfer:</strong> Please scan the QR code at the counter or transfer to the bank account provided.
                    </div>
                  
                    <% }

                    } else if (status.equalsIgnoreCase("completed")) { %>
                    <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-1">Service Summary</span>
                    <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-2 text-xs text-emerald-700">
                        <strong>✅ Completed:</strong> Thank you for using AutoWash Pro! Feel free to book your next wash anytime.
                    </div>

                    <% } else if (status.equalsIgnoreCase("cancelled")) { %>
                    <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-1">Booking Status</span>
                    <div class="bg-red-50 border border-red-200 rounded-lg p-2 text-xs text-red-700">
                        <strong>❌ Cancelled:</strong> This booking has been cancelled. You can place a new booking anytime.
                    </div>

                    <% } else if (status.equalsIgnoreCase("no_show")) { %>
                    <span class="text-[10px] uppercase font-bold text-slate-400 font-mono tracking-wider block mb-1">Booking Status</span>
                    <div class="bg-purple-50 border border-purple-200 rounded-lg p-2 text-xs text-purple-700">
                        <strong>⚠️ No Show:</strong> You did not show up for this appointment. Please contact support if this is a mistake.
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Action Buttons - View Details và Cancel Booking -->
            <div class="flex justify-end items-center mt-2 pt-3 border-t border-slate-100">
                <% if (status.equalsIgnoreCase("pending")) {%>
                <div class="flex items-center gap-4">
                    <button onclick="openBookingDetail(<%= bk.getBookingId()%>)"
                            class="text-sm text-[#0060ac] hover:text-primary font-bold transition-all">
                        View Details
                    </button>
                    <button onclick="openCancelConfirm(<%= bk.getBookingId()%>)"
                            class="border border-red-200 text-red-600 hover:bg-red-50 text-xs font-bold py-1.5 px-4 rounded-lg transition-colors">
                        Cancel Booking
                    </button>
                </div>
                <% } else { %>
                <button onclick="openBookingDetail(<%= bk.getBookingId()%>)"
                        class="text-sm text-[#0060ac] hover:text-primary font-bold transition-all">
                    View Details
                </button>
                <% }%>
            </div>
        </div>

        <!-- MODAL CHO TỪNG BOOKING -->
        <div id="bookingDetailModal-<%= bk.getBookingId()%>" class="hidden fixed inset-0 modal-overlay z-50 flex items-center justify-center">
            <div class="bg-white rounded-2xl w-[600px] max-w-[95%] shadow-2xl max-h-[90vh] overflow-y-auto">

                <!-- Header -->
                <div class="flex justify-between items-start px-5 py-4 border-b rounded-t-2xl bg-white sticky top-0">
                    <div>
                        <h2 class="text-lg font-bold text-slate-800">Booking Details</h2>
                        <p class="text-xs text-slate-400 mt-1">Booking #<%= bk.getBookingId()%></p>
                    </div>
                    <button onclick="closeBookingDetail(<%= bk.getBookingId()%>)"
                            class="text-xl text-slate-500 hover:text-red-500 transition-colors">&times;</button>
                </div>

                <!-- Content -->
                <div class="p-5">
                    <div class="space-y-4 text-sm">

                        <!-- Booking Information -->
                        <div class="bg-slate-50 rounded-lg p-3">
                            <h3 class="text-xs font-bold uppercase text-primary mb-2">Booking Information</h3>
                            <div class="space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Booking ID:</span>
                                    <strong class="text-slate-800">#<%= bk.getBookingId()%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Booking Date:</span>
                                    <strong class="text-slate-800"><%= bk.getBookingDate() != null ? bk.getBookingDate() : "N/A"%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Created At:</span>
                                    <strong class="text-slate-800"><%= bk.getCreatedAt() != null ? dateTimeFormat.format(bk.getCreatedAt()) : "N/A"%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Status:</span>
                                    <span class="px-2 py-0.5 rounded-full <%= badgeClass%> text-[10px] font-bold"><%= label%></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Model:</span>
                                    <strong class="text-slate-800"><%= bk.getModelName() != null ? bk.getModelName() : "N/A"%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Plate Number:</span>
                                    <strong class="text-slate-800"><%= bk.getPlateNumber() != null ? bk.getPlateNumber() : "N/A"%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Customer ID:</span>
                                    <strong class="text-slate-800">#<%= bk.getCustomerId()%></strong>
                                </div>
                            </div>
                        </div>

                        <!-- Customer Information -->
                        <div class="bg-slate-50 rounded-lg p-3">
                            <h3 class="text-xs font-bold uppercase text-primary mb-2">Customer Information</h3>
                            <div class="space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Full Name:</span>
                                    <strong class="text-slate-800"><%= bk.getCustomerFullName() != null ? bk.getCustomerFullName() : "N/A"%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Phone:</span>
                                    <strong class="text-slate-800"><%= bk.getCustomerPhone() != null ? bk.getCustomerPhone() : "N/A"%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Email:</span>
                                    <strong class="text-slate-800"><%= bk.getCustomerEmail() != null ? bk.getCustomerEmail() : "N/A"%></strong>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-slate-500">Payment Method:</span>
                                    <strong class="text-slate-800"><%= bk.getPaymentMethod() != null ? bk.getPaymentMethod() : "N/A"%></strong>
                                </div>
                            </div>
                        </div>

                        <!-- Verification Images - CHỈ HIỆN KHI STATUS LÀ COMPLETED -->
                        <% if (status.equalsIgnoreCase("completed")) { %>
                        <div class="bg-slate-50 rounded-lg p-3">
                            <h3 class="text-xs font-bold uppercase text-primary mb-2">Verification Images</h3>
                            <div class="grid grid-cols-2 gap-3">
                                <div>
                                    <p class="text-[10px] text-slate-400 mb-1">📸 Check-in</p>
                                    <% if (bk.getCheckinImageUrl() != null && !bk.getCheckinImageUrl().isEmpty()) {%>
                                    <img src="${pageContext.request.contextPath}/<%= bk.getCheckinImageUrl()%>"
                                         alt="Check-in"
                                         class="rounded-lg border w-full h-[100px] object-cover">
                                    <% } else { %>
                                    <div class="rounded-lg border w-full h-[100px] bg-slate-100 flex items-center justify-center text-slate-400 text-xs">
                                        No image
                                    </div>
                                    <% } %>
                                </div>
                                <div>
                                    <p class="text-[10px] text-slate-400 mb-1">📸 Check-out</p>
                                    <% if (bk.getCheckoutImageUrl() != null && !bk.getCheckoutImageUrl().isEmpty()) {%>
                                    <img src="${pageContext.request.contextPath}/<%= bk.getCheckoutImageUrl()%>"
                                         alt="Check-out"
                                         class="rounded-lg border w-full h-[100px] object-cover">
                                    <% } else { %>
                                    <div class="rounded-lg border w-full h-[100px] bg-slate-100 flex items-center justify-center text-slate-400 text-xs">
                                        No image
                                    </div>
                                    <% }%>
                                </div>
                            </div>
                        </div>
                        <% } %>

                    </div>
                </div>

                <!-- Footer -->
                <div class="border-t px-5 py-4 flex justify-end bg-white rounded-b-2xl sticky bottom-0">
                    <button onclick="closeBookingDetail(<%= bk.getBookingId()%>)"
                            class="bg-slate-900 text-white px-5 py-2 rounded-lg text-sm font-semibold hover:bg-slate-700 transition-colors">
                        Close
                    </button>
                </div>

            </div>
        </div>

        <%
                }
            }
        %>

    </div>
</main>

<!-- MODAL XÁC NHẬN HỦY BOOKING (dùng chung cho mọi card pending) -->
<div id="cancelConfirmModal" class="hidden fixed inset-0 modal-overlay z-[60] flex items-center justify-center">
    <div class="bg-white rounded-2xl w-[380px] max-w-[95%] shadow-2xl p-6 text-center">
        <div class="w-12 h-12 rounded-full bg-red-50 text-red-500 flex items-center justify-center mx-auto mb-4">
            <i data-lucide="alert-triangle" class="w-6 h-6"></i>
        </div>
        <h3 class="text-base font-bold text-slate-800 mb-2">Cancel this booking?</h3>
        <p class="text-sm text-slate-500 mb-6">This action cannot be undone. Are you sure you want to cancel this booking?</p>

        <div class="flex gap-3">
            <button onclick="closeCancelConfirm()"
                    class="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-sm font-bold rounded-xl transition-colors">
                Keep Booking
            </button>
            <a id="cancelConfirmLink" href="#"
               class="flex-1 py-2.5 bg-red-600 hover:bg-red-700 text-white text-sm font-bold rounded-xl transition-colors">
                Yes, Cancel
            </a>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />

<script>
    const filterBtn = document.getElementById("filterBtn");
    const filterMenu = document.getElementById("filterMenu");

    filterBtn.addEventListener("click", function (e) {
        e.stopPropagation();
        filterMenu.classList.toggle("hidden");
    });

    document.addEventListener("click", function () {
        filterMenu.classList.add("hidden");
    });

    // Functions for booking detail modal
    function openBookingDetail(bookingId) {
        const modal = document.getElementById("bookingDetailModal-" + bookingId);
        if (modal) {
            modal.classList.remove("hidden");
            document.body.style.overflow = "hidden";
        }
    }

    function closeBookingDetail(bookingId) {
        const modal = document.getElementById("bookingDetailModal-" + bookingId);
        if (modal) {
            modal.classList.add("hidden");
            document.body.style.overflow = "auto";
        }
    }

    // Functions for cancel confirm modal
    function openCancelConfirm(bookingId) {
        const link = document.getElementById("cancelConfirmLink");
        link.href = "${pageContext.request.contextPath}/BookingHistory?cancelId=" + bookingId;
        document.getElementById("cancelConfirmModal").classList.remove("hidden");
        document.body.style.overflow = "hidden";
    }

    function closeCancelConfirm() {
        document.getElementById("cancelConfirmModal").classList.add("hidden");
        document.body.style.overflow = "auto";
    }

    // Close modal when clicking outside
    window.onclick = function (event) {
        if (event.target.classList && event.target.classList.contains('modal-overlay')) {
            const modals = document.querySelectorAll('[id^="bookingDetailModal-"]');
            modals.forEach(modal => {
                if (!modal.classList.contains('hidden')) {
                    modal.classList.add('hidden');
                    document.body.style.overflow = "auto";
                }
            });

            const cancelModal = document.getElementById("cancelConfirmModal");
            if (cancelModal && !cancelModal.classList.contains('hidden')) {
                cancelModal.classList.add('hidden');
                document.body.style.overflow = "auto";
            }
        }
    }

    if (window.lucide) {
        lucide.createIcons();
    }
</script>
