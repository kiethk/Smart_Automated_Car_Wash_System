package dto;

public class Slot {
    private int slotId;
    private String timeValue;
    private String startTime;
    private String endTime;
    private int maxCapacity;
    private int isActive;
    private boolean isFull; // Trường tính toán, không có trong DB

    public Slot() {}

    public Slot(int slotId, String timeValue, String startTime, String endTime,
                int maxCapacity, int isActive, boolean isFull) {
        this.slotId = slotId;
        this.timeValue = timeValue;
        this.startTime = startTime;
        this.endTime = endTime;
        this.maxCapacity = maxCapacity;
        this.isActive = isActive;
        this.isFull = isFull;
    }

    public int getSlotId() { return slotId; }
    public void setSlotId(int slotId) { this.slotId = slotId; }

    public String getTimeValue() { return timeValue; }
    public void setTimeValue(String timeValue) { this.timeValue = timeValue; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public int getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(int maxCapacity) { this.maxCapacity = maxCapacity; }

    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }

    public boolean isFull() { return isFull; }
    public void setFull(boolean isFull) { this.isFull = isFull; }

    @Override
    public String toString() {
        return "Slot{slotId=" + slotId + ", timeValue=" + timeValue
                + ", isActive=" + isActive + ", isFull=" + isFull + "}";
    }
}