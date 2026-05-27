package dto;

import java.sql.Timestamp;

public class PromotionUsage {
    private int promotionUsageId;
    private Timestamp usedAt;
    private int promotionId;
    private int bookingId;

    public PromotionUsage() {}

    public PromotionUsage(int promotionUsageId, Timestamp usedAt, int promotionId, int bookingId) {
        this.promotionUsageId = promotionUsageId;
        this.usedAt = usedAt;
        this.promotionId = promotionId;
        this.bookingId = bookingId;
    }

    // Getters and Setters
    public int getPromotionUsageId() { return promotionUsageId; }
    public void setPromotionUsageId(int promotionUsageId) { this.promotionUsageId = promotionUsageId; }
    public Timestamp getUsedAt() { return usedAt; }
    public void setUsedAt(Timestamp usedAt) { this.usedAt = usedAt; }
    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
}