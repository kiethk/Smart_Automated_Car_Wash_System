<%@page import="dto.Customer"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    Integer totalEarned = (Integer) request.getAttribute("totalEarned");
    Integer totalRedeemed = (Integer) request.getAttribute("totalRedeemed");
    Integer totalExpired = (Integer) request.getAttribute("totalExpired");
    Integer totalCustomers = (Integer) request.getAttribute("totalCustomers");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="/components/admin/adminHead.jsp" />
        <style>
            /* Modal overlay */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(4px);
                z-index: 9999;
                justify-content: center;
                align-items: center;
            }
            .modal-overlay.active {
                display: flex;
            }
            .modal-content {
                background: white;
                border-radius: 20px;
                max-width: 800px;
                width: 90%;
                max-height: 85vh;
                overflow-y: auto;
                padding: 30px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                animation: modalFadeIn 0.3s ease;
                position: relative;
            }
            @keyframes modalFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-30px) scale(0.95);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }
            .modal-close {
                position: absolute;
                top: 15px;
                right: 20px;
                font-size: 28px;
                color: #94a3b8;
                cursor: pointer;
                transition: color 0.2s;
                background: none;
                border: none;
                line-height: 1;
            }
            .modal-close:hover {
                color: #ef4444;
            }
            .modal-title {
                font-size: 22px;
                font-weight: 800;
                color: #0f172a;
                margin-bottom: 20px;
                padding-right: 40px;
            }
            .modal-divider {
                border: none;
                border-top: 2px solid #f1f5f9;
                margin: 16px 0;
            }
            .detail-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 12px 24px;
            }
            .detail-item {
                display: flex;
                flex-direction: column;
            }
            .detail-label {
                font-size: 11px;
                font-weight: 700;
                color: #94a3b8;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .detail-value {
                font-size: 15px;
                font-weight: 600;
                color: #0f172a;
                margin-top: 2px;
            }
            .detail-value.tier-badge {
                display: inline-block;
                padding: 2px 12px;
                border-radius: 20px;
                font-size: 13px;
            }
            .detail-value.tier-Platinum {
                background: #ede9fe;
                color: #7c3aed;
            }
            .detail-value.tier-Gold {
                background: #fef3c7;
                color: #d97706;
            }
            .detail-value.tier-Silver {
                background: #f1f5f9;
                color: #64748b;
            }
            .detail-value.tier-Member {
                background: #dbeafe;
                color: #2563eb;
            }
            .status-active {
                color: #16a34a;
                font-weight: 700;
            }
            .status-inactive {
                color: #dc2626;
                font-weight: 700;
            }
            .history-list {
                max-height: 180px;
                overflow-y: auto;
                background: #f8fafc;
                border-radius: 12px;
                padding: 10px 14px;
                margin-top: 4px;
            }
            .history-item {
                font-size: 13px;
                padding: 4px 0;
                border-bottom: 1px solid #e2e8f0;
            }
            .history-item:last-child {
                border-bottom: none;
            }
            .history-item.earn {
                color: #16a34a;
            }
            .history-item.redeem {
                color: #dc2626;
            }
            .history-item.expired {
                color: #ea580c;
            }
            .modal-footer {
                margin-top: 20px;
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                border-top: 2px solid #f1f5f9;
                padding-top: 16px;
            }
            .btn-close-modal {
                padding: 10px 28px;
                background: #e2e8f0;
                color: #475569;
                border: none;
                border-radius: 12px;
                font-weight: 700;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .btn-close-modal:hover {
                background: #cbd5e1;
            }
            @media (max-width: 640px) {
                .detail-grid {
                    grid-template-columns: 1fr;
                    gap: 8px;
                }
                .modal-content {
                    padding: 20px;
                    width: 95%;
                }
            }
        </style>
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
                                Loyalty Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                View all customer loyalty transactions (Earn, Redeem, Expired)
                            </p>
                        </div>

                        <div class="flex items-center gap-3">
                            <div class="px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-sm font-bold text-slate-700">
                                Total: <%= customers != null ? customers.size() : 0%> customers
                            </div>
                        </div>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Total Earned</p>
                            <p class="text-2xl font-extrabold text-emerald-600 mt-2">+<%= totalEarned != null ? totalEarned : 0%></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Total Redeemed</p>
                            <p class="text-2xl font-extrabold text-red-500 mt-2">-<%= totalRedeemed != null ? totalRedeemed : 0%></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Total Expired</p>
                            <p class="text-2xl font-extrabold text-orange-500 mt-2">-<%= totalExpired != null ? totalExpired : 0%></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Active Customers</p>
                            <p class="text-2xl font-extrabold text-slate-900 mt-2"><%= totalCustomers != null ? totalCustomers : 0%></p>
                        </div>
                    </div>

                    <!-- Search and Filter -->
                    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-4 mb-6">
                        <div class="flex flex-wrap gap-4">
                            <div class="flex-1 min-w-[200px]">
                                <input type="text"
                                       id="loyaltySearch"
                                       placeholder="Search customer name, email..."
                                       onkeyup="filterLoyalty()"
                                       class="w-full px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                            </div>
                            <div>
                                <select id="typeFilter" onchange="filterLoyalty()" class="px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <option value="all">All Types</option>
                                    <option value="earn">Earn</option>
                                    <option value="redeem">Redeem</option>
                                    <option value="expired">Expired</option>
                                </select>
                            </div>
                            <button onclick="clearFilters()" class="px-4 py-2.5 rounded-2xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                Clear Filters
                            </button>
                        </div>
                    </div>

                    <!-- Loyalty Table -->
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                            <div>
                                <h3 class="text-lg font-bold text-slate-900">
                                    Loyalty History List
                                </h3>
                                <p class="text-sm text-slate-400">
                                    View all customer loyalty transactions
                                </p>
                            </div>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold">Customer</th>
                                        <th class="px-5 py-3 text-left font-bold">Earn History</th>
                                        <th class="px-5 py-3 text-left font-bold">Redeem History</th>
                                        <th class="px-5 py-3 text-left font-bold">Expired History</th>
                                        <th class="px-5 py-3 text-center font-bold">Current Points</th>
                                        <th class="px-5 py-3 text-center font-bold">Actions</th>
                                    </tr>
                                </thead>

                                <tbody id="loyaltyTableBody" class="divide-y divide-slate-100">
                                    <c:forEach items="${customers}" var="customer">
                                        <tr class="loyalty-row hover:bg-slate-50 transition-colors"
                                            data-name="${customer.fullName != null ? customer.fullName.toLowerCase() : ''}"
                                            data-email="${customer.email != null ? customer.email.toLowerCase() : ''}"
                                            data-customerid="${customer.customerId}">

                                            <td class="px-5 py-4 min-w-[220px]">
                                                <div class="flex items-center gap-3">
                                                    <c:choose>
                                                        <c:when test="${not empty customer.avatarUrl}">
                                                            <img src="${customer.avatarUrl}" class="w-11 h-11 rounded-full">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/assets/images/avatar-placeholder.jpg" class="w-11 h-11 rounded-full">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <p class="customer-name font-bold text-slate-900">${customer.fullName}</p>
                                                        <p class="customer-email text-xs text-slate-400">${customer.email}</p>
                                                    </div>
                                                </div>
                                            </td>

                                            <td class="px-5 py-4">
                                                <div class="earn-history max-h-20 overflow-y-auto">
                                                    <c:set var="earnList" value="${earnHistoryMap[customer.customerId]}" />
                                                    <c:choose>
                                                        <c:when test="${not empty earnList}">
                                                            <c:forEach items="${earnList}" var="h" varStatus="status">
                                                                <c:if test="${status.index < 3}">
                                                                    <div class="text-xs text-emerald-600">
                                                                        +${h.pointsEarned} - ${h.description}
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                            <c:if test="${earnList.size() > 3}">
                                                                <div class="text-xs text-slate-400">+${earnList.size() - 3} more...</div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-xs text-slate-400">No earn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <td class="px-5 py-4">
                                                <div class="redeem-history max-h-20 overflow-y-auto">
                                                    <c:set var="redeemList" value="${redeemHistoryMap[customer.customerId]}" />
                                                    <c:choose>
                                                        <c:when test="${not empty redeemList}">
                                                            <c:forEach items="${redeemList}" var="h" varStatus="status">
                                                                <c:if test="${status.index < 3}">
                                                                    <div class="text-xs text-red-500">
                                                                        -${h.pointsUsed} - ${h.description}
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                            <c:if test="${redeemList.size() > 3}">
                                                                <div class="text-xs text-slate-400">+${redeemList.size() - 3} more...</div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-xs text-slate-400">No redeem</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <td class="px-5 py-4">
                                                <div class="expired-history max-h-20 overflow-y-auto">
                                                    <c:set var="expiredList" value="${expiredHistoryMap[customer.customerId]}" />
                                                    <c:choose>
                                                        <c:when test="${not empty expiredList}">
                                                            <c:forEach items="${expiredList}" var="h" varStatus="status">
                                                                <c:if test="${status.index < 3}">
                                                                    <div class="text-xs text-orange-500">
                                                                        -${h.pointsUsed} - ${h.description}
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                            <c:if test="${expiredList.size() > 3}">
                                                                <div class="text-xs text-slate-400">+${expiredList.size() - 3} more...</div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-xs text-slate-400">No expired</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <td class="px-5 py-4 text-center">
                                                <span class="inline-flex px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-bold">
                                                    ${customer.totalPoints}
                                                </span>
                                            </td>

                                            <td class="px-5 py-4 text-center">
                                                <button onclick="openModal(${customer.customerId})"
                                                        class="px-3 py-2 rounded-xl bg-indigo-50 text-indigo-600 text-xs font-bold hover:bg-indigo-100 transition-all">
                                                    <i class="fas fa-eye"></i> View Detail
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty customers}">
                                        <tr>
                                            <td colspan="6" class="px-5 py-10 text-center text-slate-400">
                                                No customers found.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <!-- ===== MODAL ===== -->
        <div id="customerModal" class="modal-overlay" onclick="closeModalOutside(event)">
            <div class="modal-content">
                <button class="modal-close" onclick="closeModal()">&times;</button>
                <div class="modal-title" id="modalCustomerName">Customer Details</div>
                <hr class="modal-divider">

                <div id="modalBody">
                    <!-- Nội dung sẽ được load bằng AJAX -->
                    <div class="text-center py-8 text-slate-400">
                        <i class="fas fa-spinner fa-spin fa-2x"></i>
                        <p class="mt-2">Loading...</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function filterLoyalty() {
                const keyword = document.getElementById("loyaltySearch").value.toLowerCase();
                const typeFilter = document.getElementById("typeFilter").value;
                const rows = document.querySelectorAll(".loyalty-row");

                rows.forEach(row => {
                    const name = row.querySelector(".customer-name").innerText.toLowerCase();
                    const email = row.querySelector(".customer-email").innerText.toLowerCase();

                    const earnText = row.querySelector(".earn-history").innerText.toLowerCase();
                    const redeemText = row.querySelector(".redeem-history").innerText.toLowerCase();
                    const expiredText = row.querySelector(".expired-history").innerText.toLowerCase();

                    const matchesKeyword = name.includes(keyword) || email.includes(keyword);

                    let matchesType = true;
                    if (typeFilter === "earn") {
                        matchesType = earnText.includes("+") && !earnText.includes("no earn");
                    } else if (typeFilter === "redeem") {
                        matchesType = redeemText.includes("-") && !redeemText.includes("no redeem");
                    } else if (typeFilter === "expired") {
                        matchesType = expiredText.includes("-") && !expiredText.includes("no expired");
                    }

                    row.style.display = matchesKeyword && matchesType ? "" : "none";
                });
            }

            function clearFilters() {
                document.getElementById("loyaltySearch").value = "";
                document.getElementById("typeFilter").value = "all";
                filterLoyalty();
            }

            // ===== MODAL FUNCTIONS =====
            function openModal(customerId) {
                const modal = document.getElementById("customerModal");
                const body = document.getElementById("modalBody");

                // Show loading
                body.innerHTML = `
                    <div class="text-center py-8 text-slate-400">
                        <i class="fas fa-spinner fa-spin fa-2x"></i>
                        <p class="mt-2">Loading customer details...</p>
                    </div>
                `;

                // Show modal
                modal.classList.add("active");
                document.body.style.overflow = "hidden";

                // Fetch customer details via AJAX
                fetch('${pageContext.request.contextPath}/admin/loyalty/' + customerId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.text();
                    })
                    .then(html => {
                        body.innerHTML = html;
                        // Update modal title
                        const titleEl = document.getElementById('modalCustomerName');
                        const nameEl = body.querySelector('.customer-name-display');
                        if (nameEl) {
                            titleEl.textContent = nameEl.textContent;
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        body.innerHTML = `
                            <div class="text-center py-8 text-red-500">
                                <i class="fas fa-exclamation-circle fa-2x"></i>
                                <p class="mt-2">Failed to load customer details. Please try again.</p>
                                <button onclick="closeModal()" class="mt-4 px-4 py-2 bg-slate-200 rounded-xl">Close</button>
                            </div>
                        `;
                    });
            }

            function closeModal() {
                const modal = document.getElementById("customerModal");
                modal.classList.remove("active");
                document.body.style.overflow = "";
            }

            function closeModalOutside(event) {
                if (event.target === event.currentTarget) {
                    closeModal();
                }
            }

            // Close modal with ESC key
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    closeModal();
                }
            });
        </script>
    </body>
</html>