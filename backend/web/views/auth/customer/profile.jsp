<%@page import="dto.Vehicle"%>
<%@page import="dao.VehicleDAO"%>
<%@page import="dto.Wallet"%>
<%@page import="dao.WalletDAO"%>
<%@page import="dao.TiersDAO"%>
<%@page import="dto.Tiers"%>
<%@page import="dto.Customer"%>
<%@page import="dto.User"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="dao.UserDAO"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %>
<%// Lúc này file JSP chỉ làm duy nhất 1 nhiệm vụ: Lấy các Attribute đã được Servlet tính sẵn ra để dùng
    User loginedUser = (User) session.getAttribute("USER");
    Customer loginedCustomer = (Customer) request.getAttribute("customerData");
    Tiers loginedTiers = (Tiers) request.getAttribute("tierData");
    Wallet loginedWallet = (Wallet) request.getAttribute("walletData");
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("vehicles");

    // Đọc các thông số phần trăm
    boolean hasNextTier = (boolean) request.getAttribute("hasNextTier");
    int targetWashes = (int) request.getAttribute("targetWashes");
    long targetSpent = (long) request.getAttribute("targetSpent");
    int washesPercent = (int) request.getAttribute("washesPercent");
    int spentPercent = (int) request.getAttribute("spentPercent");
%>

<jsp:include page="/components/header.jsp" />

<main class="min-h-screen bg-background section-spacing">
    <div class="max-w-[1280px] mx-auto px-4 md:px-16 py-8">
        <div class="mb-8">
            <h1 class="text-3xl font-extrabold text-on-background tracking-tight">Account Profile</h1>
            <p class="text-sm text-slate-500">Manage your personal information, loyalty status, and registered vehicles.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-12 gap-8">

            <div class="md:col-span-4 space-y-6">
                <div class="bg-surface-container rounded-2xl p-6 border border-surface-border flex flex-col items-center text-center">

                    <div class="w-24 h-24 bg-primary/10 rounded-full flex items-center justify-center text-primary text-3xl font-bold mb-4 border-2 border-primary/20 overflow-hidden">
                        <img src="<%
                            if (loginedUser.getAvatarUrl() != null && !loginedUser.getAvatarUrl().trim().isEmpty()) {
                                out.print(loginedUser.getAvatarUrl());
                            } else {
                                out.print(request.getContextPath() + "/assets/images/avatar-placeholder.jpg");
                            }
                             %>" 
                             alt="User Avatar" 
                             class="w-full h-full object-cover" />
                    </div>

                    <h2 class="text-xl font-bold text-on-background"><%= loginedUser.getFullName()%></h2>
                    <span class="text-xs bg-primary/10 text-primary font-semibold px-3 py-1 rounded-full mt-1 uppercase">
                        <%= loginedTiers.getTierName()%>
                    </span>

                    <hr class="w-full border-surface-border my-6">

                    <div class="w-full space-y-4 text-left text-sm">
                        <div>
                            <label class="form-label">Email Address</label>
                            <span class="text-on-background font-medium block mt-0.5"><%= loginedUser.getEmail()%></span>
                        </div>
                        <div>
                            <label class="form-label">Phone Number</label>
                            <span class="text-on-background font-medium block mt-0.5"><%= loginedUser.getPhone() != null ? loginedUser.getPhone() : "Not provided"%></span>
                        </div>
                        <div>
                            <label class="form-label">Member Since</label>
                            <span class="text-on-background font-medium block mt-0.5"><%= loginedCustomer.getJoinDate()%></span>
                        </div>
                    </div>

                    <button class="btn-secondary w-full mt-6 py-2.5 text-sm">
                        Edit Profile
                    </button>
                </div>
            </div>

            <div class="md:col-span-8 space-y-6">

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">

                    <div class="bg-surface-container rounded-2xl p-6 border border-surface-border relative overflow-hidden flex flex-col justify-between">
                        <div>
                            <div class="text-xs font-bold text-secondary uppercase tracking-widest mb-1">Loyalty Level</div>
                            <div class="text-2xl font-black text-on-background bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent uppercase">
                                <%= loginedTiers.getTierName()%>
                            </div>
                            <div class="text-xs text-slate-400 mt-1">
                                Current Reward Points: <strong class="text-primary font-bold"><%= loginedCustomer.getTotalPoints()%> pts</strong>
                            </div>
                        </div>

                        <div class="mt-4 space-y-4">
                            <% if (hasNextTier) {%>
                            <div>
                                <div class="flex justify-between text-xs font-medium mb-1">
                                    <span class="text-slate-500">Washes: <%= loginedCustomer.getTotalWashes()%> / <%= targetWashes%> (Next Level)</span>
                                    <span class="text-primary font-bold"><%= washesPercent%>%</span>
                                </div>
                                <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                                    <div class="bg-primary h-full rounded-full" style="width: <%= washesPercent%>%;"></div>
                                </div>
                            </div>

                            <div>
                                <div class="flex justify-between text-xs font-medium mb-1">
                                    <span class="text-slate-500">Spent: <%= String.format("%,d", loginedCustomer.getTotalSpent())%> / <%= String.format("%,d", targetSpent)%> VND</span>
                                    <span class="text-secondary font-bold"><%= spentPercent%>%</span>
                                </div>
                                <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                                    <div class="bg-secondary h-full rounded-full" style="width: <%= spentPercent%>%;"></div>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="text-xs text-emerald-600 bg-emerald-50 border border-emerald-100 p-3 rounded-xl font-medium">
                                🎉 Elite Tier Reached! You have unlocked maximum tier privilege utilities.
                            </div>
                            <% }%>
                        </div>

                        <div class="mt-4 pt-3 border-t border-dashed border-surface-border flex justify-between text-xs text-slate-400">
                            <span>Total Washes: <strong class="text-on-background"><%= loginedCustomer.getTotalWashes()%></strong></span>
                            <span>Total Spent: <strong class="text-on-background"><%= String.format("%,d", loginedCustomer.getTotalSpent())%> VND</strong></span>
                        </div>
                    </div>

                    <div class="bg-surface-container rounded-2xl p-6 border border-surface-border flex flex-col justify-between">
                        <div>
                            <div class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Vehicle Wallet</div>
                            <div class="text-3xl font-bold text-on-background mt-1 tech-data">
                                <%= loginedWallet != null ? String.format("%,d", loginedWallet.getBalance()) + " VND" : "0 VND"%>
                            </div>
                            <p class="text-xs text-slate-500 mt-2">Available balance for instant slot booking activation inside infrastructure.</p>
                        </div>

                        <div class="mt-4 pt-3 border-t border-dashed border-surface-border flex gap-2">
                            <button class="text-xs text-primary font-bold hover:underline">Top Up Balance →</button>
                        </div>
                    </div>

                </div>

                <div class="bg-surface-container rounded-2xl p-6 border border-surface-border">
                    <div class="flex justify-between items-center mb-4">
                        <div>
                            <h3 class="text-lg font-bold text-on-background">My Registered Vehicles</h3>
                            <p class="text-xs text-slate-500">Manage licenses and access tiers for your fleet.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/addVehicle" class="inline-block">
                            <button class="btn-primary px-4 py-2 text-xs flex items-center gap-1">
                                <span>+</span> Add Vehicle
                            </button>
                        </a>
                    </div>

                    <div class="divide-y divide-surface-border">
                        <%
                            if (vehicleList != null && !vehicleList.isEmpty()) {
                                for (Vehicle vehicle : vehicleList) {
                        %>
                        <div class="py-4 flex justify-between items-center first:pt-0 last:pb-0">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-10 bg-slate-100 rounded-xl flex items-center justify-center text-slate-600 font-black text-[10px] tracking-tight tech-data uppercase px-1">
                                    <%= vehicle.getVehicleType()%>
                                </div>
                                <div>
                                    <div class="font-bold text-on-background"><%= vehicle.getBrand()%> <%= vehicle.getModel()%></div>
                                    <div class="text-xs text-slate-400 tracking-wider tech-data font-semibold"><%= vehicle.getPlateNumber()%></div>
                                </div>
                            </div>
                            <div class="flex items-center gap-3">
                                <span class="text-[11px] text-slate-400 font-mono"><%= vehicle.getColor()%></span>
                                <span class="text-xs bg-emerald-50 text-emerald-600 font-medium px-2.5 py-1 rounded-md border border-emerald-100">
                                    Active
                                </span>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="py-8 text-center text-sm text-slate-400 font-medium">
                            No vehicles registered yet. Click "+ Add Vehicle" to register your fleet.
                        </div>
                        <%
                            }
                        %>
                    </div>

                </div>

            </div>
        </div>

    </div>
</main>

<jsp:include page="/components/footer.jsp" />
