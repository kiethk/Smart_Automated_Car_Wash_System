<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String currentUri = request.getRequestURI();

    String dashboardActive = currentUri.contains("/admin/dashboard") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";
    String bookingActive = currentUri.contains("/admin/bookings") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";
    String customerActive = currentUri.contains("/admin/customers") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";
    String serviceActive = currentUri.contains("/admin/services") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";
    String promotionActive = currentUri.contains("/admin/promotions") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";
    String bayActive = currentUri.contains("/admin/bays") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";
    String slotActive = currentUri.contains("/admin/slots") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";
    String notificationActive = currentUri.contains("/admin/notifications") ? "bg-indigo-50 text-indigo-700 border-indigo-200" : "text-slate-600 border-transparent hover:bg-slate-50 hover:text-indigo-700";


%>

<aside class="w-72 min-h-screen bg-white border-r border-slate-200 hidden lg:flex flex-col sticky top-0">
    <div class="h-16 px-6 flex items-center border-b border-slate-100">
        <jsp:include page="/components/logo.jsp" />
    </div>

    <div class="flex-1 px-4 py-5 overflow-y-auto admin-scrollbar">
        <p class="px-3 text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">
            Management
        </p>

        <nav class="space-y-1">
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= dashboardActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Dashboard
            </a>

            <a href="${pageContext.request.contextPath}/admin/bookings"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= bookingActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Bookings
            </a>

            <a href="${pageContext.request.contextPath}/admin/customers"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= customerActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Customers
            </a>

            <a href="${pageContext.request.contextPath}/admin/services"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= serviceActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Services
            </a>

            <a href="${pageContext.request.contextPath}/admin/promotions"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= promotionActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Promotions
            </a>

            <a href="${pageContext.request.contextPath}/admin/bays"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= bayActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Bays
            </a>

            <a href="${pageContext.request.contextPath}/admin/slots"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= slotActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Slots
            </a>

            <a href="${pageContext.request.contextPath}/admin/notifications"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border text-sm font-semibold transition-all <%= notificationActive%>">
                <span class="w-2 h-2 rounded-full bg-current opacity-70"></span>
                Notifications
            </a>
        </nav>

        <p class="px-3 text-xs font-bold text-slate-400 uppercase tracking-wider mt-8 mb-3">
            System
        </p>

        <nav class="space-y-1">
            <a href="${pageContext.request.contextPath}/MainController?action=home"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border border-transparent text-sm font-semibold text-slate-600 hover:bg-slate-50 hover:text-indigo-700 transition-all">
                Back to Website
            </a>

            <a href="${pageContext.request.contextPath}/logout"
               class="flex items-center gap-3 px-4 py-3 rounded-2xl border border-transparent text-sm font-semibold text-red-500 hover:bg-red-50 transition-all">
                Logout
            </a>
        </nav>
    </div>

</aside>
