package dto;

public class Bay {
    private int bayId;
    private String bayName;
    private String status; // available, occupied, maintenance
    private int capacityPerHour;

    public Bay() {}

    public Bay(int bayId, String bayName, String status, int capacityPerHour) {
        this.bayId = bayId;
        this.bayName = bayName;
        this.status = status;
        this.capacityPerHour = capacityPerHour;
    }
    
    

    // Getters and Setters
    public int getBayId() { return bayId; }
    public void setBayId(int bayId) { this.bayId = bayId; }
    public String getBayName() { return bayName; }
    public void setBayName(String bayName) { this.bayName = bayName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getCapacityPerHour() { return capacityPerHour; }
    public void setCapacityPerHour(int capacityPerHour) { this.capacityPerHour = capacityPerHour; }
}