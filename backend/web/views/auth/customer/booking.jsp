<%@page import="dto.Wallet"%>
<%@page import="dto.User"%>
<%@page import="dto.Slot"%>
<%@page import="dto.Service"%>
<%@page import="dto.Vehicle"%>
<%@page import="java.util.List"%>
<%-- Đảm bảo import chính xác đường dẫn Class DTO trong project của bạn --%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<jsp:include page="/components/header.jsp" />

<%
    // Lấy dữ liệu từ Request và Session (Ép kiểu về List / Object tương ứng)
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("VEHICLES");
    List<Service> serviceList = (List<Service>) request.getAttribute("SERVICES");
    List<Slot> bayList = (List<Slot>) request.getAttribute("SLOTS");

    User user = (User) session.getAttribute("USER");
    Wallet wallet = (Wallet) session.getAttribute("WALLET");

    // Khai báo an toàn đề phòng dữ liệu bị null
    String fullName = (user != null) ? user.getFullName() : "Customer";
    double walletBalance = (wallet != null) ? wallet.getBalance() : 0;
%>

<main class="flex-grow pt-[32px] pb-24 px-4 md:px-16 max-w-[1280px] mx-auto w-full flex flex-col md:flex-row gap-6">

    <%-- FORM ĐĂNG KÝ LỊCH HẸN --%>
    <form action="${pageContext.request.contextPath}/MainController" method="POST" class="w-full md:w-2/3 flex flex-col gap-12">
        <input type="hidden" name="action" value="submitBooking">

        <%-- CHỌN XE (SELECT VEHICLE) --%>
        <section>
            <h2 class="text-2xl font-bold mb-6 text-slate-900">Select Vehicle</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <%
                    if (vehicleList != null && !vehicleList.isEmpty()) {
                        for (int i = 0; i < vehicleList.size(); i++) {
                            Vehicle vehicle = vehicleList.get(i);
                            boolean isFirst = (i == 0);
                %>
                <div class="cursor-pointer bg-white p-4 flex justify-between items-center rounded-lg border border-slate-200 shadow-sm ">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-10 bg-slate-100 rounded-xl flex items-center justify-center text-slate-600 font-black text-[10px] tracking-tight tech-data uppercase px-1">
                            <%= vehicle.getVehicleType()%>
                        </div>
                        <div>
                            <div class="font-bold text-on-background"><%= vehicle.getBrand()%> <%= vehicle.getModel()%></div>
                            <div class="text-xs text-slate-400 tracking-wider tech-data font-semibold"><%= vehicle.getPlateNumber()%></div>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="col-span-2 p-6 border-2 border-dashed border-slate-200 rounded-xl text-center bg-white">
                    <p class="text-sm text-slate-500 mb-3">You haven't registered any vehicle yet.</p>
                    <a href="${pageContext.request.contextPath}/MainController?action=addVehicle" class="inline-block bg-indigo-950 text-white text-xs font-bold px-4 py-2 rounded-xl">
                        + Add New Vehicle
                    </a>
                </div>
                <%
                    }
                %>
            </div>
        </section>

        <%-- GÓI DỊCH VỤ (SERVICE PACKAGE) --%>
        <section>
            <h2 class="text-2xl font-bold mb-6 text-slate-900">Service Package</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                <%
                    if (serviceList != null) {
                        for (Service s : serviceList) {
                            boolean isPopular = (s.getServiceId() == 102); // Gói Deluxe ID 102 là phổ biến
%>
                <label class="cursor-pointer">
                    <input class="peer sr-only" name="serviceId" type="radio" value="<%= s.getServiceId()%>" 
                           data-name="<%= s.getServiceName()%>" data-price="<%= s.getPrice()%>" <%= isPopular ? "checked" : ""%>/>
                    <div class="p-6 rounded-xl border <%= isPopular ? "border-2 border-indigo-900 shadow-sm relative" : "border-slate-200"%> bg-white hover:shadow-sm transition-all peer-checked:border-indigo-900 peer-checked:bg-indigo-50/50 h-full flex flex-col">
                        <% if (isPopular) { %>
                        <div class="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-indigo-900 text-white px-3 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider">Popular</div>
                        <% }%>
                        <h3 class="text-lg font-bold text-slate-900 mb-2 <%= isPopular ? "mt-2" : ""%>"><%= s.getServiceName()%></h3>
                        <p class="text-sm text-slate-500 mb-4 flex-grow"><%= s.getDescription()%></p>
                        <div class="font-bold text-base text-indigo-950 font-mono">
                            <%= String.format("%,d", s.getPrice())%> VND
                        </div>
                    </div>
                </label>
                <%
                        }
                    }
                %>
            </div>

            <h3 class="text-lg font-bold mb-4 text-slate-800">Machine Add-ons</h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <label class="flex items-center gap-3 p-4 rounded-xl border border-slate-200 bg-white cursor-pointer hover:bg-slate-50 transition-colors">
                    <input name="addons" value="ceramic" data-price="150000" class="w-5 h-5 text-indigo-900 rounded border-slate-300 focus:ring-indigo-900 focus:ring-offset-0 bg-transparent" type="checkbox"/>
                    <span class="text-sm font-medium text-slate-700 flex-grow">Ceramic Shield Coating</span>
                    <span class="text-xs font-bold text-slate-500 font-mono">+150,000 VND</span>
                </label>
                <label class="flex items-center gap-3 p-4 rounded-xl border border-slate-200 bg-white cursor-pointer hover:bg-slate-50 transition-colors">
                    <input name="addons" value="wheel" data-price="50000" class="w-5 h-5 text-indigo-900 rounded border-slate-300 focus:ring-indigo-900 focus:ring-offset-0 bg-transparent" type="checkbox"/>
                    <span class="text-sm font-medium text-slate-700 flex-grow">Deep Wheel Scrub & Polish</span>
                    <span class="text-xs font-bold text-slate-500 font-mono">+50,000 VND</span>
                </label>
            </div>
        </section>

        <%-- CHỌN NGÀY VÀ GIỜ KHUNG (DATE & TIME) --%>
        <section>
            <h2 class="text-2xl font-bold mb-2 text-slate-900">Select Date & Time</h2>
            <div class="bg-amber-500/10 text-amber-900 px-4 py-3 rounded-xl mb-6 flex items-start gap-3 border border-amber-500/20">
                <span aria-hidden="true" class="material-symbols-outlined text-amber-600 mt-0.5">stars</span>
                <p class="text-xs font-medium leading-relaxed">
                    ✨ Hello <strong class="font-bold"><%= fullName%></strong>! Based on your <strong class="uppercase text-amber-700 font-bold">Gold Tier</strong>, you can priority book bays up to 12 days in advance.
                </p>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                <div class="p-6 rounded-xl border border-slate-200 bg-white flex flex-col justify-center space-y-3">
                    <label for="bookingDate" class="block text-sm font-bold text-slate-700">Choose Appointment Date</label>
                    <div class="relative">
                        <input type="date" id="bookingDate" name="bookingDate" required
                               class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-indigo-500 font-semibold font-mono">
                    </div>
                    <p class="text-[11px] text-slate-400">Please choose a standard working day. Real-time bay statuses will update upon selection.</p>
                </div>

                <div>
                    <h3 class="text-base font-bold mb-4 text-slate-800">Available Times</h3>
                    <div class="grid grid-cols-2 gap-3">
                        <%
                            if (bayList != null) {
                                for (Slot bay : bayList) {
                                    if (bay.isFull()) {
                        %>
                        <button type="button" class="py-2.5 px-4 rounded-xl border border-slate-100 bg-slate-100 text-slate-400 text-xs font-bold font-mono opacity-60 cursor-not-allowed text-center" disabled>
                            <%= bay.getTimeValue()%> (Full)
                        </button>
                        <%
                        } else {
                        %>
                        <label class="cursor-pointer block text-center">
                            <input class="peer sr-only" name="bayId" type="radio" value="<%= bay.getSlotId()%>" required/>
                            <div class="py-2.5 px-4 rounded-xl border border-slate-200 bg-white text-slate-700 text-xs font-bold font-mono hover:border-indigo-900 peer-checked:bg-indigo-950 peer-checked:text-white peer-checked:border-indigo-950 transition-colors">
                                <%= bay.getTimeValue()%>
                            </div>
                        </label>
                        <%
                                    }
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </section>

        <%-- GHI CHÚ BỔ SUNG --%>
        <section>
            <h2 class="text-2xl font-bold mb-4 text-slate-900">Additional Notes</h2>
            <textarea name="notes" class="w-full rounded-xl border-slate-200 bg-white focus:border-indigo-900 focus:ring focus:ring-indigo-900/10 transition-shadow p-4 text-sm resize-none" placeholder="Notes for the Car Care Station / Special Requests..." rows="3"></textarea>
        </section>

        <%-- PHƯƠNG THỨC THANH TOÁN --%>
        <section>
            <h2 class="text-2xl font-bold mb-6 text-slate-900">Payment Method</h2>
            <div class="space-y-4">
                <label class="cursor-pointer block">
                    <input checked="" class="peer sr-only" name="paymentMethod" type="radio" value="WALLET"/>
                    <div class="p-4 rounded-xl border border-slate-200 bg-white hover:shadow-sm transition-all peer-checked:border-indigo-900 peer-checked:bg-indigo-50/50 flex items-center gap-4">
                        <span aria-hidden="true" class="material-symbols-outlined text-indigo-900 text-2xl">account_balance_wallet</span>
                        <span class="text-sm font-semibold text-slate-700 flex-grow">AutoWash Digital Wallet</span>
                        <span class="text-sm font-bold text-slate-500 font-mono">
                            <%= String.format("%,.0f", walletBalance)%> VND
                        </span>
                    </div>
                </label>
                <label class="cursor-pointer block">
                    <input class="peer sr-only" name="paymentMethod" type="radio" value="QR"/>
                    <div class="p-4 rounded-xl border border-slate-200 bg-white hover:shadow-sm transition-all peer-checked:border-indigo-900 peer-checked:bg-indigo-50/50 flex items-center gap-4">
                        <span aria-hidden="true" class="material-symbols-outlined text-slate-400 text-2xl">qr_code_scanner</span>
                        <span class="text-sm font-semibold text-slate-700 flex-grow">Scan VNPAY-QR Code</span>
                    </div>
                </label>
            </div>
        </section>
    </form>

    <%-- CỘT BÊN PHẢI: ORDER SUMMARY (STICKY) --%>
    <div class="w-full md:w-1/3">
        <div class="sticky top-[32px] bg-white rounded-2xl border border-slate-200 shadow-sm p-6 flex flex-col gap-6">
            <h2 class="text-xl font-bold border-b border-slate-100 pb-4 text-slate-900">Order Summary</h2>

            <div class="space-y-3 text-sm">
                <div class="flex justify-between text-slate-500">
                    <span id="summaryPackageName">Selected Package</span>
                    <span id="summaryPackagePrice" class="font-semibold font-mono">0 VND</span>
                </div>
                <div class="flex justify-between text-slate-500">
                    <span>Add-ons Fee</span>
                    <span id="summaryAddonsPrice" class="font-semibold font-mono">0 VND</span>
                </div>
                <div class="flex justify-between text-emerald-600 font-medium">
                    <span>Gold Tier Discount (10%)</span>
                    <span id="summaryDiscount" class="font-mono">-0 VND</span>
                </div>
            </div>

            <div class="border-t border-slate-100 pt-4">
                <label class="block text-xs font-bold text-slate-700 mb-2 uppercase tracking-wider">Redeem Reward Points</label>
                <div class="flex gap-2">
                    <input name="redeemPoints" class="flex-grow rounded-xl border-slate-200 bg-white focus:border-indigo-900 focus:ring focus:ring-indigo-900/10 transition-shadow px-3 py-2 text-xs font-mono" placeholder="Available: 12,450 pts" type="number"/>
                    <button type="button" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition-colors">Apply</button>
                </div>
            </div>

            <div class="border-t border-slate-100 pt-4 flex justify-between items-center text-lg font-bold">
                <span class="text-slate-900">Total to Pay</span>
                <span id="summaryTotal" class="text-indigo-900 font-mono">0 VND</span>
            </div>

            <div class="bg-amber-500/10 text-amber-900 px-4 py-3 rounded-xl border border-amber-500/20 flex items-start gap-3">
                <span aria-hidden="true" class="material-symbols-outlined text-amber-600 mt-0.5">workspace_premium</span>
                <p class="text-xs font-medium leading-relaxed">
                    Your Gold Tier grants you <strong class="font-bold">+20% bonus points</strong>! You will earn approximately <span class="font-bold text-amber-700">[+55 Points]</span> upon cashout.
                </p>
            </div>

            <button onclick="submitBookingForm()" type="button" class="w-full bg-gradient-to-r from-indigo-950 to-slate-900 text-white font-bold text-sm py-4 rounded-xl hover:opacity-95 transition-opacity shadow-sm flex items-center justify-center gap-2">
                <span aria-hidden="true" class="material-symbols-outlined text-sm">check_circle</span>
                Confirm & Book Slot
            </button>
        </div>
    </div>
</main>



<script>
    // Khóa không cho chọn ngày quá khứ
    document.getElementById('bookingDate').min = new Date().toISOString().split("T")[0];

    // Trigger submit form bên trái
    function submitBookingForm() {
        const form = document.querySelector('form');
        if (form.reportValidity()) {
            form.submit();
        }
    }

    // --- LOGIC TÍNH TIỀN CHẠY REAL-TIME TRÊN GIAO DIỆN ---
    function updateOrderSummary() {
        const selectedPackage = document.querySelector('input[name="serviceId"]:checked');
        let packagePrice = 0;
        let packageName = "Selected Package";
        if (selectedPackage) {
            packagePrice = parseFloat(selectedPackage.getAttribute('data-price')) || 0;
            packageName = selectedPackage.getAttribute('data-name');
        }

        let addonsPrice = 0;
        const checkedAddons = document.querySelectorAll('input[name="addons"]:checked');
        checkedAddons.forEach(addon => {
            addonsPrice += parseFloat(addon.getAttribute('data-price')) || 0;
        });

        const discountRate = 0.10; // Giảm giá 10% Gold Tier
        let discountAmount = packagePrice * discountRate;
        let totalPay = (packagePrice + addonsPrice) - discountAmount;
        if (totalPay < 0)
            totalPay = 0;

        document.getElementById('summaryPackageName').innerText = packageName;
        document.getElementById('summaryPackagePrice').innerText = packagePrice.toLocaleString('vi-VN') + " VND";
        document.getElementById('summaryAddonsPrice').innerText = addonsPrice.toLocaleString('vi-VN') + " VND";
        document.getElementById('summaryDiscount').innerText = "-" + discountAmount.toLocaleString('vi-VN') + " VND";
        document.getElementById('summaryTotal').innerText = totalPay.toLocaleString('vi-VN') + " VND";
    }

    // Gán sự kiện lắng nghe click
    document.querySelectorAll('input[name="serviceId"]').forEach(radio => {
        radio.addEventListener('change', updateOrderSummary);
    });
    document.querySelectorAll('input[name="addons"]').forEach(checkbox => {
        checkbox.addEventListener('change', updateOrderSummary);
    });

    // Chạy tính toán khi load trang lần đầu
    document.addEventListener('DOMContentLoaded', updateOrderSummary);
</script>

<jsp:include page="/components/footer.jsp" />