<%
    // Kiểm tra nếu đã có session USER thì chuyển hướng về profile
    if (session.getAttribute("USER") != null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return; // Dừng việc tải trang login lại
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register | AutoWash Pro</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />

    <script src="https://unpkg.com/lucide@latest"></script>
    
    <jsp:include page="/components/head.jsp" />

    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface-container-lowest": "#ffffff",
                        "surface-container": "#eaedff",
                        "secondary-fixed": "#d4e3ff",
                        "surface-container-highest": "#dae2fd",
                        "on-tertiary-fixed": "#2a1700",
                        "on-surface-variant": "#464553",
                        "on-background": "#131b2e",
                        "on-primary-container": "#a9a7ff",
                        "on-tertiary-fixed-variant": "#653e00",
                        "on-secondary-fixed": "#001c39",
                        "inverse-surface": "#283044",
                        "surface": "#faf8ff",
                        "surface-container-low": "#f2f3ff",
                        "primary-container": "#3730a3",
                        "secondary-fixed-dim": "#a4c9ff",
                        "on-tertiary": "#ffffff",
                        "on-tertiary-container": "#f49d09",
                        "surface-tint": "#544fc0",
                        "surface-dim": "#d2d9f4",
                        "surface-container-high": "#e2e7ff",
                        "tertiary-container": "#603b00",
                        "tertiary-fixed": "#ffddb8",
                        "background": "#faf8ff",
                        "on-primary-fixed": "#0f0069",
                        "on-surface": "#131b2e",
                        "surface-base": "#f8fafc",
                        "on-primary-fixed-variant": "#3b35a7",
                        "on-secondary-fixed-variant": "#004883",
                        "tertiary": "#422700",
                        "surface-border": "#e2e8f0",
                        "on-error-container": "#93000a",
                        "on-primary": "#ffffff",
                        "primary": "#1f108e",
                        "on-error": "#ffffff",
                        "loyalty-silver": "#94a3b8",
                        "surface-bright": "#faf8ff",
                        "error-container": "#ffdad6",
                        "outline-variant": "#c8c4d5",
                        "primary-fixed-dim": "#c3c0ff",
                        "tertiary-fixed-dim": "#ffb95f",
                        "on-secondary-container": "#003c70",
                        "error": "#f43f5e",
                        "loyalty-gold": "#f59e0b",
                        "primary-fixed": "#e2dfff",
                        "surface-variant": "#dae2fd",
                        "secondary": "#0060ac",
                        "outline": "#777584",
                        "inverse-primary": "#c3c0ff",
                        "on-secondary": "#ffffff",
                        "secondary-container": "#64a8fe",
                        "inverse-on-surface": "#eef0ff",
                        "success": "#10b981"
                    },
                    borderRadius: {
                        DEFAULT: "0.25rem",
                        lg: "0.5rem",
                        xl: "0.75rem",
                        full: "9999px"
                    },
                    spacing: {
                        base: "4px",
                        gutter: "24px",
                        "margin-mobile": "16px",
                        "margin-desktop": "64px",
                        "max-width": "1280px"
                    },
                    fontFamily: {
                        "label-sm": ["JetBrains Mono"],
                        "body-md": ["Inter"],
                        "headline-md": ["Inter"],
                        "headline-xl": ["Inter"],
                        "headline-lg": ["Inter"],
                        "body-lg": ["Inter"],
                        "label-md": ["JetBrains Mono"],
                        "headline-lg-mobile": ["Inter"]
                    },
                    fontSize: {
                        "label-sm": ["12px", { lineHeight: "16px", fontWeight: "600" }],
                        "body-md": ["16px", { lineHeight: "24px", fontWeight: "400" }],
                        "headline-md": ["24px", { lineHeight: "32px", fontWeight: "600" }],
                        "headline-xl": ["48px", { lineHeight: "56px", letterSpacing: "-0.02em", fontWeight: "800" }],
                        "headline-lg": ["32px", { lineHeight: "40px", letterSpacing: "-0.01em", fontWeight: "700" }],
                        "body-lg": ["18px", { lineHeight: "28px", fontWeight: "400" }],
                        "label-md": ["14px", { lineHeight: "20px", letterSpacing: "0.05em", fontWeight: "500" }],
                        "headline-lg-mobile": ["28px", { lineHeight: "36px", fontWeight: "700" }]
                    }
                },
            },
        }
    </script>

    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
    </style>
</head>

<body class="bg-surface font-body-md text-on-surface min-h-screen flex flex-col">

    <main class="flex-grow flex items-center justify-center py-12 px-margin-mobile md:px-margin-desktop bg-surface-base">

        <!-- CARD -->
        <div class="max-w-5xl min-h-[680px] w-full mx-auto flex flex-col md:flex-row bg-surface-container-lowest rounded-2xl shadow-xl overflow-hidden border border-surface-border">

            <!-- LEFT -->
            <div class="w-full md:w-5/12 bg-gradient-to-br from-primary to-secondary p-12 flex flex-col justify-between text-on-primary relative overflow-hidden">

                <div class="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 bg-white/10 rounded-full blur-3xl"></div>

                <div class="relative z-10">
                    <div class="mb-8">
                        <i class="w-16 h-16 text-on-primary opacity-90" data-lucide="car"></i>
                    </div>
                    <h1 class="font-headline-lg text-headline-lg mb-4">Join AutoWash Pro</h1>
                    <p class="font-body-lg text-body-lg opacity-90 leading-relaxed">
                        Premium care for your ride. Sign up to manage your fleet,
                        track service history, and access exclusive loyalty tiers.
                    </p>
                </div>

                <div class="relative z-10 glass-effect p-6 rounded-xl mt-12">
                    <div class="flex items-center gap-3 mb-2">
                        <span class="w-2 h-2 rounded-full bg-success"></span>
                        <p class="font-label-md text-label-md text-white">SYSTEM ONLINE</p>
                    </div>
                    <p class="font-label-sm text-label-sm text-white/80">
                        Experience 100% frictionless vehicle maintenance scheduling.
                    </p>
                </div>

                <div class="absolute inset-0 opacity-5 pointer-events-none"
                    style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 24px 24px;">
                </div>
            </div>

            <!-- RIGHT -->
            <div class="w-full md:w-7/12 p-10 md:p-14">

                <div class="mb-8">
                    <h2 class="font-headline-md text-headline-md text-on-surface mb-2">Create Account</h2>
                    <p class="font-body-md text-body-md text-on-surface-variant">Fill in the details below to get started.</p>
                </div>

                <%-- ERROR MESSAGE FROM SERVLET --%>
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div class="mb-5 px-4 py-3 bg-error-container text-on-error-container rounded-xl font-body-md text-body-md flex items-center gap-2">
                    <i class="w-4 h-4 flex-shrink-0" data-lucide="circle-alert"></i>
                    <span><%= error %></span>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-5">

                    <div class="space-y-5">

                        <!-- FULL NAME -->
                        <div class="space-y-1.5">
                            <label class="font-label-md text-label-md text-on-surface-variant px-1">Full Name</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-outline group-focus-within:text-primary transition-colors">
                                    <i class="w-4 h-4" data-lucide="user"></i>
                                </div>
                                <input
                                    type="text"
                                    name="fullName"
                                    placeholder="John Doe"
                                    required
                                    value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>"
                                    class="w-full pl-10 pr-4 py-3 bg-surface-container-low border-none rounded-xl focus:ring-2 focus:ring-primary-fixed-dim font-body-md text-body-md text-on-surface transition-all" />
                            </div>
                        </div>

                        <!-- EMAIL -->
                        <div class="space-y-1.5">
                            <label class="font-label-md text-label-md text-on-surface-variant px-1">Email Address</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-outline group-focus-within:text-primary transition-colors">
                                    <i class="w-4 h-4" data-lucide="mail"></i>
                                </div>
                                <input
                                    type="email"
                                    name="email"
                                    placeholder="john@example.com"
                                    required
                                    value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                                    class="w-full pl-10 pr-4 py-3 bg-surface-container-low border-none rounded-xl focus:ring-2 focus:ring-primary-fixed-dim font-body-md text-body-md text-on-surface transition-all" />
                            </div>
                        </div>

                        <!-- PASSWORD -->
                        <div class="space-y-1.5">
                            <label class="font-label-md text-label-md text-on-surface-variant px-1">Password</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-outline group-focus-within:text-primary transition-colors">
                                    <i class="w-4 h-4" data-lucide="lock"></i>
                                </div>
                                <input
                                    type="password"
                                    name="password"
                                    placeholder="At least 6 characters"
                                    required
                                    class="w-full pl-10 pr-4 py-3 bg-surface-container-low border-none rounded-xl focus:ring-2 focus:ring-primary-fixed-dim font-body-md text-body-md text-on-surface transition-all" />
                            </div>
                        </div>

                        <!-- CONFIRM PASSWORD -->
                        <div class="space-y-1.5">
                            <label class="font-label-md text-label-md text-on-surface-variant px-1">Confirm Password</label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-outline group-focus-within:text-primary transition-colors">
                                    <i class="w-4 h-4" data-lucide="shield-check"></i>
                                </div>
                                <input
                                    type="password"
                                    name="confirmPassword"
                                    placeholder="Confirm your password"
                                    required
                                    class="w-full pl-10 pr-4 py-3 bg-surface-container-low border-none rounded-xl focus:ring-2 focus:ring-primary-fixed-dim font-body-md text-body-md text-on-surface transition-all" />
                            </div>
                        </div>

                    </div>

                    <!-- SUBMIT BUTTON -->
                    <div class="pt-4">
                        <button
                            type="submit"
                            class="w-full bg-gradient-to-r from-primary to-secondary text-on-primary py-4 rounded-xl font-headline-md text-headline-md hover:shadow-lg hover:shadow-primary/20 active:scale-[0.98] transition-all flex items-center justify-center gap-3">
                            Create Account
                            <i class="w-5 h-5" data-lucide="arrow-right"></i>
                        </button>
                    </div>

                    <p class="text-center font-body-md text-body-md text-on-surface-variant pt-4">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/login"
                           class="text-primary font-bold hover:underline decoration-2 underline-offset-4">
                            Sign In
                        </a>
                    </p>

                </form>

            </div>
        </div>
    </main>

    <script>
        lucide.createIcons();

        // Client-side confirm password check
        const form = document.querySelector("form");
        form.addEventListener("submit", function (e) {
            const password = form.querySelector('[name="password"]').value;
            const confirm  = form.querySelector('[name="confirmPassword"]').value;
            if (password !== confirm) {
                e.preventDefault();
                alert("Passwords do not match!");
            }
        });
    </script>

</body>
</html>
