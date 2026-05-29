<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/components/header.jsp" />

<main class="min-h-screen bg-background section-spacing">
    <div class="max-w-[1280px] mx-auto px-4 md:px-16 py-8">

        <!-- TIÊU ĐỀ TRANG -->
        <div class="mb-8">
            <h1 class="text-3xl font-extrabold text-on-background tracking-tight">Account Profile</h1>
            <p class="text-sm text-slate-500">Manage your personal information, loyalty status, and registered vehicles.</p>
        </div>

        <!-- BỐ CỤC GRID 12 CỘT -->
        <div class="grid grid-cols-1 md:grid-cols-12 gap-8">

            <!-- ================= CỘT TRÁI HẸP (4 CỘT): THÔNG TIN CÁ NHÂN ================= -->
            <div class="md:col-span-4 space-y-6">
                <div class="bg-surface-container rounded-2xl p-6 border border-surface-border flex flex-col items-center text-center">
                    <!-- Avatar & Name -->
                    <div class="w-24 h-24 bg-primary/10 rounded-full flex items-center justify-center text-primary text-3xl font-bold mb-4 border-2 border-primary/20">
                        JD
                    </div>
                    <h2 class="text-xl font-bold text-on-background">John Doe</h2>
                    <span class="text-xs bg-primary/10 text-primary font-semibold px-3 py-1 rounded-full mt-1">Premium Customer</span>

                    <hr class="w-full border-surface-border my-6">

                    <!-- Detail Info List -->
                    <div class="w-full space-y-4 text-left text-sm">
                        <div>
                            <label class="block text-xs text-slate-400 font-medium uppercase tracking-wider">Email Address</label>
                            <span class="text-on-background font-medium block mt-0.5">johndoe@example.com</span>
                        </div>
                        <div>
                            <label class="block text-xs text-slate-400 font-medium uppercase tracking-wider">Phone Number</label>
                            <span class="text-on-background font-medium block mt-0.5">+84 987 654 321</span>
                        </div>
                        <div>
                            <label class="block text-xs text-slate-400 font-medium uppercase tracking-wider">Member Since</label>
                            <span class="text-on-background font-medium block mt-0.5">May 2026</span>
                        </div>
                    </div>

                    <!-- Edit Button -->
                    <button class="btn-secondary w-full mt-6 py-2.5 text-sm">
                        Edit Profile
                    </button>
                </div>
            </div>

            <!-- ================= CỘT PHẢI RỘNG (8 CỘT): TIERS, WALLET & VEHICLES ================= -->
            <div class="md:col-span-8 space-y-6">

                <!-- HÀNG TRÊN: LOYALTY TIER & WALLET (Chia đôi bằng grid) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">

                    <!-- Khối Loyalty Tier -->
                    <div class="bg-surface-container rounded-2xl p-6 border border-surface-border relative overflow-hidden">
                        <div class="absolute top-0 right-0 w-24 h-24 bg-secondary/5 rounded-full translate-x-6 -translate-y-6"></div>
                        <div class="text-xs font-bold text-secondary uppercase tracking-widest mb-1">Loyalty Level</div>
                        <div class="text-2xl font-black text-on-background bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">GOLD MEMBER</div>

                        <!-- Progress Bar tích điểm -->
                        <div class="mt-4">
                            <div class="flex justify-between text-xs font-medium mb-1">
                                <span class="text-slate-500">750 / 1000 Points</span>
                                <span class="text-primary font-bold">75%</span>
                            </div>
                            <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                                <!-- Đổi style="w-3/4" thành style="width: 75%;" -->
                                <div class="bg-primary h-full rounded-full" style="width: 75%;"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Khối Vehicle Wallet -->
                    <div class="bg-surface-container rounded-2xl p-6 border border-surface-border">
                        <div class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Vehicle Wallet</div>
                        <div class="text-3xl font-mono font-bold text-on-background mt-1">$120.50</div>
                        <p class="text-xs text-slate-500 mt-2">Available balance for instant slot booking activation.</p>

                        <div class="mt-3 flex gap-2">
                            <button class="text-xs text-primary font-bold hover:underline">Top Up Balance →</button>
                        </div>
                    </div>

                </div>

                <!-- HÀNG DƯỚI: LIST VEHICLES (Danh sách xe) -->
                <div class="bg-surface-container rounded-2xl p-6 border border-surface-border">
                    <div class="flex justify-between items-center mb-4">
                        <div>
                            <h3 class="text-lg font-bold text-on-background">My Registered Vehicles</h3>
                            <p class="text-xs text-slate-500">Manage licenses and access tiers for your fleet.</p>
                        </div>
                        <button class="btn-primary px-4 py-2 text-xs flex items-center gap-1">
                            <span>+</span> Add Vehicle
                        </button>
                    </div>

                    <!-- Bảng/Danh sách xe -->
                    <div class="divide-y divide-surface-border">
                        <!-- Xe 1 -->
                        <div class="py-4 flex justify-between items-center first:pt-0 last:pb-0">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 bg-slate-100 rounded-xl flex items-center justify-center text-slate-600 font-bold text-xs">
                                    CAR
                                </div>
                                <div>
                                    <div class="font-bold text-on-background">Audi A6</div>
                                    <div class="font-mono text-xs text-slate-400 tracking-wider">30F-123.45</div>
                                </div>
                            </div>
                            <span class="text-xs bg-emerald-50 text-emerald-600 font-medium px-2.5 py-1 rounded-md border border-emerald-100">
                                Active
                            </span>
                        </div>

                        <!-- Xe 2 -->
                        <div class="py-4 flex justify-between items-center first:pt-0 last:pb-0">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 bg-slate-100 rounded-xl flex items-center justify-center text-slate-600 font-bold text-xs">
                                    SUV
                                </div>
                                <div>
                                    <div class="font-bold text-on-background">VinFast VF8</div>
                                    <div class="font-mono text-xs text-slate-400 tracking-wider">29A-888.88</div>
                                </div>
                            </div>
                            <span class="text-xs bg-emerald-50 text-emerald-600 font-medium px-2.5 py-1 rounded-md border border-emerald-100">
                                Active
                            </span>
                        </div>
                    </div>

                </div>

            </div>
        </div>

    </div>
</main>
