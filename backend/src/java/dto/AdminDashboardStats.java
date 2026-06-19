package dto;

public class AdminDashboardStats {

    private long todayRevenue;
    private long monthRevenue;

    private int todayBookings;
    private int pendingBookings;
    private int unpaidBookings;
    private int completedThisMonth;

    private int activeCustomers;
    private int availableBays;
    private int maintenanceBays;

    private int activeServices;
    private int activePromotions;
    private int activeSlots;

    public AdminDashboardStats() {
    }

    public long getTodayRevenue() {
        return todayRevenue;
    }

    public void setTodayRevenue(long todayRevenue) {
        this.todayRevenue = todayRevenue;
    }

    public long getMonthRevenue() {
        return monthRevenue;
    }

    public void setMonthRevenue(long monthRevenue) {
        this.monthRevenue = monthRevenue;
    }

    public int getTodayBookings() {
        return todayBookings;
    }

    public void setTodayBookings(int todayBookings) {
        this.todayBookings = todayBookings;
    }

    public int getPendingBookings() {
        return pendingBookings;
    }

    public void setPendingBookings(int pendingBookings) {
        this.pendingBookings = pendingBookings;
    }

    public int getUnpaidBookings() {
        return unpaidBookings;
    }

    public void setUnpaidBookings(int unpaidBookings) {
        this.unpaidBookings = unpaidBookings;
    }

    public int getCompletedThisMonth() {
        return completedThisMonth;
    }

    public void setCompletedThisMonth(int completedThisMonth) {
        this.completedThisMonth = completedThisMonth;
    }

    public int getActiveCustomers() {
        return activeCustomers;
    }

    public void setActiveCustomers(int activeCustomers) {
        this.activeCustomers = activeCustomers;
    }

    public int getAvailableBays() {
        return availableBays;
    }

    public void setAvailableBays(int availableBays) {
        this.availableBays = availableBays;
    }

    public int getMaintenanceBays() {
        return maintenanceBays;
    }

    public void setMaintenanceBays(int maintenanceBays) {
        this.maintenanceBays = maintenanceBays;
    }

    public int getActiveServices() {
        return activeServices;
    }

    public void setActiveServices(int activeServices) {
        this.activeServices = activeServices;
    }

    public int getActivePromotions() {
        return activePromotions;
    }

    public void setActivePromotions(int activePromotions) {
        this.activePromotions = activePromotions;
    }

    public int getActiveSlots() {
        return activeSlots;
    }

    public void setActiveSlots(int activeSlots) {
        this.activeSlots = activeSlots;
    }
}
