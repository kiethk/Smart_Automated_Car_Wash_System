<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.AdminCustomerView"%>
<%@page import="dto.Tiers"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<AdminCustomerView> customers = (List<AdminCustomerView>) request.getAttribute("CUSTOMERS");
    List<Tiers> tiers = (List<Tiers>) request.getAttribute("TIERS");
    AdminCustomerView editCustomer = (AdminCustomerView) request.getAttribute("EDIT_CUSTOMER");

    boolean isEditMode = editCustomer != null;

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
                    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                        <div>
                            <h2 class="text-2xl font-extrabold text-slate-900">
                                Customer Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                View customers, wallet balance, loyalty points and account status.
                            </p>
                        </div>

                        <div class="flex items-center gap-3">
                            <div class="px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-sm font-bold text-slate-700">
                                Total: <%= customers != null ? customers.size() : 0%> customers
                            </div>
                        </div>
                    </div>

                    <% if ("status_updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Customer account status updated successfully.
                    </div>
                    <% } else if ("updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Customer information updated successfully.
                    </div>
                    <% } %>

                    <% if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Something went wrong. Please try again.
                    </div>
                    <% }%>


                    <%-- FORM --%>
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden mb-6">
                        <button type="button"
                                onclick="toggleCustomerEditForm()"
                                class="w-full px-5 py-4 flex items-center justify-between hover:bg-slate-50 transition-all">

                            <div class="text-left">
                                <h3 class="text-lg font-bold text-slate-900">
                                    <%= isEditMode ? "Edit Customer Metrics" : "Customer Metrics Editor"%>
                                </h3>
                                <p class="text-sm text-slate-400 mt-1">
                                    <%= isEditMode
                                            ? "Editing: " + (editCustomer.getFullName() != null ? editCustomer.getFullName() : "Unnamed Customer")
                                            : "Select a customer from the table to edit tier, spending, washes, points and wallet balance."%>
                                </p>
                            </div>

                            <div class="flex items-center gap-3">
                                <% if (isEditMode) { %>
                                <a href="${pageContext.request.contextPath}/admin/customers"
                                   onclick="event.stopPropagation();"
                                   class="hidden sm:inline-flex px-4 py-2 rounded-xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                    Cancel Edit
                                </a>
                                <% }%>

                                <span id="customerEditFormArrow"
                                      class="w-9 h-9 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-extrabold transition-transform duration-200 <%= isEditMode ? "rotate-180" : ""%>">
                                    ↓
                                </span>
                            </div>
                        </button>

                        <div id="customerEditFormBody"
                             class="<%= isEditMode ? "" : "hidden"%> border-t border-slate-100 p-5">

                            <% if (!isEditMode) { %>
                            <div class="rounded-2xl border border-slate-200 bg-slate-50 px-5 py-4 text-sm text-slate-500">
                                Click <strong>Edit</strong> on a customer row to update operational values.
                            </div>
                            <% } else {%>

                            <form action="${pageContext.request.contextPath}/admin/customers"
                                  method="post"
                                  class="space-y-5">

                                <input type="hidden" name="action" value="updateAdminFields">
                                <input type="hidden" name="customerId" value="<%= editCustomer.getCustomerId()%>">

                                <div class="flex items-center gap-4 rounded-2xl bg-slate-50 border border-slate-200 p-4">
                                    <div class="w-14 h-14 rounded-full overflow-hidden bg-indigo-50 border border-indigo-100 shrink-0">
                                        <img src="<%= editCustomer.getAvatarUrl() != null && !editCustomer.getAvatarUrl().trim().isEmpty() ? editCustomer.getAvatarUrl() : request.getContextPath() + "/assets/images/avatar-placeholder.jpg"%>"
                                             alt="Avatar"
                                             class="w-full h-full object-cover">
                                    </div>

                                    <div>
                                        <p class="font-extrabold text-slate-900">
                                            <%= editCustomer.getFullName() != null ? editCustomer.getFullName() : "Unnamed Customer"%>
                                        </p>
                                        <p class="text-sm text-slate-500 mt-1">
                                            <%= editCustomer.getEmail() != null ? editCustomer.getEmail() : "No email"%>
                                        </p>
                                    </div>
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-4">
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Tier
                                        </label>
                                        <select name="tierId"
                                                required
                                                class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                            <% if (tiers != null) { %>
                                            <% for (Tiers t : tiers) {%>
                                            <option value="<%= t.getTierId()%>"
                                                    <%= editCustomer.getTierId() == t.getTierId() ? "selected" : ""%>>
                                                <%= t.getTierName()%>
                                            </option>
                                            <% } %>
                                            <% }%>
                                        </select>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Total Spent
                                        </label>
                                        <input type="number"
                                               name="totalSpent"
                                               value="<%= editCustomer.getTotalSpent()%>"
                                               min="0"
                                               required
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Total Washes
                                        </label>
                                        <input type="number"
                                               name="totalWashes"
                                               value="<%= editCustomer.getTotalWashes()%>"
                                               min="0"
                                               required
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Loyalty Points
                                        </label>
                                        <input type="number"
                                               name="totalPoints"
                                               value="<%= editCustomer.getTotalPoints()%>"
                                               min="0"
                                               required
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Wallet Balance
                                        </label>
                                        <input type="number"
                                               name="walletBalance"
                                               value="<%= editCustomer.getWalletBalance()%>"
                                               min="0"
                                               required
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>
                                </div>

                                <div class="flex flex-col sm:flex-row gap-3 justify-end">
                                    <a href="${pageContext.request.contextPath}/admin/customers"
                                       class="inline-flex items-center justify-center px-5 py-3 rounded-2xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                        Cancel
                                    </a>

                                    <button type="submit"
                                            class="inline-flex items-center justify-center px-5 py-3 rounded-2xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                        Save Changes
                                    </button>
                                </div>
                            </form>

                            <% } %>
                        </div>
                    </section>


                    <%-- TABLE --%>
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-slate-100 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-3">
                            <div>
                                <h3 class="text-lg font-bold text-slate-900">
                                    Customer List
                                </h3>
                                <p class="text-sm text-slate-400">
                                    Search and manage customer accounts.
                                </p>
                            </div>

                            <div class="flex flex-col sm:flex-row gap-3 w-full lg:w-auto">
                                <input type="text"
                                       id="customerSearch"
                                       placeholder="Search name, email, phone..."
                                       onkeyup="filterCustomers()"
                                       class="w-full lg:w-80 px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">

                                <select id="statusFilter"
                                        onchange="filterCustomers()"
                                        class="w-full sm:w-44 px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <option value="all">All Status</option>
                                    <option value="active">Active</option>
                                    <option value="disabled">Disabled</option>
                                </select>
                            </div>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold">Customer</th>
                                        <th class="px-5 py-3 text-center font-bold">Tier</th>
                                        <th class="px-5 py-3 text-right font-bold">Total Spent</th>
                                        <th class="px-5 py-3 text-center font-bold">Washes</th>
                                        <th class="px-5 py-3 text-center font-bold">Points</th>
                                        <th class="px-5 py-3 text-right font-bold">Wallet</th>
                                        <th class="px-5 py-3 text-center font-bold">Status</th>
                                        <th class="px-5 py-3 text-right font-bold">Actions</th>
                                    </tr>
                                </thead>

                                <tbody class="divide-y divide-slate-100">
                                    <% if (customers == null || customers.isEmpty()) { %>
                                    <tr>
                                        <td colspan="8" class="px-5 py-10 text-center text-slate-400">
                                            No customers found.
                                        </td>
                                    </tr>
                                    <% } else { %>

                                    <% for (AdminCustomerView c : customers) {
                                            String statusText = c.getIsActive() == 1 ? "active" : "disabled";
                                    %>

                                    <tr class="customer-row hover:bg-slate-50 transition-colors"
                                        data-status="<%= statusText%>">
                                        <td class="px-5 py-4 min-w-[280px]">
                                            <div class="flex items-center gap-3">
                                                <div class="w-11 h-11 rounded-full overflow-hidden bg-indigo-50 border border-indigo-100 shrink-0">
                                                    <img src="<%= c.getAvatarUrl() != null && !c.getAvatarUrl().trim().isEmpty() ? c.getAvatarUrl() : request.getContextPath() + "/assets/images/avatar-placeholder.jpg"%>"
                                                         alt="Avatar"
                                                         class="w-full h-full object-cover">
                                                </div>

                                                <div>
                                                    <p class="customer-name font-extrabold text-slate-900">
                                                        <%= c.getFullName() != null ? c.getFullName() : "Unnamed Customer"%>
                                                    </p>
                                                    <p class="customer-email text-xs text-slate-500 mt-1">
                                                        <%= c.getEmail() != null ? c.getEmail() : "No email"%>
                                                    </p>
                                                    <p class="customer-phone text-xs text-slate-400 mt-1">
                                                        <%= c.getPhone() != null ? c.getPhone() : "No phone"%>
                                                    </p>
                                                </div>
                                            </div>
                                        </td>

                                        <td class="px-5 py-4 text-center">
                                            <span class="inline-flex px-3 py-1 rounded-full bg-indigo-50 text-indigo-600 text-xs font-bold">
                                                <%= c.getTierName() != null ? c.getTierName() : "No Tier"%>
                                            </span>
                                        </td>

                                        <td class="px-5 py-4 text-right font-bold text-slate-800">
                                            <%= currencyFormat.format(c.getTotalSpent())%> VND
                                        </td>

                                        <td class="px-5 py-4 text-center font-semibold text-slate-700">
                                            <%= c.getTotalWashes()%>
                                        </td>

                                        <td class="px-5 py-4 text-center font-semibold text-slate-700">
                                            <%= c.getTotalPoints()%>
                                        </td>

                                        <td class="px-5 py-4 text-right font-bold text-emerald-600">
                                            <%= currencyFormat.format(c.getWalletBalance())%> VND
                                        </td>

                                        <td class="px-5 py-4 text-center">
                                            <% if (c.getIsActive() == 1) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                Active
                                            </span>
                                            <% } else { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-red-50 text-red-500 text-xs font-bold">
                                                Disabled
                                            </span>
                                            <% }%>
                                        </td>

                                        <td class="px-5 py-4">
                                            <div class="flex items-center justify-end gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/customers?editCustomerId=<%= c.getCustomerId()%>"
                                                   class="px-3 py-2 rounded-xl bg-indigo-50 text-indigo-600 text-xs font-bold hover:bg-indigo-100 transition-all">
                                                    Edit
                                                </a>
                                                <form action="${pageContext.request.contextPath}/admin/customers"
                                                      method="post"
                                                      onsubmit="return confirm('Are you sure you want to change this customer account status?');">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="userId" value="<%= c.getUserId()%>">
                                                    <input type="hidden" name="isActive" value="<%= c.getIsActive() == 1 ? 0 : 1%>">

                                                    <button type="submit"
                                                            class="px-3 py-2 rounded-xl <%= c.getIsActive() == 1 ? "bg-red-50 text-red-500 hover:bg-red-100" : "bg-emerald-50 text-emerald-600 hover:bg-emerald-100"%> text-xs font-bold transition-all">
                                                        <%= c.getIsActive() == 1 ? "Disable" : "Enable"%>
                                                    </button>
                                                </form>
                                            </div>
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

        <script>
            function toggleCustomerEditForm() {
                const body = document.getElementById("customerEditFormBody");
                const arrow = document.getElementById("customerEditFormArrow");

                if (!body || !arrow) {
                    return;
                }

                body.classList.toggle("hidden");
                arrow.classList.toggle("rotate-180");
            }

            function filterCustomers() {
                const keyword = document.getElementById("customerSearch").value.toLowerCase();
                const statusFilter = document.getElementById("statusFilter").value;
                const rows = document.querySelectorAll(".customer-row");

                rows.forEach(row => {
                    const name = row.querySelector(".customer-name").innerText.toLowerCase();
                    const email = row.querySelector(".customer-email").innerText.toLowerCase();
                    const phone = row.querySelector(".customer-phone").innerText.toLowerCase();
                    const status = row.getAttribute("data-status");

                    const matchesKeyword =
                            name.includes(keyword)
                            || email.includes(keyword)
                            || phone.includes(keyword);

                    const matchesStatus =
                            statusFilter === "all"
                            || statusFilter === status;

                    row.style.display = matchesKeyword && matchesStatus ? "" : "none";
                });
            }
        </script>
    </body>
</html>