package dto;

import java.sql.Timestamp;

public class CustomerMonthlyStats {
    private int customerId;
    private int statYear;
    private int statMonth;
    private long monthlySpent;
    private int monthlyWashes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public CustomerMonthlyStats() {
    }

    public CustomerMonthlyStats(int customerId, int statYear, int statMonth, long monthlySpent, int monthlyWashes,
            Timestamp createdAt, Timestamp updatedAt) {
        this.customerId = customerId;
        this.statYear = statYear;
        this.statMonth = statMonth;
        this.monthlySpent = monthlySpent;
        this.monthlyWashes = monthlyWashes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getStatYear() {
        return statYear;
    }

    public void setStatYear(int statYear) {
        this.statYear = statYear;
    }

    public int getStatMonth() {
        return statMonth;
    }

    public void setStatMonth(int statMonth) {
        this.statMonth = statMonth;
    }

    public long getMonthlySpent() {
        return monthlySpent;
    }

    public void setMonthlySpent(long monthlySpent) {
        this.monthlySpent = monthlySpent;
    }

    public int getMonthlyWashes() {
        return monthlyWashes;
    }

    public void setMonthlyWashes(int monthlyWashes) {
        this.monthlyWashes = monthlyWashes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "CustomerMonthlyStats{" +
                "customerId=" + customerId +
                ", statYear=" + statYear +
                ", statMonth=" + statMonth +
                ", monthlySpent=" + monthlySpent +
                ", monthlyWashes=" + monthlyWashes +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}