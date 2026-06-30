<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/components/header.jsp" />
<main class="max-w-[1280px] mx-auto px-4 md:px-16 py-8 min-h-[85vh] space-y-6">

    <c:choose>
        <c:when test="${requestScope.HAS_BANNER}">
            <div class="text-left w-full animate-fade-in">
                <div class="flex items-center gap-2.5 pl-1 mb-7">
                    <div class="w-1 h-4 bg-gradient-to-b from-blue-950 to-blue-600 rounded-full"></div>
                    <h3 class="text-sm font-black text-slate-700 uppercase tracking-wider">
                        Available Special Offers
                    </h3>
                </div>
                <jsp:include page="/components/promotions-carousel.jsp" />
            </div>
        </c:when>
        <c:otherwise>
            <div class="relative overflow-hidden rounded-2xl p-6 md:p-8 shadow-md text-left text-white bg-gradient-to-r from-blue-950 to-slate-900 w-full min-h-[160px] flex flex-col justify-center mb-4">
                <div class="relative z-10 space-y-1">
                    <h2 class="text-xl md:text-2xl font-bold tracking-tight text-white">Welcome back to AutoWash Pro Ecosystem!</h2>
                    <p class="text-slate-300 text-sm">Experience frictionless, high-trust automated automotive care with absolute precision.</p>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start w-full">

        <div class="lg:col-span-2 space-y-6">

            <div class="bg-gradient-to-r from-blue-950 via-blue-900 to-blue-600 text-white rounded-2xl p-6 shadow-md relative overflow-hidden">
                <div class="absolute -right-10 -top-10 w-40 h-40 bg-white/5 rounded-full blur-xl"></div>

                <div class="flex justify-between items-start mb-8">
                    <div>
                        <p class="text-xs text-blue-200 uppercase tracking-wider font-medium mb-1">Digital Member Card</p>
                        <h2 class="text-2xl font-bold tracking-tight">${sessionScope.USER.fullName}</h2>
                    </div>
                    <span class="bg-amber-400 text-amber-950 text-[10px] font-extrabold px-3 py-1 rounded-full flex items-center gap-1 shadow-sm uppercase tracking-wider">
                        ★ ${requestScope.CURRENT_TIER_NAME} Tier
                    </span>
                </div>

                <div class="grid grid-cols-2 gap-4 pt-4 border-t border-white/10">
                    <div>
                        <p class="text-xs text-blue-200 font-medium mb-1">Points Balance</p>
                        <p class="text-xl font-mono font-bold tracking-wide">
                            <fmt:formatNumber value="${sessionScope.CUSTOMER.totalPoints}" pattern="#,###"/>
                        </p>
                    </div>
                    <div class="flex justify-between items-end">
                        <div>
                            <p class="text-xs text-blue-200 font-medium mb-1">Wallet Balance</p>
                            <p class="text-xl font-mono font-bold tracking-wide">
                                <fmt:formatNumber value="${sessionScope.WALLET.balance}" pattern="#,###" groupingUsed="false"/> VND
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/MainController?action=topup" 
                           class="bg-white text-blue-900 hover:bg-slate-100 text-xs font-bold px-4 py-2 rounded-xl transition shadow-sm">
                            Top up Wallet
                        </a>
                    </div>
                </div>
            </div>

            <div class="bg-white border border-slate-200/80 rounded-2xl p-5 shadow-sm">
                <div class="flex justify-between text-xs font-bold text-slate-600 mb-2">
                    <span>Tier Progress</span>
                    <span class="text-slate-500 font-medium">
                        <c:choose>
                            <c:when test="${requestScope.IS_MAX_TIER}">
                                You have reached the highest <strong class="text-slate-800 font-bold">Platinum</strong> elite status!
                            </c:when>
                            <c:otherwise>
                                ${requestScope.WASHES_LEFT} more washes until <strong class="text-slate-800 font-bold">${requestScope.NEXT_TIER_NAME}</strong>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="w-full bg-slate-100 h-3 rounded-full overflow-hidden">
                    <div class="bg-amber-500 h-full rounded-full transition-all duration-500" style="width: ${requestScope.PROGRESS_PERCENT}%"></div>
                </div>
            </div>

        </div>

        <div class="w-full">
            <div class="bg-white border border-slate-200/80 rounded-2xl p-6 shadow-sm flex flex-col justify-between min-h-[300px]">
                <div>
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="text-lg font-bold text-slate-900 tracking-tight">Upcoming Appointment</h3>

                        <c:choose>
                            <c:when test="${requestScope.HAS_APPOINTMENT}">
                                <span class="bg-emerald-50 text-emerald-700 border border-emerald-200 text-[10px] font-bold px-2.5 py-1 rounded-full flex items-center gap-1 capitalize">
                                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                                    ${requestScope.APPOINTMENT.status}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="bg-slate-50 text-slate-500 border border-slate-200 text-[10px] font-bold px-2.5 py-1 rounded-full flex items-center gap-1">
                                    No Slot Booked
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="space-y-5">
                        <c:choose>
                            <%-- TRƯỜNG HỢP 1: CÓ LỊCH HẸN THẬT SỰ ➡️ HIỂN THỊ CHI TIẾT --%>
                            <c:when test="${requestScope.HAS_APPOINTMENT}">
                                <div class="flex items-start gap-3.5">
                                    <div class="bg-indigo-50 text-indigo-600 p-2.5 rounded-xl border border-indigo-100 mt-0.5">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-xs text-slate-400 font-medium">Date & Time</p>
                                        <p class="text-sm font-semibold text-slate-800">
                                            ${requestScope.APPOINTMENT.bookingDate} at ${requestScope.APPOINTMENT.timeValue}
                                        </p>
                                    </div>
                                </div>

                                <div class="flex items-start gap-3.5">
                                    <div class="bg-indigo-50 text-indigo-600 p-2.5 rounded-xl border border-indigo-100 mt-0.5">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.124l-.047-2.437a5.616 5.616 0 0 0-5.12-5.407L15.75 5.25h-3.115c-.422 0-.811.235-1.004.61l-.975 1.95H3.375c-.621 0-1.125.504-1.125 1.125v4.33M3.375 14.25h17.25M2.25 14.25v-.031c0-.122.1-.222.22-.222h19.06c.12 0 .22.1.22.222v.031m-18 0h16.5" />
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-xs text-slate-400 font-medium">Vehicle Details</p>
                                        <p class="text-sm font-semibold text-slate-800 font-mono">
                                            ${requestScope.APPOINTMENT.plateNumber} (${requestScope.APPOINTMENT.brandDisplay} ${requestScope.APPOINTMENT.modelDisplay})
                                        </p>
                                    </div>
                                </div>

                                <div class="flex items-start gap-3.5">
                                    <div class="bg-indigo-50 text-indigo-600 p-2.5 rounded-xl border border-indigo-100 mt-0.5">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 21h16.5M4.5 3h15M5.25 3v18m13.5-18v18M9 6.75h1.5m-1.5 3h1.5m-1.5 3h1.5m3-6H15m-1.5 3H15m-1.5 3H15M9 21v-3.375c0-.621.504-1.125 1.125-1.125h3.75c.621 0 1.125.504 1.125 1.125V21" />
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-xs text-slate-400 font-medium">Service Bay</p>
                                        <p class="text-sm font-semibold text-slate-800">
                                            ${requestScope.APPOINTMENT.bayName != null ? requestScope.APPOINTMENT.bayName : 'Assigning Automatically...'}
                                        </p>
                                    </div>
                                </div>
                            </c:when>

                            <%-- TRƯỜNG HỢP 2: KHÔNG CÓ LỊCH HẸN NÀO ➡️ HIỂN THỊ THÔNG BÁO VÀ NÚT ĐẶT LỊCH GỌN GÀNG --%>
                            <c:otherwise>
                                <div class="text-center py-10 flex flex-col items-center justify-center space-y-3 animate-fade-in">
                                    <span class="text-3xl">📭</span>
                                    <p class="text-sm font-bold text-slate-700">No Slot Booked</p>
                                    <p class="text-xs text-slate-400 max-w-[220px] leading-relaxed mx-auto">
                                        You don't have any upcoming appointments. Book a slot now to experience our care ecosystem!
                                    </p>
                                    <div class="pt-4 w-full">
                                        <a href="${pageContext.request.contextPath}/booking" 
                                           class="inline-block bg-gradient-to-r from-blue-950 via-blue-900 to-blue-600 hover:from-blue-900 hover:to-blue-500 text-white text-xs font-bold py-2.5 px-6 rounded-xl transition text-center shadow-sm w-full">
                                            Book A Slot Now
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

    </div>
</main>
<jsp:include page="/components/footer.jsp" />