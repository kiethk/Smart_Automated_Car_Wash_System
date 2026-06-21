package dto;

import java.sql.Timestamp;

/**
 * DTO này KHÔNG map 1-1 với 1 bảng cụ thể nào.
 * Nó đại diện cho kết quả của câu query JOIN (Booking + Customer + User + Vehicle + Model + Payment)
 * dùng riêng cho trang Booking History.
 *
 * Entity gốc map đúng bảng Booking vẫn là dto.Booking (không đổi).
 */
public class BookingHistoryDTO {

    // ===== Các field gốc lấy từ bảng Booking =====
    private int bookingId;
    private String bookingDate;
    private Timestamp createdAt;
    private Integer customerId;
    private Integer vehicleId;
    private String status;

    // ===== Các field bổ sung, lấy qua JOIN từ các bảng khác =====
    private String customerFullName;   // từ bảng User
    private String customerPhone;      // từ bảng User
    private String customerEmail;      // từ bảng User

    private String paymentMethod;      // từ bảng Payment
    private String checkinImageUrl;    // từ bảng Payment
    private String checkoutImageUrl;   // từ bảng Payment

    private String modelName;          // từ bảng Model (qua Vehicle)
    private String plateNumber;        // từ bảng Vehicle

    public BookingHistoryDTO() {
    }

    // ===== Getter/Setter các field gốc =====
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ===== Getter/Setter các field bổ sung từ JOIN =====
    public String getCustomerFullName() {
        return customerFullName;
    }

    public void setCustomerFullName(String customerFullName) {
        this.customerFullName = customerFullName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getCheckinImageUrl() {
        return checkinImageUrl;
    }

    public void setCheckinImageUrl(String checkinImageUrl) {
        this.checkinImageUrl = checkinImageUrl;
    }

    public String getCheckoutImageUrl() {
        return checkoutImageUrl;
    }

    public void setCheckoutImageUrl(String checkoutImageUrl) {
        this.checkoutImageUrl = checkoutImageUrl;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }
}
