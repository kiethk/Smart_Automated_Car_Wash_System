package dto;

import java.sql.Date;

public class Customer {
    private int customerId;
    private String address;
    private int totalPoints;
    private long totalSpent;
    private int totalWashes;
    private Date joinDate;
    private Date dateOfBirth;
    private int userId;
    private int tierId;
    private Date lastReviewDate;

    // ===== THÊM CÁC FIELD HỖ TRỢ HIỂN THỊ (KHÔNG LƯU DB) =====
    private String tierName;
    private double pointMultiplier;
    private String fullName;

    public Customer() {}

    public Customer(int customerId, String address, int totalPoints, long totalSpent, 
                    int totalWashes, Date joinDate, Date dateOfBirth, 
                    int userId, int tierId, Date lastReviewDate) {
        this.customerId = customerId;
        this.address = address;
        this.totalPoints = totalPoints;
        this.totalSpent = totalSpent;
        this.totalWashes = totalWashes;
        this.joinDate = joinDate;
        this.dateOfBirth = dateOfBirth;
        this.userId = userId;
        this.tierId = tierId;
        this.lastReviewDate = lastReviewDate;
    }

    // Getters and Setters
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public int getTotalPoints() { return totalPoints; }
    public void setTotalPoints(int totalPoints) { this.totalPoints = totalPoints; }

    public long getTotalSpent() { return totalSpent; }
    public void setTotalSpent(long totalSpent) { this.totalSpent = totalSpent; }

    public int getTotalWashes() { return totalWashes; }
    public void setTotalWashes(int totalWashes) { this.totalWashes = totalWashes; }

    public Date getJoinDate() { return joinDate; }
    public void setJoinDate(Date joinDate) { this.joinDate = joinDate; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTierId() { return tierId; }
    public void setTierId(int tierId) { this.tierId = tierId; }

    public Date getLastReviewDate() { return lastReviewDate; }
    public void setLastReviewDate(Date lastReviewDate) { this.lastReviewDate = lastReviewDate; }

    // ===== GETTERS & SETTERS CHO FIELD HỖ TRỢ =====
    public String getTierName() { return tierName; }
    public void setTierName(String tierName) { this.tierName = tierName; }

    public double getPointMultiplier() { return pointMultiplier; }
    public void setPointMultiplier(double pointMultiplier) { this.pointMultiplier = pointMultiplier; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
}