package dto;

import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private String paymentMethod; // cash, credit_card, wallet, momo, vnpay
    private String paymentStatus; // pending, completed, failed, refunded
    private long amount;          // BIGINT -> long
    private Timestamp paidAt;     // Chấp nhận NULL nếu chưa thanh toán xong
    private String transactionId; // Mã giao dịch đối soát bên thứ ba
    private int bookingId;

    public Payment() {}

    public Payment(int paymentId, String paymentMethod, String paymentStatus, long amount, Timestamp paidAt, String transactionId, int bookingId) {
        this.paymentId = paymentId;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.amount = amount;
        this.paidAt = paidAt;
        this.transactionId = transactionId;
        this.bookingId = bookingId;
    }
    
    

    // Getters and Setters
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
}
