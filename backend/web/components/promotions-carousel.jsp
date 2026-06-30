<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="carousel-container relative w-full group overflow-hidden rounded-2xl shadow-sm border border-slate-100">
    
    <div class="promo-slider flex overflow-x-auto scroll-smooth snap-x snap-mandatory no-scrollbar">
        <c:forEach var="promo" items="${requestScope.PROMOTIONS_LIST}" varStatus="status">
            
            <%-- Đặt mặc định ảnh nếu không có ảnh --%>
            <c:set var="bgImage" value="${not empty promo.imageUrl ? promo.imageUrl : '/assets/images/car-background.jpg'}" />
            
            <%-- BỘ LỌC ĐƯỜNG DẪN ẢNH CLOUDINARY --%>
            <c:set var="finalImgUrl" value="${bgImage}" />
            <c:if test="${not fn:startsWith(bgImage, 'http://') && not fn:startsWith(bgImage, 'https://')}">
                <c:set var="finalImgUrl" value="${pageContext.request.contextPath}${bgImage}" />
            </c:if>
            
            <div class="slide-item snap-start shrink-0 w-full bg-cover bg-center p-8 md:p-12 text-white relative min-h-[210px] md:min-h-[250px] flex flex-col justify-center transition-all duration-300"
                 style="background-image: linear-gradient(to right, rgba(15, 23, 42, 0.85), rgba(15, 23, 42, 0.4)), url('${finalImgUrl}');">
                
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

    <button class="btn-prev absolute left-4 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full bg-slate-950/40 hover:bg-slate-950/60 text-white flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 backdrop-blur-sm focus:outline-none z-20 shadow-sm">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
        </svg>
    </button>
    <button class="btn-next absolute right-4 top-1/2 -translate-y-1/2 w-9 h-9 rounded-full bg-slate-950/40 hover:bg-slate-950/60 text-white flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 backdrop-blur-sm focus:outline-none z-20 shadow-sm">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
        </svg>
    </button>

    <div class="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2 z-20">
        <c:forEach var="promo" items="${requestScope.PROMOTIONS_LIST}" varStatus="status">
            <button data-index="${status.index}" class="dot-indicator h-2 rounded-full bg-white/40 transition-all duration-300 focus:outline-none ${status.index == 0 ? 'bg-white w-5' : 'w-2'}">
            </button>
        </c:forEach>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const carousels = document.querySelectorAll('.carousel-container');
        
        carousels.forEach(container => {
            if(container.dataset.initialized) return;
            container.dataset.initialized = 'true';

            const slider = container.querySelector('.promo-slider');
            const dots = container.querySelectorAll('.dot-indicator');
            const prevBtn = container.querySelector('.btn-prev');
            const nextBtn = container.querySelector('.btn-next');
            const slideCount = dots.length;
            let currentIndex = 0;
            let autoSlideTimer;
            let isAnimating = false; // Cờ hiệu ngăn click liên tục gây lỗi

            if (!slider || slideCount <= 1) return;

            // BƯỚC 1: TẠO BẢN SAO (CLONE) CHO SLIDE ĐẦU TIÊN
            // Thủ thuật "Infinite Loop" bắt đầu từ đây
            const firstSlide = slider.children[0];
            const cloneSlide = firstSlide.cloneNode(true);
            slider.appendChild(cloneSlide);

            // Hàm cập nhật chấm sáng Indicator
            function updateIndicators(index) {
                // Nếu đang ở slide Ảo (cuối cùng), thắp sáng chấm số 0
                const activeIndex = index === slideCount ? 0 : index;
                dots.forEach((dot, idx) => {
                    if (idx === activeIndex) {
                        dot.classList.add('bg-white', 'w-5');
                        dot.classList.remove('bg-white/40', 'w-2');
                    } else {
                        dot.classList.remove('bg-white', 'w-5');
                        dot.classList.add('bg-white/40', 'w-2');
                    }
                });
            }

            // Hàm dịch chuyển màn hình
            function goToSlide(index, isSmooth = true) {
                // Bật/tắt cuộn mượt (Tailwind scroll-smooth)
                if (isSmooth) {
                    slider.classList.add('scroll-smooth');
                } else {
                    slider.classList.remove('scroll-smooth');
                }
                const slideWidth = slider.clientWidth;
                slider.scrollLeft = index * slideWidth;
                updateIndicators(index);
            }

            // Hàm xử lý Logic khi qua lại
            function moveSlide(direction) {
                if (isAnimating) return;
                isAnimating = true;

                // TRƯỜNG HỢP 1: Đang ở đầu mà bấm Lùi -> Giật tới Clone cuối rồi cuộn mượt lùi
                if (currentIndex === 0 && direction === -1) {
                    goToSlide(slideCount, false); // Nhảy tới bản ảo (không mượt)
                    currentIndex = slideCount - 1;
                    setTimeout(() => {
                        goToSlide(currentIndex, true); // Cuộn mượt về slide cuối thật
                        setTimeout(() => isAnimating = false, 500);
                    }, 50);
                    return;
                }

                // TRƯỜNG HỢP BÌNH THƯỜNG: Cuộn mượt
                currentIndex += direction;
                goToSlide(currentIndex, true);

                // TRƯỜNG HỢP 2: Đã cuộn mượt tới bản Clone ảo ở cuối (Infinite Loop)
                if (currentIndex === slideCount) {
                    // Đợi 500ms cho hiệu ứng cuộn mượt hoàn tất...
                    setTimeout(() => {
                        // ...sau đó tắt mượt và giật về Slide số 1 THẬT (tại index 0)
                        goToSlide(0, false); 
                        currentIndex = 0;
                        isAnimating = false;
                    }, 500); 
                } else {
                    setTimeout(() => isAnimating = false, 500);
                }
            }

            function startAutoSlide() {
                autoSlideTimer = setInterval(() => {
                    moveSlide(1);
                }, 5000);
            }

            function stopAutoSlide() {
                clearInterval(autoSlideTimer);
            }

            // Xử lý khi người dùng kéo/vuốt màn hình bằng tay
            let isScrolling;
            slider.addEventListener('scroll', () => {
                window.clearTimeout(isScrolling);
                isScrolling = setTimeout(() => {
                    if (isAnimating) return; // Bỏ qua nếu đang chạy Auto
                    const slideWidth = slider.clientWidth;
                    if (slideWidth > 0) {
                        let newIndex = Math.round(slider.scrollLeft / slideWidth);
                        // Nếu vuốt tay tới trúng slide ảo -> Giật về slide đầu thật
                        if (newIndex === slideCount) {
                            goToSlide(0, false);
                            currentIndex = 0;
                        } else if (newIndex !== currentIndex) {
                            currentIndex = newIndex;
                            updateIndicators(currentIndex);
                        }
                    }
                }, 100);
            });

            // Lắng nghe sự kiện Hover chuột và Click
            container.addEventListener('mouseenter', stopAutoSlide);
            container.addEventListener('mouseleave', startAutoSlide);

            if(prevBtn) prevBtn.addEventListener('click', () => moveSlide(-1));
            if(nextBtn) nextBtn.addEventListener('click', () => moveSlide(1));

            dots.forEach((dot, idx) => {
                dot.addEventListener('click', function() {
                    if (isAnimating) return;
                    currentIndex = idx;
                    goToSlide(currentIndex, true);
                });
            });

            // Khởi động chạy tự động
            startAutoSlide();
        });
    });
</script>

<style>
    .no-scrollbar::-webkit-scrollbar { display: none; }
    .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
</style>
