<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/components/header.jsp" />
<main class="max-w-[1280px] mx-auto px-4 md:px-16 py-8 min-h-[85vh]">

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <div class="lg:col-span-2 space-y-6">

            <div class="relative overflow-hidden bg-gradient-to-r from-slate-900 to-indigo-950 text-white rounded-2xl p-6 md:p-8 shadow-sm group">
                <div class="absolute inset-0 opacity-20 bg-cover bg-center transition-transform duration-500 group-hover:scale-105" 
                     style="background-image: url('${pageContext.request.contextPath}/assets/images/car-background.jpg');"></div>

                <div class="relative z-10 space-y-3 max-w-xl">
                    <span class="inline-block bg-indigo-500/20 text-indigo-300 text-xs font-semibold px-3 py-1 rounded-full border border-indigo-500/30">
                        Weekend Flash Sale: 15% Off for Silver Tier+
                    </span>
                    <p class="text-slate-300 text-sm leading-relaxed">
                        Top up Wallet over 500k to get 50k bonus! Ensure your vehicle receives expert care this weekend.
                    </p>
                    <div class="pt-2">
                        <a href="${pageContext.request.contextPath}/booking" 
                           class="inline-block bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold px-5 py-2.5 rounded-xl transition shadow-sm">
                            Book Now
                        </a>
                    </div>
                </div>
            </div>

            <div class="bg-gradient-to-br from-indigo-900 via-indigo-800 to-blue-900 text-white rounded-2xl p-6 shadow-md relative overflow-hidden">
                <div class="absolute -right-10 -top-10 w-40 h-40 bg-white/5 rounded-full blur-xl"></div>

                <div class="flex justify-between items-start mb-8">
                    <div>
                        <p class="text-xs text-indigo-200 uppercase tracking-wider font-medium mb-1">Digital Member Card</p>
                        <h2 class="text-2xl font-bold tracking-tight">${sessionScope.USER.fullName}</h2>
                    </div>
                    <span class="bg-amber-400 text-amber-950 text-[10px] font-extrabold px-3 py-1 rounded-full flex items-center gap-1 shadow-sm uppercase tracking-wider">
                        ★ Gold Tier
                    </span>
                </div>

                <div class="grid grid-cols-2 gap-4 pt-4 border-t border-white/10">
                    <div>
                        <p class="text-xs text-indigo-200 font-medium mb-1">Points Balance</p>
                        <p class="text-xl font-mono font-bold tracking-wide">12,450</p>
                    </div>
                    <div class="flex justify-between items-end">
                        <div>
                            <p class="text-xs text-indigo-200 font-medium mb-1">Wallet Balance</p>
                            <p class="text-xl font-mono font-bold tracking-wide">1,250,000 VND</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/MainController?action=topup" 
                           class="bg-white text-indigo-900 hover:bg-slate-100 text-xs font-bold px-4 py-2 rounded-xl transition shadow-sm">
                            Top up Wallet
                        </a>
                    </div>
                </div>
            </div>

            <div class="bg-white border border-slate-200/80 rounded-2xl p-5 shadow-sm">
                <div class="flex justify-between text-xs font-bold text-slate-600 mb-2">
                    <span>Tier Progress</span>
                    <span class="text-slate-500 font-medium">2 more washes until <strong class="text-slate-800 font-bold">Platinum</strong></span>
                </div>
                <div class="w-full bg-slate-100 h-3 rounded-full overflow-hidden">
                    <div class="bg-amber-500 h-full rounded-full transition-all duration-500" style="width: 75%"></div>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/booking" 
               class="flex flex-col items-center justify-center border-2 border-dashed border-slate-200 hover:border-indigo-400 bg-white hover:bg-indigo-50/30 text-indigo-950 p-8 rounded-2xl transition group shadow-sm">
                <div class="bg-indigo-50 text-indigo-600 p-4 rounded-full mb-3 transition group-hover:scale-110 group-hover:bg-indigo-100">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5m-9-6h.008v.008H12v-.008ZM12 15h.008v.008H12V15Zm0 2.25h.008v.008H12v-.008ZM9.75 15h.008v.008H9.75V15Zm0 2.25h.008v.008H9.75v-.008ZM7.5 15h.008v.008H7.5V15Zm0 2.25h.008v.008H7.5v-.008Zm6.75-4.5h.008v.008h-.008v-.008Zm0 2.25h.008v.008h-.008V15Zm0 2.25h.008v.008h-.008v-.008Zm2.25-4.5h.008v.008H16.5v-.008Zm0 2.25h.008v.008H16.5V15Z" />
                    </svg>
                </div>
                <span class="text-base font-bold tracking-tight">Book a New Wash Slot</span>
            </a>

        </div>

        <div class="space-y-6">

            <div class="bg-white border border-slate-200/80 rounded-2xl p-6 shadow-sm flex flex-col justify-between h-full">
                <div>
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="text-lg font-bold text-slate-900 tracking-tight">Upcoming Appointment</h3>
                        <span class="bg-emerald-50 text-emerald-700 border border-emerald-200 text-[10px] font-bold px-2.5 py-1 rounded-full flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                            Approved
                        </span>
                    </div>

                    <div class="space-y-5">

                        <div class="flex items-start gap-3.5">
                            <div class="bg-indigo-50 text-indigo-600 p-2.5 rounded-xl border border-indigo-100 mt-0.5">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-xs text-slate-400 font-medium">Date & Time</p>
                                <p class="text-sm font-semibold text-slate-800">Oct 28, 2023 at 09:00 AM</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-3.5">
                            <div class="bg-indigo-50 text-indigo-600 p-2.5 rounded-xl border border-indigo-100 mt-0.5">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124l-.047-2.437a5.616 5.616 0 0 0-5.12-5.407L15.75 5.25h-3.115c-.422 0-.811.235-1.004.61l-.975 1.95H3.375c-.621 0-1.125.504-1.125 1.125v4.33M3.375 14.25h17.25M2.25 14.25v-.031c0-.122.1-.222.22-.222h19.06c.12 0 .22.1.22.222v.031m-18 0h16.5" />
                                </svg>
                            </div>
                            <div>
                                <p class="text-xs text-slate-400 font-medium">Vehicle Details</p>
                                <p class="text-sm font-semibold text-slate-800 font-mono">XYZ-9876 (Black SUV)</p>
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
                                <p class="text-sm font-semibold text-slate-800">Bay 02 - Premium Detail</p>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="grid grid-cols-2 gap-3 pt-8 mt-auto border-t border-slate-100">
                    <a href="${pageContext.request.contextPath}/MainController?action=reschedule" 
                       class="border border-slate-200 hover:bg-slate-50 text-slate-700 text-xs font-bold py-2.5 rounded-xl text-center transition">
                        Reschedule
                    </a>
                    <a href="${pageContext.request.contextPath}/MainController?action=viewAppointment" 
                       class="bg-indigo-950 hover:bg-indigo-900 text-white text-xs font-bold py-2.5 rounded-xl text-center transition shadow-sm">
                        View Details
                    </a>
                </div>
            </div>

        </div>

    </div>
</main>

<jsp:include page="/components/footer.jsp" />