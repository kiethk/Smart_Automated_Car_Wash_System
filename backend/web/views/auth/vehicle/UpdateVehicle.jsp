<jsp:include page="/components/header.jsp"/>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Brand" %>
<%@ page import="dto.Model" %>

<%
    List<Brand> brands = (List<Brand>) request.getAttribute("brands");
    Integer currentBrandId = (Integer) request.getAttribute("currentBrandId");
    Integer currentModelId = (Integer) request.getAttribute("currentModelId");
    String brandSelect = (String) request.getAttribute("brandSelect");
    String modelSelect = (String) request.getAttribute("modelSelect");
%>

<main class="py-12 px-6 bg-slate-50">
    <div class="max-w-3xl mx-auto">

        <div class="flex items-center gap-4 mb-8">
            <div class="w-12 h-12 bg-[#1f108e] rounded-xl flex items-center justify-center">
                <i data-lucide="edit-3" class="w-6 h-6 text-white"></i>
            </div>
            <div>
                <h1 class="text-2xl font-bold text-slate-900">Update Vehicle</h1>
                <p class="text-sm text-slate-500">Update your vehicle information</p>
            </div>
        </div>

        <%
            String error = (String) request.getAttribute("ERROR");
            if (error != null) {
        %>
        <div class="bg-red-50 border border-red-200 text-red-600 p-4 rounded-xl mb-6 text-sm font-medium">
            <%= error %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/updateVehicle" method="POST" class="bg-white rounded-xl shadow-sm border border-slate-200">
            <div class="p-6 space-y-5">
                <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="form-label">License Plate Number *</label>
                        <input type="text" name="plateNumber" class="form-input" required 
                               value="${vehicle.plateNumber}">
                    </div>

                    <!-- Brand Selection -->
                    <div>
                        <label class="form-label">Brand *</label>
                        <select name="brandSelect" id="brandSelect" class="form-input" onchange="toggleBrandInput()" required>
                            <option value="existing" <%= (brandSelect == null || "existing".equals(brandSelect)) ? "selected" : "" %>>Select from list</option>
                            <option value="new" <%= "new".equals(brandSelect) ? "selected" : "" %>>Add new brand</option>
                        </select>
                    </div>

                    <div id="existingBrandDiv" <%= "new".equals(brandSelect) ? "style='display: none;'" : "" %>>
                        <label class="form-label">Select Brand *</label>
                        <select name="brandId" id="brandId" class="form-input" onchange="loadModels()">
                            <option value="">-- Select Brand --</option>
                            <%
                                if (brands != null) {
                                    for (Brand brand : brands) {
                            %>
                            <option value="<%= brand.getBrandId() %>" <%= (currentBrandId != null && currentBrandId == brand.getBrandId()) ? "selected" : "" %>>
                                <%= brand.getBrandName() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div id="newBrandDiv" <%= "new".equals(brandSelect) ? "" : "style='display: none;'" %>>
                        <label class="form-label">New Brand Name *</label>
                        <input type="text" name="newBrandName" class="form-input">
                    </div>

                    <!-- Model Selection -->
                    <div>
                        <label class="form-label">Model *</label>
                        <select name="modelSelect" id="modelSelect" class="form-input" onchange="toggleModelInput()" required>
                            <option value="existing" <%= (modelSelect == null || "existing".equals(modelSelect)) ? "selected" : "" %>>Select from list</option>
                            <option value="new" <%= "new".equals(modelSelect) ? "selected" : "" %>>Add new model</option>
                        </select>
                    </div>

                    <div id="existingModelDiv" <%= "new".equals(modelSelect) ? "style='display: none;'" : "" %>>
                        <label class="form-label">Select Model *</label>
                        <select name="modelId" id="modelId" class="form-input">
                            <option value="">-- Select Brand First --</option>
                            <%
                                // Nếu đã chọn brand, load models của brand đó
                                if (currentBrandId != null && currentBrandId > 0) {
                                    List<Model> models = (List<Model>) request.getAttribute("models_" + currentBrandId);
                                    if (models != null) {
                                        for (Model model : models) {
                            %>
                            <option value="<%= model.getModelId() %>" <%= (currentModelId != null && currentModelId == model.getModelId()) ? "selected" : "" %>>
                                <%= model.getModelName() %>
                            </option>
                            <%
                                        }
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div id="newModelDiv" <%= "new".equals(modelSelect) ? "" : "style='display: none;'" %>>
                        <label class="form-label">New Model Name *</label>
                        <input type="text" name="newModelName" class="form-input">
                    </div>

                    <div>
                        <label class="form-label">Vehicle Category *</label>
                        <select name="vehicleType" class="form-input" required>
                            <option value="" disabled ${empty vehicle.vehicleType ? 'selected' : ''}>Select type</option>
                            <option value="Sedan" ${vehicle.vehicleType == 'Sedan' ? 'selected' : ''}>Sedan</option>
                            <option value="SUV" ${vehicle.vehicleType == 'SUV' ? 'selected' : ''}>SUV</option>
                            <option value="Truck" ${vehicle.vehicleType == 'Truck' ? 'selected' : ''}>Truck / Pickup</option>
                        </select>
                    </div>

                    <div>
                        <label class="form-label">Color</label>
                        <input type="text" name="color" class="form-input" 
                               value="${vehicle.color}">
                    </div>

                    <div>
                        <label class="form-label">Manufacture Year</label>
                        <input type="number" name="manufactureYear" class="form-input" min="1900" max="2026"
                               value="${vehicle.manufactureYear != 0 ? vehicle.manufactureYear : ''}">
                    </div>
                </div>
            </div>

            <div class="p-6 bg-slate-50 border-t border-slate-200 flex gap-4">
                <button type="submit" class="btn-primary flex items-center gap-2">
                    <i data-lucide="save" class="w-4 h-4"></i>
                    Update Vehicle
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
    
    // Khai báo biến toàn cục lưu tất cả models (giống AddVehicle)
    var allModels = {};
    
    <%
        // Lấy tất cả models từ request và đưa vào JavaScript
        if (brands != null) {
            for (Brand brand : brands) {
                List<Model> models = (List<Model>) request.getAttribute("models_" + brand.getBrandId());
                if (models != null && !models.isEmpty()) {
    %>
    allModels[<%= brand.getBrandId() %>] = [
        <%
            for (int i = 0; i < models.size(); i++) {
                Model model = models.get(i);
        %>
        {modelId: <%= model.getModelId() %>, modelName: '<%= model.getModelName() %>'}<%= (i < models.size() - 1) ? "," : "" %>
        <%
            }
        %>
    ];
    <%
                }
            }
        }
    %>
    
    console.log('All models loaded for Update:', allModels);
    
    function toggleBrandInput() {
        var select = document.getElementById('brandSelect');
        var existingDiv = document.getElementById('existingBrandDiv');
        var newDiv = document.getElementById('newBrandDiv');
        
        if (select.value === 'new') {
            existingDiv.style.display = 'none';
            newDiv.style.display = 'block';
        } else {
            existingDiv.style.display = 'block';
            newDiv.style.display = 'none';
        }
    }
    
    function toggleModelInput() {
        var select = document.getElementById('modelSelect');
        var existingDiv = document.getElementById('existingModelDiv');
        var newDiv = document.getElementById('newModelDiv');
        
        if (select.value === 'new') {
            existingDiv.style.display = 'none';
            newDiv.style.display = 'block';
        } else {
            existingDiv.style.display = 'block';
            newDiv.style.display = 'none';
        }
    }
    
    function loadModels() {
        var brandId = document.getElementById('brandId').value;
        var modelSelect = document.getElementById('modelId');
        
        if (!brandId) {
            modelSelect.innerHTML = '<option value="">-- Select Brand First --</option>';
            return;
        }
        
        // Lấy models từ biến allModels đã được load từ server (giống AddVehicle)
        var models = allModels[parseInt(brandId)] || [];
        modelSelect.innerHTML = '<option value="">-- Select Model --</option>';
        for (var i = 0; i < models.length; i++) {
            modelSelect.innerHTML += '<option value="' + models[i].modelId + '">' + models[i].modelName + '</option>';
        }
    }
    
    // Khi trang load xong, nếu đã có brand được chọn sẵn thì load models
    document.addEventListener('DOMContentLoaded', function() {
        var brandIdSelect = document.getElementById('brandId');
        if (brandIdSelect && brandIdSelect.value) {
            loadModels();
        }
    });
</script>

<jsp:include page="/components/footer.jsp"/>