package dto;

import java.sql.Date;
import java.sql.Timestamp;

public class LoyaltyPointHistory {
    private int pointHistoryId;
    private int pointsEarned;
    private int pointsUsed;
    private String transactionType; // earned, redeemed, expired
    private String description;
    private Date expiredDate;       // Chấp nhận NULL
    private Timestamp createdAt;
    private int customerId;

    public LoyaltyPointHistory() {}

    public LoyaltyPointHistory(int pointHistoryId, int pointsEarned, int pointsUsed, String transactionType, String description, Date expiredDate, Timestamp createdAt, int customerId) {
        this.pointHistoryId = pointHistoryId;
        this.pointsEarned = pointsEarned;
        this.pointsUsed = pointsUsed;
        this.transactionType = transactionType;
        this.description = description;
        this.expiredDate = expiredDate;
        this.createdAt = createdAt;
        this.customerId = customerId;
    }
    
    

    // Getters and Setters
    public int getPointHistoryId() { return pointHistoryId; }
    public void setPointHistoryId(int pointHistoryId) { this.pointHistoryId = pointHistoryId; }
    public int getPointsEarned() { return pointsEarned; }
    public void setPointsEarned(int pointsEarned) { this.pointsEarned = pointsEarned; }
    public int getPointsUsed() { return pointsUsed; }
    public void setPointsUsed(int pointsUsed) { this.pointsUsed = pointsUsed; }
    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Date getExpiredDate() { return expiredDate; }
    public void setExpiredDate(Date expiredDate) { this.expiredDate = expiredDate; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
}