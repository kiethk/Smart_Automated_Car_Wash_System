package model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Booking {
    private int bookingId;
    private Date bookingDate;
    private Time appointmentTime;
    private long discountAmount;
    private long totalAmount;
    private int pointsEarned;
    private String status; // pending, confirmed, completed, cancelled
    private String notes;
    private Timestamp createdAt;
    private int customerId;
    private int vehicleId;
    private int bayId;
    private Integer promotionId; // Dùng Integer thay vì int để có thể nhận giá trị null

    public Booking() {}

    public Booking(int bookingId, Date bookingDate, Time appointmentTime, long discountAmount, long totalAmount, int pointsEarned, String status, String notes, Timestamp createdAt, int customerId, int vehicleId, int bayId, Integer promotionId) {
        this.bookingId = bookingId;
        this.bookingDate = bookingDate;
        this.appointmentTime = appointmentTime;
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
    
    

    // Getter và Setter
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    public Time getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(Time appointmentTime) { this.appointmentTime = appointmentTime; }
    public long getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(long discountAmount) { this.discountAmount = discountAmount; }
    public long getTotalAmount() { return totalAmount; }
    public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }
    public int getPointsEarned() { return pointsEarned; }
    public void setPointsEarned(int pointsEarned) { this.pointsEarned = pointsEarned; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }
    public int getBayId() { return bayId; }
    public void setBayId(int bayId) { this.bayId = bayId; }
    public Integer getPromotionId() { return promotionId; }
    public void setPromotionId(Integer promotionId) { this.promotionId = promotionId; }
}