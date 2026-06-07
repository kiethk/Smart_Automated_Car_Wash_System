package dto;

public class Vehicle {
    private int vehicleId;
    private String plateNumber;
    private int modelId;
    private String vehicleType;
    private String color;
    private int manufactureYear;
    private int customerId;
    private int isActive;
    private String vehicleImageUrl;
    private String customBrandName; // Hãng tự nhập khi không có trong danh sách
    private String customModelName; // Dòng xe tự nhập khi không có trong danh sách

    // Các trường bổ trợ từ VIEW VehicleDetail (JOIN Brand + Model)
    private String brandDisplay;
    private String modelDisplay;

    public Vehicle() {}

    public Vehicle(int vehicleId, String plateNumber, int modelId, String vehicleType, String color,
                   int manufactureYear, int customerId, int isActive, String vehicleImageUrl,
                   String customBrandName, String customModelName,
                   String brandDisplay, String modelDisplay) {
        this.vehicleId = vehicleId;
        this.plateNumber = plateNumber;
        this.modelId = modelId;
        this.vehicleType = vehicleType;
        this.color = color;
        this.manufactureYear = manufactureYear;
        this.customerId = customerId;
        this.isActive = isActive;
        this.vehicleImageUrl = vehicleImageUrl;
        this.customBrandName = customBrandName;
        this.customModelName = customModelName;
        this.brandDisplay = brandDisplay;
        this.modelDisplay = modelDisplay;
    }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public String getPlateNumber() { return plateNumber; }
    public void setPlateNumber(String plateNumber) { this.plateNumber = plateNumber; }

    public int getModelId() { return modelId; }
    public void setModelId(int modelId) { this.modelId = modelId; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public int getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(int manufactureYear) { this.manufactureYear = manufactureYear; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }

    public String getVehicleImageUrl() { return vehicleImageUrl; }
    public void setVehicleImageUrl(String vehicleImageUrl) { this.vehicleImageUrl = vehicleImageUrl; }

    public String getCustomBrandName() { return customBrandName; }
    public void setCustomBrandName(String customBrandName) { this.customBrandName = customBrandName; }

    public String getCustomModelName() { return customModelName; }
    public void setCustomModelName(String customModelName) { this.customModelName = customModelName; }

    public String getBrandDisplay() { return brandDisplay; }
    public void setBrandDisplay(String brandDisplay) { this.brandDisplay = brandDisplay; }

    public String getModelDisplay() { return modelDisplay; }
    public void setModelDisplay(String modelDisplay) { this.modelDisplay = modelDisplay; }

    @Override
    public String toString() {
        return "Vehicle{vehicleId=" + vehicleId + ", plateNumber=" + plateNumber
                + ", brandDisplay=" + brandDisplay + ", modelDisplay=" + modelDisplay
                + ", vehicleType=" + vehicleType + ", color=" + color + "}";
    }
}