package dto;

import java.sql.Timestamp;

public class WalletTransaction {
    private int transactionId;
    private long amount; // BIGINT -> long (dương: nạp, âm: trừ)
    private String type; // deposit, payment, refund
    private String description;
    private Timestamp createdAt;
    private int walletId;
    private Integer bookingId; // Khóa ngoại có thể NULL (nếu là giao dịch nạp tiền thuần túy)

    public WalletTransaction() {}

    public WalletTransaction(int transactionId, long amount, String type, String description, Timestamp createdAt, int walletId, Integer bookingId) {
        this.transactionId = transactionId;
        this.amount = amount;
        this.type = type;
        this.description = description;
        this.createdAt = createdAt;
        this.walletId = walletId;
        this.bookingId = bookingId;
    }

    // Getters and Setters
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }
    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public int getWalletId() { return walletId; }
    public void setWalletId(int walletId) { this.walletId = walletId; }
    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }
}