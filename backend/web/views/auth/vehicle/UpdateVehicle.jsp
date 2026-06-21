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
    String newBrandName = (String) request.getAttribute("newBrandName");
    String newModelName = (String) request.getAttribute("newModelName");
%>

<style>
    .form-input {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        font-size: 14px;
    }
    .form-input:focus {
        outline: none;
        border-color: #1f108e;
        box-shadow: 0 0 0 3px rgba(31, 16, 142, 0.1);
    }
    .btn-primary {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        background: #1f108e;
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-weight: 500;
        border: none;
        cursor: pointer;
        text-decoration: none;
        transition: background 0.2s;
    }
    .btn-primary:hover {
        background: #170b6d;
    }
    .btn-secondary {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        background: #f1f5f9;
        color: #1e293b;
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-weight: 500;
        border: 1px solid #e2e8f0;
        cursor: pointer;
        text-decoration: none;
        transition: background 0.2s;
    }
    .btn-secondary:hover {
        background: #e2e8f0;
    }
    .form-label {
        display: block;
        font-weight: 500;
        margin-bottom: 0.25rem;
        color: #0f172a;
    }
    .suggestions-box {
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        border-radius: 8px;
        max-height: 200px;
        overflow-y: auto;
        background: white;
        z-index: 1000;
        margin-top: 4px;
        display: none;
        position: absolute;
        width: 100%;
    }
    .suggestion-item {
        padding: 8px 12px;
        cursor: pointer;
        border-bottom: 1px solid #f0f0f0;
    }
    .suggestion-item:hover {
        background: #f0f0f0;
    }
    .suggestion-item.new-item {
        background: #f0f7ff;
        color: #1f108e;
        font-weight: 500;
    }
    .hidden-field {
        display: none;
    }
    .image-preview {
        max-width: 200px;
        max-height: 150px;
        border-radius: 8px;
        object-fit: cover;
        border: 1px solid #e5e7eb;
    }
</style>

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

        <form action="${pageContext.request.contextPath}/updateVehicle" method="POST" enctype="multipart/form-data" class="bg-white rounded-xl shadow-sm border border-slate-200">
            <div class="p-6 space-y-5">
                <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                    <!-- License Plate -->
                    <div>
                        <label class="form-label">License Plate Number *</label>
                        <input type="text" name="plateNumber" class="form-input" required 
                               value="${vehicle.plateNumber}">
                    </div>

                    <!-- Brand Input với gợi ý -->
                    <div style="position: relative;">
                        <label class="form-label">Brand *</label>
                        <input type="text" 
                               id="brandInput" 
                               name="brandInput" 
                               class="form-input" 
                               placeholder="Search or enter brand name..."
                               autocomplete="off"
                               oninput="filterBrandList()"
                               onfocus="filterBrandList()"
                               onblur="validateBrandSelection()"
                               value="<%= (newBrandName != null && !newBrandName.isEmpty()) ? newBrandName : (currentBrandId != null ? getBrandName(currentBrandId, brands) : "") %>">
                        
                        <div id="brandSuggestions" class="suggestions-box">
                            <%
                                if (brands != null) {
                                    for (Brand brand : brands) {
                            %>
                            <div class="suggestion-item" 
                                 data-brand-id="<%= brand.getBrandId() %>"
                                 data-brand-name="<%= brand.getBrandName() %>"
                                 onclick="selectBrand(this, '<%= brand.getBrandId() %>', '<%= brand.getBrandName() %>')">
                                <%= brand.getBrandName() %>
                            </div>
                            <%
                                    }
                                }
                            %>
                            <div id="newBrandOption" class="suggestion-item new-item" style="display: none;" onclick="addNewBrand()">
                                Add new brand: <span id="newBrandText"></span>
                            </div>
                        </div>
                        <input type="hidden" name="brandSelect" id="brandSelect" value="<%= (newBrandName != null && !newBrandName.isEmpty()) ? "new" : "existing" %>">
                        <input type="hidden" name="brandId" id="brandId" value="<%= currentBrandId != null ? currentBrandId : "" %>">
                        <input type="hidden" name="newBrandName" id="newBrandName" value="<%= newBrandName != null ? newBrandName : "" %>">
                    </div>

                    <!-- Model Input -->
                    <div style="position: relative;">
                        <label class="form-label">Model *</label>
                        <!-- Model dropdown -->
                        <div id="modelDropdownWrapper">
                            <select name="modelId" id="modelId" class="form-input" onchange="onModelSelectChange()">
                                <option value="">-- Select Model --</option>
                                <%
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
                                <option value="__new__" id="newModelOptionInDropdown">+ Add new model</option>
                            </select>
                        </div>
                        
                        <!-- Model text input (khi brand mới hoặc chọn thêm mới) -->
                        <div id="modelTextWrapper" style="display: none;">
                            <input type="text" 
                                   id="modelTextInput" 
                                   name="modelTextInput" 
                                   class="form-input" 
                                   placeholder="Enter new model name..."
                                   value="<%= newModelName != null ? newModelName : "" %>">
                        </div>

                        <input type="hidden" name="modelSelect" id="modelSelect" value="<%= (newModelName != null && !newModelName.isEmpty()) ? "new" : "existing" %>">
                        <input type="hidden" name="newModelName" id="newModelName" value="<%= newModelName != null ? newModelName : "" %>">
                    </div>

                    <!-- Vehicle Category -->
                    <div>
                        <label class="form-label">Vehicle Category *</label>
                        <select name="vehicleType" class="form-input" required>
                            <option value="" disabled ${empty vehicle.vehicleType ? 'selected' : ''}>Select type</option>
                            <option value="Sedan" ${vehicle.vehicleType == 'Sedan' ? 'selected' : ''}>Sedan</option>
                            <option value="SUV" ${vehicle.vehicleType == 'SUV' ? 'selected' : ''}>SUV</option>
                            <option value="Truck" ${vehicle.vehicleType == 'Truck' ? 'selected' : ''}>Truck / Pickup</option>
                        </select>
                    </div>

                    <!-- Color -->
                    <div>
                        <label class="form-label">Color</label>
                        <input type="text" name="color" class="form-input" 
                               value="${vehicle.color}">
                    </div>

                    <!-- Manufacture Year -->
                    <div>
                        <label class="form-label">Manufacture Year</label>
                        <input type="number" name="manufactureYear" class="form-input" min="1900" max="2026"
                               value="${vehicle.manufactureYear != 0 ? vehicle.manufactureYear : ''}">
                    </div>

                    <!-- Upload Image -->
                    <div class="md:col-span-2">
                        <label class="form-label">Vehicle Image <span class="text-slate-400 text-sm font-normal">(Optional)</span></label>
                        
                        <!-- Hiển thị ảnh cũ nếu có -->
                        <c:if test="${vehicle.vehicleImageUrl != null}">
                            <div id="existingImageContainer" style="margin-bottom: 8px;">
                                <img src="${vehicle.vehicleImageUrl}" alt="Current vehicle image" class="image-preview">
                                <p class="text-xs text-slate-400">Current image</p>
                            </div>
                        </c:if>
                        
                        <input type="file" name="vehicleImage" accept="image/*" class="form-input" onchange="previewImage(this)">
                        <p class="text-xs text-slate-400 mt-1">Upload new image to replace current one. Supported formats: JPG, PNG, GIF. Max size: 5MB</p>
                        
                        <div id="imagePreviewContainer" style="margin-top: 8px; display: none;">
                            <img id="imagePreview" src="#" alt="Preview" class="image-preview">
                            <button type="button" onclick="removeImage()" class="text-red-500 text-sm mt-1 hover:underline">Remove new image</button>
                        </div>
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

<%!
    // Helper lấy tên brand từ ID
    private String getBrandName(Integer brandId, List<Brand> brands) {
        if (brandId == null || brands == null) return "";
        for (Brand b : brands) {
            if (b.getBrandId() == brandId) return b.getBrandName();
        }
        return "";
    }
%>

<script>
    lucide.createIcons();

    // ==================== DỮ LIỆU TỪ SERVER ====================
    var brandList = [];
    <%
        if (brands != null) {
            for (Brand brand : brands) {
    %>
    brandList.push({id: <%= brand.getBrandId() %>, name: '<%= brand.getBrandName() %>'});
    <%
            }
        }
    %>

    var allModelsData = {};
    <%
        if (brands != null) {
            for (Brand brand : brands) {
                List<Model> models = (List<Model>) request.getAttribute("models_" + brand.getBrandId());
                if (models != null) {
    %>
    allModelsData[<%= brand.getBrandId() %>] = [
        <%
            for (int i = 0; i < models.size(); i++) {
                Model model = models.get(i);
        %>
        {id: <%= model.getModelId() %>, name: '<%= model.getModelName() %>'}<%= (i < models.size() - 1) ? "," : "" %>
        <%
            }
        %>
    ];
    <%
                }
            }
        }
    %>

    // ==================== BIẾN TOÀN CỤC ====================
    var isBrandNew = false;
    var isModelNew = false;
    var selectedBrandId = null;
    var currentModels = [];

    // ==================== IMAGE PREVIEW ====================
    function previewImage(input) {
        var container = document.getElementById('imagePreviewContainer');
        var preview = document.getElementById('imagePreview');
        var existingContainer = document.getElementById('existingImageContainer');
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                container.style.display = 'block';
                if (existingContainer) existingContainer.style.display = 'none';
            }
            reader.readAsDataURL(input.files[0]);
        } else {
            container.style.display = 'none';
            preview.src = '#';
            if (existingContainer) existingContainer.style.display = 'block';
        }
    }

    function removeImage() {
        var input = document.querySelector('input[name="vehicleImage"]');
        var container = document.getElementById('imagePreviewContainer');
        var preview = document.getElementById('imagePreview');
        var existingContainer = document.getElementById('existingImageContainer');
        input.value = '';
        container.style.display = 'none';
        preview.src = '#';
        if (existingContainer) existingContainer.style.display = 'block';
    }

    // ==================== BRAND FUNCTIONS ====================
    function filterBrandList() {
        var input = document.getElementById('brandInput');
        var suggestions = document.getElementById('brandSuggestions');
        var newBrandOption = document.getElementById('newBrandOption');
        var newBrandText = document.getElementById('newBrandText');
        var query = input.value.trim().toLowerCase();

        var items = suggestions.querySelectorAll('.suggestion-item:not(#newBrandOption)');

        var exactMatch = false;
        items.forEach(function(item) {
            var name = item.getAttribute('data-brand-name').toLowerCase();
            if (query === '' || name.includes(query)) {
                item.style.display = 'block';
                if (name === query) exactMatch = true;
            } else {
                item.style.display = 'none';
            }
        });

        if (query !== '' && !exactMatch) {
            newBrandOption.style.display = 'block';
            newBrandText.textContent = query;
            isBrandNew = true;
        } else {
            newBrandOption.style.display = 'none';
            isBrandNew = false;
        }

        suggestions.style.display = 'block';
    }

    function selectBrand(element, brandId, brandName) {
        document.getElementById('brandInput').value = brandName;
        document.getElementById('brandId').value = brandId;
        document.getElementById('brandSelect').value = 'existing';
        document.getElementById('newBrandName').value = '';
        document.getElementById('brandSuggestions').style.display = 'none';
        selectedBrandId = parseInt(brandId);
        isBrandNew = false;

        loadModelsForBrand(selectedBrandId);
        document.getElementById('modelDropdownWrapper').style.display = 'block';
        document.getElementById('modelTextWrapper').style.display = 'none';
        document.getElementById('modelSelect').value = 'existing';
    }

    function addNewBrand() {
        var input = document.getElementById('brandInput');
        var brandName = input.value.trim();
        if (brandName === '') return;

        document.getElementById('newBrandName').value = brandName;
        document.getElementById('brandId').value = '';
        document.getElementById('brandSelect').value = 'new';
        document.getElementById('brandSuggestions').style.display = 'none';
        selectedBrandId = null;
        isBrandNew = true;

        document.getElementById('modelDropdownWrapper').style.display = 'none';
        document.getElementById('modelTextWrapper').style.display = 'block';
        document.getElementById('modelSelect').value = 'new';
        document.getElementById('modelId').value = '';
        document.getElementById('modelTextInput').value = '';
        document.getElementById('newModelName').value = '';
        isModelNew = false;
    }

    function validateBrandSelection() {
        setTimeout(function() {
            var input = document.getElementById('brandInput');
            var suggestions = document.getElementById('brandSuggestions');
            var brandId = document.getElementById('brandId').value;
            var brandName = input.value.trim();

            if (brandName === '') {
                suggestions.style.display = 'none';
                return;
            }

            if (brandId) {
                suggestions.style.display = 'none';
                return;
            }

            if (isBrandNew) {
                suggestions.style.display = 'none';
                return;
            }

            var found = false;
            brandList.forEach(function(b) {
                if (b.name.toLowerCase() === brandName.toLowerCase()) {
                    document.getElementById('brandId').value = b.id;
                    document.getElementById('brandSelect').value = 'existing';
                    selectedBrandId = b.id;
                    found = true;
                    loadModelsForBrand(b.id);
                    document.getElementById('modelDropdownWrapper').style.display = 'block';
                    document.getElementById('modelTextWrapper').style.display = 'none';
                    document.getElementById('modelSelect').value = 'existing';
                }
            });

            if (!found && brandName !== '') {
                addNewBrand();
            }

            suggestions.style.display = 'none';
        }, 200);
    }

    // ==================== MODEL FUNCTIONS ====================
    function loadModelsForBrand(brandId) {
        var models = allModelsData[brandId] || [];
        currentModels = models;
        var select = document.getElementById('modelId');
        select.innerHTML = '<option value="">-- Select Model --</option>';
        for (var i = 0; i < models.length; i++) {
            select.innerHTML += '<option value="' + models[i].id + '">' + models[i].name + '</option>';
        }
        select.innerHTML += '<option value="__new__">+ Add new model</option>';
        select.value = '';
        document.getElementById('modelTextInput').value = '';
        document.getElementById('newModelName').value = '';
        document.getElementById('modelSelect').value = 'existing';
        isModelNew = false;
    }

    function onModelSelectChange() {
        var select = document.getElementById('modelId');
        if (select.value === '__new__') {
            document.getElementById('modelDropdownWrapper').style.display = 'none';
            document.getElementById('modelTextWrapper').style.display = 'block';
            document.getElementById('modelSelect').value = 'new';
            document.getElementById('modelTextInput').value = '';
            document.getElementById('newModelName').value = '';
            isModelNew = true;
        } else {
            document.getElementById('modelSelect').value = 'existing';
            document.getElementById('newModelName').value = '';
            isModelNew = false;
        }
    }

    // Khởi tạo trạng thái ban đầu
    document.addEventListener('DOMContentLoaded', function() {
        var modelTextInput = document.getElementById('modelTextInput');
        if (modelTextInput) {
            modelTextInput.addEventListener('input', function() {
                document.getElementById('newModelName').value = this.value.trim();
            });
        }

        var brandId = '<%= currentBrandId != null ? currentBrandId : "" %>';
        var newBrand = '<%= newBrandName != null ? newBrandName : "" %>';
        var newModel = '<%= newModelName != null ? newModelName : "" %>';

        if (brandId) {
            var brand = brandList.find(function(b) { return b.id == brandId; });
            if (brand) {
                document.getElementById('brandInput').value = brand.name;
                document.getElementById('brandId').value = brandId;
                document.getElementById('brandSelect').value = 'existing';
                selectedBrandId = brandId;
                loadModelsForBrand(brandId);
                document.getElementById('modelDropdownWrapper').style.display = 'block';
                document.getElementById('modelTextWrapper').style.display = 'none';
                document.getElementById('modelSelect').value = 'existing';

                var modelId = '<%= currentModelId != null ? currentModelId : "" %>';
                if (modelId) {
                    document.getElementById('modelId').value = modelId;
                }
            }
        } else if (newBrand) {
            document.getElementById('brandInput').value = newBrand;
            document.getElementById('newBrandName').value = newBrand;
            document.getElementById('brandSelect').value = 'new';
            isBrandNew = true;
            selectedBrandId = null;

            document.getElementById('modelDropdownWrapper').style.display = 'none';
            document.getElementById('modelTextWrapper').style.display = 'block';
            document.getElementById('modelSelect').value = 'new';
            if (newModel) {
                document.getElementById('modelTextInput').value = newModel;
                document.getElementById('newModelName').value = newModel;
                isModelNew = true;
            }
        } else {
            document.getElementById('modelDropdownWrapper').style.display = 'block';
            document.getElementById('modelTextWrapper').style.display = 'none';
            document.getElementById('modelSelect').value = 'existing';
        }
    });

    document.addEventListener('click', function(e) {
        if (!e.target.closest('#brandInput') && !e.target.closest('#brandSuggestions')) {
            document.getElementById('brandSuggestions').style.display = 'none';
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.getElementById('brandSuggestions').style.display = 'none';
        }
    });
</script>

<jsp:include page="/components/footer.jsp"/>