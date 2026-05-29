<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoWash Pro</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style type="text/tailwindcss">
        @layer components {
            /* Layout tổng */
            .main-container {
                @apply max-w-[1280px] mx-auto px-4 md:px-16 py-10;
            }

            /* Hệ thống Nút bấm (Xoay góc 135 độ từ Deep Indigo sang Bright Blue) */
            .btn-primary {
                @apply bg-gradient-to-br from-[#1f108e] to-[#0060ac] text-white font-semibold px-6 py-2.5 rounded-lg shadow-sm hover:-translate-y-0.5 hover:shadow-md active:translate-y-0 transition-all duration-200 text-center;
            }
            .btn-secondary {
                @apply border border-slate-200 text-[#1f108e] font-semibold px-6 py-2.5 rounded-lg hover:bg-slate-50 transition-all duration-200 text-center;
            }

            /* Hệ thống Ô nhập liệu & Biểu mẫu */
            .form-input {
                @apply w-full px-4 py-2.5 bg-white border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-300 focus:border-transparent transition-all duration-150 placeholder:text-slate-400;
            }
            .form-label {
                @apply block text-sm font-semibold text-[#131b2e] mb-1.5;
            }

            /* Thẻ dịch vụ / Thẻ tính năng thông tin */
            .service-card {
                @apply bg-white border border-slate-100 rounded-lg p-6 shadow-[0px_1px_3px_rgba(15,23,42,0.05)] hover:-translate-y-0.5 hover:shadow-md transition-all duration-200;
            }

            /* Font chữ kỹ thuật hiển thị biển số xe, giá tiền, ngày tháng */
            .tech-data {
                font-family: 'JetBrains Mono', monospace;
                @apply tracking-wider text-sm font-medium;
            }

            /* Huy hiệu Hạng thành viên (Loyalty Badges) */
            .badge-gold {
                @apply bg-[#f59e0b] text-white px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider shadow-sm;
            }
            .badge-silver {
                @apply bg-[#94a3b8] text-white px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider shadow-sm;
            }

            /* Dấu chấm trạng thái xe */
            .dot-status-in-progress { @apply w-2.5 h-2.5 bg-[#f59e0b] rounded-full inline-block; }
            .dot-status-cleaned { @apply w-2.5 h-2.5 bg-[#10b981] rounded-full inline-block; }
            .dot-status-scheduled { @apply w-2.5 h-2.5 bg-[#94a3b8] rounded-full inline-block; }
        }
    </style>
</head>
<body>
    <nav class="bg-white border-b border-slate-100 py-4 shadow-sm">
        <div class="max-w-[1280px] mx-auto px-4 md:px-16 flex justify-between items-center">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-xl font-bold text-[#1f108e]">AutoWash Pro</a>
            <div class="space-x-4">
                <a href="${pageContext.request.contextPath}/views/customer/profile.jsp" class="text-sm font-medium text-slate-600 hover:text-[#1f108e]">Hồ sơ</a>
            </div>
        </div>
    </nav>
