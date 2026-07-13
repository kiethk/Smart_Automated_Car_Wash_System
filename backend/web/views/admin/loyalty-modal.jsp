<%@page import="dto.Customer"%>
<%@page import="dto.LoyaltyPointHistory"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<LoyaltyPointHistory> earnHistory = (List<LoyaltyPointHistory>) request.getAttribute("earnHistory");
    List<LoyaltyPointHistory> redeemHistory = (List<LoyaltyPointHistory>) request.getAttribute("redeemHistory");
    List<LoyaltyPointHistory> expiredHistory = (List<LoyaltyPointHistory>) request.getAttribute("expiredHistory");
%>

<div class="modal-body-content">
    <!-- Customer Info -->
    <div class="flex items-center gap-4 mb-6">
        <c:choose>
            <c:when test="${not empty customer.avatarUrl}">
                <img src="${customer.avatarUrl}" class="w-20 h-20 rounded-full border-4 border-indigo-100">
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/assets/images/avatar-placeholder.jpg" class="w-20 h-20 rounded-full border-4 border-indigo-100">
            </c:otherwise>
        </c:choose>
        <div>
            <p class="customer-name-display text-2xl font-extrabold text-slate-900">${customer.fullName}</p>
            <p class="text-sm text-slate-500">${customer.email}</p>
            <p class="text-sm text-slate-500">${customer.phone != null ? customer.phone : 'No phone'}</p>
        </div>
    </div>

    <hr class="modal-divider">

    <!-- Detail Grid -->
    <div class="detail-grid">
        <div class="detail-item">
            <span class="detail-label">Tier</span>
            <span class="detail-value tier-badge tier-${customer.tierName}">${customer.tierName != null ? customer.tierName : 'Member'}</span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Discount</span>
            <span class="detail-value">${customer.discountPercent != null ? customer.discountPercent : 0}%</span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Total Points</span>
            <span class="detail-value font-bold text-blue-600">${customer.totalPoints}</span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Wallet Balance</span>
            <span class="detail-value font-bold text-emerald-600"><fmt:formatNumber value="${customer.walletBalance != null ? customer.walletBalance : 0}" type="currency" currencySymbol="₫"/></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Total Spent</span>
            <span class="detail-value"><fmt:formatNumber value="${customer.totalSpent}" type="currency" currencySymbol="₫"/></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Total Washes</span>
            <span class="detail-value">${customer.totalWashes}</span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Joined Date</span>
            <span class="detail-value">${customer.joinDate}</span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Status</span>
            <span class="detail-value ${customer.isActive == 1 ? 'status-active' : 'status-inactive'}">
                ${customer.isActive == 1 ? 'Active' : 'Inactive'}
            </span>
        </div>
    </div>

    <hr class="modal-divider">

    <!-- History Tabs -->
    <div>
        <div class="flex gap-2 mb-3">
            <button onclick="showModalTab('earn')" id="modalTabEarn" class="px-4 py-1.5 rounded-full text-xs font-bold bg-emerald-100 text-emerald-700">Earn</button>
            <button onclick="showModalTab('redeem')" id="modalTabRedeem" class="px-4 py-1.5 rounded-full text-xs font-bold bg-slate-100 text-slate-500 hover:bg-red-100 hover:text-red-600">Redeem</button>
            <button onclick="showModalTab('expired')" id="modalTabExpired" class="px-4 py-1.5 rounded-full text-xs font-bold bg-slate-100 text-slate-500 hover:bg-orange-100 hover:text-orange-600">Expired</button>
        </div>

        <!-- Earn -->
        <div id="modalEarnContent" class="history-list">
            <c:choose>
                <c:when test="${not empty earnHistory}">
                    <c:forEach items="${earnHistory}" var="h">
                        <div class="history-item earn">+${h.pointsEarned} - ${h.description} <span class="text-slate-400 text-xs">(${h.createdAt})</span></div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-slate-400 text-sm py-2">No earn history</div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Redeem -->
        <div id="modalRedeemContent" class="history-list" style="display:none;">
            <c:choose>
                <c:when test="${not empty redeemHistory}">
                    <c:forEach items="${redeemHistory}" var="h">
                        <div class="history-item redeem">-${h.pointsUsed} - ${h.description} <span class="text-slate-400 text-xs">(${h.createdAt})</span></div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-slate-400 text-sm py-2">No redeem history</div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Expired -->
        <div id="modalExpiredContent" class="history-list" style="display:none;">
            <c:choose>
                <c:when test="${not empty expiredHistory}">
                    <c:forEach items="${expiredHistory}" var="h">
                        <div class="history-item expired">-${h.pointsUsed} - ${h.description} <span class="text-slate-400 text-xs">(${h.createdAt})</span></div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-slate-400 text-sm py-2">No expired history</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="modal-footer">
        <button class="btn-close-modal" onclick="closeModal()">Close</button>
    </div>
</div>

<script>
    function showModalTab(tab) {
        // Hide all
        document.getElementById('modalEarnContent').style.display = 'none';
        document.getElementById('modalRedeemContent').style.display = 'none';
        document.getElementById('modalExpiredContent').style.display = 'none';

        // Reset all tabs
        document.getElementById('modalTabEarn').className = 'px-4 py-1.5 rounded-full text-xs font-bold bg-slate-100 text-slate-500';
        document.getElementById('modalTabRedeem').className = 'px-4 py-1.5 rounded-full text-xs font-bold bg-slate-100 text-slate-500';
        document.getElementById('modalTabExpired').className = 'px-4 py-1.5 rounded-full text-xs font-bold bg-slate-100 text-slate-500';

        // Show selected
        if (tab === 'earn') {
            document.getElementById('modalEarnContent').style.display = 'block';
            document.getElementById('modalTabEarn').className = 'px-4 py-1.5 rounded-full text-xs font-bold bg-emerald-100 text-emerald-700';
        } else if (tab === 'redeem') {
            document.getElementById('modalRedeemContent').style.display = 'block';
            document.getElementById('modalTabRedeem').className = 'px-4 py-1.5 rounded-full text-xs font-bold bg-red-100 text-red-600';
        } else if (tab === 'expired') {
            document.getElementById('modalExpiredContent').style.display = 'block';
            document.getElementById('modalTabExpired').className = 'px-4 py-1.5 rounded-full text-xs font-bold bg-orange-100 text-orange-600';
        }
    }
</script>