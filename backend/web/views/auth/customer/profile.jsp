<%@page import="dto.Vehicle"%>
<%@page import="dao.VehicleDAO"%>
<%@page import="dto.Wallet"%>
<%@page import="dao.WalletDAO"%>
<%@page import="dao.TiersDAO"%>
<%@page import="dto.Tiers"%>
<%@page import="dto.Customer"%>
<%@page import="dto.User"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="dao.UserDAO"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %>
<%// Lúc này file JSP chỉ làm duy nhất 1 nhiệm vụ: Lấy các Attribute đã được Servlet tính sẵn ra để dùng
    User loginedUser = (User) session.getAttribute("USER");
    Customer loginedCustomer = (Customer) request.getAttribute("customerData");
    Tiers loginedTiers = (Tiers) request.getAttribute("tierData");
    Wallet loginedWallet = (Wallet) request.getAttribute("walletData");
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("vehicles");

    // Đọc các thông số phần trăm
    boolean hasNextTier = (boolean) request.getAttribute("hasNextTier");
    int targetWashes = (int) request.getAttribute("targetWashes");
    long targetSpent = (long) request.getAttribute("targetSpent");
    int washesPercent = (int) request.getAttribute("washesPercent");
    int spentPercent = (int) request.getAttribute("spentPercent");
%>

<jsp:include page="/components/header.jsp" />

<main class="min-h-screen bg-background section-spacing">
    <div class="max-w-[1280px] mx-auto px-4 md:px-16 py-8">
        <div class="mb-8">
            <h1 class="text-3xl font-extrabold text-on-background tracking-tight">Account Profile</h1>
            <p class="text-sm text-slate-500">Manage your personal information, loyalty status, and registered vehicles.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-12 gap-8">

            <div class="md:col-span-4 space-y-6">
                <div class="bg-surface-container rounded-2xl p-6 border border-surface-border flex flex-col items-center text-center">
                    <div class="relative w-24 h-24">
                        <div class="w-full h-full bg-primary/10 rounded-full flex items-center justify-center text-primary text-3xl font-bold border-2 border-primary/20 overflow-hidden">
                            <img src="<%= (loginedUser.getAvatarUrl() != null && !loginedUser.getAvatarUrl().trim().isEmpty()) ? loginedUser.getAvatarUrl() : request.getContextPath() + "/assets/images/avatar-placeholder.jpg"%>" 
                                 alt="User Avatar" class="w-full h-full object-cover" id="avatar-preview" />
                        </div>

                        <label for="avatar-upload" class="absolute bottom-0 right-0 bg-primary text-white p-1.5 rounded-full border-2 border-surface-container cursor-pointer hover:bg-primary-dark transition-all">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                <circle cx="12" cy="13" r="4"></circle>
                            </svg>
                        </label>
                        <input type="file" id="avatar-upload" class="hidden" accept="image/*" onchange="uploadAvatar(this)">
                    </div>

                    <h2 class="text-xl font-bold text-on-background"><%= loginedUser.getFullName()%></h2>
                    <span class="text-xs bg-primary/10 text-primary font-semibold px-3 py-1 rounded-full mt-1 uppercase">
                        <%= loginedTiers.getTierName()%>
                    </span>

                    <hr class="w-full border-surface-border my-6">

                        <div class="w-full space-y-4 text-left text-sm" id="profile-info">
                            <div>
                                <label class="form-label block text-xs font-semibold uppercase opacity-70">Email Address</label>
                                <span class="text-on-background font-medium block mt-1"><%= loginedUser.getEmail()%></span>
                            </div>

                            <div>
                                <label class="form-label block text-xs font-semibold uppercase opacity-70">Member Since</label>
                                <span class="text-on-background font-medium block mt-1"><%= loginedCustomer.getJoinDate()%></span>
                            </div>

                            <div class="editable-group">
                                <label class="form-label block text-xs font-semibold uppercase opacity-70">Phone Number</label>
                                <div class="flex items-center justify-between mt-1">
                                    <span class="text-on-background font-medium" id="phone-text">
                                        <%= loginedUser.getPhone() != null ? loginedUser.getPhone() : "Not provided"%>
                                    </span>
                                    <button onclick="toggleEdit('phone')" class="text-primary hover:text-primary-dark ml-2">✎</button>
                                </div>
                                <input type="text" id="phone-input" 
                                       class="hidden w-full bg-surface-container border border-primary p-2 rounded mt-1 focus:outline-none" 
                                       value="<%= loginedUser.getPhone() != null ? loginedUser.getPhone() : ""%>" 
                                       onkeydown="if (event.key === 'Enter')
                                                   saveField('phone', this.value)"
                                       onblur="saveField('phone', this.value)">
                            </div>

                            <div class="editable-group">
                                <label class="form-label block text-xs font-semibold uppercase opacity-70">Address</label>
                                <div class="flex items-center justify-between mt-1">
                                    <span class="text-on-background font-medium" id="address-text">
                                        <%= loginedCustomer.getAddress() != null ? loginedCustomer.getAddress() : "Not provided"%>
                                    </span>
                                    <button onclick="toggleEdit('address')" class="text-primary hover:text-primary-dark ml-2">✎</button>
                                </div>
                                <input type="text" id="address-input" 
                                       class="hidden w-full bg-surface-container border border-primary p-2 rounded mt-1 focus:outline-none" 
                                       value="<%= loginedCustomer.getAddress() != null ? loginedCustomer.getAddress() : ""%>" 
                                       onkeydown="if (event.key === 'Enter')
                                                   saveField('address', this.value)"
                                       onblur="saveField('address', this.value)">
                            </div>

                            <div class="editable-group">
                                <label class="form-label block text-xs font-semibold uppercase opacity-70">DATE OF BIRTH</label>
                                <div class="flex items-center justify-between mt-1">
                                    <span class="text-on-background font-medium" id="dob-text">
                                        <%= loginedCustomer.getDateOfBirth() != null ? loginedCustomer.getDateOfBirth() : "Not provided"%>
                                    </span>
                                    <button onclick="toggleEdit('dob')" class="text-primary hover:text-primary-dark ml-2">✎</button>
                                </div>
                                <input type="date" id="dob-input" 
                                       class="hidden w-full bg-surface-container border border-primary p-2 rounded mt-1 focus:outline-none" 
                                       value="<%= loginedCustomer.getDateOfBirth() != null ? loginedCustomer.getDateOfBirth() : ""%>" 
                                       onkeydown="if (event.key === 'Enter')
                                                   saveField('dob', this.value)"
                                       onblur="saveField('dob', this.value)">
                            </div>                     
                        </div>
                </div>
            </div>

            <div class="md:col-span-8 space-y-6">

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">

                    <div class="bg-surface-container rounded-2xl p-6 border border-surface-border relative overflow-hidden flex flex-col justify-between">
                        <div>
                            <div class="text-xs font-bold text-secondary uppercase tracking-widest mb-1">Loyalty Level</div>
                            <div class="text-2xl font-black text-on-background bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent uppercase">
                                <%= loginedTiers.getTierName()%>
                            </div>
                            <div class="text-xs text-slate-400 mt-1">
                                Current Reward Points: <strong class="text-primary font-bold"><%= loginedCustomer.getTotalPoints()%> pts</strong>
                            </div>
                        </div>

                        <div class="mt-4 space-y-4">
                            <% if (hasNextTier) {%>
                            <div>
                                <div class="flex justify-between text-xs font-medium mb-1">
                                    <span class="text-slate-500">Washes: <%= loginedCustomer.getTotalWashes()%> / <%= targetWashes%> (Next Level)</span>
                                    <span class="text-primary font-bold"><%= washesPercent%>%</span>
                                </div>
                                <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                                    <div class="bg-primary h-full rounded-full" style="width: <%= washesPercent%>%;"></div>
                                </div>
                            </div>

                            <div>
                                <div class="flex justify-between text-xs font-medium mb-1">
                                    <span class="text-slate-500">Spent: <%= String.format("%,d", loginedCustomer.getTotalSpent())%> / <%= String.format("%,d", targetSpent)%> VND</span>
                                    <span class="text-secondary font-bold"><%= spentPercent%>%</span>
                                </div>
                                <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                                    <div class="bg-secondary h-full rounded-full" style="width: <%= spentPercent%>%;"></div>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="text-xs text-emerald-600 bg-emerald-50 border border-emerald-100 p-3 rounded-xl font-medium">
                                🎉 Elite Tier Reached! You have unlocked maximum tier privilege utilities.
                            </div>
                            <% }%>
                        </div>

                        <div class="mt-4 pt-3 border-t border-dashed border-surface-border flex justify-between text-xs text-slate-400">
                            <span>Total Washes: <strong class="text-on-background"><%= loginedCustomer.getTotalWashes()%></strong></span>
                            <span>Total Spent: <strong class="text-on-background"><%= String.format("%,d", loginedCustomer.getTotalSpent())%> VND</strong></span>
                        </div>
                    </div>

                    <div class="bg-surface-container rounded-2xl p-6 border border-surface-border flex flex-col justify-between">
                        <%
                            Wallet wallet = (Wallet) session.getAttribute("WALLET");
                            if (wallet != null) {
                        %>
                        <div>
                            <div class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Vehicle Wallet</div>
                            <div class="text-3xl font-bold text-on-background mt-1 tech-data">
                                <%= String.format("%,d", wallet.getBalance())%> <span class="text-lg">VND</span>
                            </div>
                            <p class="text-xs text-slate-500 mt-2">Available balance for instant slot booking.</p>
                        </div>
                        <div class="mt-4 pt-3 border-t border-dashed border-surface-border flex gap-2">
                            <button class="text-xs text-primary font-bold hover:underline">Top Up Balance →</button>
                        </div>
                        <% } else { %>
                        <div class="flex flex-col items-center justify-center h-full text-center py-4">
                            <div class="mb-3 text-slate-400">
                                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path></svg>
                            </div>
                            <h4 class="text-sm font-bold text-on-background">No Wallet Found</h4>
                            <p class="text-xs text-slate-500 mb-4 px-2">Create a digital wallet to start booking slots instantly.</p>

                            <form action="${pageContext.request.contextPath}/createWallet" method="POST">
                                <button type="submit" class="text-xs bg-primary text-on-primary px-4 py-2 rounded-lg font-bold hover:opacity-90 transition-opacity">
                                    Create Wallet Now
                                </button>
                            </form>
                        </div>
                        <% } %>
                    </div>

                </div>

                <div class="bg-surface-container rounded-2xl p-6 border border-surface-border">
                    <div class="flex justify-between items-center mb-4">
                        <div>
                            <h3 class="text-lg font-bold text-on-background">My Registered Vehicles</h3>
                            <p class="text-xs text-slate-500">Manage licenses and access tiers for your fleet.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/addVehicle" class="inline-block">
                            <button class="btn-primary px-4 py-2 text-xs flex items-center gap-1">
                                <span>+</span> Add Vehicle
                            </button>
                        </a>
                    </div>

                    <div class="divide-y divide-surface-border">
                        <%
                            if (vehicleList != null && !vehicleList.isEmpty()) {
                                for (Vehicle vehicle : vehicleList) {
                        %>
                        <div class="py-4 flex justify-between items-center first:pt-0 last:pb-0">
                            <div class="flex items-center gap-4">
                                <%-- Ảnh xe: nếu có vehicle_image_url thì hiện, không thì dùng placeholder --%>
                                <div class="w-16 h-12 rounded-xl overflow-hidden bg-slate-100 flex items-center justify-center flex-shrink-0">
                                    <% if (vehicle.getVehicleImageUrl() != null && !vehicle.getVehicleImageUrl().trim().isEmpty()) {%>
                                    <img src="<%= vehicle.getVehicleImageUrl()%>" 
                                         alt="Vehicle" class="w-full h-full object-cover" />
                                    <% } else { %>
                                    <svg class="w-7 h-7 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                              d="M9 17a2 2 0 11-4 0 2 2 0 014 0zM19 17a2 2 0 11-4 0 2 2 0 014 0z"/>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                              d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10l2 .001M13 16H9m4 0h5.5M13 16V9.5l3.5-1.5L20 11v5H18m-5 0h5"/>
                                    </svg>
                                    <% }%>
                                </div>

                                <div>
                                    <%-- Brand + Model: dùng brandDisplay/modelDisplay từ VIEW --%>
                                    <div class="font-bold text-on-background">
                                        <%= vehicle.getBrandDisplay()%> <%= vehicle.getModelDisplay()%>
                                    </div>
                                    <div class="text-xs text-slate-400 tracking-wider tech-data font-semibold mt-0.5">
                                        <%= vehicle.getPlateNumber()%>
                                    </div>
                                    <%-- Thêm màu sắc + năm sản xuất + loại xe --%>
                                    <div class="flex items-center gap-2 mt-1">
                                        <span class="text-[11px] bg-slate-100 text-slate-500 px-2 py-0.5 rounded-full font-medium">
                                            <%= vehicle.getVehicleType()%>
                                        </span>
                                        <span class="text-[11px] text-slate-400">
                                            <%= vehicle.getColor()%> · <%= vehicle.getManufactureYear()%>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="flex items-center gap-2 flex-shrink-0">
                                <a href="${pageContext.request.contextPath}/updateVehicle?id=<%= vehicle.getVehicleId()%>"
                                   class="p-2 text-primary hover:bg-indigo-50 rounded-lg transition-colors" title="Edit">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                    </svg>
                                </a>
                                <button onclick="deleteVehicle('<%= vehicle.getVehicleId()%>')"
                                        class="p-2 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors" title="Delete">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                    </svg>
                                </button>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="py-8 text-center text-sm text-slate-400 font-medium">
                            No vehicles registered yet. Click "+ Add Vehicle" to register your fleet.
                        </div>
                        <%
                            }
                        %>
                    </div>

                </div>

            </div>
        </div>

    </div>
</main>

<script>
    function toggleEdit(field) {
        document.getElementById(field + '-text').classList.add('hidden');
        document.getElementById(field + '-input').classList.remove('hidden');
        document.getElementById(field + '-input').focus();
    }

    let isSaving = false; // Biến cờ

    function saveField(field, value) {
        if (isSaving)
            return; // Nếu đang lưu thì không làm gì cả
        isSaving = true;

        // Ẩn input, hiện text lại ngay
        document.getElementById(field + '-text').classList.remove('hidden');
        document.getElementById(field + '-input').classList.add('hidden');

        fetch('${pageContext.request.contextPath}/updateProfile', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'field=' + field + '&value=' + encodeURIComponent(value)
        })
                .then(response => response.text())
                .then(data => {
                    isSaving = false; // Reset cờ
                    console.log(data);
                    if (data.trim() === "success") {
                        document.getElementById(field + '-text').innerText = (value.trim() === "") ? "Not provided" : value;
                    } else {
                        alert("Failed to update " + field);
                    }
                })
                .catch(err => {
                    isSaving = false;
                    alert("System error!");
                });
    }

    async function uploadAvatar(input) {
        const file = input.files[0];
        if (!file)
            return;

        const preview = document.getElementById('avatar-preview');
        preview.style.opacity = "0.5";

        const formData = new FormData();
        formData.append("file", file);
        formData.append("upload_preset", "avatar_prj_upload");

        try {
            const response = await fetch("https://api.cloudinary.com/v1_1/dtkasmhud/image/upload", {
                method: "POST",
                body: formData
            });

            const data = await response.json();

            if (data.secure_url) {
                preview.src = data.secure_url;
                preview.style.opacity = "1";

                saveAvatarUrlToDB(data.secure_url);
            } else {
                throw new Error("Upload failed!");
            }
        } catch (error) {
            console.error("Error: ", error);
            preview.style.opacity = "1";
            alert("Cannot upload your image. Please try again!");
        }
    }

    function saveAvatarUrlToDB(url) {
        fetch('${pageContext.request.contextPath}/updateProfile', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'field=avatar&value=' + encodeURIComponent(url)
        });
    }
</script>

<jsp:include page="/components/footer.jsp" />
