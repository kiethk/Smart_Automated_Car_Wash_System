
<jsp:include page="/components/header.jsp"/>


<main class="py-12 px-6 bg-slate-50">
    <div class="max-w-3xl mx-auto">

        <!-- Header -->
        <div class="flex items-center gap-4 mb-8">
            <div class="w-12 h-12 bg-[#1f108e] rounded-xl flex items-center justify-center">
                <i data-lucide="plus" class="w-6 h-6 text-white"></i>
            </div>
            <div>
                <h1 class="text-2xl font-bold text-slate-900">Add New Vehicle</h1>
                <p class="text-sm text-slate-500">Register your vehicle for LPR automatic recognition</p>
            </div>
        </div>

        <!-- Error Message -->
        <%
            String error = (String) request.getAttribute("ERROR");
            if (error != null) {
        %>
        <div class="bg-red-50 border border-red-200 text-red-600 p-4 rounded-xl mb-6 text-sm font-medium">
            <%= error%>
        </div>
        <% }%>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/addVehicle" method="POST" class="bg-white rounded-xl shadow-sm border border-slate-200">
            <div class="p-6 space-y-5">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                    <div>
                        <label class="form-label">License Plate Number *</label>
                        <input type="text" name="plateNumber" 
                               value="${vehicle.plateNumber != null ? vehicle.plateNumber : ''}" 
                               class="form-input" required>
                    </div>

                    <div>
                        <label class="form-label">Brand</label>
                        <input type="text" name="brand" 
                               value="${vehicle.brand != null ? vehicle.brand : ''}" 
                               class="form-input">
                    </div>

                    <div>
                        <label class="form-label">Model</label>
                        <input type="text" name="model" 
                               value="${vehicle.model != null ? vehicle.model : ''}" 
                               class="form-input">
                    </div>

                    <div>
                        <label class="form-label">Vehicle Category *</label>
                        <select name="vehicleType" class="form-input" required>
                            <option value="" ${vehicle.vehicleType == null ? 'selected' : 'disabled'}>Select type</option>
                            <option value="Sedan" ${vehicle.vehicleType == 'Sedan' ? 'selected' : ''}>Sedan</option>
                            <option value="SUV" ${vehicle.vehicleType == 'SUV' ? 'selected' : ''}>SUV</option>
                            <option value="Truck" ${vehicle.vehicleType == 'Truck' ? 'selected' : ''}>Truck / Pickup</option>
                        </select>
                    </div>

                    <div>
                        <label class="form-label">Color</label>
                        <input type="text" name="color" 
                               value="${vehicle.color != null ? vehicle.color : ''}" 
                               class="form-input">
                    </div>

                    <div>
                        <label class="form-label">Manufacture Year</label>
                        <input type="number" name="manufactureYear" 
                               value="${vehicle.manufactureYear != 0 ? vehicle.manufactureYear : ''}" 
                               class="form-input" min="1900" max="2026">
                    </div>

                </div>
            </div>

            <div class="p-6 bg-slate-50 border-t border-slate-200 flex gap-4">
                <button type="submit" class="btn-primary flex items-center gap-2">
                    Add Vehicle
                </button>
                <a href="${pageContext.request.contextPath}/profile" class="btn-secondary">
                    Cancel
                </a>
            </div>
        </form>

    </div>
</main>

<script>
    lucide.createIcons();
</script>

<jsp:include page="/components/footer.jsp"/>
