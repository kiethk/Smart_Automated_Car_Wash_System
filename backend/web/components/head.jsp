<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">

<script src="https://cdn.tailwindcss.com"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/global.css">
<script src="https://unpkg.com/lucide@latest"></script>
<script>
    tailwind.config = {theme: {
            extend: {
                /* 1. ĐỒNG BỘ TOÀN BỘ BẢNG MÀU HỆ THỐNG */
                colors: {
                    primary: 'var(--primary)',
                    'on-primary': 'var(--on-primary)',
                    secondary: 'var(--secondary)',
                    'on-secondary': 'var(--on-secondary)',
                    background: 'var(--background)',
                    'on-background': 'var(--on-background)',
                    surface: 'var(--surface)',
                    'surface-card': 'var(--surface-card)',
                    'surface-border': 'var(--surface-border)',
                    'surface-container': 'var(--surface-container)',
                    'on-surface-variant': 'var(--on-surface-variant)',
                    'loyalty-gold': 'var(--loyalty-gold)',
                    'loyalty-silver': 'var(--loyalty-silver)',
                    success: 'var(--success)',
                    error: 'var(--error)'
                },
                /* 2. ĐỒNG BỘ HỆ THỐNG BO GÓC (SHAPES) */
                borderRadius: {
                    'sm': 'var(--rounded-sm)',
                    'md': 'var(--rounded-md)',
                    'lg': 'var(--rounded-lg)',
                    '2xl': 'var(--rounded-2xl)', /* 16px - Chuẩn nút bấm & thẻ card chính */
                    'xl': 'var(--rounded-xl)',
                    'full': 'var(--rounded-full)'
                },
                /* 3. ĐỒNG BỘ HỆ THỐNG PHÔNG CHỮ (BỊ THIẾU LÚC TRƯỚC) */
                fontFamily: {
                    sans: ['var(--font-sans)', 'sans-serif'], /* Inter cho văn bản thông thường */
                    mono: ['var(--font-mono)', 'monospace']    /* JetBrains Mono cho dữ liệu kỹ thuật */
                }
            }
        }
    }
</script>


<style type="text/tailwindcss">
    @layer components {
        /* Hệ thống Nút bấm */
        .btn-primary {
            @apply bg-gradient-to-br from-primary to-secondary text-on-primary font-semibold px-6 py-2.5 rounded-2xl shadow-sm hover:-translate-y-0.5 hover:shadow-md active:translate-y-0 transition-all duration-200 text-center inline-flex items-center justify-center;
        }

        .btn-secondary {
            @apply border border-surface-border text-primary font-semibold px-6 py-2.5 rounded-2xl hover:bg-slate-50 transition-all duration-200 text-center inline-flex items-center justify-center;
        }

        /* Hệ thống Ô nhập liệu & Biểu mẫu */
        .form-input {
            @apply w-full px-4 py-2.5 bg-slate-50 border border-surface-border rounded-2xl focus:outline-none focus:bg-white focus:ring-4 focus:ring-indigo-100 focus:border-primary transition-all duration-150 placeholder:text-slate-400 text-sm;
        }

        .form-label {
            @apply block text-xs font-bold uppercase tracking-wider text-slate-400 mb-2;
        }

        /* Thẻ dịch vụ */
        .service-card {
            @apply bg-surface-card border border-surface-border rounded-2xl p-6 shadow-[0px_1px_3px_rgba(15,23,42,0.05)] hover:-translate-y-0.5 hover:shadow-md transition-all duration-200;
        }

        /* Font chữ kỹ thuật */
        .tech-data {
            @apply font-mono tracking-wider text-sm font-medium;
        }
    }
</style>