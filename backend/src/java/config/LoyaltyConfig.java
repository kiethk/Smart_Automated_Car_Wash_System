package config;

public class LoyaltyConfig {

    // 1000 VND = 1 point
    public static final int AMOUNT_PER_POINT = 1000;

    // Points expire after 12 months
    public static final int POINT_EXPIRY_MONTHS = 12;

    private LoyaltyConfig() {
        // Prevent object creation
    }
}
