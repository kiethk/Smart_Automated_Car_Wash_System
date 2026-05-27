package dto;

import java.sql.Date;

public class Promotion {
    private int promotionId;
    private String code;
    private String discountType; // 'percent', 'fixed'
    private long discountValue;   // BIGINT -> long
    private long minOrderAmount;  // BIGINT -> long
    private int usageLimit;
    private Date startDate;
    private Date endDate;
    private int isActive;
    private Integer targetTierId; // Chấp nhận NULL nếu áp dụng toàn hệ thống

    public Promotion() {}

    public Promotion(int promotionId, String code, String discountType, long discountValue, long minOrderAmount, int usageLimit, Date startDate, Date endDate, int isActive, Integer targetTierId) {
        this.promotionId = promotionId;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderAmount = minOrderAmount;
        this.usageLimit = usageLimit;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
        this.targetTierId = targetTierId;
    }
    
    

    // Getters and Setters
    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    public long getDiscountValue() { return discountValue; }
    public void setDiscountValue(long discountValue) { this.discountValue = discountValue; }
    public long getMinOrderAmount() { return minOrderAmount; }
    public void setMinOrderAmount(long minOrderAmount) { this.minOrderAmount = minOrderAmount; }
    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }
    public Integer getTargetTierId() { return targetTierId; }
    public void setTargetTierId(Integer targetTierId) { this.targetTierId = targetTierId; }
}