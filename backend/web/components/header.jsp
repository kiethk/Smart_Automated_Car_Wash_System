<%@page import="dto.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoWash Pro</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">

        <jsp:include page="/components/head.jsp" />
        
    </head>
    <body class="bg-background text-on-background antialiased font-sans">
        <nav class="bg-[var(--surface-card)] border-b border-[var(--surface-border)] py-4 shadow-sm">
            <div class="max-w-[1280px] mx-auto px-4 md:px-16 flex justify-between items-center">

                <jsp:include page="/components/logo.jsp" />

                <div class="flex items-center space-x-6 relative">
                    <% User user = (User) session.getAttribute("USER");
                        if (user == null) { %>
                    <a href="${pageContext.request.contextPath}//MainController?action=register" class="text-sm font-medium text-primary">Sign up</a>
                    <a href="${pageContext.request.contextPath}//MainController?action=login" class="btn-primary py-2 px-4 text-sm">Login</a>
                    <% } else {%>
                    <div class="relative">
                        <button onclick="toggleDropdown()" class="flex items-center space-x-3 hover:opacity-80 transition-opacity focus:outline-none">
                            <span class="text-sm font-semibold text-on-background"><%= user.getFullName() != null ? user.getFullName() : "User"%></span>
                            <div class="w-9 h-9 rounded-full border-2 border-primary/20 overflow-hidden bg-primary/10">
                                <img src="<%= (user.getAvatarUrl() != null && !user.getAvatarUrl().trim().isEmpty()) ? user.getAvatarUrl() : request.getContextPath() + "/assets/images/avatar-placeholder.jpg"%>" alt="Avatar" class="w-full h-full object-cover">
                            </div>
                        </button>

                        <div id="user-dropdown" class="overflow-hidden hidden absolute right-0 mt-2 w-48 bg-white border border-surface-border rounded-xl shadow-lg py-2 z-50">
                            <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-2 text-sm text-on-background hover:bg-slate-50 transition-colors">
                                My Profile
                            </a>
                            <hr class="my-1 border-surface-border">
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-error hover:bg-red-50 transition-colors">
                                Logout
                            </a>
                        </div>
                    </div>
                    <% }%>
                </div>


            </div>
        </nav>