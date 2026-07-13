<%@page import="dto.Notifications"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/components/header.jsp" />

<main class="max-w-3xl mx-auto px-4 py-10 min-h-[85vh]">
            <%
                List<Notifications> list = (List<Notifications>) request.getAttribute("USER_NOTIFICATIONS");
                int unreadTotal = 0;
                if (list != null) {
                    for (Notifications item : list) {
                        if (item.getIsRead() == 0) {
                            unreadTotal++;
                        }
                    }
                }
            %>

            <div class="flex justify-between items-center mb-8 border-b border-[var(--surface-border)] pb-4">
                <h1 class="text-2xl font-bold tracking-tight text-on-background">
                    Notifications
                </h1>
                <div class="flex items-center gap-3">
                    <% if (unreadTotal > 0) { %>
                    <a href="${pageContext.request.contextPath}/NotificationController?action=mark-all-read"
                       class="text-xs font-semibold bg-primary text-white px-3 py-2 rounded-lg hover:opacity-90 transition-opacity">
                        Mark all as read
                    </a>
                    <% } %>
                    <a href="${pageContext.request.contextPath}/MainController?action=home"
                       class="text-sm font-semibold text-primary hover:opacity-80 transition-opacity">
                        Back to home
                    </a>
                </div>
            </div>

            <div class="space-y-4">
                <%
                    if (list != null && !list.isEmpty()) {
                        for (Notifications noti : list) {
                            pageContext.setAttribute("noti", noti);
                            boolean isUnread = (noti.getIsRead() == 0);
                            String cardStyle = isUnread
                                    ? "bg-primary/5 border-l-4 border-primary shadow-sm"
                                    : "bg-[var(--surface-card)] opacity-70 border border-[var(--surface-border)]";
                %>
                <div class="p-5 rounded-xl transition-all duration-200 flex justify-between items-start gap-4 <%= cardStyle%>">
                    <div class="space-y-1">
                        <h3 class="text-base font-bold <%= isUnread ? "text-primary" : "text-on-background"%>">
                            <c:out value="${noti.title}" />
                        </h3>
                        <p class="text-sm text-on-surface-variant leading-relaxed">
                            <c:out value="${noti.content}" />
                        </p>
                        <span class="block text-xs text-neutral-400 pt-2">
                            <%= noti.getCreatedAt()%>
                        </span>
                    </div>

                    <% if (isUnread) {%>
                    <a href="${pageContext.request.contextPath}/NotificationController?action=mark-read&id=<%= noti.getNotificationId()%>"
                       class="text-xs font-semibold bg-primary text-white px-3 py-2 rounded-lg hover:opacity-90 transition-opacity shrink-0 shadow-sm shadow-primary/10">
                        Mark as read
                    </a>
                    <% } %>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="text-center py-16 bg-[var(--surface-card)] rounded-2xl border border-[var(--surface-border)]">
                    <p class="text-on-surface-variant text-sm">Your inbox is empty. You do not have any notifications yet.</p>
                </div>
                <%
                    }
                %>
            </div>
</main>

<jsp:include page="/components/footer.jsp" />
