<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="carousel-container" class="relative w-full group overflow-hidden rounded-2xl shadow-sm border border-slate-100">
    
    <div id="promo-slider" class="flex overflow-x-auto scroll-smooth snap-x snap-mandatory no-scrollbar">
        <c:forEach var="promo" items="${requestScope.PROMOTIONS_LIST}" varStatus="status">
            <c:set var="bgImage" value="${not empty promo.imageUrl ? promo.imageUrl : '/assets/images/car-background.jpg'}" />
            
            <div class="slide-item snap-start shrink-0 w-full bg-cover bg-center p-8 md:p-12 text-white relative min-h-[210px] md:min-h-[250px] flex flex-col justify-center"
                 style="background-image: linear-gradient(to right, rgba(15, 23, 42, 0.85), rgba(15, 23, 42, 0.4)), url('${pageContext.request.contextPath}${bgImage}');">
                
                <div class="relative z-10 space-y-3 max-w-xl text-left">
                    <span class="inline-block bg-blue-500/20 text-blue-300 text-[10px] font-bold uppercase tracking-wider px-2.5 py-1 rounded-md border border-blue-500/30">
                        Code: ${promo.code}
                    </span>
                    <h3 class="text-xl md:text-2xl font-extrabold tracking-tight leading-tight text-white">
                        ${promo.title}
                    </h3>
                    <p class="text-slate-200 text-xs md:text-sm font-medium opacity-90 line-clamp-2 max-w-lg">
                        ${promo.description}
                    </p>
                    <div class="pt-2">
                        <a href="${pageContext.request.contextPath}/MainController?action=booking&code=${promo.code}" 
                           class="inline-block bg-gradient-to-r from-blue-950 via-blue-900 to-blue-600 hover:from-blue-900 hover:to-blue-500 text-xs font-bold px-6 py-2.5 rounded-xl transition-all duration-300 shadow-md">
                            Get This Offer
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <button onclick="moveSlide(-1)" class="absolute left-4 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full bg-slate-950/40 hover:bg-slate-950/60 text-white flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 backdrop-blur-sm focus:outline-none z-20 shadow-sm">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
        </svg>
    </button>
    <button onclick="moveSlide(1)" class="absolute right-4 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full bg-slate-950/40 hover:bg-slate-950/60 text-white flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 backdrop-blur-sm focus:outline-none z-20 shadow-sm">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
        </svg>
    </button>

    <div class="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2 z-20">
        <c:forEach var="promo" items="${requestScope.PROMOTIONS_LIST}" varStatus="status">
            <button onclick="goToSlide(${status.index})" 
                    class="dot-indicator h-2 rounded-full bg-white/40 transition-all duration-300 focus:outline-none ${status.index == 0 ? 'bg-white w-5' : 'w-2'}">
            </button>
        </c:forEach>
    </div>
</div>

<script>
    (function() {
        const slider = document.getElementById('promo-slider');
        const container = document.getElementById('carousel-container');
        const dots = document.querySelectorAll('.dot-indicator');
        let currentIndex = 0;
        const slideCount = dots.length;
        let autoSlideTimer;

        // Nếu cơ sở dữ liệu không có hoặc chỉ có 1 ưu đãi thì không chạy logic trượt
        if (!slider || slideCount <= 1) return;

        // Hàm dịch chuyển màn hình đến Slide được chỉ định
        window.goToSlide = function(index) {
            currentIndex = index;
            const slideWidth = slider.clientWidth;
            slider.scrollLeft = currentIndex * slideWidth;
            updateIndicators();
        };

        // Hàm tiến 1 bước hoặc lùi 1 bước
        window.moveSlide = function(direction) {
            currentIndex += direction;
            if (currentIndex >= slideCount) currentIndex = 0;
            if (currentIndex < 0) currentIndex = slideCount - 1;
            goToSlide(currentIndex);
        };

        // Cập nhật chấm tròn nào đang hoạt động (Chấm hoạt động sẽ dài ra cực kỳ chuyên nghiệp)
        function updateIndicators() {
            dots.forEach((dot, idx) => {
                if (idx === currentIndex) {
                    dot.classList.add('bg-white', 'w-5');
                    dot.classList.remove('bg-white/40', 'w-2');
                } else {
                    dot.classList.remove('bg-white', 'w-5');
                    dot.classList.add('bg-white/40', 'w-2');
                }
            });
        }

        // Tạo vòng lặp kích hoạt tự động chuyển động sau 5000ms (5 giây)
        function startAutoSlide() {
            autoSlideTimer = setInterval(() => {
                moveSlide(1);
            }, 5000);
        }

        // Xóa vòng lặp khi người dùng rê chuột vào đọc nội dung voucher (Tránh ức chế cho người dùng)
        function stopAutoSlide() {
            clearInterval(autoSlideTimer);
        }

        // Lắng nghe hành vi cuộn vuốt bằng tay để đồng bộ chỉ số chấm tròn kịp thời
        let isScrolling;
        slider.addEventListener('scroll', () => {
            window.clearTimeout(isScrolling);
            isScrolling = setTimeout(() => {
                const slideWidth = slider.clientWidth;
                if (slideWidth > 0) {
                    const newIndex = Math.round(slider.scrollLeft / slideWidth);
                    if (newIndex !== currentIndex && newIndex < slideCount) {
                        currentIndex = newIndex;
                        updateIndicators();
                    }
                }
            }, 100);
        });

        // Đăng ký sự kiện Hover hoãn và chạy lại vòng lặp
        container.addEventListener('mouseenter', stopAutoSlide);
        container.addEventListener('mouseleave', startAutoSlide);

        // Khởi động chạy tự động ngay khi trang web tải xong
        startAutoSlide();
    })();
</script>

<style>
    /* Khóa chết và ẩn hoàn toàn thanh cuộn thô cứng của hệ thống */
    .no-scrollbar::-webkit-scrollbar { display: none; }
    .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
</style>