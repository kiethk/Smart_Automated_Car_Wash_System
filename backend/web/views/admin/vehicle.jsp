<%@page import="dao.VehicleDAO"%>
<%@page import="dto.Vehicle"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("VEHICLES");
    VehicleDAO.VehicleStatistics stats = (VehicleDAO.VehicleStatistics) request.getAttribute("STATISTICS");
    Vehicle vehicleDetail = (Vehicle) request.getAttribute("VEHICLE_DETAIL");

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
                                Vehicle Management
                            </h2>
                            <p class="text-sm text-slate-500 mt-1">
                                Manage all customer vehicles in the system.
                            </p>
                        </div>

                        <div class="flex items-center gap-3">
                            <div class="px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-sm font-bold text-slate-700">
                                Total: <%= vehicles != null ? vehicles.size() : 0%> vehicles
                            </div>
                        </div>
                    </div>

                    <% if ("status_updated".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Vehicle status updated successfully.
                    </div>
                    <% } else if ("deleted".equals(msg)) { %>
                    <div class="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-5 py-3 text-sm font-semibold text-emerald-700">
                        Vehicle deleted successfully.
                    </div>
                    <% } %>

                    <% if (error != null) { %>
                    <div class="mb-5 rounded-2xl border border-red-200 bg-red-50 px-5 py-3 text-sm font-semibold text-red-600">
                        Something went wrong. Please try again.
                    </div>
                    <% }%>

                    <!-- Statistics Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-6">
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Total Vehicles</p>
                            <p class="text-2xl font-extrabold text-slate-900 mt-2"><%= stats != null ? stats.getTotalVehicles() : 0%></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Active</p>
                            <p class="text-2xl font-extrabold text-emerald-600 mt-2"><%= stats != null ? stats.getActiveVehicles() : 0%></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Inactive</p>
                            <p class="text-2xl font-extrabold text-red-500 mt-2"><%= stats != null ? stats.getInactiveVehicles() : 0%></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Customers with Vehicles</p>
                            <p class="text-2xl font-extrabold text-slate-900 mt-2"><%= stats != null ? stats.getCustomersWithVehicles() : 0%></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm">
                            <p class="text-sm font-semibold text-slate-500">Total Models</p>
                            <p class="text-2xl font-extrabold text-slate-900 mt-2"><%= stats != null ? stats.getTotalModels() : 0%></p>
                        </div>
                    </div>

                    <!-- Search and Filter -->
                    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-4 mb-6">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/vehicles" class="flex flex-wrap gap-4">
                            <div class="flex-1 min-w-[200px]">
                                <input type="text" name="keyword" placeholder="Search by plate, brand, model..." 
                                       value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : ""%>"
                                       class="w-full px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                            </div>
                            <div>
                                <select name="type" class="px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <option value="">All Types</option>
                                    <option value="Sedan" <%= "Sedan".equals(request.getParameter("type")) ? "selected" : ""%>>Sedan</option>
                                    <option value="SUV" <%= "SUV".equals(request.getParameter("type")) ? "selected" : ""%>>SUV</option>
                                    <option value="Truck" <%= "Truck".equals(request.getParameter("type")) ? "selected" : ""%>>Truck</option>
                                </select>
                            </div>
                            <div>
                                <select name="status" class="px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                                    <option value="">All Status</option>
                                    <option value="1" <%= "1".equals(request.getParameter("status")) ? "selected" : ""%>>Active</option>
                                    <option value="0" <%= "0".equals(request.getParameter("status")) ? "selected" : ""%>>Inactive</option>
                                </select>
                            </div>
                            <div>
                                <button type="submit" class="px-4 py-2.5 rounded-2xl bg-indigo-600 text-white text-sm font-bold hover:bg-indigo-700 transition-all">
                                    Search
                                </button>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/admin/vehicles" class="inline-flex px-4 py-2.5 rounded-2xl bg-slate-100 text-slate-700 text-sm font-bold hover:bg-slate-200 transition-all">
                                    Reset
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Vehicle Table -->
                    <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="px-5 py-4 border-b border-slate-100 flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                            <div>
                                <h3 class="text-lg font-bold text-slate-900">
                                    Vehicle List
                                </h3>
                                <p class="text-sm text-slate-400">
                                    Manage all customer vehicles
                                </p>
                            </div>

                            <input type="text"
                                   id="vehicleSearch"
                                   placeholder="Search vehicle..."
                                   onkeyup="filterVehicles()"
                                   class="w-full md:w-72 px-4 py-2.5 rounded-2xl border border-slate-200 text-sm outline-none focus:border-indigo-400 focus:ring-4 focus:ring-indigo-50">
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-slate-50 text-slate-500">
                                    <tr>
                                        <th class="px-5 py-3 text-left font-bold">Image</th>
                                        <th class="px-5 py-3 text-left font-bold">Plate</th>
                                        <th class="px-5 py-3 text-left font-bold">Brand</th>
                                        <th class="px-5 py-3 text-left font-bold">Model</th>
                                        <th class="px-5 py-3 text-left font-bold">Type</th>
                                        <th class="px-5 py-3 text-left font-bold">Color</th>
                                        <th class="px-5 py-3 text-center font-bold">Year</th>
                                        <th class="px-5 py-3 text-center font-bold">Status</th>
                                        <th class="px-5 py-3 text-right font-bold">Actions</th>
                                    </tr>
                                </thead>

                                <tbody id="vehicleTableBody" class="divide-y divide-slate-100">
                                    <% if (vehicles == null || vehicles.isEmpty()) { %>
                                    <tr>
                                        <td colspan="9" class="px-5 py-10 text-center text-slate-400">
                                            No vehicles found.
                                        </td>
                                    </tr>
                                    <% } else { %>

                                    <% for (Vehicle v : vehicles) {
                                        String imageUrl = (v.getVehicleImageUrl() != null && !v.getVehicleImageUrl().trim().isEmpty()) 
                                                ? v.getVehicleImageUrl() 
                                                : request.getContextPath() + "/assets/images/no-image-car.jpg";
                                    %>
                                    <tr class="vehicle-row hover:bg-slate-50 transition-colors">
                                        <td class="px-5 py-4">
                                            <img src="<%= imageUrl %>" class="w-12 h-12 object-cover rounded">
                                        </td>

                                        <td class="px-5 py-4 font-bold text-slate-900">
                                            <%= v.getPlateNumber()%>
                                        </td>

                                        <td class="px-5 py-4 text-slate-600">
                                            <%= v.getBrandDisplay()%>
                                        </td>

                                        <td class="px-5 py-4 text-slate-600">
                                            <%= v.getModelDisplay()%>
                                        </td>

                                        <td class="px-5 py-4 text-slate-600">
                                            <%= v.getVehicleType()%>
                                        </td>

                                        <td class="px-5 py-4 text-slate-600">
                                            <%= v.getColor()%>
                                        </td>

                                        <td class="px-5 py-4 text-center text-slate-600">
                                            <%= v.getManufactureYear()%>
                                        </td>

                                        <td class="px-5 py-4 text-center">
                                            <% if (v.getIsActive() == 1) { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-emerald-50 text-emerald-600 text-xs font-bold">
                                                Active
                                            </span>
                                            <% } else { %>
                                            <span class="inline-flex px-3 py-1 rounded-full bg-red-50 text-red-500 text-xs font-bold">
                                                Inactive
                                            </span>
                                            <% }%>
                                        </td>

                                        <td class="px-5 py-4">
                                            <div class="flex items-center justify-end gap-2">
                                                <form action="${pageContext.request.contextPath}/admin/vehicles"
                                                      method="post"
                                                      onsubmit="return confirm('Are you sure you want to change this vehicle status?');">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="vehicleId" value="<%= v.getVehicleId()%>">
                                                    <input type="hidden" name="currentStatus" value="<%= v.getIsActive()%>">

                                                    <button type="submit"
                                                            class="px-3 py-2 rounded-xl <%= v.getIsActive() == 1 ? "bg-red-50 text-red-500 hover:bg-red-100" : "bg-emerald-50 text-emerald-600 hover:bg-emerald-100"%> text-xs font-bold transition-all">
                                                        <%= v.getIsActive() == 1 ? "Disable" : "Enable"%>
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
            function filterVehicles() {
                const keyword = document.getElementById("vehicleSearch").value.toLowerCase();
                const rows = document.querySelectorAll(".vehicle-row");

                rows.forEach(row => {
                    const plate = row.querySelector("td:nth-child(2)").innerText.toLowerCase();
                    const brand = row.querySelector("td:nth-child(3)").innerText.toLowerCase();
                    const model = row.querySelector("td:nth-child(4)").innerText.toLowerCase();

                    if (plate.includes(keyword) || brand.includes(keyword) || model.includes(keyword)) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            }
        </script>
    </body>
</html>