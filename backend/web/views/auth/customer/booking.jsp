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
    List<Promotion> promoList = (List<Promotion>) request.getAttribute("PROMOTIONS");
    String selectedServiceId = (String) request.getAttribute("SELECTED_SERVICE_ID");

    if (selectedServiceId == null || selectedServiceId.trim().isEmpty()) {
        selectedServiceId = request.getParameter("serviceId");
    }

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
                           value="<%= vehicle.getVehicleId()%>"
                           data-vehicle-type="<%= vehicle.getVehicleType() != null ? vehicle.getVehicleType().toLowerCase() : ""%>"
                           <%= isFirst ? "checked" : ""%>
                           onchange="validateServiceVehicleMatch(); updateOrderSummary();"
                           required/>
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
                            String serviceNameLower = s.getServiceName().toLowerCase();
                            String sType = serviceNameLower.contains("suv") || serviceNameLower.contains("truck") ? "suvtruck" : "sedan";
                            boolean isSelectedFromIndex = selectedServiceId != null
                                    && selectedServiceId.trim().equals(String.valueOf(s.getServiceId()));
                %>

                <label class="cursor-pointer relative block" data-service-type="<%= sType%>">
                    <input class="peer sr-only" 
                           name="serviceId" 
                           type="radio" 
                           value="<%= s.getServiceId()%>"
                           data-name="<%= s.getServiceName()%>" 
                           data-price="<%= s.getPrice()%>"
                           data-service-type="<%= sType%>"
                           <%= isSelectedFromIndex ? "checked" : ""%>
                           onchange="findAndSelectMatchingVehicleForService(); validateServiceVehicleMatch(); updateOrderSummary();"
                           required/>
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
            <div id="vehicleServiceWarning"
                 class="hidden mt-4 p-4 rounded-2xl bg-red-50 border border-red-200 text-sm text-red-600 font-medium">
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
                    <div class="grid grid-cols-2 gap-3" id="slotGrid">

                    </div>
                </div>
            </div>
        </section>

        <%-- SECTION 4: ADDITIONAL NOTES --%>
        <section class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <div class="flex flex-col gap-2.5">
                <label for="notes" class="text-base font-semibold tracking-tight text-slate-900">
                    Additional Notes
                </label>
                <textarea 
                    id="notes"
                    name="notes" 
                    rows="3"
                    class="w-full rounded-xl border border-slate-200 bg-slate-50/30 p-3.5 text-sm text-slate-800 placeholder:text-slate-400 outline-none resize-none transition-all duration-200 focus:border-slate-400 focus:bg-white focus:ring-4 focus:ring-slate-100" 
                    placeholder="Notes for the Station / Special Requests..."
                    ></textarea>
            </div>
        </section>

        <%-- SECTION 5: PAYMENT METHOD --%>
        <section class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <div class="flex flex-col gap-4">
                <label class="text-base font-semibold tracking-tight text-slate-900">
                    Payment Method
                </label>

                <div class="flex flex-col gap-3">
                    <%-- Option 1: Digital Wallet --%>
                    <label class="cursor-pointer block">
                        <input checked type="radio" name="paymentMethod" value="WALLET" class="peer sr-only"/>
                        <div class="p-4 rounded-xl border border-slate-200 bg-white transition-all duration-200
                             hover:border-slate-300 hover:bg-slate-50/30
                             peer-checked:border-slate-900 peer-checked:bg-slate-50/50 peer-checked:ring-4 peer-checked:ring-slate-100
                             flex items-center gap-4">

                            <%-- Lucide Wallet Icon --%>
                            <div class="text-slate-400 transition-colors duration-200 peer-checked:text-slate-900 flex items-center justify-center shrink-0">
                                <i data-lucide="wallet" class="w-5 h-5 stroke-[1.75]"></i>
                            </div>

                            <div class="flex flex-col sm:flex-row sm:items-center gap-1 sm:gap-3 flex-grow">
                                <span class="text-sm font-medium text-slate-800">AutoWash Digital Wallet</span>
                                <span class="text-xs font-mono text-slate-400 font-medium">(Balance: <%= String.format("%,.0f", walletBalance)%> VND)</span>
                            </div>
                        </div>
                    </label>

                    <%-- Option 2: Scan QR Code --%>
                    <label class="cursor-pointer block">
                        <input type="radio" name="paymentMethod" value="QRCODE" class="peer sr-only"/>
                        <div class="p-4 rounded-xl border border-slate-200 bg-white transition-all duration-200
                             hover:border-slate-300 hover:bg-slate-50/30
                             peer-checked:border-slate-900 peer-checked:bg-slate-50/50 peer-checked:ring-4 peer-checked:ring-slate-100
                             flex items-center gap-4">

                            <%-- Lucide QR Code Icon --%>
                            <div class="text-slate-400 transition-colors duration-200 peer-checked:text-slate-900 flex items-center justify-center shrink-0">
                                <i data-lucide="qr-code" class="w-5 h-5 stroke-[1.75]"></i>
                            </div>

                            <span class="text-sm font-medium text-slate-800 flex-grow">Scan QR Code via Mobile App</span>
                        </div>
                    </label>

                    <%-- Option 3: Cash --%>
                    <label class="cursor-pointer block">
                        <input type="radio" name="paymentMethod" value="CASH" class="peer sr-only"/>
                        <div class="p-4 rounded-xl border border-slate-200 bg-white transition-all duration-200
                             hover:border-slate-300 hover:bg-slate-50/30
                             peer-checked:border-slate-900 peer-checked:bg-slate-50/50 peer-checked:ring-4 peer-checked:ring-slate-100
                             flex items-center gap-4">

                            <%-- Lucide Banknote Icon --%>
                            <div class="text-slate-400 transition-colors duration-200 peer-checked:text-slate-900 flex items-center justify-center shrink-0">
                                <i data-lucide="banknote" class="w-5 h-5 stroke-[1.75]"></i>
                            </div>

                            <span class="text-sm font-medium text-slate-800 flex-grow">Pay with Cash at Station</span>
                        </div>
                    </label>
                </div>
            </div>
        </section>


        <%-- CÁC TRƯỜNG INPUT ẨN ĐỒNG BỘ CHUẨN KHỚP VỚI BOOKINGCONTROLLER BACKEND --%>
        <input type="hidden" name="totalAmountInput" id="totalAmountInput" value="0">
        <input type="hidden" name="discountAmountInput" id="discountAmountInput" value="0">
        <input type="hidden" name="promotionIdInput" id="promotionIdInput" value="">
        <input type="hidden" name="redeemPoints" id="redeemPoints" value="0">
    </form>

    <%-- CỘT BÊN PHẢI: ORDER SUMMARY (PHONG CÁCH CHỌN PROMOTION KIỂU SHOPEE - KHÔNG BÁO ĐỎ) --%>
    <div class="w-full md:w-1/3">
        <div class="sticky top-8 bg-white rounded-2xl border border-surface-border shadow-sm p-6 flex flex-col gap-6">

            <%-- Header --%>
            <div class="flex items-center gap-2 border-b border-slate-100 pb-4">
                <i data-lucide="shopping-bag" class="w-5 h-5 text-primary stroke-[2]"></i>
                <h2 class="text-lg font-bold text-slate-900 tracking-tight">Order Summary</h2>
            </div>

            <%-- Bill Breakdown --%>
            <div class="space-y-3 text-sm">
                <%-- Base Package Price --%>
                <div class="flex justify-between items-center text-slate-500">
                    <span id="summaryPackageName">Selected Package</span>
                    <span id="summaryPackagePrice" class="tech-data text-slate-800">0 VND</span>
                </div>

                <%-- Tier Member Discount --%>
                <div class="flex justify-between items-center text-success font-medium bg-emerald-50/40 px-3 py-2 rounded-xl">
                    <div class="flex items-center gap-1.5">
                        <i data-lucide="award" class="w-4 h-4 stroke-[2]"></i>
                        <span><%= tierName%> (<%= (int) (discountRate * 100)%>%)</span>
                    </div>
                    <span id="summaryTierDiscount" class="tech-data">-0 VND</span>
                </div>

                <%-- Promotion Discount (Đổi text linh hoạt theo option được chọn) --%>
                <div class="flex justify-between items-center text-primary font-medium bg-slate-50 px-3 py-2 rounded-xl">
                    <div class="flex items-center gap-1.5">
                        <i data-lucide="ticket-percent" class="w-4 h-4 stroke-[2]"></i>
                        <span id="appliedPromoLabel">Selected Promotion</span>
                    </div>
                    <span id="summaryPromotionDiscount" class="tech-data">-0 VND</span>
                </div>

                <%-- Points Redeemed Discount --%>
                <div class="flex justify-between items-center text-slate-600 font-medium border-b border-slate-100 pb-3 px-3">
                    <div class="flex items-center gap-1.5">
                        <i data-lucide="coins" class="w-4 h-4 stroke-[2]"></i>
                        <span>Points Redeemed</span>
                    </div>
                    <span id="summaryPointsDiscount" class="tech-data">-0 VND</span>
                </div>
            </div>

            <%-- THAY Ô NHẬP TEXT THÀNH THẺ SELECT ĐỔI PROMOTION (KIỂU SHOPEE VOUCHER) --%>
            <div class="space-y-2">
                <div class="flex items-center justify-between">
                    <label for="promotionSelect" class="block text-xs font-bold uppercase tracking-wider text-slate-400">
                        Available Promotions
                    </label>
                    <span class="text-[10px] bg-primary/10 text-primary font-bold px-2 py-0.5 rounded-full">
                        Best Value Applied
                    </span>
                </div>

                <div class="relative">
                    <%-- Biểu tượng ticket nhỏ trang trí ở đầu thẻ select --%>
                    <div class="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none">
                        <i data-lucide="tag" class="w-4 h-4 stroke-[2]"></i>
                    </div>

                    <%-- Thẻ Select tùy biến cao cấp chỉnh padding-left để chừa chỗ cho icon --%>
                    <select id="promotionSelect" 
                            onchange="handlePromotionChange(this.value)"
                            class="w-full pl-10 pr-10 py-2 bg-slate-50 border border-surface-border rounded-2xl focus:outline-none focus:bg-white focus:ring-4 focus:ring-indigo-100 focus:border-primary transition-all duration-150 text-xs text-slate-700 font-medium appearance-none cursor-pointer">

                        <option value="" data-discount="0">-- No Promotion Applied --</option>

                        <%
                            if (!promoList.isEmpty()) {
                                for (Promotion p : promoList) {
                                    // Tính toán sơ bộ số tiền được giảm để hiển thị và làm data-discount cho JS
                                    // Đối với loại 'fixed', giá trị chính là discount_value.
                                    // Đối với loại 'percent' (như mã GOLDPREMIUM giảm 15%), tí nữa JavaScript sẽ tính toán động dựa trên tổng tiền hóa đơn, ở đây ta lưu tạm giá trị gốc hoặc xử lý cấu trúc.
                                    String code = p.getCode() != null ? p.getCode().trim().toUpperCase() : "NO_CODE";
                                    String discountType = p.getDiscountType() != null ? p.getDiscountType().trim().toLowerCase() : "fixed";
                                    long discountValue = p.getDiscountValue();
                                    long minOrder = p.getMinOrderAmount();

                                    String discountText = "";
                                    if ("percent".equalsIgnoreCase(discountType)) {
                                        discountText = "Giảm " + (int) discountValue + "%";
                                    } else {
                                        discountText = "Giảm " + String.format("%,d", discountValue) + " VND";
                                    }
                        %>
                        <option value="<%= p.getPromotionId()%>"
                                data-discount-type="<%= discountType%>"
                                data-discount-value="<%= discountValue%>"
                                data-min-order="<%= minOrder%>">
                            [<%= code%>] - <%= discountText%>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>

                    <%-- Mũi tên chỉ xuống tùy biến thay cho mũi tên mặc định của trình duyệt --%>
                    <div class="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none">
                        <i data-lucide="chevron-down" class="w-4 h-4 stroke-[2]"></i>
                    </div>
                </div>
                <p id="couponMsg" class="text-xs text-slate-500 mt-1"></p>
            </div>

            <%-- Khu vực đổi điểm thưởng (Loyalty Points) --%>
            <div class="border-t border-slate-100 pt-4 space-y-2">
                <div class="flex justify-between items-center">
                    <span class="block text-xs font-bold uppercase tracking-wider text-slate-400">Redeem Points</span>
                    <span class="text-[11px] text-slate-400 font-medium font-sans">Max: <%= availablePoints%> pts</span>
                </div>
                <div class="flex gap-2">
                    <div class="relative flex-grow">
                        <input id="redeemPointsInput" 
                               class="w-full px-4 py-2 bg-slate-50 border border-surface-border rounded-2xl focus:outline-none focus:bg-white focus:ring-4 focus:ring-indigo-100 focus:border-primary transition-all duration-150 placeholder:text-slate-400 text-xs font-mono pr-8" 
                               placeholder="0" 
                               type="number" 
                               min="0" 
                               max="<%= availablePoints%>"/>
                        <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-slate-400 uppercase font-mono selection:bg-transparent">PTS</span>
                    </div>
                    <button type="button" 
                            onclick="applyPoints()" 
                            class="border border-surface-border text-primary font-semibold px-4 py-2 rounded-2xl hover:bg-slate-50 transition-all duration-200 text-center inline-flex items-center justify-center text-xs whitespace-nowrap">
                        Redeem
                    </button>
                </div>
                <p id="pointsError" class="text-xs text-error mt-1 hidden"></p>
            </div>

            <%-- Total Payment --%>
            <div class="border-t border-slate-100 pt-4 flex justify-between items-center">
                <span class="text-sm font-semibold text-slate-900">Total to Pay</span>
                <span id="summaryTotal" class="text-primary font-mono text-xl font-bold tracking-tight">0 VND</span>
            </div>

            <%-- Submit Button --%>
            <div id="walletBalanceWarning" class="text-red-500 font-semibold text-xs my-2 hidden bg-red-50 p-3 rounded-xl border border-red-200 w-full text-left">
            </div>

            <%-- Submit Button - Cần thêm ID cụ thể để JS tìm thấy và can thiệp Khóa nút --%>
            <button id="confirmBookingBtn"
                    onclick="handleBookingCheckout()" 
                    type="button" 
                    class="w-full bg-gradient-to-br from-primary to-secondary text-on-primary font-semibold px-6 py-3.5 rounded-2xl shadow-sm hover:-translate-y-0.5 hover:shadow-md active:translate-y-0 transition-all duration-200 text-center inline-flex items-center justify-center gap-2 text-sm disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:translate-y-0">
                <i data-lucide="check-circle" class="w-5 h-5 stroke-[2]"></i>
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
    // Ép kiểu an toàn từ Session Java sang biến số JavaScript
    const userWalletBalance = Number(<%= walletBalance%>) || 0;
    const userDiscountRate = Number(<%= discountRate%>) || 0;
    const maxUserPoints = Number(<%= availablePoints%>) || 0;
    const userTierId = Number(<%= tierId%>) || 0;
    const bookingWindowDays = Number(<%= maxBookingDays%>) || 0;
    const preselectedServiceId = "<%= selectedServiceId != null ? selectedServiceId.trim() : ""%>";

    // --- MẢNG DỮ LIỆU PROMOTION ---
    const promoDatabase = [
    <%
        if (promoList != null && !promoList.isEmpty()) {
            for (Promotion p : promoList) {
    %>
        {
            id: <%= p.getPromotionId()%>,
            code: "<%= p.getCode().trim().toUpperCase()%>",
            type: "<%= p.getDiscountType()%>",
            value: <%= p.getDiscountValue() != 0 ? p.getDiscountValue() : 0%>,
            minOrder: <%= p.getMinOrderAmount() != 0 ? p.getMinOrderAmount() : 0%>,
            targetTier: <%= (p.getTargetTierId() != null) ? p.getTargetTierId() : "null"%>
        },
    <%
            }
        }
    %>
    ];

    let currentPackagePrice = 0;
    let appliedTierDiscount = 0;
    let appliedPromotionDiscount = 0;
    let appliedPointsValue = 0;
    let finalPayCalculated = 0;

    // --- FILTER SERVICE THEO LOẠI XE ĐƯỢC CHỌN ---
    function filterServicesByVehicleType(vehicleType, preferredServiceId = null) {
        if (!vehicleType)
            return;

        const type = vehicleType.toLowerCase();
        const targetType = (type === 'suv' || type === 'truck') ? 'suvtruck' : 'sedan';

        let selectedStillVisible = false;
        let preferredInput = null;
        let firstVisible = null;

        document.querySelectorAll('#serviceGrid label[data-service-type]').forEach(card => {
            const radio = card.querySelector('input[type="radio"]');

            if (card.dataset.serviceType === targetType) {
                card.classList.remove('hidden');
                radio.disabled = false;

                if (!firstVisible) {
                    firstVisible = radio;
                }

                if (preferredServiceId && radio.value === preferredServiceId) {
                    preferredInput = radio;
                }

                if (radio.checked) {
                    selectedStillVisible = true;
                }
            } else {
                card.classList.add('hidden');
                radio.disabled = true;
                radio.checked = false;
            }
        });

        if (preferredInput) {
            preferredInput.checked = true;
        } else if (!selectedStillVisible && firstVisible) {
            firstVisible.checked = true;
        }

        appliedPointsValue = 0;
        const pointsInput = document.getElementById('redeemPointsInput');
        if (pointsInput) {
            pointsInput.value = "";
        }

        updateOrderSummary();
    }

    document.querySelectorAll('input[name="vehicleId"]').forEach(radio => {
        radio.addEventListener('change', function () {
            const vehicleType = this.getAttribute('data-vehicle-type');
            filterServicesByVehicleType(vehicleType);
        });
    });

    // --- FETCH VÀ RENDER SLOT THEO NGÀY ---
    function fetchAndRenderSlots(dateStr) {
        const grid = document.getElementById('slotGrid');
        if (!grid)
            return;
        grid.innerHTML = '<div class="col-span-2 text-center py-6 text-xs text-slate-400 animate-pulse">Loading slots...</div>';

        fetch('${pageContext.request.contextPath}/api/slots?date=' + dateStr)
                .then(res => res.json())
                .then(slots => {
                    if (!slots || slots.length === 0) {
                        grid.innerHTML = '<p class="text-xs text-slate-400 col-span-2 text-center py-6 border border-dashed border-slate-200 rounded-xl bg-slate-50/50">No available slots for this date.</p>';
                        return;
                    }

                    let hiddenSlot = document.getElementById('hiddenSlotId');
                    if (!hiddenSlot) {
                        hiddenSlot = document.createElement('input');
                        hiddenSlot.type = 'hidden';
                        hiddenSlot.name = 'slotId';
                        hiddenSlot.id = 'hiddenSlotId';
                        document.getElementById('bookingForm').appendChild(hiddenSlot);
                    }

                    grid.innerHTML = slots.map(function (slot) {
                        var containerClass = slot.isFull ? 'cursor-not-allowed' : 'cursor-pointer';
                        var cardClass = slot.isFull
                                ? 'border-slate-100 bg-slate-50 text-slate-300'
                                : 'border-slate-200 bg-white text-slate-700 hover:border-indigo-900';
                        var fullBadge = slot.isFull ? '<span class="text-[10px] font-normal opacity-60"> (Full)</span>' : '';

                        return '<div class="slot-item block text-center ' + containerClass + '" '
                                + 'data-slot-id="' + slot.slotId + '" '
                                + 'data-full="' + slot.isFull + '">'
                                + '<div class="slot-card py-2.5 px-3 rounded-xl border text-xs font-bold font-mono transition-colors ' + cardClass + '">'
                                + slot.timeValue + fullBadge
                                + '</div>'
                                + '</div>';
                    }).join('');

                    grid.querySelectorAll('.slot-item').forEach(item => {
                        if (item.dataset.full === 'true')
                            return;
                        item.addEventListener('click', function () {
                            selectSlot(this, parseInt(this.dataset.slotId));
                        });
                    });

                    const firstAvailable = grid.querySelector('.slot-item[data-full="false"]');
                    if (firstAvailable) {
                        selectSlot(firstAvailable, parseInt(firstAvailable.dataset.slotId));
                    }
                })
                .catch(err => {
                    console.error(err);
                    grid.innerHTML = '<p class="text-xs text-red-400 col-span-2 text-center py-6 border border-dashed border-red-100 rounded-xl">Failed to load slots. Please try again.</p>';
                });
    }

    function selectSlot(el, slotId) {
        document.querySelectorAll('#slotGrid .slot-card').forEach(card => {
            card.classList.remove('bg-indigo-950', 'text-white', 'border-indigo-950');
            card.classList.add('border-slate-200', 'bg-white', 'text-slate-700');
        });
        const card = el.querySelector('.slot-card');
        if (card) {
            card.classList.remove('border-slate-200', 'bg-white', 'text-slate-700');
            card.classList.add('bg-indigo-950', 'text-white', 'border-indigo-950');
        }
        const hiddenInput = document.getElementById('hiddenSlotId');
        if (hiddenInput)
            hiddenInput.value = slotId;
    }

    // --- CALENDAR RENDER ---
    function renderCustomCalendar() {
        const grid = document.getElementById('calendarDaysGrid');
        const title = document.getElementById('calendarMonthYear');
        if (!grid || !title)
            return;

        grid.innerHTML = '';
        const today = new Date();
        const currentYear = today.getFullYear();
        const currentMonth = today.getMonth();
        const monthNames = ["January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"];
        title.innerText = monthNames[currentMonth] + " " + currentYear;

        const firstDayIndex = new Date(currentYear, currentMonth, 1).getDay();
        const totalDaysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();

        for (let i = 0; i < firstDayIndex; i++) {
            grid.appendChild(document.createElement('div'));
        }

        const selectedDateStr = document.getElementById('bookingDate').value;
        for (let day = 1; day <= totalDaysInMonth; day++) {
            const cellDate = new Date(currentYear, currentMonth, day);
            const dateStr = cellDate.getFullYear() + '-'
                    + String(cellDate.getMonth() + 1).padStart(2, '0') + '-'
                    + String(cellDate.getDate()).padStart(2, '0');
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.innerText = day;
            btn.className = "p-2 text-xs font-semibold font-mono rounded-lg transition-all flex items-center justify-center w-full";

            const diffTime = cellDate - new Date(today.getFullYear(), today.getMonth(), today.getDate());
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            if (diffDays >= 0 && diffDays < bookingWindowDays) {
                if (dateStr === selectedDateStr) {
                    btn.className += " bg-indigo-950 text-white font-bold";
                } else {
                    btn.className += " bg-white border border-slate-100 text-slate-800 hover:border-indigo-900";
                }
                btn.onclick = function () {
                    document.getElementById('bookingDate').value = dateStr;
                    document.querySelectorAll('#calendarDaysGrid button').forEach(b => {
                        b.classList.remove('bg-indigo-950', 'text-white', 'font-bold');
                        b.classList.add('bg-white', 'border', 'border-slate-100', 'text-slate-800', 'hover:border-indigo-900');
                    });
                    this.classList.remove('bg-white', 'border', 'border-slate-100', 'text-slate-800', 'hover:border-indigo-900');
                    this.classList.add('bg-indigo-950', 'text-white', 'font-bold');
                    fetchAndRenderSlots(dateStr);
                };
            } else {
                btn.className += " bg-slate-100 text-slate-300 cursor-not-allowed opacity-40";
                btn.disabled = true;
            }
            grid.appendChild(btn);
        }
    }

    // --- LOGIC TÍNH TIỀN CHÍNH (ORDER SUMMARY) ---
    function updateOrderSummary() {
        const selectedPackage = document.querySelector('input[name="serviceId"]:checked');
        let packageName = "Selected Package";
        if (selectedPackage) {
            currentPackagePrice = parseFloat(selectedPackage.getAttribute('data-price')) || 0;
            packageName = selectedPackage.getAttribute('data-name');
        } else {
            currentPackagePrice = 0;
        }

        // Tính lại Promotion theo % nếu có, vì giá gói có thể vừa đổi
        appliedPromotionDiscount = 0;
        const selectEl = document.getElementById('promotionSelect');
        if (selectEl && selectEl.value) {
            const selectedOption = selectEl.options[selectEl.selectedIndex];
            const discountType = selectedOption.getAttribute('data-discount-type');
            const discountValue = parseFloat(selectedOption.getAttribute('data-discount-value')) || 0;
            if (discountType === 'percent') {
                appliedPromotionDiscount = currentPackagePrice * (discountValue / 100);
            } else {
                appliedPromotionDiscount = discountValue;
            }
        }

        appliedTierDiscount = currentPackagePrice * userDiscountRate;

        let totalDiscountSystem = appliedTierDiscount + appliedPromotionDiscount;
        if (totalDiscountSystem > currentPackagePrice) {
            totalDiscountSystem = currentPackagePrice;
        }

        let maxAllowedPoints = currentPackagePrice - totalDiscountSystem;
        if (appliedPointsValue > maxAllowedPoints) {
            appliedPointsValue = maxAllowedPoints;
            document.getElementById('redeemPointsInput').value = appliedPointsValue;
        }

        finalPayCalculated = currentPackagePrice - totalDiscountSystem - appliedPointsValue;
        if (finalPayCalculated < 0) {
            finalPayCalculated = 0;
        }

        // Cập nhật hiển thị giao diện thành tiền
        document.getElementById('summaryPackageName').innerText = packageName;
        document.getElementById('summaryPackagePrice').innerText = currentPackagePrice.toLocaleString('vi-VN') + " VND";
        document.getElementById('summaryTierDiscount').innerText = "-" + appliedTierDiscount.toLocaleString('vi-VN') + " VND";
        document.getElementById('summaryPromotionDiscount').innerText = "-" + appliedPromotionDiscount.toLocaleString('vi-VN') + " VND";
        document.getElementById('summaryPointsDiscount').innerText = "-" + appliedPointsValue.toLocaleString('vi-VN') + " VND";
        document.getElementById('summaryTotal').innerText = finalPayCalculated.toLocaleString('vi-VN') + " VND";

        // Đồng bộ dữ liệu vào các trường Input ẩn để Submit lên Servlet (ID đã khớp đúng với HTML)
        document.getElementById('discountAmountInput').value = totalDiscountSystem;
        document.getElementById('redeemPoints').value = appliedPointsValue;
        document.getElementById('totalAmountInput').value = finalPayCalculated;

        // --- LOGIC KHÓA NÚT THANH TOÁN KHI CHỌN VÍ MÀ KHÔNG ĐỦ TIỀN ---
        const paymentMethodRadio = document.querySelector('input[name="paymentMethod"]:checked');
        const warningEl = document.getElementById('walletBalanceWarning');
        const confirmBtn = document.getElementById('confirmBookingBtn');

        if (paymentMethodRadio && paymentMethodRadio.value.toUpperCase() === 'WALLET') {
            if (finalPayCalculated > userWalletBalance) {
                if (warningEl) {
                    warningEl.classList.remove('hidden');
                    warningEl.innerText = 'Ví của bạn không đủ số dư! Thiếu: '
                            + (finalPayCalculated - userWalletBalance).toLocaleString('vi-VN')
                            + ' VND. Vui lòng nạp thêm tiền hoặc chọn hình thức thanh toán khác.';
                }
                if (confirmBtn)
                    confirmBtn.disabled = true;
            } else {
                if (warningEl)
                    warningEl.classList.add('hidden');
                if (confirmBtn)
                    confirmBtn.disabled = false;
            }
        } else {
            if (warningEl)
                warningEl.classList.add('hidden');
            if (confirmBtn)
                confirmBtn.disabled = false;
        }

        validateServiceVehicleMatch();
    }

    document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
        radio.addEventListener('change', updateOrderSummary);
    });

    // --- HÀM XỬ LÝ KHI KHÁCH HÀNG CHỌN PROMOTION TỪ THẺ SELECT ---
    function handlePromotionChange(promoId) {
        const selectEl = document.getElementById('promotionSelect');
        const selectedOption = selectEl.options[selectEl.selectedIndex];
        const labelEl = document.getElementById('appliedPromoLabel');

        if (!promoId) {
            labelEl.innerText = "Promotion Code";
            appliedPromotionDiscount = 0;
            document.getElementById('promotionIdInput').value = "";
            updateOrderSummary();
            return;
        }

        labelEl.innerText = "Active Promotion";

        const discountType = selectedOption.getAttribute('data-discount-type');
        const discountValue = parseFloat(selectedOption.getAttribute('data-discount-value')) || 0;
        const minOrder = parseFloat(selectedOption.getAttribute('data-min-order')) || 0;

        // Kiểm tra điều kiện đơn hàng tối thiểu
        if (currentPackagePrice < minOrder) {
            alert("Đơn hàng chưa đạt giá trị tối thiểu " + minOrder.toLocaleString('vi-VN') + " VND để áp dụng mã này!");
            selectEl.value = "";
            appliedPromotionDiscount = 0;
            document.getElementById('promotionIdInput').value = "";
            updateOrderSummary();
            return;
        }

        document.getElementById('promotionIdInput').value = promoId;

        if (discountType === 'percent') {
            appliedPromotionDiscount = currentPackagePrice * (discountValue / 100);
        } else {
            appliedPromotionDiscount = discountValue;
        }

        if (appliedPromotionDiscount > currentPackagePrice) {
            appliedPromotionDiscount = currentPackagePrice;
        }

        updateOrderSummary();
    }

    // --- HÀM ĐỔI ĐIỂM THƯỞNG THÀNH TIỀN ---
    function applyPoints() {
        const pointsInput = document.getElementById('redeemPointsInput');
        const pointsValue = parseInt(pointsInput.value) || 0;
        const errorEl = document.getElementById('pointsError');
        if (!errorEl)
            return;
        errorEl.classList.add('hidden');

        if (pointsValue < 0 || pointsValue > maxUserPoints) {
            errorEl.innerText = "Not enough points.";
            errorEl.classList.remove('hidden');
            return;
        }

        let maxAllowedPoints = currentPackagePrice - appliedTierDiscount - appliedPromotionDiscount;
        if (maxAllowedPoints < 0)
            maxAllowedPoints = 0;

        if (pointsValue > maxAllowedPoints) {
            errorEl.innerText = "Exceeds remaining price.";
            errorEl.classList.remove('hidden');
            return;
        }

        appliedPointsValue = pointsValue;
        updateOrderSummary();
    }

    // --- CHECKOUT SUBMIT CONTROL ---
    function handleBookingCheckout() {
        const form = document.getElementById('bookingForm');
        if (!form || !form.reportValidity())
            return;

        const hiddenSlot = document.getElementById('hiddenSlotId');
        if (!hiddenSlot || !hiddenSlot.value) {
            alert('Please select a time slot.');
            return;
        }

        const checkedMethod = document.querySelector('input[name="paymentMethod"]:checked');
        const method = checkedMethod ? checkedMethod.value.toUpperCase() : "CASH";

        if (method === 'QRCODE') {
            document.getElementById('qrTotalText').innerText = finalPayCalculated.toLocaleString('vi-VN') + " VND";
            document.getElementById('qrImageElement').src = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=AutoWashPayment_" + finalPayCalculated;
            document.getElementById('qrModal').classList.remove('hidden');
        } else {
            form.submit();
        }
    }

    function closeQrModal() {
        document.getElementById('qrModal').classList.add('hidden');
    }

    function confirmPaidQr() {
        document.getElementById('qrModal').classList.add('hidden');
        const form = document.getElementById('bookingForm');
        if (form)
            form.submit();
    }

    function normalizeVehicleType(type) {
        if (!type)
            return "";
        type = type.toLowerCase();

        if (type.includes("sedan"))
            return "sedan";
        if (type.includes("suv") || type.includes("truck"))
            return "suvtruck";

        return type;
    }

    function isVehicleMatchService(vehicleType, serviceType) {
        const normalizedVehicleType = normalizeVehicleType(vehicleType);

        if (!serviceType)
            return true;

        if (serviceType === "sedan") {
            return normalizedVehicleType === "sedan";
        }

        if (serviceType === "suvtruck") {
            return normalizedVehicleType === "suvtruck";
        }

        return true;
    }

    function findAndSelectMatchingVehicleForService() {
        const selectedService = document.querySelector('input[name="serviceId"]:checked');
        if (!selectedService)
            return;

        const serviceType = selectedService.getAttribute('data-service-type');
        const selectedVehicle = document.querySelector('input[name="vehicleId"]:checked');

        if (selectedVehicle && isVehicleMatchService(selectedVehicle.getAttribute('data-vehicle-type'), serviceType)) {
            return;
        }

        const vehicles = document.querySelectorAll('input[name="vehicleId"]');

        for (const vehicle of vehicles) {
            const vehicleType = vehicle.getAttribute('data-vehicle-type');
            if (isVehicleMatchService(vehicleType, serviceType)) {
                vehicle.checked = true;
                return;
            }
        }
    }

    function validateServiceVehicleMatch() {
        const selectedService = document.querySelector('input[name="serviceId"]:checked');
        const selectedVehicle = document.querySelector('input[name="vehicleId"]:checked');
        const warningEl = document.getElementById('vehicleServiceWarning');
        const confirmBtn = document.getElementById('confirmBookingBtn');

        if (!selectedService || !selectedVehicle) {
            if (confirmBtn)
                confirmBtn.disabled = true;
            return false;
        }

        const serviceType = selectedService.getAttribute('data-service-type');
        const vehicleType = selectedVehicle.getAttribute('data-vehicle-type');

        const valid = isVehicleMatchService(vehicleType, serviceType);

        if (!valid) {
            if (warningEl) {
                warningEl.innerText = "Dịch vụ bạn chọn không phù hợp với loại xe hiện tại. Vui lòng chọn xe khác, chọn gói dịch vụ khác, hoặc thêm xe phù hợp trong Profile.";
                warningEl.classList.remove('hidden');
            }
            if (confirmBtn)
                confirmBtn.disabled = true;
            return false;
        }

        if (warningEl) {
            warningEl.classList.add('hidden');
        }

        return true;
    }

    document.querySelectorAll('input[name="serviceId"]').forEach(radio => {
        radio.addEventListener('change', () => {
            appliedPointsValue = 0;
            const pointsInput = document.getElementById('redeemPointsInput');
            if (pointsInput)
                pointsInput.value = "";
            updateOrderSummary();
        });
    });

    // --- KHỞI TẠO HOÀN CHỈNH KHI TRANG TẢI XONG ---
    document.addEventListener('DOMContentLoaded', () => {

        if (preselectedServiceId) {
            const targetService = document.querySelector('input[name="serviceId"][value="' + preselectedServiceId + '"]');

            if (targetService) {
                targetService.checked = true;

                findAndSelectMatchingVehicleForService();

                const selectedVehicle = document.querySelector('input[name="vehicleId"]:checked');
                if (selectedVehicle) {
                    filterServicesByVehicleType(
                            selectedVehicle.getAttribute('data-vehicle-type'),
                            preselectedServiceId
                            );
                }
            }
        } else {
            const firstVehicle = document.querySelector('input[name="vehicleId"]:checked');

            if (firstVehicle) {
                filterServicesByVehicleType(firstVehicle.getAttribute('data-vehicle-type'));
            } else {
                const firstRadio = document.querySelector('input[name="serviceId"]');
                if (firstRadio) {
                    firstRadio.checked = true;
                }
            }
        }

        renderCustomCalendar();

        const selectedDate = document.getElementById('bookingDate').value;
        if (selectedDate) {
            fetchAndRenderSlots(selectedDate);
        }

        validateServiceVehicleMatch();
        updateOrderSummary();

        if (window.lucide) {
            lucide.createIcons();
        }
    });
</script>

<jsp:include page="/components/footer.jsp" />