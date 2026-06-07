<%@page import="dto.Promotion"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Wallet"%>
<%@page import="dto.User"%>
<%@page import="dto.Slot"%>
<%@page import="dto.Service"%>
<%@page import="dto.Vehicle"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<jsp:include page="/components/header.jsp" />

<%
    // 1. Nhận nguyên liệu an toàn từ Controller truyền sang
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("VEHICLES");
    List<Service> serviceList = (List<Service>) request.getAttribute("SERVICES");
    List<Slot> slotList = (List<Slot>) request.getAttribute("SLOTS");
    List<Slot> allSlotList = (List<Slot>) request.getAttribute("ALLSLOTLIST");
    List<Promotion> promoList = (List<Promotion>) request.getAttribute("PROMOTIONS");

    if (vehicleList == null) {
        vehicleList = new ArrayList<>();
    }
    if (serviceList == null) {
        serviceList = new ArrayList<>();
    }
    if (slotList == null) {
        slotList = new ArrayList<>();
    }
    if (promoList == null) {
        promoList = new ArrayList<>();
    }

    User user = (User) session.getAttribute("USER");
    Wallet wallet = (Wallet) session.getAttribute("WALLET");
    Customer customer = (Customer) session.getAttribute("CUSTOMER");

    String fullName = (user != null) ? user.getFullName() : "Customer";
    double walletBalance = (wallet != null) ? wallet.getBalance() : 0;
    int availablePoints = (customer != null) ? customer.getTotalPoints() : 0;
    int tierId = (customer != null) ? customer.getTierId() : 1;

    // Xác định cấu hình theo Hạng thành viên của nhóm bạn
    double discountRate = 0.0;
    String tierName = "Member";
    int maxBookingDays = 7; // Mặc định Member là 7 ngày

    if (tierId == 2) {
        discountRate = 0.05;
        tierName = "Silver";
        maxBookingDays = 10;
    } else if (tierId == 3) {
        discountRate = 0.10;
        tierName = "Gold";
        maxBookingDays = 12;
    } else if (tierId == 4) {
        discountRate = 0.15;
        tierName = "Platinum";
        maxBookingDays = 14;
    }
%>

<main class="flex-grow pt-[32px] pb-24 px-4 md:px-16 max-w-[1280px] mx-auto w-full flex flex-col md:flex-row gap-6 font-sans">

    <%-- CỘT BÊN TRÁI: KHU VỰC ĐIỀN FORM --%>
    <form action="${pageContext.request.contextPath}/booking" method="POST" id="bookingForm" class="w-full md:w-2/3 flex flex-col gap-8">

        <%-- SECTION 1: SELECT VEHICLE (Nằm ngang chuẩn mẫu) --%>
        <section class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <h2 class="text-xl font-bold mb-4 text-slate-900">Select Vehicle</h2>
            <div class="flex flex-wrap gap-3">
                <%
                    if (!vehicleList.isEmpty()) {
                        for (int i = 0; i < vehicleList.size(); i++) {
                            Vehicle vehicle = vehicleList.get(i);
                            boolean isFirst = (i == 0);
                %>
                <label class="cursor-pointer w-full sm:w-auto sm:min-w-[260px] sm:flex-1">
                    <input class="sr-only peer" name="vehicleId" type="radio"
                           value="<%= vehicle.getVehicleId()%>" data-vehicle-type="<%= vehicle.getVehicleType()%>" <%= isFirst ? "checked" : ""%> required/>
                    <div class="relative p-4 rounded-2xl border-2 border-slate-100 bg-white
                         flex items-center gap-4
                         hover:border-indigo-300 hover:shadow-md
                         peer-checked:border-indigo-600 peer-checked:bg-indigo-50/40 peer-checked:shadow-indigo-100 peer-checked:shadow-lg
                         transition-all duration-200">

                        <%-- Checkmark badge khi được chọn --%>
                        <div class="absolute top-3 right-3 w-5 h-5 rounded-full border-2 border-slate-200
                             peer-checked:border-indigo-600 bg-white
                             flex items-center justify-center
                             opacity-0 peer-checked:opacity-100 transition-opacity">
                        </div>
                        <div class="hidden peer-checked:flex absolute top-2.5 right-2.5 w-5 h-5 rounded-full bg-indigo-600
                             items-center justify-center">
                            <svg class="w-3 h-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                            </svg>
                        </div>

                        <%-- Icon xe --%>
                        <div class="w-12 h-12 rounded-xl bg-slate-100 peer-checked:bg-indigo-100
                             flex items-center justify-center flex-shrink-0 transition-colors">
                            <img src="<%= (vehicle.getVehicleImageUrl() != null && !vehicle.getVehicleImageUrl().trim().isEmpty())
                                    ? vehicle.getVehicleImageUrl()
                                    : request.getContextPath() + "/assets/images/no-image-car.jpg"%>"
                                 class="w-full h-full object-cover rounded-xl" alt="vehicle"/>
                        </div>

                        <%-- Thông tin xe --%>
                        <div class="flex-1 min-w-0 pr-4">
                            <div class="font-bold text-slate-800 text-sm truncate">
                                <%= vehicle.getBrandDisplay()%> <%= vehicle.getModelDisplay()%>
                            </div>
                            <div class="text-xs text-slate-400 font-mono mt-0.5 truncate">
                                <%= vehicle.getPlateNumber()%>
                            </div>
                            <div class="flex items-center gap-1.5 mt-1.5">
                                <span class="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-slate-100 text-slate-500">
                                    <%= vehicle.getVehicleType()%>
                                </span>
                                <span class="text-[10px] text-slate-400">
                                    <%= vehicle.getColor()%> · <%= vehicle.getManufactureYear()%>
                                </span>
                            </div>
                        </div>
                    </div>
                </label>
                <%
                    }
                } else {
                %>
                <div class="w-full flex flex-col items-center justify-center py-8 text-center
                     border-2 border-dashed border-slate-200 rounded-2xl bg-slate-50">
                    <span class="material-symbols-outlined text-slate-300 text-4xl mb-2">no_crash</span>
                    <p class="text-sm font-semibold text-slate-400">No vehicles found</p>
                    <p class="text-xs text-slate-400 mt-1">
                        Please <a href="${pageContext.request.contextPath}/profile"
                                  class="text-indigo-600 hover:underline font-medium">add a vehicle</a> in your profile first.
                    </p>
                </div>
                <%
                    }
                %>
            </div>
        </section>

        <%-- SECTION 2: SERVICE PACKAGE --%>
        <section class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <h2 class="text-xl font-bold mb-4 text-slate-900">Service Package</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4" id="serviceGrid">
                <%
                    if (!serviceList.isEmpty()) {
                        for (Service s : serviceList) {
                            // Xác định loại service dựa theo tên
                            String sType = s.getServiceName().toLowerCase().contains("suv") ? "suvtruck" : "sedan";
                %>
                <label class="cursor-pointer relative block" data-service-type="<%= sType%>">
                    <input class="peer sr-only" name="serviceId" type="radio" value="<%= s.getServiceId()%>"
                           data-name="<%= s.getServiceName()%>" data-price="<%= s.getPrice()%>" required/>
                    <div class="p-5 rounded-2xl border-2 border-slate-100 bg-white
                         hover:border-indigo-300 hover:shadow-md
                         peer-checked:border-indigo-600 peer-checked:bg-indigo-50/40 peer-checked:shadow-lg peer-checked:shadow-indigo-100
                         transition-all duration-200 h-full flex flex-col justify-between relative">

                        <%-- Checkmark góc trên phải --%>
                        <div class="hidden peer-checked:flex absolute top-3 right-3 w-5 h-5 rounded-full bg-indigo-600
                             items-center justify-center">
                            <svg class="w-3 h-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                            </svg>
                        </div>

                        <div>
                            <h3 class="text-sm font-bold text-slate-900 mb-1 pr-6"><%= s.getServiceName()%></h3>
                            <p class="text-xs text-slate-400 line-clamp-3 mb-4"><%= s.getDescription()%></p>
                        </div>
                        <div class="flex items-center justify-between mt-auto">
                            <span class="font-bold text-sm text-indigo-900 font-mono">
                                <%= String.format("%,d", s.getPrice())%> VND
                            </span>
                            <span class="text-[10px] px-2 py-0.5 rounded-full font-semibold
                                  <%= sType.equals("suvtruck") ? "bg-orange-100 text-orange-600" : "bg-blue-100 text-blue-600"%>">
                                <%= sType.equals("suvtruck") ? "SUV/Truck" : "Sedan"%>
                            </span>
                        </div>
                    </div>
                </label>
                <%
                        }
                    }
                %>
            </div>
        </section>

        <%-- SECTION 3: SELECT DATE & TIME (Custom Calendar lưới ô vuông) --%>
        <section class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <h2 class="text-xl font-bold text-slate-900 mb-1">Select Date & Time</h2>
            <div class="bg-indigo-50 text-indigo-950 px-4 py-2.5 rounded-xl mb-4 text-xs font-medium">
                ✨ Based on your <strong class="uppercase text-indigo-700 font-bold"><%= tierName%> Tier</strong>, you can book up to <strong class="font-bold"><%= maxBookingDays%> days</strong> in advance.
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <%-- Custom Calendar UI Component --%>
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-2 uppercase">Calendar</label>
                    <div class="border border-slate-200 rounded-xl p-4 bg-slate-50/50">
                        <div class="flex justify-between items-center mb-3">
                            <span id="calendarMonthYear" class="text-sm font-bold text-slate-800">Month Year</span>
                        </div>
                        <%-- Khung lưới hiển thị các ô ngày đặt lịch --%>
                        <div class="grid grid-cols-7 gap-1 text-center text-xs font-semibold mb-1 text-slate-400">
                            <div>Su</div><div>Mo</div><div>Tu</div><div>We</div><div>Th</div><div>Fr</div><div>Sa</div>
                        </div>
                        <div id="calendarDaysGrid" class="grid grid-cols-7 gap-1">
                            <%-- Các ô ngày sẽ được JavaScript tự sinh ra real-time tại đây --%>
                        </div>
                    </div>
                    <%-- Input ẩn lưu ngày khách hàng click chọn thực tế để gửi lên Server --%>
                    <input type="hidden" id="bookingDate" name="bookingDate" value="${requestScope.SELECTED_DATE}" required>
                </div>

                <%-- Available Times --%>
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-2 uppercase">Available Times</label>
                    <div class="grid grid-cols-2 gap-3">
                        <%
                            if (!slotList.isEmpty()) {
                                for (Slot slot : slotList) {
                        %>
                        <label class="cursor-pointer block text-center">
                            <input class="peer sr-only" name="slotId" type="radio" value="<%= slot.getSlotId()%>" required/>
                            <div class="py-2.5 px-3 rounded-xl border border-slate-200 bg-white text-slate-700 text-xs font-bold font-mono hover:border-indigo-900 peer-checked:bg-indigo-950 peer-checked:text-white peer-checked:border-indigo-950 transition-colors">
                                <%= slot.getTimeValue()%>
                            </div>
                        </label>
                        <%
                            }
                        } else {
                        %>
                        <p class="text-xs text-slate-400 col-span-2 text-center py-6 border border-dashed border-slate-200 rounded-xl bg-slate-50/50">Please select a date from the calendar to view slots.</p>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </section>

        <%-- SECTION 4: ADDITIONAL NOTES --%>
        <section class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <h2 class="text-xl font-bold mb-3 text-slate-900">Additional Notes</h2>
            <textarea name="notes" class="w-full rounded-xl border-slate-200 bg-white focus:border-indigo-900 focus:ring focus:ring-indigo-900/10 transition-shadow p-3 text-xs resize-none" placeholder="Notes for the Station / Special Requests..." rows="3"></textarea>
        </section>

        <%-- SECTION 5: PAYMENT METHOD --%>
        <section class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <h2 class="text-xl font-bold mb-4 text-slate-900">Payment Method</h2>
            <div class="flex flex-col gap-3">
                <%-- Option 1: Digital Wallet --%>
                <label class="cursor-pointer block">
                    <input checked="" class="peer sr-only" name="paymentMethod" type="radio" value="WALLET"/>
                    <div class="p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-600 peer-checked:border-indigo-950 peer-checked:bg-indigo-50/20 flex items-center gap-3">
                        <span class="material-symbols-outlined text-indigo-950">account_balance_wallet</span>
                        <span class="text-xs font-bold text-slate-700 flex-grow">AutoWash Digital Wallet</span>
                        <span class="text-xs font-mono text-slate-400 font-bold">(Balance: <%= String.format("%,.0f", walletBalance)%> VND)</span>
                    </div>
                </label>
                <%-- Option 2: Scan QR Code --%>
                <label class="cursor-pointer block">
                    <input class="peer sr-only" name="paymentMethod" type="radio" value="QRCODE"/>
                    <div class="p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-600 peer-checked:border-indigo-950 peer-checked:bg-indigo-50/20 flex items-center gap-3">
                        <span class="material-symbols-outlined text-slate-700">qr_code_scanner</span>
                        <span class="text-xs font-bold text-slate-700">Scan QR Code via Mobile App</span>
                    </div>
                </label>
                <%-- Option 3: Cash --%>
                <label class="cursor-pointer block">
                    <input class="peer sr-only" name="paymentMethod" type="radio" value="CASH"/>
                    <div class="p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-600 peer-checked:border-indigo-950 peer-checked:bg-indigo-50/20 flex items-center gap-3">
                        <span class="material-symbols-outlined text-slate-700">payments</span>
                        <span class="text-xs font-bold text-slate-700">Pay with Cash at Station</span>
                    </div>
                </label>
            </div>
        </section>

        <%-- Các trường input ẩn phụ trợ gửi giá trị tính toán lên DB --%>
        <input type="hidden" name="hiddenDiscountAmount" id="hiddenDiscountAmount" value="0">
        <input type="hidden" name="hiddenPointsRedeemed" id="hiddenPointsRedeemed" value="0">
        <input type="hidden" name="hiddenPromotionId" id="hiddenPromotionId" value="">
    </form>

    <%-- CỘT BÊN PHẢI: ORDER SUMMARY (STICKY CHUẨN MẪU) --%>
    <div class="w-full md:w-1/3">
        <div class="sticky top-[32px] bg-white rounded-2xl border border-slate-200 shadow-sm p-5 flex flex-col gap-5">
            <h2 class="text-lg font-bold border-b border-slate-100 pb-3 text-slate-900">Order Summary</h2>

            <div class="space-y-2 text-xs">
                <div class="flex justify-between text-slate-500">
                    <span id="summaryPackageName">Selected Package</span>
                    <span id="summaryPackagePrice" class="font-bold font-mono text-slate-800">0 VND</span>
                </div>
                <div class="flex justify-between text-emerald-600 font-semibold">
                    <span><%= tierName%> Discount (<%= (int) (discountRate * 100)%>%)</span>
                    <span id="summaryTierDiscount" class="font-mono">-0 VND</span>
                </div>
                <div class="flex justify-between text-indigo-600 font-semibold border-b border-slate-100 pb-2">
                    <span>Voucher Coupon</span>
                    <span id="summaryVoucherDiscount" class="font-mono">-0 VND</span>
                </div>
            </div>

            <%-- Nhập Voucher --%>
            <div>
                <label class="block text-[10px] font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Apply Promo Code</label>
                <div class="flex gap-2">
                    <input id="couponInput" class="flex-grow rounded-xl border-slate-200 bg-white px-3 py-2 text-xs uppercase font-mono font-bold focus:border-indigo-900 focus:ring-0" placeholder="CODE" type="text"/>
                    <button type="button" onclick="applyVoucher()" class="px-3 py-2 bg-indigo-950 text-white hover:bg-indigo-900 rounded-xl text-xs font-bold transition-colors">Apply</button>
                </div>
                <p id="couponMsg" class="text-[10px] mt-1 hidden"></p>
            </div>

            <%-- Đổi điểm --%>
            <div class="border-t border-slate-100 pt-3">
                <label class="block text-[10px] font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Redeem Points (Max: <%= availablePoints%> pts)</label>
                <div class="flex gap-2">
                    <input id="redeemPointsInput" class="flex-grow rounded-xl border-slate-200 bg-white px-3 py-2 text-xs font-mono" placeholder="Points" type="number" min="0" max="<%= availablePoints%>"/>
                    <button type="button" onclick="applyPoints()" class="px-3 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition-colors">Apply</button>
                </div>
                <p id="pointsError" class="text-[10px] text-red-500 mt-1 hidden"></p>
            </div>

            <div class="border-t border-slate-100 pt-3 flex justify-between items-center text-base font-bold">
                <span class="text-slate-900">Total to Pay</span>
                <span id="summaryTotal" class="text-indigo-950 font-mono text-lg">0 VND</span>
            </div>

            <button onclick="handleBookingCheckout()" type="button" class="w-full bg-gradient-to-r from-indigo-950 to-slate-900 text-white font-bold text-xs py-3.5 rounded-xl shadow-sm flex items-center justify-center gap-2 hover:opacity-95 transition-opacity">
                <span class="material-symbols-outlined text-sm">check_circle</span>
                Confirm Booking
            </button>
        </div>
    </div>
</main>

<%-- POPUP DIALOG QUÉT MÃ QR CODE --%>
<div id="qrModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center hidden">
    <div class="bg-white p-6 rounded-2xl border border-slate-100 max-w-sm w-full text-center shadow-xl flex flex-col items-center">
        <h3 class="text-base font-bold text-slate-900 mb-1">Scan QR Code to Pay</h3>
        <p class="text-xs text-slate-400 mb-4">Open your Mobile Banking or E-Wallet app to scan</p>

        <div class="w-48 h-48 bg-slate-100 p-2 rounded-xl border border-slate-200 mb-4 flex items-center justify-center">
            <%-- Dùng API tạo mã QR động hiển thị số tiền thanh toán thực tế --%>
            <img id="qrImageElement" src="" alt="Payment QR Code" class="w-full h-full object-contain">
        </div>

        <p id="qrTotalText" class="font-mono font-bold text-indigo-950 mb-5 text-sm">0 VND</p>

        <div class="flex gap-2 w-full">
            <button type="button" onclick="closeQrModal()" class="flex-1 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition-colors">Cancel</button>
            <button type="button" onclick="confirmPaidQr()" class="flex-1 py-2 bg-indigo-950 hover:bg-indigo-900 text-white text-xs font-bold rounded-xl transition-all shadow-sm">I have paid on app</button>
        </div>
    </div>
</div>

<script>
    // Toàn bộ slot data từ server, load 1 lần duy nhất
    const allSlots = [
    <%
        for (Slot slot : allSlotList) {
            // Kiểm tra slot này có full trong ngày đang chọn không
            boolean isFull = false;
            for (Slot s : slotList) {
                if (s.getSlotId() == slot.getSlotId()) {
                    isFull = s.isFull();
                    break;
                }
            }
    %>
    {
    slotId: <%= slot.getSlotId()%>,
            timeValue: "<%= slot.getTimeValue()%>",
            startTime: "<%= slot.getStartTime()%>",
            endTime: "<%= slot.getEndTime()%>",
            isActive: <%= slot.getIsActive()%>,
            isFull: <%= isFull%>
    },
    <%
        }
    %>
    ];
    // --- FILTER SERVICE THEO LOẠI XE ĐƯỢC CHỌN ---
    function filterServicesByVehicleType(vehicleType) {
    const type = vehicleType.toLowerCase();
    // Sedan -> hiện sedan, ẩn suvtruck | SUV/Truck -> hiện suvtruck, ẩn sedan
    const targetType = (type === 'suv' || type === 'truck') ? 'suvtruck' : 'sedan';
    document.querySelectorAll('#serviceGrid label[data-service-type]').forEach(card => {
    const radio = card.querySelector('input[type="radio"]');
    if (card.dataset.serviceType === targetType) {
    card.classList.remove('hidden');
    radio.disabled = false;
    } else {
    card.classList.add('hidden');
    radio.disabled = true;
    radio.checked = false;
    }
    });
    // Tự động chọn service đầu tiên còn hiển thị
    const firstVisible = document.querySelector('#serviceGrid label[data-service-type="' + targetType + '"] input[type="radio"]');
    if (firstVisible) {
    firstVisible.checked = true;
    appliedPointsValue = 0;
    document.getElementById('redeemPointsInput').value = "";
    updateOrderSummary();
    }
    }

// Gắn event lắng nghe thay đổi xe
    document.querySelectorAll('input[name="vehicleId"]').forEach(radio => {
    radio.addEventListener('change', function () {
    const selectedLabel = this.closest('label');
    // Lấy vehicleType từ data attribute trên label
    const vehicleType = this.getAttribute('data-vehicle-type');
    if (vehicleType)
            filterServicesByVehicleType(vehicleType);
    });
    });
    // 2. Mock danh sách Khuyến mãi đồng bộ từ DB
    const promoDatabase = [
    <%
        if (!promoList.isEmpty()) {
            for (Promotion p : promoList) {
    %>
    {
    id: <%= p.getPromotionId()%>,
            code: "<%= p.getCode().trim().toUpperCase()%>",
            type: "<%= p.getDiscountType()%>",
            value: <%= p.getDiscountValue()%>,
            minOrder: <%= p.getMinOrderAmount()%>,
            targetTier: <%= (p.getTargetTierId() != null) ? p.getTargetTierId() : "null"%>
    },
    <%
            }
        }
    %>
    ];
    let currentPackagePrice = 0;
    let appliedTierDiscount = 0;
    let appliedVoucherDiscount = 0;
    let appliedPointsValue = 0;
    let currentVoucherObj = null;
    let finalPayCalculated = 0;
    const userDiscountRate = <%= discountRate%>;
    const maxUserPoints = <%= availablePoints%>;
    const userTierId = <%= tierId%>;
    const bookingWindowDays = <%= maxBookingDays%>;
    // --- LOGIC CUSTOM CALENDAR CHUẨN KHOẢNG NGÀY ĐẶT THEO TIER ---
    // Ngày hợp lệ nằm trong khoảng cho phép chọn
    function renderSlots() {
    const grid = document.getElementById('slotGrid');
    const activeSlots = allSlots.filter(s => s.isActive === 1);
    if (activeSlots.length === 0) {
    grid.innerHTML = `
            <p class="text-xs text-slate-400 col-span-2 text-center py-6
                       border border-dashed border-slate-200 rounded-xl bg-slate-50/50">
                No available slots.
            </p>`;
    return;
    }

    // Tìm slot đầu tiên còn chỗ để auto-check
    const firstAvailable = activeSlots.find(s => !s.isFull);
    grid.innerHTML = activeSlots.map(slot => `
        <label class="cursor-pointer block text-center ${slot.isFull ? 'cursor-not-allowed' : ''}">
            <input class="peer sr-only" name="slotId" type="radio"
                   value="${slot.slotId}"
    ${firstAvailable && slot.slotId == firstAvailable.slotId ? 'checked' : ''}
    ${slot.isFull ? 'disabled' : ''} required/>
            <div class="py-2.5 px-3 rounded-xl border text-xs font-bold font-mono transition-colors
    ${slot.isFull
      ? 'border-slate-100 bg-slate-50 text-slate-300 cursor-not-allowed'
      : 'border-slate-200 bg-white text-slate-700 hover:border-indigo-900 peer-checked:bg-indigo-950 peer-checked:text-white peer-checked:border-indigo-950'}">
      ${slot.timeValue}
      ${slot.isFull ? '<span class="block text-[10px] font-normal opacity-60">Full</span>' : ''}
            </div>
        </label>
    `).join('');
    }

    function renderCustomCalendar() {
    const grid = document.getElementById('calendarDaysGrid');
    const title = document.getElementById('calendarMonthYear');
    grid.innerHTML = '';
    const today = new Date();
    const currentYear = today.getFullYear();
    const currentMonth = today.getMonth();
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    title.innerText = monthNames[currentMonth] + " " + currentYear;
    const firstDayIndex = new Date(currentYear, currentMonth, 1).getDay();
    const totalDaysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();
    // Tạo khoảng trắng ô đệm đầu tháng
    for (let i = 0; i < firstDayIndex; i++) {
    const emptyDiv = document.createElement('div');
    grid.appendChild(emptyDiv);
    }

    const selectedDateStr = document.getElementById('bookingDate').value;
    // Sinh lưới ngày
    for (let day = 1; day <= totalDaysInMonth; day++) {
    const cellDate = new Date(currentYear, currentMonth, day);
    const dateStr = cellDate.getFullYear() + '-'
            + String(cellDate.getMonth() + 1).padStart(2, '0') + '-'
            + String(cellDate.getDate()).padStart(2, '0');
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.innerText = day;
    btn.className = "p-2 text-xs font-semibold font-mono rounded-lg transition-all flex items-center justify-center w-full ";
    // Tính khoảng cách ngày so với hôm nay để check giới hạn Tier
    const diffTime = cellDate - new Date(today.getFullYear(), today.getMonth(), today.getDate());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    if (diffDays >= 0 && diffDays < bookingWindowDays) {
    if (dateStr === selectedDateStr) {
    btn.className += " bg-indigo-950 text-white font-bold ";
    } else {
    btn.className += " bg-white border border-slate-100 text-slate-800 hover:border-indigo-900 ";
    }
    btn.onclick = function () {
    document.getElementById('bookingDate').value = dateStr;
    // Cập nhật highlight ngày được chọn
    document.querySelectorAll('#calendarDaysGrid button').forEach(b => {
    b.classList.remove('bg-indigo-950', 'text-white', 'font-bold');
    b.classList.add('bg-white', 'border', 'border-slate-100', 'text-slate-800', 'hover:border-indigo-900');
    });
    this.classList.remove('bg-white', 'border', 'border-slate-100', 'text-slate-800', 'hover:border-indigo-900');
    this.classList.add('bg-indigo-950', 'text-white', 'font-bold');
    renderSlots();
    };
    } else {
    // Ngày nằm ngoài giới hạn Booking Window của Tier -> Khóa (Disable)
    btn.className += " bg-slate-100 text-slate-300 cursor-not-allowed opacity-40 ";
    btn.disabled = true;
    }
    grid.appendChild(btn);
    }
    }

    // --- HÀM TÍNH TOÁN REAL-TIME TỔNG HÓA ĐƠN ---
    function updateOrderSummary() {
    const selectedPackage = document.querySelector('input[name="serviceId"]:checked');
    let packageName = "Selected Package";
    if (selectedPackage) {
    currentPackagePrice = parseFloat(selectedPackage.getAttribute('data-price')) || 0;
    packageName = selectedPackage.getAttribute('data-name');
    } else {
    currentPackagePrice = 0;
    }

    appliedTierDiscount = currentPackagePrice * userDiscountRate;
    appliedVoucherDiscount = 0;
    if (currentVoucherObj) {
    if (currentPackagePrice < currentVoucherObj.minOrder) {
    currentVoucherObj = null;
    const msgEl = document.getElementById('couponMsg');
    msgEl.innerText = "Voucher removed. Base price too low!";
    msgEl.className = "text-[10px] text-red-500 mt-1";
    document.getElementById('couponInput').value = "";
    document.getElementById('hiddenPromotionId').value = "";
    } else {
    if (currentVoucherObj.type === 'percent') {
    appliedVoucherDiscount = currentPackagePrice * (currentVoucherObj.value / 100);
    } else if (currentVoucherObj.type === 'fixed') {
    appliedVoucherDiscount = currentVoucherObj.value;
    }
    }
    }

    let totalDiscountSystem = appliedTierDiscount + appliedVoucherDiscount;
    if (totalDiscountSystem > currentPackagePrice)
            totalDiscountSystem = currentPackagePrice;
    let maxAllowedPoints = currentPackagePrice - totalDiscountSystem;
    if (appliedPointsValue > maxAllowedPoints) {
    appliedPointsValue = maxAllowedPoints;
    document.getElementById('redeemPointsInput').value = appliedPointsValue;
    }

    finalPayCalculated = currentPackagePrice - totalDiscountSystem - appliedPointsValue;
    if (finalPayCalculated < 0)
            finalPayCalculated = 0;
    document.getElementById('summaryPackageName').innerText = packageName;
    document.getElementById('summaryPackagePrice').innerText = currentPackagePrice.toLocaleString('vi-VN') + " VND";
    document.getElementById('summaryTierDiscount').innerText = "-" + appliedTierDiscount.toLocaleString('vi-VN') + " VND";
    document.getElementById('summaryVoucherDiscount').innerText = "-" + appliedVoucherDiscount.toLocaleString('vi-VN') + " VND";
    document.getElementById('summaryTotal').innerText = finalPayCalculated.toLocaleString('vi-VN') + " VND";
    document.getElementById('hiddenDiscountAmount').value = totalDiscountSystem;
    document.getElementById('hiddenPointsRedeemed').value = appliedPointsValue;
    }

    function applyVoucher() {
    const inputCode = document.getElementById('couponInput').value.trim().toUpperCase();
    const msgEl = document.getElementById('couponMsg');
    msgEl.classList.remove('hidden');
    if (!inputCode) {
    msgEl.innerText = "Enter a code.";
    msgEl.className = "text-[10px] text-red-500 mt-1";
    return;
    }

    const voucher = promoDatabase.find(v => v.code === inputCode);
    if (!voucher) {
    msgEl.innerText = "Invalid code.";
    msgEl.className = "text-[10px] text-red-500 mt-1";
    currentVoucherObj = null;
    document.getElementById('hiddenPromotionId').value = "";
    updateOrderSummary();
    return;
    }

    if (voucher.targetTier && userTierId < voucher.targetTier) {
    msgEl.innerText = "Tier too low.";
    msgEl.className = "text-[10px] text-red-500 mt-1";
    currentVoucherObj = null;
    document.getElementById('hiddenPromotionId').value = "";
    updateOrderSummary();
    return;
    }

    if (currentPackagePrice < voucher.minOrder) {
    msgEl.innerText = "Min order: " + voucher.minOrder.toLocaleString('vi-VN') + " VND";
    msgEl.className = "text-[10px] text-red-500 mt-1";
    currentVoucherObj = null;
    document.getElementById('hiddenPromotionId').value = "";
    updateOrderSummary();
    return;
    }

    msgEl.innerText = "Code applied!";
    msgEl.className = "text-[10px] text-emerald-600 mt-1 font-bold";
    currentVoucherObj = voucher;
    document.getElementById('hiddenPromotionId').value = voucher.id;
    updateOrderSummary();
    }

    function applyPoints() {
    const pointsInput = document.getElementById('redeemPointsInput');
    const pointsValue = parseInt(pointsInput.value) || 0;
    const errorEl = document.getElementById('pointsError');
    errorEl.classList.add('hidden');
    if (pointsValue < 0 || pointsValue > maxUserPoints) {
    errorEl.innerText = "Not enough points.";
    errorEl.classList.remove('hidden');
    return;
    }

    let currentTotalDiscountSystem = appliedTierDiscount + appliedVoucherDiscount;
    let maxAllowedPoints = currentPackagePrice - currentTotalDiscountSystem;
    if (pointsValue > maxAllowedPoints) {
    errorEl.innerText = "Exceeds remaining price.";
    errorEl.classList.remove('hidden');
    return;
    }

    appliedPointsValue = pointsValue;
    updateOrderSummary();
    }

    // --- LUỒNG XỬ LÝ CHECKOUT / POPUP THEO PHƯƠNG THỨC THANH TOÁN ---
    function handleBookingCheckout() {
    const form = document.getElementById('bookingForm');
    if (!form.reportValidity())
            return;
    const method = document.querySelector('input[name="paymentMethod"]:checked').value;
    if (method === 'QRCODE') {
    // Hiển thị Popup QR Code real-time số tiền
    document.getElementById('qrTotalText').innerText = finalPayCalculated.toLocaleString('vi-VN') + " VND";
    // Sử dụng link sinh mã QR mẫu từ QR Server API miễn phí
    document.getElementById('qrImageElement').src = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=AutoWashPayment_" + finalPayCalculated;
    document.getElementById('qrModal').classList.remove('hidden');
    } else {
    // WALLET hoặc CASH -> Thực hiện gửi thẳng form lên Controller xử lý
    form.submit();
    }
    }

    function closeQrModal() {
    document.getElementById('qrModal').classList.add('hidden');
    }

    function confirmPaidQr() {
    // Sau khi khách bấm xác nhận đã quét QR -> Tự đóng popup và submit form
    document.getElementById('qrModal').classList.add('hidden');
    document.getElementById('bookingForm').submit();
    }

    document.querySelectorAll('input[name="serviceId"]').forEach(radio => {
    radio.addEventListener('change', () => {
    appliedPointsValue = 0;
    document.getElementById('redeemPointsInput').value = "";
    updateOrderSummary();
    });
    });
    document.addEventListener('DOMContentLoaded', () => {
    // Tự động tích chọn gói đầu tiên để có data tính toán
    const firstRadio = document.querySelector('input[name="serviceId"]');
    if (firstRadio)
            firstRadio.checked = true;
    const firstVehicle = document.querySelector('input[name="vehicleId"]:checked');
    if (firstVehicle)
            filterServicesByVehicleType(firstVehicle.getAttribute('data-vehicle-type'));
    renderCustomCalendar();
    renderSlots();
    updateOrderSummary();
    });
    </script>

    <jsp:include page="/components/footer.jsp" />