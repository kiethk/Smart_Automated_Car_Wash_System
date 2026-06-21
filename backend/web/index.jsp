<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Service" %>
<%@ page import="java.text.DecimalFormat" %>

<jsp:include page="/components/header.jsp" />

<main class="section-spacing h-[calc(100vh-64px)] flex flex-col justify-between items-center overflow-hidden pt-2 pb-4 bg-cover bg-center bg-no-repeat relative"
      style="background-image: linear-gradient(to bottom, rgba(15, 23, 42, 0.8), rgba(15, 23, 42, 0.88)), url('<%= request.getContextPath()%>/assets/images/hero-bg.jpg');">

    <div class="w-full max-w-[1280px] mx-auto flex flex-col justify-between h-full items-center text-center px-4 md:px-16 relative z-10">

        <div class="space-y-4 max-w-3xl mx-auto mt-1 flex-grow flex flex-col justify-center items-center">
            <span class="inline-block bg-white/10 text-white text-xs font-bold tracking-widest uppercase px-4 py-1.5 rounded-full border border-white/10">
                Next-Gen Car Care Ecosystem
            </span>

            <h1 class="text-4xl md:text-5xl font-extrabold text-white tracking-tight leading-tight">
                Smart Automated <br/>
                <span class="bg-gradient-to-r from-blue-500 via-blue-400 to-cyan-300 bg-clip-text text-transparent drop-shadow-sm">
                    Car Wash System
                </span>
            </h1>

            <p class="text-lg text-slate-300 max-w-2xl mx-auto leading-relaxed font-medium">
                Experience frictionless, high-trust automotive care. Manage your vehicles,<br class="hidden md:inline"/> 
                track service history, and unlock premium rewards with absolute precision.
            </p> 

            <div class="pt-3 flex flex-col sm:flex-row justify-center gap-4">
                <a href="<%= request.getContextPath()%>/MainController?action=login" class="btn-primary px-8 py-3">
                    Get Started
                </a>
                <a href="#services-catalogue" class="btn-secondary px-8 py-3 bg-white/10 text-white border-white/20 hover:bg-white/20 transition-colors">
                    Learn More
                </a>
            </div>
        </div>

        <section id="features" class="relative z-10 w-full mt-2 py-1 shrink-0">
            <div class="w-full mx-auto">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

                    <div class="service-card text-left p-4.5 bg-white border border-surface-border rounded-2xl shadow-sm">
                        <div class="text-primary font-bold text-xl mb-1">01. Swift Booking</div>
                        <p class="text-slate-500 text-sm leading-normal">Schedule automated washing slots in under 5 seconds with modern queuing technology.</p>
                    </div>

                    <div class="service-card text-left p-4.5 bg-white border border-surface-border rounded-2xl shadow-sm">
                        <div class="text-primary font-bold text-xl mb-1">02. Vehicle Wallet</div>
                        <p class="text-slate-500 text-sm leading-normal">Manage multiple corporate or personal vehicles and store licenses with monospaced precision.</p>
                    </div>

                    <div class="service-card text-left p-4.5 bg-white border border-surface-border rounded-2xl shadow-sm">
                        <div class="text-primary font-bold text-xl mb-1">03. Loyalty Tiers</div>
                        <p class="text-slate-500 text-sm leading-normal">Earn reward points instantly and level up to unlock the high-contrast Gold membership perks.</p>
                    </div>

                </div>
            </div>
        </section>

    </div>
</main>

<section id="services-catalogue" class="w-full border-t border-surface-border pt-8 pb-20 bg-white flex justify-center">
    <div class="w-full max-w-[1280px] mx-auto px-4 md:px-16 text-center">

        <%
            Boolean hasBanner = (Boolean) request.getAttribute("HAS_BANNER");
            if (hasBanner != null && hasBanner) {
        %>
        <div class="text-left w-full animate-fade-in mb-8">
            <div class="flex items-center gap-2.5 pl-1 mb-8">
                <div class="w-1 h-4 bg-gradient-to-b from-blue-950 to-blue-600 rounded-full"></div>
                <h3 class="text-sm font-black text-slate-700 uppercase tracking-wider">
                    Special Active Offers
                </h3>
            </div>
            <jsp:include page="/components/promotions-carousel.jsp" />
        </div>
        <% } %>

        <div class="flex flex-col items-center mb-10">
            <h2 class="text-3xl md:text-4xl font-bold text-on-background mb-8">Select Your Service Level</h2>
            <div class="flex items-center p-1 bg-slate-100 rounded-full border border-surface-border">
                <button id="btn-sedan" class="px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 bg-primary text-on-primary shadow-sm focus:outline-none">
                    Sedan
                </button>
                <button id="btn-suv" class="px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 text-slate-500 hover:text-on-background focus:outline-none">
                    SUV / Truck
                </button>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-24 text-left items-stretch">

            <%
                List<Service> servicesList = (List<Service>) request.getAttribute("SERVICES_LIST");
                DecimalFormat priceFormat = new DecimalFormat("#,###");

                if (servicesList != null) {
                    // VÒNG LẶP 1: LỌC VÀ HIỂN THỊ CÁC DỊCH VỤ CHO XE SEDAN BẰNG JAVA THUẦN
                    for (Service service : servicesList) {
                        String sName = service.getServiceName() != null ? service.getServiceName() : "";

                        if (sName.toLowerCase().contains("sedan")) {
                            String displayName = sName.replace(" (Sedan)", "");
                            boolean isDeluxe = sName.toLowerCase().contains("deluxe");
                            boolean isExpress = sName.toLowerCase().contains("express");

                            String cardClasses = isDeluxe
                                    ? "border-2 border-primary transform md:-translate-y-4 shadow-lg"
                                    : "border border-surface-border shadow-sm";
                            String btnClass = isDeluxe ? "btn-primary" : "btn-secondary";
            %>

            <div class="service-card sedan-card flex flex-col relative bg-[var(--surface-card)] mt-8 p-8 <%= cardClasses%>">

                <% if (isDeluxe) { %>
                <div class="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
                    <span class="bg-primary text-on-primary text-[10px] font-bold uppercase tracking-wider px-4 py-1 rounded-full">
                        Most Popular
                    </span>
                </div>
                <% }%>

                <div class="mb-6 <%= isDeluxe ? "mt-4" : ""%>">
                    <h3 class="text-2xl font-bold text-on-background mb-2">
                        <%= displayName%>
                    </h3>

                    <p class="text-sm text-slate-500">
                        <%
                            String descText = "The absolute best care available.";
                            if (isExpress) {
                                descText = "Quick and efficient everyday clean.";
                            } else if (isDeluxe) {
                                descText = "Enhanced protection and shine.";
                            }
                        %>
                        <%= descText%>
                    </p>
                </div>

                <div class="mb-8">
                    <span class="text-4xl md:text-5xl font-black font-sans tracking-tight text-on-background tech-data">
                        <%= priceFormat.format(service.getPrice())%>đ
                    </span>
                    <span class="text-xs font-sans font-bold text-slate-400 ml-1">/wash</span>
                </div>

                <ul class="space-y-2.5 mb-6 flex-grow text-sm">

                    <%
                        String rawDesc = service.getDescription() != null ? service.getDescription() : "";
                        String[] features = rawDesc.split(",");
                        for (String feature : features) {
                            String featureText = feature.trim().replace(" for Sedan", "").replace(" for SUV/Truck", "");
                            String featureLower = featureText.toLowerCase();
                            String featureIcon = "check-circle";

                            if (featureLower.contains("features")) {
                                featureIcon = "layers";
                            } else if (featureLower.contains("heavy-duty") || featureLower.contains("pressure") || featureLower.contains("express wash")) {
                                featureIcon = "droplets";
                            } else if (featureLower.contains("foam") || featureLower.contains("conditioner")) {
                                featureIcon = "cloud-rain";
                            } else if (featureLower.contains("dry") || featureLower.contains("blow")) {
                                featureIcon = "wind";
                            } else if (featureLower.contains("underbody") || featureLower.contains("rinse")) {
                                featureIcon = "waves";
                            } else if (featureLower.contains("clearance") || featureLower.contains("frame")) {
                                featureIcon = "truck";
                            } else if (featureLower.contains("rim") || featureLower.contains("wheel") || featureLower.contains("de-ironing") || featureLower.contains("hub")) {
                                featureIcon = "disc";
                            } else if (featureLower.contains("tire") || featureLower.contains("shine") || featureLower.contains("dressing")) {
                                featureIcon = "sparkles";
                            } else if (featureLower.contains("wax") || featureLower.contains("ceramic") || featureLower.contains("protective") || featureLower.contains("paint")) {
                                featureIcon = "gem";
                            } else if (featureLower.contains("hydro") || featureLower.contains("shield") || featureLower.contains("surface coat")) {
                                featureIcon = "shield";
                            } else if (featureLower.contains("cabin") || featureLower.contains("freshener") || featureLower.contains("deodorization")) {
                                featureIcon = "smile";
                            }
                    %>

                    <li class="flex items-center gap-3 min-h-[28px]">
                        <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                            <i class="w-5 h-5" data-lucide="<%= featureIcon%>"></i>
                        </span>
                        <span class="text-sm text-on-background font-medium leading-5">
                            <%= featureText%>
                        </span>
                    </li>

                    <% } // kết thúc vòng lặp mảng features %>

                    <li class="flex items-center gap-3 min-h-[28px] pt-1">
                        <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                            <i class="w-5 h-5" data-lucide="clock-3"></i>
                        </span>
                        <span class="text-sm text-on-background font-semibold leading-5">
                            Duration: <%= service.getDurationMinutes()%> minutes
                        </span>
                    </li>

                </ul>

                <a href="<%= request.getContextPath()%>/MainController?action=booking&serviceId=<%= service.getServiceId()%>"
                   class="<%= btnClass%> w-full text-center">
                    Book <%= displayName%>
                </a>

            </div>

            <%
                    } // end if contains Sedan
                } // end vòng lặp 1

                // VÒNG LẶP 2: LỌC VÀ HIỂN THỊ CÁC DỊCH VỤ CHO XE SUV/TRUCK BẰNG JAVA THUẦN
                for (Service service : servicesList) {
                    String sName = service.getServiceName() != null ? service.getServiceName() : "";

                    if (sName.toLowerCase().contains("suv") || sName.toLowerCase().contains("truck")) {
                        String displayName = sName.replace(" (SUV/Truck)", "");
                        boolean isDeluxe = sName.toLowerCase().contains("deluxe");
                        boolean isExpress = sName.toLowerCase().contains("express");

                        String cardClasses = isDeluxe
                                ? "border-2 border-primary transform md:-translate-y-4 shadow-lg"
                                : "border border-surface-border shadow-sm";
                        String btnClass = isDeluxe ? "btn-primary" : "btn-secondary";
            %>

            <div class="service-card suv-card hidden flex-col relative bg-[var(--surface-card)] mt-8 p-8 <%= cardClasses%>">

                <% if (isDeluxe) { %>
                <div class="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
                    <span class="bg-primary text-on-primary text-[10px] font-bold uppercase tracking-wider px-4 py-1 rounded-full">
                        Most Popular
                    </span>
                </div>
                <% }%>

                <div class="mb-6 <%= isDeluxe ? "mt-4" : ""%>">
                    <h3 class="text-2xl font-bold text-on-background mb-2">
                        <%= displayName%>
                    </h3>

                    <p class="text-sm text-slate-500">
                        <%
                            String descText = "The absolute best care available.";
                            if (isExpress) {
                                descText = "Quick and efficient everyday clean.";
                            } else if (isDeluxe) {
                                descText = "Enhanced protection and shine.";
                            }
                        %>
                        <%= descText%>
                    </p>
                </div>

                <div class="mb-8">
                    <span class="text-4xl md:text-5xl font-black font-sans tracking-tight text-on-background tech-data">
                        <%= priceFormat.format(service.getPrice())%>đ
                    </span>
                    <span class="text-xs font-sans font-bold text-slate-400 ml-1">/wash</span>
                </div>

                <ul class="space-y-2.5 mb-6 flex-grow text-sm">

                    <%
                        String rawDesc = service.getDescription() != null ? service.getDescription() : "";
                        String[] features = rawDesc.split(",");
                        for (String feature : features) {
                            String featureText = feature.trim().replace(" for Sedan", "").replace(" for SUV/Truck", "");
                            String featureLower = featureText.toLowerCase();
                            String featureIcon = "check-circle";

                            if (featureLower.contains("features")) {
                                featureIcon = "layers";
                            } else if (featureLower.contains("heavy-duty") || featureLower.contains("pressure") || featureLower.contains("express wash")) {
                                featureIcon = "droplets";
                            } else if (featureLower.contains("foam") || featureLower.contains("conditioner")) {
                                featureIcon = "cloud-rain";
                            } else if (featureLower.contains("dry") || featureLower.contains("blow")) {
                                featureIcon = "wind";
                            } else if (featureLower.contains("underbody") || featureLower.contains("rinse")) {
                                featureIcon = "waves";
                            } else if (featureLower.contains("clearance") || featureLower.contains("frame")) {
                                featureIcon = "truck";
                            } else if (featureLower.contains("rim") || featureLower.contains("wheel") || featureLower.contains("de-ironing") || featureLower.contains("hub")) {
                                featureIcon = "disc";
                            } else if (featureLower.contains("tire") || featureLower.contains("shine") || featureLower.contains("dressing")) {
                                featureIcon = "sparkles";
                            } else if (featureLower.contains("wax") || featureLower.contains("ceramic") || featureLower.contains("protective") || featureLower.contains("paint")) {
                                featureIcon = "gem";
                            } else if (featureLower.contains("hydro") || featureLower.contains("shield") || featureLower.contains("surface coat")) {
                                featureIcon = "shield";
                            } else if (featureLower.contains("cabin") || featureLower.contains("freshener") || featureLower.contains("deodorization")) {
                                featureIcon = "smile";
                            }
                    %>

                    <li class="flex items-center gap-3 min-h-[28px]">
                        <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                            <i class="w-5 h-5" data-lucide="<%= featureIcon%>"></i>
                        </span>
                        <span class="text-sm text-on-background font-medium leading-5">
                            <%= featureText%>
                        </span>
                    </li>

                    <% } // kết thúc vòng lặp mảng features %>

                    <li class="flex items-center gap-3 min-h-[28px] pt-1">
                        <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                            <i class="w-5 h-5" data-lucide="clock-3"></i>
                        </span>
                        <span class="text-sm text-on-background font-semibold leading-5">
                            Duration: <%= service.getDurationMinutes()%> minutes
                        </span>
                    </li>

                </ul>

                <a href="<%= request.getContextPath()%>/MainController?action=booking&serviceId=<%= service.getServiceId()%>"
                   class="<%= btnClass%> w-full text-center">
                    Book <%= displayName%>
                </a>

            </div>

            <%
                        } // end if contains SUV
                    } // end vòng lặp 2
                } // end if danh sách không null
            %>

        </div>

        <div class="bg-slate-50 border border-surface-border rounded-2xl p-8 md:p-12">
            <div class="text-center mb-12">
                <h2 class="text-3xl font-bold text-on-background mb-4">Precision Robotic Flow</h2>
                <p class="text-sm text-slate-500 max-w-3xl mx-auto">Our 5-step automated process ensures every inch of your vehicle is treated with exact scientific precision.</p>
            </div>

            <div class="relative flex flex-col md:flex-row justify-between items-start md:items-center gap-8 md:gap-4 text-left md:text-center">
                <div class="hidden md:block absolute top-12 left-10 right-10 h-0.5 bg-slate-200 z-0"></div>
                <div class="md:hidden absolute top-10 bottom-10 left-12 w-0.5 bg-slate-200 z-0"></div>

                <div class="relative z-10 flex md:flex-col items-center gap-4 md:w-1/5 group">
                    <div class="w-24 h-24 rounded-full bg-white border-2 border-slate-200 flex items-center justify-center shadow-sm group-hover:-translate-y-1 transition-transform shrink-0">
                        <i class="w-10 h-10 text-primary" data-lucide="scan-line"></i>
                    </div>
                    <div>
                        <h4 class="font-bold text-on-background text-lg mb-1">1. Scan</h4>
                        <p class="text-xs text-slate-500 md:max-w-[160px] mx-auto">Laser profiling adjusts nozzles to vehicle shape.</p>
                    </div>
                </div>
                <div class="relative z-10 flex md:flex-col items-center gap-4 md:w-1/5 group">
                    <div class="w-24 h-24 rounded-full bg-white border-2 border-slate-200 flex items-center justify-center shadow-sm group-hover:-translate-y-1 transition-transform shrink-0">
                        <i class="w-10 h-10 text-secondary" data-lucide="droplets"></i>
                    </div>
                    <div>
                        <h4 class="font-bold text-on-background text-lg mb-1">2. Prep</h4>
                        <p class="text-xs text-slate-500 md:max-w-[160px] mx-auto">Loosens grime with targeted pre-soak agents.</p>
                    </div>
                </div>
                <div class="relative z-10 flex md:flex-col items-center gap-4 md:w-1/5 group">
                    <div class="w-24 h-24 rounded-full bg-white border-2 border-slate-200 flex items-center justify-center shadow-sm group-hover:-translate-y-1 transition-transform shrink-0">
                        <i class="w-10 h-10 text-secondary" data-lucide="waves"></i>
                    </div>
                    <div>
                        <h4 class="font-bold text-on-background text-lg mb-1">3. Wash</h4>
                        <p class="text-xs text-slate-500 md:max-w-[160px] mx-auto">High-pressure oscillating soft-touch foam.</p>
                    </div>
                </div>
                <div class="relative z-10 flex md:flex-col items-center gap-4 md:w-1/5 group">
                    <div class="w-24 h-24 rounded-full bg-white border-2 border-slate-200 flex items-center justify-center shadow-sm group-hover:-translate-y-1 transition-transform shrink-0">
                        <i class="w-10 h-10 text-loyalty-gold" data-lucide="sparkles"></i>
                    </div>
                    <div>
                        <h4 class="font-bold text-on-background text-lg mb-1">4. Wax</h4>
                        <p class="text-xs text-slate-500 md:max-w-[160px] mx-auto">Carnauba and ceramic infused polymer seal.</p>
                    </div>
                </div>
                <div class="relative z-10 flex md:flex-col items-center gap-4 md:w-1/5 group">
                    <div class="w-24 h-24 rounded-full bg-white border-2 border-slate-200 flex items-center justify-center shadow-sm group-hover:-translate-y-1 transition-transform shrink-0">
                        <i class="w-10 h-10 text-slate-400" data-lucide="wind"></i>
                    </div>
                    <div>
                        <h4 class="font-bold text-on-background text-lg mb-1">5. Dry</h4>
                        <p class="text-xs text-slate-500 md:max-w-[160px] mx-auto">Heated, aerodynamic focused air blades.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        const btnSedan = document.getElementById('btn-sedan');
        const btnSuv = document.getElementById('btn-suv');

        const sedanCards = document.querySelectorAll('.sedan-card');
        const suvCards = document.querySelectorAll('.suv-card');

        function showServices(type) {
            if (type === 'sedan') {
                sedanCards.forEach(card => {
                    card.classList.remove('hidden');
                    card.classList.add('flex');
                });

                suvCards.forEach(card => {
                    card.classList.add('hidden');
                    card.classList.remove('flex');
                });

                btnSedan.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 bg-primary text-on-primary shadow-sm focus:outline-none";
                btnSuv.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 text-slate-500 hover:text-on-background focus:outline-none";
            } else {
                suvCards.forEach(card => {
                    card.classList.remove('hidden');
                    card.classList.add('flex');
                });

                sedanCards.forEach(card => {
                    card.classList.add('hidden');
                    card.classList.remove('flex');
                });

                btnSuv.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 bg-primary text-on-primary shadow-sm focus:outline-none";
                btnSedan.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 text-slate-500 hover:text-on-background focus:outline-none";
            }

            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }

        btnSedan.addEventListener('click', function () {
            showServices('sedan');
        });

        btnSuv.addEventListener('click', function () {
            showServices('suv');
        });

        showServices('sedan');
    });
</script>

<jsp:include page="/components/footer.jsp" />