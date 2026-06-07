<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<jsp:include page="/components/header.jsp" />

<main class="section-spacing h-[calc(100vh-64px)] flex flex-col justify-between items-center overflow-hidden pt-2 pb-4 bg-cover bg-center bg-no-repeat relative"
      style="background-image: linear-gradient(to bottom, rgba(15, 23, 42, 0.8), rgba(15, 23, 42, 0.88)), url('${pageContext.request.contextPath}/assets/images/hero-bg.jpg');">

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
                <a href="${pageContext.request.contextPath}/MainController?action=login" class="btn-primary px-8 py-3">
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

<!-- ==================== SERVICES CATALOGUE SECTION (DYNAMIC WORD SPLIT) ==================== -->
<section id="services-catalogue" class="w-full border-t border-surface-border pt-10 pb-20 bg-white flex justify-center">
    <div class="w-full max-w-[1280px] mx-auto px-4 md:px-16 text-center">

        <div class="flex flex-col items-center mb-16">
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

        <c:forEach var="item" items="${SERVICES_LIST}">
            <c:if test="${fn:containsIgnoreCase(item.serviceName, 'Express') && fn:containsIgnoreCase(item.serviceName, 'Sedan')}">
                <c:set var="expSedanId" value="${item.serviceId}"/>
                <c:set var="expSedanPrice" value="${item.price}"/>
            </c:if>
            <c:if test="${fn:containsIgnoreCase(item.serviceName, 'Express') && fn:containsIgnoreCase(item.serviceName, 'SUV')}">
                <c:set var="expSuvId" value="${item.serviceId}"/>
                <c:set var="expSuvPrice" value="${item.price}"/>
            </c:if>
            <c:if test="${fn:containsIgnoreCase(item.serviceName, 'Deluxe') && fn:containsIgnoreCase(item.serviceName, 'Sedan')}">
                <c:set var="dlxSedanId" value="${item.serviceId}"/>
                <c:set var="dlxSedanPrice" value="${item.price}"/>
            </c:if>
            <c:if test="${fn:containsIgnoreCase(item.serviceName, 'Deluxe') && fn:containsIgnoreCase(item.serviceName, 'SUV')}">
                <c:set var="dlxSuvId" value="${item.serviceId}"/>
                <c:set var="dlxSuvPrice" value="${item.price}"/>
            </c:if>
            <c:if test="${fn:containsIgnoreCase(item.serviceName, 'Ultimate') && fn:containsIgnoreCase(item.serviceName, 'Sedan')}">
                <c:set var="ultSedanId" value="${item.serviceId}"/>
                <c:set var="ultSedanPrice" value="${item.price}"/>
            </c:if>
            <c:if test="${fn:containsIgnoreCase(item.serviceName, 'Ultimate') && fn:containsIgnoreCase(item.serviceName, 'SUV')}">
                <c:set var="ultSuvId" value="${item.serviceId}"/>
                <c:set var="ultSuvPrice" value="${item.price}"/>
            </c:if>
        </c:forEach>

        <fmt:formatNumber var="fmtExpSedan" value="${expSedanPrice}" pattern="#,###"/>
        <fmt:formatNumber var="fmtExpSuv" value="${expSuvPrice}" pattern="#,###"/>
        <fmt:formatNumber var="fmtDlxSedan" value="${dlxSedanPrice}" pattern="#,###"/>
        <fmt:formatNumber var="fmtDlxSuv" value="${dlxSuvPrice}" pattern="#,###"/>
        <fmt:formatNumber var="fmtUltSedan" value="${ultSedanPrice}" pattern="#,###"/>
        <fmt:formatNumber var="fmtUltSuv" value="${ultSuvPrice}" pattern="#,###"/>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-24 text-left items-stretch">

            <div class="service-card flex flex-col relative bg-[var(--surface-card)] mt-8 p-8 border border-surface-border shadow-sm">
                <div class="mb-6">
                    <h3 class="text-2xl font-bold text-on-background mb-2">Express Wash</h3>
                    <p class="text-sm text-slate-500">Quick and efficient everyday clean.</p>
                </div>
                <div class="mb-8">
                    <span id="price-express" class="text-4xl md:text-5xl font-black font-sans tracking-tight text-on-background tech-data price-display" 
                                  data-sedan="${fmtExpSedan}đ" data-suv="${fmtExpSuv}đ">${fmtExpSedan}đ</span>
                    <span class="text-xs font-sans font-bold text-slate-400 ml-1">/wash</span>
                </div>

                <ul class="space-y-4 mb-8 flex-grow">
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="droplets"></i>
                        <span class="text-sm text-on-background font-medium">High-pressure express wash</span>
                    </li>
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="cloud-rain"></i>
                        <span class="text-sm text-on-background font-medium">Triple foam conditioner</span>
                    </li>
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="wind"></i>
                        <span class="text-sm text-on-background font-medium">Heated air blow dry</span>
                    </li>
                </ul>
                <a id="link-express" href="${pageContext.request.contextPath}/MainController?action=login&serviceId=${expSedanId}" 
                   data-sedan-id="${expSedanId}" data-suv-id="${expSuvId}" class="btn-secondary w-full text-center">
                    Book Express
                </a>
            </div>

            <div class="service-card flex flex-col relative bg-[var(--surface-card)] mt-8 p-8 border-2 border-primary transform md:-translate-y-4 shadow-lg">
                <div class="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
                    <span class="bg-primary text-on-primary text-[10px] font-bold uppercase tracking-wider px-4 py-1 rounded-full">Most Popular</span>
                </div>
                <div class="mb-6 mt-4">
                    <h3 class="text-2xl font-bold text-on-background mb-2">Deluxe Wash</h3>
                    <p class="text-sm text-slate-500">Enhanced protection and shine.</p>
                </div>
                <div class="mb-8">
                    <span id="price-deluxe" class="text-4xl md:text-5xl font-black font-sans tracking-tight text-on-background tech-data price-display" 
                                  data-sedan="${fmtDlxSedan}đ" data-suv="${fmtDlxSuv}đ">${fmtDlxSedan}đ</span>
                    <span class="text-xs font-sans font-bold text-slate-400 ml-1">/wash</span>
                </div>

                <ul class="space-y-4 mb-8 flex-grow">
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="layers"></i>
                        <span class="text-sm text-primary font-semibold">Includes Express wash features</span>
                    </li>
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="disc"></i>
                        <span class="text-sm text-on-background font-medium">Wheel & rim deep clean</span>
                    </li>
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="sparkles"></i>
                        <span class="text-sm text-on-background font-medium">Tire shine & dressing</span>
                    </li>
                </ul>
                <a id="link-deluxe" href="${pageContext.request.contextPath}/MainController?action=login&serviceId=${dlxSedanId}" 
                   data-sedan-id="${dlxSedanId}" data-suv-id="${dlxSuvId}" class="btn-primary w-full text-center">
                    Book Deluxe
                </a>
            </div>

            <div class="service-card flex flex-col relative bg-[var(--surface-card)] mt-8 p-8 border border-surface-border shadow-sm">
                <div class="mb-6">
                    <h3 class="text-2xl font-bold text-on-background mb-2">Ultimate Wash</h3>
                    <p class="text-sm text-slate-500">The absolute best care available.</p>
                </div>
                <div class="mb-8">
                    <span id="price-ultimate" class="text-4xl md:text-5xl font-black font-sans tracking-tight text-on-background tech-data price-display" 
                                  data-sedan="${fmtUltSedan}đ" data-suv="${fmtUltSuv}đ">${fmtUltSedan}đ</span>
                    <span class="text-xs font-sans font-bold text-slate-400 ml-1">/wash</span>
                </div>

                <ul class="space-y-4 mb-8 flex-grow">
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="layers"></i>
                        <span class="text-sm text-primary font-semibold">Includes Deluxe wash features</span>
                    </li>
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="gem"></i>
                        <span class="text-sm text-on-background font-medium">Ceramic wax coating</span>
                    </li>
                    <li class="flex items-start gap-3">
                        <i class="w-5 h-5 text-primary shrink-0 mt-0.5" data-lucide="smile"></i>
                        <span class="text-sm text-on-background font-medium">Cabin deodorization & freshener</span>
                    </li>
                </ul>
                <a id="link-ultimate" href="${pageContext.request.contextPath}/MainController?action=login&serviceId=${ultSedanId}" 
                   data-sedan-id="${ultSedanId}" data-suv-id="${ultSuvId}" class="btn-secondary w-full text-center">
                    Book Ultimate
                </a>
            </div>
        </div>

        <!-- Sơ đồ quy trình 5 bước Robotic Flow giữ nguyên bên dưới... -->

        <div class="bg-slate-50 border border-surface-border rounded-2xl p-8 md:p-12">
            <div class="text-center mb-12">
                <h2 class="text-3xl font-bold text-on-background mb-4">Precision Robotic Flow</h2>
                <p class="text-sm text-slate-500 max-w-3xl mx-auto">Our 5-step automated process ensures every inch of your vehicle is treated with exact scientific precision.</p>
            </div>

            <div class="relative flex flex-col md:flex-row justify-between items-start md:items-center gap-8 md:gap-4 text-left md:text-center">
                <div class="hidden md:block absolute top-12 left-10 right-10 h-0.5 bg-slate-200 z-0"></div>
                <div class="md:hidden absolute top-10 bottom-10 left-12 w-0.5 bg-slate-200 z-0"></div>

                <div class="relative z-10 flex md:flex-col items-center gap-4 md:w-1/5 group">
                    <div class="w-24 h-24 rounded-full bg-white border-2 border-primary flex items-center justify-center shadow-sm group-hover:-translate-y-1 transition-transform shrink-0">
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
        // Vẽ icon hệ thống ban đầu
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        const btnSedan = document.getElementById('btn-sedan');
        const btnSuv = document.getElementById('btn-suv');
        const priceDisplays = document.querySelectorAll('.price-display');

        const linkExpress = document.getElementById('link-express');
        const linkDeluxe = document.getElementById('link-deluxe');
        const linkUltimate = document.getElementById('link-ultimate');

        function updatePricing(type) {
            // 1. Thay đổi giá hiển thị khi click mượt mà
            priceDisplays.forEach(display => {
                const targetPrice = display.getAttribute('data-' + type);
                display.textContent = targetPrice;
            });

            // 2. Cập nhật chính xác link Href tương ứng ServiceId (ĐÃ SỬA LỖI CHUỖI KHÔNG CÒN CRASH)
            const contextPath = "${pageContext.request.contextPath}";
            linkExpress.href = contextPath + "/MainController?action=login&serviceId=" + linkExpress.getAttribute('data-' + type + '-id');
            linkDeluxe.href = contextPath + "/MainController?action=login&serviceId=" + linkDeluxe.getAttribute('data-' + type + '-id');
            linkUltimate.href = contextPath + "/MainController?action=login&serviceId=" + linkUltimate.getAttribute('data-' + type + '-id');

            // 3. Thay đổi màu class active của tab button
            if (type === 'sedan') {
                btnSedan.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 bg-primary text-on-primary shadow-sm focus:outline-none";
                btnSuv.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 text-slate-500 hover:text-on-background focus:outline-none";
            } else {
                btnSuv.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 bg-primary text-on-primary shadow-sm focus:outline-none";
                btnSedan.className = "px-6 py-2 rounded-full font-semibold text-sm transition-all duration-300 text-slate-500 hover:text-on-background focus:outline-none";
            }
        }

        btnSedan.addEventListener('click', () => updatePricing('sedan'));
        btnSuv.addEventListener('click', () => updatePricing('suv'));
    });
</script>

<jsp:include page="/components/footer.jsp" />