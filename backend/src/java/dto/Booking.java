package dto;

import java.sql.Timestamp;

public class Booking {

    private int bookingId;
    private String bookingDate; // Sử dụng String để dễ dàng đồng bộ định dạng 'YYYY-MM-DD' với Form HTML/JSP
    private int slotId;
    private long discountAmount;
    private long totalAmount;
    private int pointsEarned;
    private String status;
    private String notes;
    private Timestamp createdAt; // Định dạng DATETIME trong SQL Server ánh xạ sang Timestamp trong Java
    private Integer customerId;  // Sử dụng Integer (Wrapper class) để chấp nhận giá trị NULL trong DB nếu cần
    private Integer vehicleId;// Sử dụng Integer (Wrapper class) để chấp nhận giá trị NULL trong DB nếu cần

    private Integer bayId;
    private Integer promotionId;

    public Booking() {
    }

    public Booking(int bookingId, String bookingDate, int slotId, long discountAmount, long totalAmount, int pointsEarned, String status, String notes, Timestamp createdAt, Integer customerId, Integer vehicleId, Integer bayId, Integer promotionId) {
        this.bookingId = bookingId;
        this.bookingDate = bookingDate;
        this.slotId = slotId;
        this.discountAmount = discountAmount;
        this.totalAmount = totalAmount;
        this.pointsEarned = pointsEarned;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
        this.customerId = customerId;
        this.vehicleId = vehicleId;
        this.bayId = bayId;
        this.promotionId = promotionId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(String bookingDate) {
        this.bookingDate = bookingDate;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public long getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(long discountAmount) {
        this.discountAmount = discountAmount;
    }

    public long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getPointsEarned() {
        return pointsEarned;
    }

    public void setPointsEarned(int pointsEarned) {
        this.pointsEarned = pointsEarned;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Integer vehicleId) {
        this.vehicleId = vehicleId;
    }

    public Integer getBayId() {
        return bayId;
    }

    public void setBayId(Integer bayId) {
        this.bayId = bayId;
    }

    public Integer getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(Integer promotionId) {
        this.promotionId = promotionId;
    }
}
