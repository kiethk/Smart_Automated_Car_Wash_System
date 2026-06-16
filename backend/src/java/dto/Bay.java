package dto;

public class Bay {
    private int bayId;
    private String bayName;
    private String status; // available | maintenance

    public Bay() {}

    public Bay(int bayId, String bayName, String status) {
        this.bayId = bayId;
        this.bayName = bayName;
        this.status = status;
    }

    public int getBayId() { return bayId; }
    public void setBayId(int bayId) { this.bayId = bayId; }

    public String getBayName() { return bayName; }
    public void setBayName(String bayName) { this.bayName = bayName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Bay{bayId=" + bayId + ", bayName=" + bayName + ", status=" + status + "}";
    }
}