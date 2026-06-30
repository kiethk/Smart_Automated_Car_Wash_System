<jsp:include page="/components/header.jsp"/>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Customer" %>
<%@ page import="dto.Tiers" %>
<%@ page import="dto.LoyaltyPointHistory" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Customer customer = (Customer) request.getAttribute("customer");
    Tiers currentTier = (Tiers) request.getAttribute("currentTier");
    List<Tiers> allTiers = (List<Tiers>) request.getAttribute("allTiers");
    List<LoyaltyPointHistory> pointHistory = (List<LoyaltyPointHistory>) request.getAttribute("pointHistory");
    Integer totalEarned = (Integer) request.getAttribute("totalEarned");
    Integer totalUsed = (Integer) request.getAttribute("totalUsed");

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<style>
    .tier-card {
        transition: all 0.3s ease;
        border: 2px solid transparent;
    }
    .tier-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 24px rgba(0,0,0,0.1);
    }
    .tier-card.active {
        border-color: #1f108e;
        background: linear-gradient(135deg, #f0f4ff 0%, #ffffff 100%);
    }
    .tier-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }
    .tier-badge-member { background: #e5e7eb; color: #4b5563; }
    .tier-badge-silver { background: #e5e7eb; color: #6b7280; border: 1px solid #9ca3af; }
    .tier-badge-gold { background: #fef3c7; color: #92400e; border: 1px solid #f59e0b; }
    .tier-badge-platinum { background: #e0e7ff; color: #3730a3; border: 1px solid #6366f1; }
</style>

<main class="min-h-screen bg-slate-50 py-12 px-6">
    <div class="max-w-6xl mx-auto">

        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-slate-900">Loyalty Rewards Center</h1>
            <p class="text-sm text-slate-500 mt-1">Manage your rewards, track your benefits, and explore how to unlock the next level of automotive care.</p>
        </div>

        <!-- Error Message -->
        <%
            String error = (String) request.getAttribute("ERROR_MSG");
            if (error != null) {
        %>
        <div class="bg-red-50 border border-red-200 text-red-600 p-4 rounded-xl mb-6 text-sm font-medium">
            <%= error %>
        </div>
        <% } %>

        <!-- ======================================== -->
        <!-- MEMBERSHIP CARD -->
        <!-- ======================================== -->
        <div class="bg-gradient-to-r from-[#1f108e] to-[#4a3a8a] rounded-2xl p-8 text-white mb-8 shadow-xl">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                <div>
                    <p class="text-sm opacity-75 font-medium">MEMBERSHIP CARD</p>
                    <h2 class="text-2xl font-bold mt-1"><%= customer != null ? customer.getTierName() : "Member" %></h2>
                    <p class="text-sm opacity-75 
                       mt-1">
                        <%= customer != null && customer.getFullName() != null ? customer.getFullName() : "Customer" %>
                    </p>
                    <div class="flex items-center gap-4 mt-3">
                        <span class="text-sm opacity-75">Member since: <%= customer != null && customer.getJoinDate() != null ? dateFormat.format(customer.getJoinDate()) : "N/A" %></span>
                        <span class="text-sm opacity-75">•</span>
                        <span class="text-sm opacity-75">Points Multiplier: <strong class="text-white"><%= currentTier != null ? String.format("%.1f", currentTier.getPointMultiplier()) + "x" : "1x" %></strong></span>
                    </div>
                </div>
                <div class="mt-4 md:mt-0 text-right">
                    <p class="text-sm opacity-75 font-medium">CURRENT BALANCE</p>
                    <p class="text-4xl font-bold"><%= customer != null ? customer.getTotalPoints() : 0 %> <span class="text-lg font-medium opacity-75">Pts</span></p>
                    <p class="text-xs opacity-75 mt-1">
                        Lifetime Earned: <strong><%= totalEarned != null ? totalEarned : 0 %></strong> pts
                        • Used: <strong><%= totalUsed != null ? totalUsed : 0 %></strong> pts
                    </p>
                </div>
            </div>

            <!-- Progress to next tier -->
            <%
                if (allTiers != null && currentTier != null) {
                    int currentIndex = -1;
                    for (int i = 0; i < allTiers.size(); i++) {
                        if (allTiers.get(i).getTierId() == currentTier.getTierId()) {
                            currentIndex = i;
                            break;
                        }
                    }
                    if (currentIndex >= 0 && currentIndex < allTiers.size() - 1) {
                        Tiers nextTier = allTiers.get(currentIndex + 1);
                        int totalWashes = customer != null ? customer.getTotalWashes() : 0;
                        long totalSpent = customer != null ? customer.getTotalSpent() : 0;
                        int washProgress = Math.min(100, (int) ((double) totalWashes / nextTier.getMinWashes() * 100));
                        int spentProgress = Math.min(100, (int) ((double) totalSpent / nextTier.getMinSpent() * 100));
            %>
            <div class="mt-6 pt-6 border-t border-white/20">
                <p class="text-sm font-medium">Next Tier: <strong><%= nextTier.getTierName() %></strong></p>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-3">
                    <div>
                        <div class="flex justify-between text-xs opacity-75 mb-1">
                            <span>Washes: <%= totalWashes %> / <%= nextTier.getMinWashes() %></span>
                            <span><%= washProgress %>%</span>
                        </div>
                        <div class="w-full h-2 bg-white/20 rounded-full overflow-hidden">
                            <div class="h-full bg-white rounded-full" style="width: <%= washProgress %>%"></div>
                        </div>
                    </div>
                    <div>
                        <div class="flex justify-between text-xs opacity-75 mb-1">
                            <span>Spent: <%= String.format("%,d", totalSpent) %> / <%= String.format("%,d", nextTier.getMinSpent()) %> VND</span>
                            <span><%= spentProgress %>%</span>
                        </div>
                        <div class="w-full h-2 bg-white/20 rounded-full overflow-hidden">
                            <div class="h-full bg-white rounded-full" style="width: <%= spentProgress %>%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    } else {
            %>
            <div class="mt-6 pt-6 border-t border-white/20">
                <p class="text-sm font-medium text-emerald-300">🎉 Elite Tier Reached! You have unlocked maximum privileges.</p>
            </div>
            <%
                    }
                }
            %>
        </div>

        <!-- ======================================== -->
        <!-- TIER BENEFITS MATRIX -->
        <!-- ======================================== -->
        <div class="mb-8">
            <h2 class="text-xl font-bold text-slate-900 mb-4">Tier Benefits Matrix</h2>
            <p class="text-sm text-slate-500 mb-4">Compare your current benefits and see what's next.</p>

            <div class="overflow-x-auto">
                <table class="w-full bg-white rounded-xl border border-slate-200">
                    <thead>
                        <tr class="bg-slate-50">
                            <th class="text-left py-3 px-4 text-sm font-semibold text-slate-600 border-b">Benefits</th>
                            <%
                                if (allTiers != null) {
                                    for (Tiers tier : allTiers) {
                                        boolean isActive = currentTier != null && tier.getTierId() == currentTier.getTierId();
                            %>
                            <th class="text-center py-3 px-4 text-sm font-semibold border-b <%= isActive ? "text-[#1f108e]" : "text-slate-600" %>">
                                <%= tier.getTierName() %>
                                <% if (isActive) { %>
                                <span class="block text-[10px] text-[#1f108e] font-normal">(Current)</span>
                                <% } %>
                            </th>
                            <%
                                    }
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="py-3 px-4 text-sm text-slate-600 border-b font-medium">Minimum Requirements</td>
                            <%
                                if (allTiers != null) {
                                    for (Tiers tier : allTiers) {
                            %>
                            <td class="text-center py-3 px-4 text-sm text-slate-500 border-b">
                                <%= tier.getMinWashes() == 0 ? "Sign Up" : tier.getMinWashes() + " Washes/mo" %>
                            </td>
                            <%
                                    }
                                }
                            %>
                        </tr>
                        <tr>
                            <td class="py-3 px-4 text-sm text-slate-600 border-b font-medium">Points Multiplier</td>
                            <%
                                if (allTiers != null) {
                                    for (Tiers tier : allTiers) {
                            %>
                            <td class="text-center py-3 px-4 text-sm text-slate-500 border-b"><%= String.format("%.1f", tier.getPointMultiplier()) %>x</td>
                            <%
                                    }
                                }
                            %>
                        </tr>
                        <tr>
                            <td class="py-3 px-4 text-sm text-slate-600 border-b font-medium">Booking Window</td>
                            <%
                                if (allTiers != null) {
                                    for (Tiers tier : allTiers) {
                            %>
                            <td class="text-center py-3 px-4 text-sm text-slate-500 border-b"><%= tier.getBookingWindowDays() %> days</td>
                            <%
                                    }
                                }
                            %>
                        </tr>
                        <tr>
                            <td class="py-3 px-4 text-sm text-slate-600 border-b font-medium">Discount</td>
                            <%
                                if (allTiers != null) {
                                    for (Tiers tier : allTiers) {
                            %>
                            <td class="text-center py-3 px-4 text-sm text-slate-500 border-b"><%= String.format("%.0f", tier.getDiscountPercent()) %>%</td>
                            <%
                                    }
                                }
                            %>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ======================================== -->
        <!-- POINTS LEDGER -->
        <!-- ======================================== -->
        <div class="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <div class="p-6 border-b border-slate-200">
                <div class="flex items-center justify-between">
                    <div>
                        <h2 class="text-xl font-bold text-slate-900">Points Ledger</h2>
                        <p class="text-sm text-slate-500">Recent activity and point transactions.</p>
                    </div>
                    <span class="text-sm text-slate-500">Total: <%= pointHistory != null ? pointHistory.size() : 0 %> transactions</span>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead>
                        <tr class="bg-slate-50">
                            <th class="text-left py-3 px-6 text-xs font-semibold text-slate-500 uppercase">Date</th>
                            <th class="text-left py-3 px-6 text-xs font-semibold text-slate-500 uppercase">Action</th>
                            <th class="text-left py-3 px-6 text-xs font-semibold text-slate-500 uppercase">Description</th>
                            <th class="text-right py-3 px-6 text-xs font-semibold text-slate-500 uppercase">Points Delta</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (pointHistory != null && !pointHistory.isEmpty()) {
                                for (LoyaltyPointHistory record : pointHistory) {
                                    String deltaClass = "";
                                    String deltaText = "";
                                    if (record.getPointsEarned() > 0) {
                                        deltaClass = "text-emerald-600";
                                        deltaText = "+" + record.getPointsEarned() + " Pts";
                                    } else if (record.getPointsUsed() > 0) {
                                        deltaClass = "text-red-500";
                                        deltaText = "-" + record.getPointsUsed() + " Pts";
                                    } else {
                                        deltaClass = "text-slate-400";
                                        deltaText = "0 Pts";
                                    }
                        %>
                        <tr class="border-b border-slate-100 hover:bg-slate-50 transition">
                            <td class="py-3 px-6 text-sm text-slate-600"><%= record.getCreatedAt() != null ? dateFormat.format(record.getCreatedAt()) : "N/A" %></td>
                            <td class="py-3 px-6 text-sm">
                                <span class="text-xs font-medium px-2 py-1 rounded-full 
                                    <%= record.getPointsEarned() > 0 ? "bg-emerald-100 text-emerald-700" : "bg-red-100 text-red-700" %>">
                                    <%= record.getPointsEarned() > 0 ? "Earned" : "Used" %>
                                </span>
                            </td>
                            <td class="py-3 px-6 text-sm text-slate-600"><%= record.getDescription() != null ? record.getDescription() : "N/A" %></td>
                            <td class="py-3 px-6 text-sm font-medium text-right <%= deltaClass %>"><%= deltaText %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="4" class="py-8 text-center text-sm text-slate-400">No transaction history yet.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<script>
    lucide.createIcons();
</script>

<jsp:include page="/components/footer.jsp"/>