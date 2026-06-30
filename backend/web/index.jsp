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
                <div class="grid grid-cols- 1 md:grid-cols-3 gap-6">

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

        <c:if test="${requestScope.HAS_BANNER}">
            <div class="text-left w-full animate-fade-in mb-8">
                <div class="flex items-center gap-2.5 pl-1 mb-8">
                    <div class="w-1 h-4 bg-gradient-to-b from-blue-950 to-blue-600 rounded-full"></div>
                    <h3 class="text-sm font-black text-slate-700 uppercase tracking-wider">
                        Special Active Offers
                    </h3>
                </div>
                <jsp:include page="/components/promotions-carousel.jsp" />
            </div>
        </c:if>
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

            <c:forEach var="service" items="${SERVICES_LIST}">
                <c:if test="${fn:containsIgnoreCase(service.serviceName, 'Sedan')}">

                    <c:set var="displayName" value="${fn:replace(service.serviceName, ' (Sedan)', '')}" />

                    <div class="service-card sedan-card flex flex-col relative bg-[var(--surface-card)] mt-8 p-8
                         ${fn:containsIgnoreCase(service.serviceName, 'Deluxe') 
                           ? 'border-2 border-primary transform md:-translate-y-4 shadow-lg' 
                           : 'border border-surface-border shadow-sm'}">

                        <c:if test="${fn:containsIgnoreCase(service.serviceName, 'Deluxe')}">
                            <div class="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
                                <span class="bg-primary text-on-primary text-[10px] font-bold uppercase tracking-wider px-4 py-1 rounded-full">
                                    Most Popular
                                </span>
                            </div>
                        </c:if>

                        <div class="mb-6 ${fn:containsIgnoreCase(service.serviceName, 'Deluxe') ? 'mt-4' : ''}">
                            <h3 class="text-2xl font-bold text-on-background mb-2">
                                ${displayName}
                            </h3>

                            <p class="text-sm text-slate-500">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(service.serviceName, 'Express')}">
                                        Quick and efficient everyday clean.
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(service.serviceName, 'Deluxe')}">
                                        Enhanced protection and shine.
                                    </c:when>
                                    <c:otherwise>
                                        The absolute best care available.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="mb-8">
                            <span class="text-4xl md:text-5xl font-black font-sans tracking-tight text-on-background tech-data">
                                <fmt:formatNumber value="${service.price}" pattern="#,###"/>đ
                            </span>
                            <span class="text-xs font-sans font-bold text-slate-400 ml-1">/wash</span>
                        </div>

                        <ul class="space-y-2.5 mb-6 flex-grow text-sm">

                            <c:forEach var="feature" items="${fn:split(service.description, ',')}">

                                <c:set var="featureText" value="${fn:trim(feature)}" />
                                <c:set var="featureText" value="${fn:replace(featureText, ' for Sedan', '')}" />
                                <c:set var="featureText" value="${fn:replace(featureText, ' for SUV/Truck', '')}" />
                                <c:set var="featureLower" value="${fn:toLowerCase(featureText)}" />

                                <c:choose>
                                    <%-- Dòng kiểu: Express wash features, Deluxe wash features --%>
                                    <c:when test="${fn:contains(featureLower, 'features')}">
                                        <c:set var="featureIcon" value="layers" />
                                    </c:when>

                                    <%-- Rửa áp lực, express wash, heavy-duty --%>
                                    <c:when test="${fn:contains(featureLower, 'heavy-duty') 
                                                    || fn:contains(featureLower, 'pressure') 
                                                    || fn:contains(featureLower, 'express wash')}">
                                        <c:set var="featureIcon" value="droplets" />
                                    </c:when>

                                    <%-- Bọt tuyết / conditioner --%>
                                    <c:when test="${fn:contains(featureLower, 'foam') 
                                                    || fn:contains(featureLower, 'conditioner')}">
                                        <c:set var="featureIcon" value="cloud-rain" />
                                    </c:when>

                                    <%-- Sấy khô --%>
                                    <c:when test="${fn:contains(featureLower, 'dry') 
                                                    || fn:contains(featureLower, 'blow')}">
                                        <c:set var="featureIcon" value="wind" />
                                    </c:when>

                                    <%-- Gầm xe / xịt rửa gầm --%>
                                    <c:when test="${fn:contains(featureLower, 'underbody') 
                                                    || fn:contains(featureLower, 'rinse')}">
                                        <c:set var="featureIcon" value="waves" />
                                    </c:when>

                                    <%-- Xe cao, khung gầm SUV/Truck --%>
                                    <c:when test="${fn:contains(featureLower, 'clearance') 
                                                    || fn:contains(featureLower, 'frame')}">
                                        <c:set var="featureIcon" value="truck" />
                                    </c:when>

                                    <%-- Mâm, bánh xe, wheel hub, rim --%>
                                    <c:when test="${fn:contains(featureLower, 'rim') 
                                                    || fn:contains(featureLower, 'wheel') 
                                                    || fn:contains(featureLower, 'de-ironing') 
                                                    || fn:contains(featureLower, 'hub')}">
                                        <c:set var="featureIcon" value="disc" />
                                    </c:when>

                                    <%-- Lốp, làm bóng lốp --%>
                                    <c:when test="${fn:contains(featureLower, 'tire') 
                                                    || fn:contains(featureLower, 'shine') 
                                                    || fn:contains(featureLower, 'dressing')}">
                                        <c:set var="featureIcon" value="sparkles" />
                                    </c:when>

                                    <%-- Wax, ceramic, sơn, lớp bảo vệ --%>
                                    <c:when test="${fn:contains(featureLower, 'wax') 
                                                    || fn:contains(featureLower, 'ceramic') 
                                                    || fn:contains(featureLower, 'protective') 
                                                    || fn:contains(featureLower, 'paint')}">
                                        <c:set var="featureIcon" value="gem" />
                                    </c:when>

                                    <%-- Hydro shield, surface coat --%>
                                    <c:when test="${fn:contains(featureLower, 'hydro') 
                                                    || fn:contains(featureLower, 'shield') 
                                                    || fn:contains(featureLower, 'surface coat')}">
                                        <c:set var="featureIcon" value="shield" />
                                    </c:when>

                                    <%-- Cabin, khử mùi, làm thơm nội thất --%>
                                    <c:when test="${fn:contains(featureLower, 'cabin') 
                                                    || fn:contains(featureLower, 'freshener') 
                                                    || fn:contains(featureLower, 'deodorization')}">
                                        <c:set var="featureIcon" value="smile" />
                                    </c:when>

                                    <%-- Mặc định --%>
                                    <c:otherwise>
                                        <c:set var="featureIcon" value="check-circle" />
                                    </c:otherwise>
                                </c:choose>

                                <li class="flex items-center gap-3 min-h-[28px]">
                                    <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                                        <i class="w-5 h-5" data-lucide="${featureIcon}"></i>
                                    </span>

                                    <span class="text-sm text-on-background font-medium leading-5">
                                        ${featureText}
                                    </span>
                                </li>

                            </c:forEach>

                            <li class="flex items-center gap-3 min-h-[28px] pt-1">
                                <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                                    <i class="w-5 h-5" data-lucide="clock-3"></i>
                                </span>

                                <span class="text-sm text-on-background font-semibold leading-5">
                                    Duration: ${service.durationMinutes} minutes
                                </span>
                            </li>

                        </ul>

                        <a href="${pageContext.request.contextPath}/MainController?action=booking&serviceId=${service.serviceId}"
                           class="${fn:containsIgnoreCase(service.serviceName, 'Deluxe') ? 'btn-primary' : 'btn-secondary'} w-full text-center">
                            Book ${displayName}
                        </a>
                    </div>

                </c:if>
            </c:forEach>


            <c:forEach var="service" items="${SERVICES_LIST}">
                <c:if test="${fn:containsIgnoreCase(service.serviceName, 'SUV') || fn:containsIgnoreCase(service.serviceName, 'Truck')}">

                    <c:set var="displayName" value="${fn:replace(service.serviceName, ' (SUV/Truck)', '')}" />

                    <div class="service-card suv-card hidden flex-col relative bg-[var(--surface-card)] mt-8 p-8
                         ${fn:containsIgnoreCase(service.serviceName, 'Deluxe') 
                          ? 'border-2 border-primary transform md:-translate-y-4 shadow-lg' 
                           : 'border border-surface-border shadow-sm'}">

                        <c:if test="${fn:containsIgnoreCase(service.serviceName, 'Deluxe')}">
                            <div class="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
                                <span class="bg-primary text-on-primary text-[10px] font-bold uppercase tracking-wider px-4 py-1 rounded-full">
                                    Most Popular
                                </span>
                            </div>
                        </c:if>

                        <div class="mb-6 ${fn:containsIgnoreCase(service.serviceName, 'Deluxe') ? 'mt-4' : ''}">
                            <h3 class="text-2xl font-bold text-on-background mb-2">
                                ${displayName}
                            </h3>

                            <p class="text-sm text-slate-500">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(service.serviceName, 'Express')}">
                                        Quick and efficient everyday clean.
                                    </c:when>
                                    <c:when test="${fn:containsIgnoreCase(service.serviceName, 'Deluxe')}">
                                        Enhanced protection and shine.
                                    </c:when>
                                    <c:otherwise>
                                        The absolute best care available.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="mb-8">
                            <span class="text-4xl md:text-5xl font-black font-sans tracking-tight text-on-background tech-data">
                                <fmt:formatNumber value="${service.price}" pattern="#,###"/>đ
                            </span>
                            <span class="text-xs font-sans font-bold text-slate-400 ml-1">/wash</span>
                        </div>

                        <ul class="space-y-2.5 mb-6 flex-grow text-sm">

                            <c:forEach var="feature" items="${fn:split(service.description, ',')}">

                                <c:set var="featureText" value="${fn:trim(feature)}" />
                                <c:set var="featureText" value="${fn:replace(featureText, ' for Sedan', '')}" />
                                <c:set var="featureText" value="${fn:replace(featureText, ' for SUV/Truck', '')}" />
                                <c:set var="featureLower" value="${fn:toLowerCase(featureText)}" />

                                <c:choose>
                                    <c:when test="${fn:contains(featureLower, 'features')}">
                                        <c:set var="featureIcon" value="layers" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'heavy-duty') 
                                                    || fn:contains(featureLower, 'pressure') 
                                                    || fn:contains(featureLower, 'express wash')}">
                                        <c:set var="featureIcon" value="droplets" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'foam') 
                                                    || fn:contains(featureLower, 'conditioner')}">
                                        <c:set var="featureIcon" value="cloud-rain" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'dry') 
                                                    || fn:contains(featureLower, 'blow')}">
                                        <c:set var="featureIcon" value="wind" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'underbody') 
                                                    || fn:contains(featureLower, 'rinse')}">
                                        <c:set var="featureIcon" value="waves" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'clearance') 
                                                    || fn:contains(featureLower, 'frame')}">
                                        <c:set var="featureIcon" value="truck" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'rim') 
                                                    || fn:contains(featureLower, 'wheel') 
                                                    || fn:contains(featureLower, 'de-ironing') 
                                                    || fn:contains(featureLower, 'hub')}">
                                        <c:set var="featureIcon" value="disc" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'tire') 
                                                    || fn:contains(featureLower, 'shine') 
                                                    || fn:contains(featureLower, 'dressing')}">
                                        <c:set var="featureIcon" value="sparkles" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'wax') 
                                                    || fn:contains(featureLower, 'ceramic') 
                                                    || fn:contains(featureLower, 'protective') 
                                                    || fn:contains(featureLower, 'paint')}">
                                        <c:set var="featureIcon" value="gem" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'hydro') 
                                                    || fn:contains(featureLower, 'shield') 
                                                    || fn:contains(featureLower, 'surface coat')}">
                                        <c:set var="featureIcon" value="shield" />
                                    </c:when>

                                    <c:when test="${fn:contains(featureLower, 'cabin') 
                                                    || fn:contains(featureLower, 'freshener') 
                                                    || fn:contains(featureLower, 'deodorization')}">
                                        <c:set var="featureIcon" value="smile" />
                                    </c:when>

                                    <c:otherwise>
                                        <c:set var="featureIcon" value="check-circle" />
                                    </c:otherwise>
                                </c:choose>

                                <li class="flex items-center gap-3 min-h-[28px]">
                                    <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                                        <i class="w-5 h-5" data-lucide="${featureIcon}"></i>
                                    </span>

                                    <span class="text-sm text-on-background font-medium leading-5">
                                        ${featureText}
                                    </span>
                                </li>

                            </c:forEach>

                            <li class="flex items-center gap-3 min-h-[28px] pt-1">
                                <span class="w-6 h-6 flex items-center justify-center shrink-0 text-primary">
                                    <i class="w-5 h-5" data-lucide="clock-3"></i>
                                </span>

                                <span class="text-sm text-on-background font-semibold leading-5">
                                    Duration: ${service.durationMinutes} minutes
                                </span>
                            </li>

                        </ul>

                        <a href="${pageContext.request.contextPath}/MainController?action=booking&serviceId=${service.serviceId}"
                           class="${fn:containsIgnoreCase(service.serviceName, 'Deluxe') ? 'btn-primary' : 'btn-secondary'} w-full text-center">
                            Book ${displayName}
                        </a>
                    </div>

                </c:if>
            </c:forEach>

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