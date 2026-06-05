<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/components/header.jsp" />

<main class="section-spacing min-h-[100vh] flex flex-col justify-center items-center overflow-hidden">

    <div class="w-full flex flex-col justify-center items-center text-center">
        
        <div class="space-y-6 max-w-3xl px-4">
            <span class="inline-block bg-surface-container text-primary text-xs font-bold tracking-widest uppercase px-4 py-1.5 rounded-full">
                Next-Gen Car Care Ecosystem
            </span>

            <h1 class="text-4xl md:text-5xl font-extrabold text-on-background tracking-tight leading-tight">
                Smart Automated <br/>
                <span class="bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
                    Car Wash System
                </span>
            </h1>

            <p class="text-lg text-slate-500 max-w-2xl mx-auto">
                Experience frictionless, high-trust automotive care. Track your service history, manage your vehicles, and unlock premium rewards with absolute precision.
            </p> <div class="pt-6 flex flex-col sm:flex-row justify-center gap-4">
                <a href="${pageContext.request.contextPath}/MainController?action=login" class="btn-primary px-8 py-3">
                    Get Started
                </a>
                <a href="#features" class="btn-secondary px-8 py-3">
                    Learn More
                </a>
            </div>
        </div>

        <section id="features" class="relative z-10  w-full border-t border-surface-border mt-16 py-16">
            <div class="max-w-[1280px] mx-auto px-4 md:px-16">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    
                    <div class="service-card">
                        <div class="text-primary font-bold text-xl mb-2">01. Swift Booking</div>
                        <p class="text-slate-500 text-sm">Schedule automated washing slots in under 5 seconds with modern queuing technology.</p>
                    </div>
                    
                    <div class="service-card">
                        <div class="text-primary font-bold text-xl mb-2">02. Vehicle Wallet</div>
                        <p class="text-slate-500 text-sm">Manage multiple corporate or personal vehicles and store licenses with monospaced precision.</p>
                    </div>
                    
                    <div class="service-card">
                        <div class="text-primary font-bold text-xl mb-2">03. Loyalty Tiers</div>
                        <p class="text-slate-500 text-sm">Earn reward points instantly and level up to unlock the high-contrast Gold membership perks.</p>
                    </div>
                    
                </div>
            </div>
        </section>
        
    </div>
</main>


<jsp:include page="/components/footer.jsp" />