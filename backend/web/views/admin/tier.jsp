<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.Tiers"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Tiers> tierList = (List<Tiers>) request.getAttribute("TIER_LIST");
    List<Integer> customerCounts = (List<Integer>) request.getAttribute("CUSTOMER_COUNTS");
    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
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
                    <h2 class="text-2xl font-extrabold text-slate-900">Tier Management</h2>
                    <p class="text-sm text-slate-500 mt-1">
                        Configure membership tier thresholds, discounts, and loyalty rules.
                    </p>
                </div>
                <div class="px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-sm font-bold text-slate-700">
                    <%= tierList != null ? tierList.size() : 0 %> tiers configured
                </div>
            </div>

            <%-- Toast messages --%>
            <% if (msg != null) { %>
            <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                Tier updated successfully.
            </div>
            <% } %>
            <% if (error != null) { %>
            <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                Action failed: <%= error %>
            </div>
            <% } %>

            <%-- Tier Cards --%>
            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5 mb-8">
                <%
                    String[] tierColors = {
                        "border-slate-300 bg-slate-50",    // Member
                        "border-slate-400 bg-slate-100",   // Silver
                        "border-yellow-400 bg-yellow-50",  // Gold
                        "border-purple-400 bg-purple-50"   // Platinum
                    };
                    String[] tierBadgeColors = {
                        "bg-slate-200 text-slate-700",
                        "bg-slate-300 text-slate-800",
                        "bg-yellow-200 text-yellow-800",
                        "bg-purple-200 text-purple-800"
                    };

                    if (tierList != null) {
                        for (int i = 0; i < tierList.size(); i++) {
                            Tiers t = tierList.get(i);
                            int count = (customerCounts != null && i < customerCounts.size()) ? customerCounts.get(i) : 0;
                            String cardColor = i < tierColors.length ? tierColors[i] : "border-slate-200 bg-white";
                            String badgeColor = i < tierBadgeColors.length ? tierBadgeColors[i] : "bg-slate-100 text-slate-600";
                %>
                <div class="bg-white rounded-2xl border-2 <%= cardColor %> shadow-sm p-5 flex flex-col gap-3">
                    <div class="flex items-center justify-between">
                        <span class="px-3 py-1 rounded-full text-xs font-bold <%= badgeColor %>">
                            <%= t.getTierName() %>
                        </span>
                        <span class="text-xs text-slate-400 font-medium"><%= count %> customers</span>
                    </div>
                    <div class="space-y-1 text-xs text-slate-500">
                        <p>Min spent: <strong class="text-slate-800"><%= currencyFormat.format(t.getMinSpent()) %> VND</strong></p>
                        <p>Min washes: <strong class="text-slate-800"><%= t.getMinWashes() %></strong></p>
                        <p>Discount: <strong class="text-slate-800"><%= (int) t.getDiscountPercent() %>%</strong></p>
                        <p>Points x<strong class="text-slate-800"><%= t.getPointMultiplier() %></strong></p>
                        <p>Book window: <strong class="text-slate-800"><%= t.getBookingWindowDays() %> days</strong></p>
                    </div>
                    <button type="button"
                            onclick="openEditModal(<%= t.getTierId() %>, '<%= t.getTierName() %>', <%= t.getMinWashes() %>, <%= t.getMinSpent() %>, <%= t.getPointMultiplier() %>, <%= t.getDiscountPercent() %>, <%= t.getBookingWindowDays() %>, '<%= t.getDescription() != null ? t.getDescription().replace("'", "\\'") : "" %>')"
                            class="mt-auto w-full py-2 rounded-xl bg-indigo-50 text-indigo-700 text-xs font-bold hover:bg-indigo-100 transition-all">
                        Edit
                    </button>
                </div>
                <% } } %>
            </div>

            <%-- Table --%>
            <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="px-5 py-4 border-b border-slate-100">
                    <h3 class="text-lg font-bold text-slate-900">Tier Configuration Table</h3>
                    <p class="text-sm text-slate-400">Full overview of all tier parameters.</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead class="bg-slate-50 text-slate-500">
                            <tr>
                                <th class="px-5 py-3 text-left font-bold">Tier</th>
                                <th class="px-5 py-3 text-right font-bold">Min Spent</th>
                                <th class="px-5 py-3 text-center font-bold">Min Washes</th>
                                <th class="px-5 py-3 text-center font-bold">Discount</th>
                                <th class="px-5 py-3 text-center font-bold">Point Multiplier</th>
                                <th class="px-5 py-3 text-center font-bold">Book Window</th>
                                <th class="px-5 py-3 text-center font-bold">Customers</th>
                               
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <% if (tierList == null || tierList.isEmpty()) { %>
                            <tr>
                                <td colspan="8" class="px-5 py-10 text-center text-slate-400">No tiers found.</td>
                            </tr>
                            <% } else {
                                for (int i = 0; i < tierList.size(); i++) {
                                    Tiers t = tierList.get(i);
                                    int count = (customerCounts != null && i < customerCounts.size()) ? customerCounts.get(i) : 0;
                            %>
                            <tr class="hover:bg-slate-50 transition-colors">
                                <td class="px-5 py-4">
                                    <span class="font-extrabold text-slate-900"><%= t.getTierName() %></span>
                                    <p class="text-xs text-slate-400 mt-0.5"><%= t.getDescription() != null ? t.getDescription() : "" %></p>
                                </td>
                                <td class="px-5 py-4 text-right font-bold text-slate-900">
                                    <%= currencyFormat.format(t.getMinSpent()) %> VND
                                </td>
                                <td class="px-5 py-4 text-center text-slate-700">
                                    <%= t.getMinWashes() %>
                                </td>
                                <td class="px-5 py-4 text-center">
                                    <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                        <%= (int) t.getDiscountPercent() %>%
                                    </span>
                                </td>
                                <td class="px-5 py-4 text-center text-slate-700">
                                    x<%= t.getPointMultiplier() %>
                                </td>
                                <td class="px-5 py-4 text-center text-slate-700">
                                    <%= t.getBookingWindowDays() %> days
                                </td>
                                <td class="px-5 py-4 text-center">
                                    <span class="inline-flex px-3 py-1 rounded-full bg-indigo-50 text-indigo-600 text-xs font-bold">
                                        <%= count %>
                                    </span>
                                </td>
                                
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</div>

<%-- Edit Modal --%>
<div id="editTierModal"
     class="hidden fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4"
     onclick="closeEditModal(event)">
    <div class="w-full max-w-lg bg-white rounded-2xl shadow-2xl overflow-hidden"
         onclick="event.stopPropagation()">

        <div class="flex items-start justify-between gap-4 border-b border-slate-200 px-6 py-5">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-400">Edit Tier</p>
                <h3 class="mt-1 text-xl font-extrabold text-slate-900" id="modalTierName"></h3>
            </div>
            <button type="button"
                    onclick="closeEditModal()"
                    class="h-10 w-10 flex items-center justify-center rounded-xl bg-slate-100 text-slate-500 hover:bg-slate-200 transition-colors">
                ×
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/tiers" method="post" class="p-6 space-y-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="tierId" id="editTierId">

            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Min Washes</label>
                    <input type="number" name="minWashes" id="editMinWashes" min="0"
                           class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Min Spent (VND)</label>
                    <input type="number" name="minSpent" id="editMinSpent" min="0"
                           class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Discount (%)</label>
                    <input type="number" name="discountPercent" id="editDiscountPercent" min="0" max="100" step="0.01"
                           class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Point Multiplier</label>
                    <input type="number" name="pointMultiplier" id="editPointMultiplier" min="0" step="0.01"
                           class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                </div>
                <div class="col-span-2">
                    <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Booking Window (days)</label>
                    <input type="number" name="bookingWindowDays" id="editBookingWindowDays" min="1"
                           class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                </div>
                <div class="col-span-2">
                    <label class="block text-xs font-bold text-slate-500 mb-1.5 uppercase tracking-wider">Description</label>
                    <textarea name="description" id="editDescription" rows="2"
                              class="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50 resize-none"></textarea>
                </div>
            </div>

            <div class="flex gap-3 pt-2">
                <button type="button"
                        onclick="closeEditModal()"
                        class="flex-1 py-2.5 rounded-xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                    Cancel
                </button>
                <button type="submit"
                        class="flex-1 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(tierId, tierName, minWashes, minSpent, pointMultiplier, discountPercent, bookingWindowDays, description) {
        document.getElementById('editTierId').value = tierId;
        document.getElementById('modalTierName').innerText = tierName;
        document.getElementById('editMinWashes').value = minWashes;
        document.getElementById('editMinSpent').value = minSpent;
        document.getElementById('editPointMultiplier').value = pointMultiplier;
        document.getElementById('editDiscountPercent').value = discountPercent;
        document.getElementById('editBookingWindowDays').value = bookingWindowDays;
        document.getElementById('editDescription').value = description;
        document.getElementById('editTierModal').classList.remove('hidden');
    }

    function closeEditModal(event) {
        if (event && event.target !== event.currentTarget) return;
        document.getElementById('editTierModal').classList.add('hidden');
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeEditModal();
    });
</script>
</body>
</html>