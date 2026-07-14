<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.Tiers"%>
<%@page import="dto.Promotion"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Promotion> promotions = (List<Promotion>) request.getAttribute("PROMOTIONS");
    List<Tiers> tiers = (List<Tiers>) request.getAttribute("TIERS");
    Map<Integer, Integer> usageMap = (Map<Integer, Integer>) request.getAttribute("USAGE_MAP");

    Promotion editPromotion = (Promotion) request.getAttribute("EDIT_PROMOTION");
    boolean isEditMode = editPromotion != null;

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
                                Promotion Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                Create, update and manage voucher campaigns.
                            </p>
                        </div>

                        <a href="${pageContext.request.contextPath}/admin/promotions"
                           class="inline-flex items-center justify-center px-4 py-2.5 rounded-2xl bg-slate-900 text-white text-sm font-bold hover:bg-slate-700 transition-all">
                            Reset Form
                        </a>
                    </div>

                    <% if ("created".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Promotion created successfully.
                    </div>
                    <% } else if ("updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Promotion updated successfully.
                    </div>
                    <% } else if ("status_updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Promotion status updated successfully.
                    </div>
                    <% } %>

                    <% if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Something went wrong. Please check promotion code, date range and discount value.
                    </div>
                    <% }%>

                    <div class="space-y-6">

                        <%-- FORM --%>
                        <section id="promotionFormSection"
                                 class="<%= isEditMode ? "" : "hidden"%> bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                            <div id="promotionFormBody"
                                 class="p-5">

                                <p class="text-sm text-slate-400 mb-5">
                                    Use 0 usage limit for unlimited usage.
                                </p>

                                <form action="${pageContext.request.contextPath}/admin/promotions" method="post" class="space-y-4">
                                    <input type="hidden" name="action" value="<%= isEditMode ? "update" : "create"%>">

                                    <% if (isEditMode) {%>
                                    <input type="hidden" name="promotionId" value="<%= editPromotion.getPromotionId()%>">
                                    <% }%>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">Code</label>
                                            <input type="text"
                                                   name="code"
                                                   value="<%= isEditMode ? editPromotion.getCode() : ""%>"
                                                   required
                                                   maxlength="50"
                                                   placeholder="SUMMER10"
                                                   class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none uppercase focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>

                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">Status</label>
                                            <select name="isActive"
                                                    class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                                <option value="1" <%= isEditMode && editPromotion.getIsActive() == 1 ? "selected" : ""%>>Active</option>
                                                <option value="0" <%= isEditMode && editPromotion.getIsActive() == 0 ? "selected" : ""%>>Inactive</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">Title</label>
                                        <input type="text"
                                               name="title"
                                               value="<%= isEditMode ? editPromotion.getTitle() : ""%>"
                                               required
                                               maxlength="100"
                                               placeholder="Summer Discount"
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">Description</label>
                                        <textarea name="description"
                                                  rows="3"
                                                  class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none resize-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50"><%= isEditMode && editPromotion.getDescription() != null ? editPromotion.getDescription() : ""%></textarea>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">
                                            Promotion Image
                                        </label>

                                        <% if (isEditMode && editPromotion.getImageUrl() != null && !editPromotion.getImageUrl().trim().isEmpty()) {%>
                                        <div class="mb-3 rounded-2xl border border-slate-200 bg-slate-50 p-3">
                                            <img id="promotionPreview"
                                                 src="<%= editPromotion.getImageUrl()%>"
                                                 alt="Promotion Image"
                                                 class="w-full h-40 object-cover rounded-xl">
                                        </div>
                                        <% } else { %>
                                        <div class="mb-3 rounded-2xl border border-slate-200 bg-slate-50 p-3 hidden" id="previewBox">
                                            <img id="promotionPreview"
                                                 src=""
                                                 alt="Promotion Image"
                                                 class="w-full h-40 object-cover rounded-xl">
                                        </div>
                                        <% }%>

                                        <input type="hidden"
                                               name="imageUrl"
                                               id="imageUrl"
                                               value="<%= isEditMode && editPromotion.getImageUrl() != null ? editPromotion.getImageUrl() : ""%>">

                                        <input type="file"
                                               id="imageFile"
                                               accept="image/*"
                                               onchange="uploadPromotionImage()"
                                               class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none bg-white focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">

                                        <p id="uploadStatus" class="text-xs text-slate-400 mt-2">
                                            Choose an image to upload to Cloudinary.
                                        </p>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">Discount Type</label>
                                            <select name="discountType"
                                                    class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                                <option value="percent" <%= isEditMode && "percent".equalsIgnoreCase(editPromotion.getDiscountType()) ? "selected" : ""%>>Percent</option>
                                                <option value="fixed" <%= isEditMode && "fixed".equalsIgnoreCase(editPromotion.getDiscountType()) ? "selected" : ""%>>Fixed VND</option>
                                            </select>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">Discount Value</label>
                                            <input type="number"
                                                   name="discountValue"
                                                   value="<%= isEditMode ? editPromotion.getDiscountValue() : ""%>"
                                                   min="1"
                                                   required
                                                   class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">Min Order VND</label>
                                            <input type="number"
                                                   name="minOrderAmount"
                                                   value="<%= isEditMode ? editPromotion.getMinOrderAmount() : "0"%>"
                                                   min="0"
                                                   required
                                                   class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>

                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">Usage Limit</label>
                                            <input type="number"
                                                   name="usageLimit"
                                                   value="<%= isEditMode ? editPromotion.getUsageLimit() : "0"%>"
                                                   min="0"
                                                   required
                                                   class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">Start Date</label>
                                            <input type="date"
                                                   name="startDate"
                                                   value="<%= isEditMode && editPromotion.getStartDate() != null ? editPromotion.getStartDate().toString() : ""%>"
                                                   required
                                                   class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>

                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">End Date</label>
                                            <input type="date"
                                                   name="endDate"
                                                   value="<%= isEditMode && editPromotion.getEndDate() != null ? editPromotion.getEndDate().toString() : ""%>"
                                                   required
                                                   class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">Target Tier</label>
                                        <select name="targetTierId"
                                                class="w-full px-4 py-3 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                            <option value="0">All Tiers</option>

                                            <% if (tiers != null) { %>
                                            <% for (Tiers t : tiers) {%>
                                            <option value="<%= t.getTierId()%>"
                                                    <%= isEditMode && editPromotion.getTargetTierId() != null && editPromotion.getTargetTierId() == t.getTierId() ? "selected" : ""%>>
                                                <%= t.getTierName()%>
                                            </option>
                                            <% } %>
                                            <% }%>
                                        </select>
                                    </div>

                                    <button type="submit"
                                            class="w-full px-4 py-3 rounded-2xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                        <%= isEditMode ? "Update Promotion" : "Create Promotion"%>
                                    </button>

                                </form>
                            </div>
                        </section>

                        <%-- TABLE --%>
                        <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="px-5 py-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                                <div>
                                    <h3 class="text-lg font-bold text-slate-900">Promotion List</h3>
                                    <p class="text-sm text-slate-400">
                                        Total: <%= promotions != null ? promotions.size() : 0%> promotions
                                    </p>
                                </div>

                                <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
                                    <input type="text"
                                           id="promotionSearch"
                                           placeholder="Search promotion..."
                                           onkeyup="filterPromotions()"
                                           class="w-full md:w-72 px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">

                                    <button type="button"
                                            onclick="togglePromotionForm()"
                                            class="px-4 py-2.5 rounded-2xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                        Add Promotion
                                    </button>
                                </div>
                            </div>

                            <div class="overflow-x-auto">
                                <table class="w-full text-sm">
                                    <thead class="bg-slate-50 text-slate-500">
                                        <tr>
                                            <th class="px-5 py-3 text-left font-bold">Promotion</th>
                                            <th class="px-5 py-3 text-left font-bold">Discount</th>
                                            <th class="px-5 py-3 text-center font-bold">Usage</th>
                                            <th class="px-5 py-3 text-center font-bold">Date</th>
                                            <th class="px-5 py-3 text-center font-bold">Status</th>
                                            <th class="px-5 py-3 text-right font-bold">Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody class="divide-y divide-slate-100">
                                        <% if (promotions == null || promotions.isEmpty()) { %>
                                        <tr>
                                            <td colspan="6" class="px-5 py-10 text-center text-slate-400">
                                                No promotions found.
                                            </td>
                                        </tr>
                                        <% } else { %>

                                        <% for (Promotion p : promotions) {
                                                int usedCount = usageMap != null && usageMap.get(p.getPromotionId()) != null
                                                        ? usageMap.get(p.getPromotionId())
                                                        : 0;

                                                String discountText = "percent".equalsIgnoreCase(p.getDiscountType())
                                                        ? p.getDiscountValue() + "%"
                                                        : currencyFormat.format(p.getDiscountValue()) + " VND";

                                                String usageText = p.getUsageLimit() <= 0
                                                        ? usedCount + " / Unlimited"
                                                        : usedCount + " / " + p.getUsageLimit();

                                                String tierText = "All Tiers";
                                                if (p.getTargetTierId() != null && tiers != null) {
                                                    for (Tiers t : tiers) {
                                                        if (t.getTierId() == p.getTargetTierId()) {
                                                            tierText = t.getTierName();
                                                            break;
                                                        }
                                                    }
                                                }
                                        %>

                                        <tr class="promotion-row hover:bg-slate-50 transition-colors">
                                            <td class="px-5 py-4 min-w-[260px]">
                                                <p class="promotion-name font-extrabold text-slate-900">
                                                    <%= p.getCode()%>
                                                </p>
                                                <p class="text-sm font-semibold text-slate-600 mt-1">
                                                    <%= p.getTitle()%>
                                                </p>
                                                <p class="text-xs text-slate-400 mt-1 line-clamp-1">
                                                    <%= p.getDescription() != null ? p.getDescription() : "No description"%>
                                                </p>
                                            </td>

                                            <td class="px-5 py-4 min-w-[180px]">
                                                <p class="font-bold text-indigo-600">
                                                    <%= discountText%>
                                                </p>
                                                <p class="text-xs text-slate-400 mt-1">
                                                    Min: <%= currencyFormat.format(p.getMinOrderAmount())%> VND
                                                </p>
                                                <p class="text-xs text-slate-400 mt-1">
                                                    Tier: <%= tierText%>
                                                </p>
                                            </td>

                                            <td class="px-5 py-4 text-center"9>
                                                <span class="inline-flex px-3 py-1 rounded-full bg-slate-100 text-slate-600 text-xs font-bold ">
                                                    <%= usageText%>
                                                </span>
                                            </td>

                                            <td class="px-5 py-4 text-center min-w-[150px]">
                                                <p class="text-xs font-semibold text-slate-700">
                                                    <%= p.getStartDate()%>
                                                </p>
                                                <p class="text-xs text-slate-400 my-1">to</p>
                                                <p class="text-xs font-semibold text-slate-700">
                                                    <%= p.getEndDate()%>
                                                </p>
                                            </td>

                                            <td class="px-5 py-4 text-center">
                                                <% if (p.getIsActive() == 1) { %>
                                                <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                    Active
                                                </span>
                                                <% } else { %>
                                                <span class="inline-flex px-3 py-1 rounded-full bg-slate-100 text-slate-500 text-xs font-bold">
                                                    Inactive
                                                </span>
                                                <% }%>
                                            </td>

                                            <td class="px-5 py-4">
                                                <div class="flex items-center justify-end gap-2">
                                                    <a href="${pageContext.request.contextPath}/admin/promotions?editId=<%= p.getPromotionId()%>"
                                                       class="px-3 py-2 rounded-xl bg-indigo-50 text-indigo-600 text-xs font-bold hover:bg-indigo-100 transition-all">
                                                        Edit
                                                    </a>

                                                    <form action="${pageContext.request.contextPath}/admin/promotions"
                                                          method="post"
                                                          onsubmit="return confirm('Are you sure you want to change this promotion status?');">
                                                        <input type="hidden" name="action" value="toggle">
                                                        <input type="hidden" name="promotionId" value="<%= p.getPromotionId()%>">
                                                        <input type="hidden" name="isActive" value="<%= p.getIsActive() == 1 ? 0 : 1%>">

                                                        <button type="submit"
                                                                class="px-3 py-2 rounded-xl <%= p.getIsActive() == 1 ? "bg-red-50 text-red-500 hover:bg-red-100" : "bg-emerald-50 text-emerald-600 hover:bg-emerald-100"%> text-xs font-bold transition-all">
                                                            <%= p.getIsActive() == 1 ? "Disable" : "Enable"%>
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
                    </div>
                </main>
            </div>
        </div>

        <script>
            function togglePromotionForm() {
                const section = document.getElementById("promotionFormSection");

                if (!section) {
                    return;
                }

                section.classList.toggle("hidden");
            }

            function filterPromotions() {
                const keyword = document.getElementById("promotionSearch").value.toLowerCase();
                const rows = document.querySelectorAll(".promotion-row");
                rows.forEach(row => {
                    const name = row.querySelector(".promotion-name").innerText.toLowerCase();
                    if (name.includes(keyword)) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            }


            const CLOUD_NAME = "dtkasmhud";
            const UPLOAD_PRESET = "promotion_prj_url";

            async function uploadPromotionImage() {
                const fileInput = document.getElementById("imageFile");
                const imageUrlInput = document.getElementById("imageUrl");
                const uploadStatus = document.getElementById("uploadStatus");
                const preview = document.getElementById("promotionPreview");
                const previewBox = document.getElementById("previewBox");
                if (!fileInput.files || fileInput.files.length === 0) {
                    return;
                }

                const file = fileInput.files[0];
                if (!file.type.startsWith("image/")) {
                    uploadStatus.innerText = "Please choose a valid image file.";
                    uploadStatus.className = "text-xs text-red-500 mt-2";
                    return;
                }

                uploadStatus.innerText = "Uploading image...";
                uploadStatus.className = "text-xs text-amber-500 mt-2";
                const formData = new FormData();
                formData.append("file", file);
                formData.append("upload_preset", UPLOAD_PRESET);
                formData.append("folder", "autowash/promotions");
                try {
                    const response = await fetch("https://api.cloudinary.com/v1_1/" + CLOUD_NAME + "/image/upload", {
                        method: "POST",
                        body: formData
                    });
                    const data = await response.json();
                    if (!response.ok) {
                        throw new Error(data.error ? data.error.message : "Upload failed");
                    }

                    imageUrlInput.value = data.secure_url;
                    if (preview) {
                        preview.src = data.secure_url;
                    }

                    if (previewBox) {
                        previewBox.classList.remove("hidden");
                    }

                    uploadStatus.innerText = "Image uploaded successfully.";
                    uploadStatus.className = "text-xs text-emerald-600 mt-2";
                } catch (error) {
                    console.error(error);
                    uploadStatus.innerText = "Upload failed: " + error.message;
                    uploadStatus.className = "text-xs text-red-500 mt-2";
                }
            }

        </script>
    </body>
</html>
