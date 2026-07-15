<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Panel - AutoWash Pro</title>
<link rel="stylesheet" type="text/css" charset="UTF-8" href="${pageContext.request.contextPath}/assets/css/global.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">

<jsp:include page="/components/head.jsp" />

<style>
    body {
        font-family: 'Inter', sans-serif;
    }

    .admin-scrollbar::-webkit-scrollbar {
        width: 6px;
    }

    .admin-scrollbar::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 999px;
    }

    .admin-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
    }
</style>
