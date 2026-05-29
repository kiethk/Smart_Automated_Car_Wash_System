<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New Vehicle - AutoWash Pro</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
            .btn-primary {
                background: linear-gradient(135deg, #1f108e 0%, #0060ac 100%);
                color: white;
                font-weight: 600;
                padding: 10px 24px;
                border-radius: 8px;
                transition: all 0.2s;
            }
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            .btn-secondary {
                border: 1px solid #e2e8f0;
                color: #1f108e;
                font-weight: 600;
                padding: 10px 24px;
                border-radius: 8px;
                background: white;
                transition: all 0.2s;
            }
            .btn-secondary:hover {
                background: #f8fafc;
            }
            .form-input {
                width: 100%;
                padding: 10px 16px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                outline: none;
                transition: all 0.2s;
            }
            .form-input:focus {
                border-color: #1f108e;
            }
            .form-label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 6px;
            }
        </style>
    </head>
    <body class="bg-slate-50">
        <jsp:include page="/components/header.jsp"/>
        <!-- Main -->
        <main class="py-12 px-6">
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
                <c:if test="${not empty param.error}">
                    <div class="mb-6 bg-red-50 border border-red-200 p-4 rounded-lg">
                        <span class="text-red-700 text-sm">Please fill all information</span>
                    </div>
                </c:if>

                <!-- Form -->
                <form action="${pageContext.request.contextPath}/addVehicle" method="POST" class="bg-white rounded-xl shadow-sm border border-slate-200">
                    <div class="p-6 space-y-5">

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                            <!-- License Plate -->
                            <div>
                                <label class="form-label">License Plate Number *</label>
                                <input type="text" name="plateNumber" class="form-input" required>
                            </div>

                            <!-- Brand -->
                            <div>
                                <label class="form-label">Brand</label>
                                <input type="text" name="brand" class="form-input">
                            </div>

                            <!-- Model -->
                            <div>
                                <label class="form-label">Model</label>
                                <input type="text" name="model" class="form-input">
                            </div>

                            <!-- Vehicle Type -->
                            <div>
                                <label class="form-label">Vehicle Category *</label>
                                <select name="vehicleType" class="form-input" required>
                                    <option value="" disabled selected>Select type</option>
                                    <option value="Sedan">Sedan</option>
                                    <option value="SUV">SUV</option>
                                    <option value="Truck">Truck / Pickup</option>
                                </select>
                            </div>

                            <!-- Color -->
                            <div>
                                <label class="form-label">Color</label>
                                <input type="text" name="color" class="form-input">
                            </div>

                            <!-- Year -->
                            <div>
                                <label class="form-label">Manufacture Year</label>
                                <input type="number" name="manufactureYear" class="form-input" min="1900" max="2026">
                            </div>

                        </div>

                    </div>

                    <!-- Buttons -->
                    <div class="p-6 bg-slate-50 border-t border-slate-200 flex gap-4">
                        <button type="submit" class="btn-primary flex items-center gap-2">
                            <i data-lucide="plus" class="w-4 h-4"></i>
                            Add Vehicle
                        </button>
                        <a href="${pageContext.request.contextPath}/vehicles" class="btn-secondary">
                            Cancel
                        </a>
                    </div>
                </form>

            </div>
        </main>

        <jsp:include page="/components/footer.jsp"/>
        <script>
            lucide.createIcons();
        </script>
    </body>
</html>