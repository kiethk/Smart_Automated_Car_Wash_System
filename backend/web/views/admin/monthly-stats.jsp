<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.CustomerMonthlyStats"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<CustomerMonthlyStats> statsList = (List<CustomerMonthlyStats>) request.getAttribute("STATS_LIST");
    int totalRecords = (int) request.getAttribute("TOTAL_RECORDS");
    int selectedYear = (int) request.getAttribute("SELECTED_YEAR");
    int selectedMonth = (int) request.getAttribute("SELECTED_MONTH");
    int currentYear = (int) request.getAttribute("CURRENT_YEAR");
    int currentMonth = (int) request.getAttribute("CURRENT_MONTH");
    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));

    String[] monthNames = {"", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"};
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/components/admin/adminHead.jsp" />
    </head>
    <body class="bg-slate-50 text-slate-900">
        <div class="flex min-h-screen">

            <jsp:include page="/components/admin/adminSidebar.jsp" />

            <div class="flex-1 min-w-0">
                <jsp:include page="/components/admin/adminTopbar.jsp" />

                <main class="p-6">
                    <%-- Header --%>
                    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-2xl font-extrabold text-slate-900">Monthly Stats</h2>
                            <p class="text-sm text-slate-500 mt-1">
                                Customer activity statistics by month — data updated automatically via trigger.
                            </p>
                        </div>
                        <div class="px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-sm font-bold text-slate-700">
                            <%= totalRecords%> records &middot; <%= monthNames[selectedMonth]%> <%= selectedYear%>
                        </div>
                    </div>

                    <%-- Month/Year Filter --%>
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 mb-6">
                        <form method="get" action="${pageContext.request.contextPath}/admin/monthly-stats"
                              class="flex flex-wrap items-end gap-4">

                            <div>
                                <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">
                                    Year
                                </label>
                                <select name="year"
                                        class="px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <% for (int y = currentYear; y >= currentYear - 3; y--) {%>
                                    <option value="<%= y%>" <%= y == selectedYear ? "selected" : ""%>><%= y%></option>
                                    <% } %>
                                </select>
                            </div>

                            <div>
                                <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">
                                    Month
                                </label>
                                <select name="month"
                                        class="px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <% for (int mo = 1; mo <= 12; mo++) {%>
                                    <option value="<%= mo%>" <%= mo == selectedMonth ? "selected" : ""%>><%= monthNames[mo]%></option>
                                    <% } %>
                                </select>
                            </div>

                            <button type="submit"
                                    class="px-5 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                Apply
                            </button>

                            <% if (selectedYear != currentYear || selectedMonth != currentMonth) { %>
                            <a href="${pageContext.request.contextPath}/admin/monthly-stats"
                               class="px-5 py-2.5 rounded-xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                Current Month
                            </a>
                            <% } %>
                        </form>
                    </section>

                    <%-- Summary Cards --%>
                    <%
                        long totalSpentSum = 0;
                        int totalWashesSum = 0;
                        if (statsList != null) {
                            for (CustomerMonthlyStats s : statsList) {
                                totalSpentSum += s.getMonthlySpent();
                                totalWashesSum += s.getMonthlyWashes();
                            }
                        }
                    %>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5">
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-wider">Active Customers</p>
                            <p class="text-3xl font-extrabold text-slate-900 mt-2"><%= totalRecords%></p>
                            <p class="text-xs text-slate-400 mt-1">Customers with activity this month</p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5">
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-wider">Total Revenue</p>
                            <p class="text-3xl font-extrabold text-slate-900 mt-2"><%= currencyFormat.format(totalSpentSum)%> <span class="text-lg font-bold text-slate-400">VND</span></p>
                            <p class="text-xs text-slate-400 mt-1">Combined monthly spend</p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5">
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-wider">Total Washes</p>
                            <p class="text-3xl font-extrabold text-slate-900 mt-2"><%= totalWashesSum%></p>
                            <p class="text-xs text-slate-400 mt-1">Combined wash sessions</p>
                        </div>
                    </div>

                    <%-- Table --%>
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-slate-100 flex flex-col gap-3">
                            <div>
                                <h3 class="text-lg font-bold text-slate-900">Customer Breakdown</h3>
                                <p class="text-sm text-slate-400">Individual activity for <%= monthNames[selectedMonth]%> <%= selectedYear%></p>
                            </div>
                            <input type="text"
                                   id="statsSearch"
                                   placeholder="Search by customer ID..."
                                   onkeyup="filterStats()"
                                   class="w-full md:w-72 px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold">
                                            <button onclick="sortStats('customer-id')" type="button"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Customer ID <span id="sort-customer-id">↕</span>
                                            </button>
                                        </th>
                                        <th class="px-5 py-3 text-left font-bold">Period</th>
                                        <th class="px-5 py-3 text-right font-bold">
                                            <button onclick="sortStats('spent')" type="button"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Monthly Spent <span id="sort-spent">↕</span>
                                            </button>
                                        </th>
                                        <th class="px-5 py-3 text-center font-bold">
                                            <button onclick="sortStats('washes')" type="button"
                                                    class="inline-flex items-center gap-1 hover:text-indigo-600 transition-colors">
                                                Washes <span id="sort-washes">↕</span>
                                            </button>
                                        </th>
                                        <th class="px-5 py-3 text-left font-bold">Last Updated</th>
                                    </tr>
                                </thead>
                                <tbody id="statsTableBody" class="divide-y divide-slate-100">
                                    <% if (statsList == null || statsList.isEmpty()) {%>
                                    <tr>
                                        <td colspan="5" class="px-5 py-10 text-center text-slate-400">
                                            No activity recorded for <%= monthNames[selectedMonth]%> <%= selectedYear%>.
                                        </td>
                                    </tr>
                                    <% } else {
                                for (CustomerMonthlyStats s : statsList) {%>
                                    <tr class="stats-row hover:bg-slate-50 transition-colors"
                                        data-customer-id="<%= s.getCustomerId()%>"
                                        data-spent="<%= s.getMonthlySpent()%>"
                                        data-washes="<%= s.getMonthlyWashes()%>">

                                        <td class="px-5 py-4">
                                            <span class="font-extrabold text-slate-900">#<%= s.getCustomerId()%></span>
                                        </td>

                                        <td class="px-5 py-4 text-slate-600">
                                            <%= monthNames[s.getStatMonth()]%> <%= s.getStatYear()%>
                                        </td>

                                        <td class="px-5 py-4 text-right">
                                            <span class="font-bold text-slate-900">
                                                <%= currencyFormat.format(s.getMonthlySpent())%> VND
                                            </span>
                                        </td>

                                        <td class="px-5 py-4 text-center">
                                            <span class="inline-flex px-3 py-1 rounded-full bg-indigo-50 text-indigo-600 text-xs font-bold">
                                                <%= s.getMonthlyWashes()%> washes
                                            </span>
                                        </td>

                                        <td class="px-5 py-4 text-slate-400 text-xs">
                                            <%= s.getUpdatedAt() != null ? s.getUpdatedAt().toString() : "—"%>
                                        </td>
                                    </tr>
                                    <% }
                                }%>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <script>
            function filterStats() {
                const keyword = document.getElementById('statsSearch').value.toLowerCase();
                document.querySelectorAll('.stats-row').forEach(row => {
                    const customerId = row.getAttribute('data-customer-id');
                    row.style.display = customerId.includes(keyword) ? '' : 'none';
                });
            }

            let currentSortKey = '';
            let currentSortDir = 'asc';

            function sortStats(key) {
                const tbody = document.getElementById('statsTableBody');
                const rows = Array.from(tbody.querySelectorAll('.stats-row'));

                currentSortDir = (currentSortKey === key && currentSortDir === 'asc') ? 'desc' : 'asc';
                currentSortKey = key;

                rows.sort((a, b) => {
                    let valA, valB;
                    if (key === 'customer-id') {
                        valA = Number(a.getAttribute('data-customer-id'));
                        valB = Number(b.getAttribute('data-customer-id'));
                    } else if (key === 'spent') {
                        valA = Number(a.getAttribute('data-spent'));
                        valB = Number(b.getAttribute('data-spent'));
                    } else if (key === 'washes') {
                        valA = Number(a.getAttribute('data-washes'));
                        valB = Number(b.getAttribute('data-washes'));
                    }
                    return currentSortDir === 'asc' ? valA - valB : valB - valA;
                });

                rows.forEach(row => tbody.appendChild(row));
                updateSortIcons(key);
            }

            function updateSortIcons(activeKey) {
                ['customer-id', 'spent', 'washes'].forEach(key => {
                    const el = document.getElementById('sort-' + key);
                    if (!el)
                        return;
                    el.innerText = key === activeKey ? (currentSortDir === 'asc' ? '↑' : '↓') : '↕';
                });
            }
        </script>
    </body>
</html>