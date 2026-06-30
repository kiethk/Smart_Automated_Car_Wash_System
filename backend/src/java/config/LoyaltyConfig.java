package config;

public class LoyaltyConfig {

    // 1000 VND = 1 point
    public static final int AMOUNT_PER_POINT = 1000;

    // Points expire after 12 months
    public static final int POINT_EXPIRY_MONTHS = 12;

    // Monthly tier review schedule (1st day of month at 00:05)
    public static final int MONTHLY_REVIEW_DAY_OF_MONTH = 1;
    public static final int MONTHLY_REVIEW_HOUR = 0;
    public static final int MONTHLY_REVIEW_MINUTE = 5;

    private LoyaltyConfig() {
        // Prevent object creation
    }
}
