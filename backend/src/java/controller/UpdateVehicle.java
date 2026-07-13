package controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import dao.CustomerDAO;
import dao.VehicleDAO;
import dao.BrandDAO;
import dao.ModelDAO;
import dto.Brand;
import dto.Customer;
import dto.Model;
import dto.User;
import dto.Vehicle;

@WebServlet("/updateVehicle")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10,
    fileSizeThreshold = 1024 * 1024
)
public class UpdateVehicle extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private VehicleDAO vehicleDAO;
    private CustomerDAO customerDAO;
    private BrandDAO brandDAO;
    private ModelDAO modelDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        vehicleDAO = new VehicleDAO();
        customerDAO = new CustomerDAO();
        brandDAO = new BrandDAO();
        modelDAO = new ModelDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        User currentUser = (User) session.getAttribute("USER");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

        String vehicleIdStr = request.getParameter("id");
        if (isNullOrBlank(vehicleIdStr)) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
            return;
        }

        try {
            int vehicleId = Integer.parseInt(vehicleIdStr);
            if (customer == null || !vehicleDAO.isVehicleBelongsToCustomer(vehicleId, customer.getCustomerId())) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
                return;
            }

            Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);
            request.setAttribute("vehicle", vehicle);

            List<Brand> brands = brandDAO.getAllBrands();
            request.setAttribute("brands", brands);
            if (brands != null) {
                for (Brand brand : brands) {
                    List<Model> models = modelDAO.getModelsByBrandId(brand.getBrandId());
                    request.setAttribute("models_" + brand.getBrandId(), models);
                }
            }

            if (vehicle.getBrandDisplay() != null && !"Other".equals(vehicle.getBrandDisplay())) {
                Brand brand = brandDAO.getBrandByName(vehicle.getBrandDisplay());
                if (brand != null) {
                    request.setAttribute("currentBrandId", brand.getBrandId());
                    request.setAttribute("currentModelId", vehicle.getModelId());
                }
            }

            request.getRequestDispatcher("views/auth/vehicle/UpdateVehicle.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        User currentUser = (User) session.getAttribute("USER");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

        String vehicleIdStr = request.getParameter("vehicleId");
        if (isNullOrBlank(vehicleIdStr)) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
            return;
        }
        int vehicleId = Integer.parseInt(vehicleIdStr);

        String plateNumber = request.getParameter("plateNumber");
        String brandSelect = request.getParameter("brandSelect");
        String modelSelect = request.getParameter("modelSelect");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("color");
        String manufactureYearStr = request.getParameter("manufactureYear");
        String brandIdStr = request.getParameter("brandId");
        String modelIdStr = request.getParameter("modelId");
        String newBrandName = request.getParameter("newBrandName");
        String newModelName = request.getParameter("newModelName");

        // Lấy vehicle cũ để giữ ảnh nếu không upload mới
        Vehicle oldVehicle = vehicleDAO.getVehicleById(vehicleId);
        String imageUrl = oldVehicle.getVehicleImageUrl(); // mặc định giữ ảnh cũ

        // Xử lý upload ảnh mới
        Part filePart = request.getPart("vehicleImage");
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            String fileName = "vehicle_" + plateNumber.trim().replaceAll("[-\\s]", "_") + "_" + System.currentTimeMillis() + ".jpg";
            String filePath = uploadPath + fileName;
            filePart.write(filePath);
            imageUrl = request.getContextPath() + "/uploads/" + fileName;
        }

        // Nếu không có ảnh (cả cũ và mới), dùng default
        if (imageUrl == null) {
            imageUrl = request.getContextPath() + "/assets/images/default-car.png";
        }

        // Khởi tạo vehicle
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(vehicleId);
        vehicle.setPlateNumber(plateNumber);
        vehicle.setVehicleType(vehicleType);
        vehicle.setColor(color);
        vehicle.setCustomerId(customer.getCustomerId());
        vehicle.setVehicleImageUrl(imageUrl);

        int manufactureYear = 0;
        String errorMsg = null;

        // Validation
        if (isNullOrBlank(plateNumber)) {
            errorMsg = "Plate number is required";
        } else if (isNullOrBlank(vehicleType)) {
            errorMsg = "Vehicle type is required";
        } else if (vehicleDAO.isPlateNumberExistsExcludeSelf(plateNumber.trim().toUpperCase(), vehicleId)) {
            errorMsg = "Plate number already exists";
        } else if (!isNullOrBlank(manufactureYearStr)) {
            try {
                manufactureYear = Integer.parseInt(manufactureYearStr);
                if (manufactureYear < 1900 || manufactureYear > 2026) {
                    errorMsg = "Manufacture year must be between 1900 and 2026";
                }
            } catch (NumberFormatException e) {
                errorMsg = "Invalid year format";
            }
        }

        if (errorMsg != null) {
            reloadData(request);
            request.setAttribute("ERROR", errorMsg);
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("views/auth/vehicle/UpdateVehicle.jsp").forward(request, response);
            return;
        }

        // Xử lý brand/model
        Integer modelId = null;
        String customBrandName = null;
        String customModelName = null;

        try {
            if ("existing".equals(brandSelect) && "existing".equals(modelSelect)) {
                if (modelIdStr != null && !modelIdStr.trim().isEmpty()) {
                    modelId = Integer.parseInt(modelIdStr);
                } else {
                    errorMsg = "Please select a model";
                }
            } else if ("new".equals(brandSelect) && "new".equals(modelSelect)) {
                if (isNullOrBlank(newBrandName)) {
                    errorMsg = "Please enter new brand name";
                } else if (isNullOrBlank(newModelName)) {
                    errorMsg = "Please enter new model name";
                } else {
                    customBrandName = newBrandName.trim();
                    customModelName = newModelName.trim();
                    modelId = modelDAO.addBrandAndModel(customBrandName, customModelName);
                    if (modelId == -1) {
                        errorMsg = "Failed to create new brand/model";
                    }
                }
            } else if ("existing".equals(brandSelect) && "new".equals(modelSelect)) {
                if (isNullOrBlank(brandIdStr)) {
                    errorMsg = "Please select a brand";
                } else if (isNullOrBlank(newModelName)) {
                    errorMsg = "Please enter new model name";
                } else {
                    int brandId = Integer.parseInt(brandIdStr);
                    customModelName = newModelName.trim();
                    modelId = modelDAO.addModel(customModelName, brandId);
                    if (modelId == -1) {
                        errorMsg = "Failed to create new model for selected brand";
                    }
                }
            } else {
                errorMsg = "Invalid brand/model selection";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Invalid input format";
            e.printStackTrace();
        } catch (Exception e) {
            errorMsg = "Error: " + e.getMessage();
            e.printStackTrace();
        }

        if (errorMsg != null) {
            reloadData(request);
            request.setAttribute("ERROR", errorMsg);
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("views/auth/vehicle/UpdateVehicle.jsp").forward(request, response);
            return;
        }

        // Cập nhật vehicle
        vehicle.setManufactureYear(manufactureYear);
        vehicle.setModelId(modelId);
        vehicle.setCustomBrandName(customBrandName);
        vehicle.setCustomModelName(customModelName);
        vehicle.setPlateNumber(plateNumber.trim().toUpperCase());

        if (vehicleDAO.updateVehicle(vehicle)) {
            session.setAttribute("SUCCESS", "Vehicle updated successfully!");
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
        } else {
            reloadData(request);
            request.setAttribute("ERROR", "Database error, please try again");
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("views/auth/vehicle/UpdateVehicle.jsp").forward(request, response);
        }
    }

    private boolean isNullOrBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void reloadData(HttpServletRequest request) {
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("brands", brands);
        if (brands != null) {
            for (Brand brand : brands) {
                List<Model> models = modelDAO.getModelsByBrandId(brand.getBrandId());
                request.setAttribute("models_" + brand.getBrandId(), models);
            }
        }
    }
}