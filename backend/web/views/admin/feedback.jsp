<%@page import="dto.AdminFeedbackView"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<AdminFeedbackView> feedbacks = (List<AdminFeedbackView>) request.getAttribute("FEEDBACKS");
    List<String> serviceNames = (List<String>) request.getAttribute("SERVICE_NAMES");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Tính average rating
    double avgRating = 0;
    if (feedbacks != null && !feedbacks.isEmpty()) {
        int total = 0;
        for (AdminFeedbackView f : feedbacks) {
            total += f.getRating();
        }
        avgRating = (double) total / feedbacks.size();
    }

    String currentKeyword = (String) request.getAttribute("CURRENT_KEYWORD");
    String currentRating = (String) request.getAttribute("CURRENT_RATING");
    String currentService = (String) request.getAttribute("CURRENT_SERVICE");

    if (currentKeyword == null) {
        currentKeyword = "";
    }
    if (currentRating == null) {
        currentRating = "all";
    }
    if (currentService == null)
        currentService = "all";
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/components/admin/adminHead.jsp" />
        <title>Feedback Management | AutoWash Pro</title>
    </head>

    <body class="bg-slate-50 text-slate-900">
        <div class="flex min-h-screen">

            <jsp:include page="/components/admin/adminSidebar.jsp" />

            <div class="flex-1 min-w-0">
                <jsp:include page="/components/admin/adminTopbar.jsp" />

                <main class="p-6">

                    <!-- Header -->
                    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-2xl font-extrabold text-slate-900">
                                Feedback Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                Monitor and analyze customer satisfaction across all service types.
                            </p>
                        </div>
                        <div class="flex items-center gap-6 px-5 py-3 bg-white rounded-2xl border border-slate-200 shadow-sm">
                            <div>
                                <p class="text-xs font-bold text-slate-400 uppercase">Average Rating</p>
                                <p class="text-xl font-extrabold text-indigo-600">
                                    <%= String.format("%.1f", avgRating)%> / 5.0
                                </p>
                            </div>
                            <div class="w-px h-8 bg-slate-200"></div>
                            <div>
                                <p class="text-xs font-bold text-slate-400 uppercase">Total Reviews</p>
                                <p class="text-xl font-extrabold text-slate-900">
                                    <%= feedbacks != null ? feedbacks.size() : 0%>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Table Section -->
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">

                        <!-- Filter Row -->
                       <!-- Filter Row -->
<div class="px-5 py-4 border-b border-slate-100 flex flex-col gap-4">

    <div>
        <h3 class="text-lg font-bold text-slate-900">Feedback List</h3>
        <p class="text-sm text-slate-400">
            Search and filter all feedback records.
        </p>
    </div>

    <form method="get"
          action="${pageContext.request.contextPath}/admin/feedbacks"
          class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-3">

        <!-- Search -->
        <input
            type="text"
            name="keyword"
            value="<%= currentKeyword %>"
            placeholder="Search customer name or comment..."
            class="xl:col-span-2 w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">

        <!-- Rating -->
        <select
            name="rating"
            class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">

            <option value="all" <%= "all".equals(currentRating) ? "selected" : "" %>>
                All Ratings
            </option>

            <option value="5" <%= "5".equals(currentRating) ? "selected" : "" %>>
                5 Stars
            </option>

            <option value="4" <%= "4".equals(currentRating) ? "selected" : "" %>>
                4 Stars
            </option>

            <option value="3" <%= "3".equals(currentRating) ? "selected" : "" %>>
                3 Stars
            </option>

            <option value="2" <%= "2".equals(currentRating) ? "selected" : "" %>>
                2 Stars
            </option>

            <option value="1" <%= "1".equals(currentRating) ? "selected" : "" %>>
                1 Star
            </option>

        </select>

        <!-- Service -->
        <select
            name="service"
            class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">

            <option value="all">All Services</option>

            <%
                if (serviceNames != null) {
                    for (String s : serviceNames) {
            %>

            <option value="<%= s %>"
                    <%= s.equals(currentService) ? "selected" : "" %>>
                <%= s %>
            </option>

            <%
                    }
                }
            %>

        </select>

        <!-- Button -->
        <div class="flex gap-2">

            <button type="submit"
                    class="w-full px-3 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                Search
            </button>

            <a href="${pageContext.request.contextPath}/admin/feedbacks"
               class="w-full flex items-center justify-center px-3 py-2.5 rounded-xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                Clear
            </a>

        </div>

    </form>

</div>
                        <!-- Table -->
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold whitespace-nowrap">Feedback ID</th>
                                        <th class="px-5 py-3 text-left font-bold">Customer</th>
                                        <th class="px-5 py-3 text-left font-bold">Rating</th>
                                        <th class="px-5 py-3 text-left font-bold">Comment</th>
                                        <th class="px-5 py-3 text-left font-bold">Service</th>
                                        <th class="px-5 py-3 text-left font-bold whitespace-nowrap">Date</th>
                                    </tr>
                                </thead>

                                <tbody id="feedbackTableBody" class="divide-y divide-slate-100">
                                    <% if (feedbacks == null || feedbacks.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" class="px-5 py-10 text-center text-slate-400">
                                            No feedback records found.
                                        </td>
                                    </tr>
                                    <% } else { %>
                                    <% for (AdminFeedbackView f : feedbacks) {%>
                                    <tr class="feedback-row hover:bg-slate-50 transition-colors"
                                        data-rating="<%= f.getRating()%>"
                                        data-service="<%= f.getServiceNames() != null ? f.getServiceNames().toLowerCase() : ""%>">

                                        <!-- Customer -->
                                        <td class="px-5 py-4 font-extrabold text-slate-900 whitespace-nowrap">
                                            #<%= f.getFeedbackId()%>
                                        </td>
                                        <td class="px-5 py-4 font-bold text-slate-900 whitespace-nowrap">
                                            <%= f.getCustomerName() != null ? f.getCustomerName() : "N/A"%>
                                        </td>

                                        <!-- Rating: hiển thị sao -->
                                        <td class="px-5 py-4 whitespace-nowrap">
                                            <div class="flex items-center gap-1">
                                                <% for (int i = 1; i <= 5; i++) {%>
                                                <span class="text-lg <%= i <= f.getRating() ? "text-amber-400" : "text-slate-200"%>">★</span>
                                                <% }%>
                                                <span class="text-xs font-bold text-slate-500 ml-1">(<%= f.getRating()%>)</span>
                                            </div>
                                        </td>

                                        <!-- Comment -->
                                        <td class="px-5 py-4 text-slate-600 max-w-xs">
                                            <p class="line-clamp-2">
                                                <%= f.getComment() != null ? f.getComment() : "—"%>
                                            </p>
                                        </td>

                                        <!-- Service -->
                                        <td class="px-5 py-4 text-slate-700">
                                            <%= f.getServiceNames() != null ? f.getServiceNames() : "—"%>
                                        </td>

                                        <!-- Date -->
                                        <td class="px-5 py-4 text-slate-500 text-xs whitespace-nowrap">
                                            <%= f.getCreatedAt() != null ? sdf.format(f.getCreatedAt()) : "—"%>
                                        </td>

                                    </tr>
                                    <% } %>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>

                    </section>

                </main>
            </div>
        </div>
    </body>
</html>
