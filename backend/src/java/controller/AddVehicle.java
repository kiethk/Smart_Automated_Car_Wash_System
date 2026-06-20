package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
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

@WebServlet("/addVehicle")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,      // 5MB
    maxRequestSize = 1024 * 1024 * 10,  // 10MB
    fileSizeThreshold = 1024 * 1024
)
public class AddVehicle extends HttpServlet {

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

        // Lấy danh sách brand
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("brands", brands);

        // Load models cho từng brand
        if (brands != null) {
            for (Brand brand : brands) {
                List<Model> models = modelDAO.getModelsByBrandId(brand.getBrandId());
                request.setAttribute("models_" + brand.getBrandId(), models);
            }
        }

        request.getRequestDispatcher("views/auth/vehicle/AddVehicle.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=home");
            return;
        }

        // Lấy tham số
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

        // Xử lý upload ảnh
        String imageUrl = null;
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

        // Nếu không có ảnh, dùng default
        if (imageUrl == null) {
            imageUrl = request.getContextPath() + "/assets/images/default-car.png";
        }

        // Khởi tạo vehicle và validation
        Vehicle vehicle = new Vehicle();
        vehicle.setPlateNumber(plateNumber);
        vehicle.setVehicleType(vehicleType);
        vehicle.setColor(color);
        vehicle.setVehicleImageUrl(imageUrl);

        int manufactureYear = 0;
        String errorMsg = null;

        try {
            if (plateNumber == null || plateNumber.trim().isEmpty()) {
                errorMsg = "Plate number is required";
            } else if (vehicleType == null || vehicleType.trim().isEmpty()) {
                errorMsg = "Vehicle type is required";
            } else if (manufactureYearStr != null && !manufactureYearStr.trim().isEmpty()) {
                manufactureYear = Integer.parseInt(manufactureYearStr);
                if (manufactureYear < 1900 || manufactureYear > 2026) {
                    errorMsg = "Manufacture year must be between 1900 and 2026";
                }
            }

            if (errorMsg == null && vehicleDAO.isPlateNumberExists(plateNumber.trim().toUpperCase())) {
                errorMsg = "Plate number already exists";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Invalid manufacture year format";
        }

        if (errorMsg != null) {
            // Reload data và forward
            reloadData(request);
            request.setAttribute("ERROR", errorMsg);
            request.setAttribute("vehicle", vehicle);
            request.setAttribute("manufactureYear", manufactureYearStr);
            request.setAttribute("brandSelect", brandSelect);
            request.setAttribute("modelSelect", modelSelect);
            request.getRequestDispatcher("views/auth/vehicle/AddVehicle.jsp").forward(request, response);
            return;
        }

        // Xử lý brand/model
        User currentUser = (User) session.getAttribute("USER");
        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());

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
                if (newBrandName == null || newBrandName.trim().isEmpty()) {
                    errorMsg = "Please enter new brand name";
                } else if (newModelName == null || newModelName.trim().isEmpty()) {
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
                if (brandIdStr == null || brandIdStr.trim().isEmpty()) {
                    errorMsg = "Please select a brand";
                } else if (newModelName == null || newModelName.trim().isEmpty()) {
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
            errorMsg = "System error: " + e.getMessage();
            e.printStackTrace();
        }

        if (errorMsg != null) {
            reloadData(request);
            request.setAttribute("ERROR", errorMsg);
            request.setAttribute("vehicle", vehicle);
            request.setAttribute("manufactureYear", manufactureYearStr);
            request.setAttribute("brandSelect", brandSelect);
            request.setAttribute("modelSelect", modelSelect);
            request.getRequestDispatcher("views/auth/vehicle/AddVehicle.jsp").forward(request, response);
            return;
        }

        // Lưu vehicle
        vehicle.setPlateNumber(plateNumber.trim().toUpperCase());
        vehicle.setManufactureYear(manufactureYear);
        vehicle.setCustomerId(customer.getCustomerId());
        vehicle.setModelId(modelId);
        vehicle.setCustomBrandName(customBrandName);
        vehicle.setCustomModelName(customModelName);

        if (vehicleDAO.addVehicle(vehicle)) {
            session.setAttribute("SUCCESS", "Vehicle added successfully!");
            response.sendRedirect(request.getContextPath() + "/MainController?action=profile");
        } else {
            reloadData(request);
            request.setAttribute("ERROR", "Database error, please try again");
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("views/auth/vehicle/AddVehicle.jsp").forward(request, response);
        }
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