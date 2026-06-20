package dto;

public class Tiers {
    private int tierId;
    private String tierName;
    private int minWashes;
    private long minSpent; // Dùng long tương ứng với BIGINT trong DB
    private double pointMultiplier;
    private double discountPercent;
    private int bookingWindowDays;
    private String description;

    public Tiers() {}

    public Tiers(int tierId, String tierName, int minWashes, long minSpent, double pointMultiplier, double discountPercent, int bookingWindowDays, String description) {
        this.tierId = tierId;
        this.tierName = tierName;
        this.minWashes = minWashes;
        this.minSpent = minSpent;
        this.pointMultiplier = pointMultiplier;
        this.discountPercent = discountPercent;
        this.bookingWindowDays = bookingWindowDays;
        this.description = description;
    }

    // Getter và Setter cho tất cả các trường
    public int getTierId() { return tierId; }
    public void setTierId(int tierId) { this.tierId = tierId; }
    public String getTierName() { return tierName; }
    public void setTierName(String tierName) { this.tierName = tierName; }
    public int getMinWashes() { return minWashes; }
    public void setMinWashes(int minWashes) { this.minWashes = minWashes; }
    public long getMinSpent() { return minSpent; }
    public void setMinSpent(long minSpent) { this.minSpent = minSpent; }
    public double getPointMultiplier() { return pointMultiplier; }
    public void setPointMultiplier(double pointMultiplier) { this.pointMultiplier = pointMultiplier; }
    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }
    public int getBookingWindowDays() { return bookingWindowDays; }
    public void setBookingWindowDays(int bookingWindowDays) { this.bookingWindowDays = bookingWindowDays; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}