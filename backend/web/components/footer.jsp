<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="bg-white border-t border-surface-border">
    <div class="max-w-[1280px] mx-auto px-4 md:px-16 py-8 flex flex-col sm:flex-row justify-between items-center gap-4">

        <div class="text-xs text-slate-400 font-normal space-y-1 text-center sm:text-left">
            <jsp:include page="/components/logo.jsp" />
            <div>&copy; 2026 AutoWash Pro. Expert care for your vehicle.</div>
        </div>

        <div class="flex flex-wrap justify-center gap-x-6 gap-y-2 text-xs font-medium text-slate-500 font-mono tracking-wide">
            <a href="#" class="hover:text-primary transition duration-150">Terms of Service</a>
            <a href="#" class="hover:text-primary transition duration-150">Privacy Policy</a>
            <a href="#" class="hover:text-primary transition duration-150">Support</a>
            <a href="#" class="hover:text-primary transition duration-150">Contact</a>
        </div>

    </div>
</footer>

<script>
    function toggleDropdown() {
        const dropdown = document.getElementById('user-dropdown');
        dropdown.classList.toggle('hidden');
    }

// Đóng dropdown khi click ra ngoài
    window.onclick = function (event) {
        if (!event.target.matches('button') && !event.target.closest('button')) {
            const dropdown = document.getElementById('user-dropdown');
            if (dropdown && !dropdown.classList.contains('hidden')) {
                dropdown.classList.add('hidden');
            }
        }
    }
</script>
</body>
</html>