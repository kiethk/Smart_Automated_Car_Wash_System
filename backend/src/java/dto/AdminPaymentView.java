package dto;

import java.sql.Timestamp;

public class AdminPaymentView {

    // Từ bảng Payment
    private int paymentId;
    private String paymentMethod;
    private String paymentStatus;
    private long amount;
    private Timestamp paidAt;
    private String transactionId;
    private int bookingId;
    private String checkinImageUrl;
    private String checkoutImageUrl;

    // JOIN từ User (qua Customer → Booking)
    private String customerName;
    private String customerPhone;
    private String customerEmail;

    // JOIN từ Service (qua BookingService)
    private String serviceNames;

    public AdminPaymentView() {}

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getCheckinImageUrl() { return checkinImageUrl; }
    public void setCheckinImageUrl(String checkinImageUrl) { this.checkinImageUrl = checkinImageUrl; }

    public String getCheckoutImageUrl() { return checkoutImageUrl; }
    public void setCheckoutImageUrl(String checkoutImageUrl) { this.checkoutImageUrl = checkoutImageUrl; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getServiceNames() { return serviceNames; }
    public void setServiceNames(String serviceNames) { this.serviceNames = serviceNames; }
}
