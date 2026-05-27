package dto;

public class Vehicle {
    private int vehicleId;
    private String plateNumber;
    private String brand;
    private String model;
    private String vehicleType;
    private String color;
    private int manufactureYear;
    private int customerId;

    public Vehicle() {}

    public Vehicle(int vehicleId, String plateNumber, String brand, String model, String vehicleType, String color, int manufactureYear, int customerId) {
        this.vehicleId = vehicleId;
        this.plateNumber = plateNumber;
        this.brand = brand;
        this.model = model;
        this.vehicleType = vehicleType;
        this.color = color;
        this.manufactureYear = manufactureYear;
        this.customerId = customerId;
    }
    
    

    // Getters and Setters
    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }
    public String getPlateNumber() { return plateNumber; }
    public void setPlateNumber(String plateNumber) { this.plateNumber = plateNumber; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public int getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(int manufactureYear) { this.manufactureYear = manufactureYear; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
}