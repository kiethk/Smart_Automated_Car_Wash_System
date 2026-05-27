package dto;

import java.sql.Timestamp;

public class WashHistory {
    private int washHistoryId;
    private Timestamp startTime;
    private Timestamp endTime;
    private String washStatus; // pending, washing, completed, cancelled
    private String lprImageUrl; // Nhận chuỗi URL ảnh hoặc NULL
    private String notes;
    private int bookingId;
    private int bayId;

    public WashHistory() {}

    public WashHistory(int washHistoryId, Timestamp startTime, Timestamp endTime, String washStatus, String lprImageUrl, String notes, int bookingId, int bayId) {
        this.washHistoryId = washHistoryId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.washStatus = washStatus;
        this.lprImageUrl = lprImageUrl;
        this.notes = notes;
        this.bookingId = bookingId;
        this.bayId = bayId;
    }
    
    

    // Getters and Setters
    public int getWashHistoryId() { return washHistoryId; }
    public void setWashHistoryId(int washHistoryId) { this.washHistoryId = washHistoryId; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    public String getWashStatus() { return washStatus; }
    public void setWashStatus(String washStatus) { this.washStatus = washStatus; }
    public String getLprImageUrl() { return lprImageUrl; }
    public void setLprImageUrl(String lprImageUrl) { this.lprImageUrl = lprImageUrl; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getBayId() { return bayId; }
    public void setBayId(int bayId) { this.bayId = bayId; }
}