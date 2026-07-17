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

    private int acceptedBookings;
    private int completedBookings;
    private int cancelledBookings;

// Chart data — dùng List<Long> và List<String> để truyền xuống JSP
    private java.util.List<Long> monthlyRevenue = new java.util.ArrayList<>();
    private java.util.List<String> monthlyLabels = new java.util.ArrayList<>();
    private java.util.List<Integer> dailyBookings = new java.util.ArrayList<>();
    private java.util.List<String> dailyLabels = new java.util.ArrayList<>();
    private java.util.List<Long> serviceRevenue = new java.util.ArrayList<>();
    private java.util.List<String> serviceLabels = new java.util.ArrayList<>();
    private java.util.List<Integer> tierCounts = new java.util.ArrayList<>();
    private java.util.List<String> tierLabels = new java.util.ArrayList<>();

    public AdminDashboardStats() {
    }

    public int getAcceptedBookings() {
        return acceptedBookings;
    }

    public void setAcceptedBookings(int v) {
        this.acceptedBookings = v;
    }

    public int getCompletedBookings() {
        return completedBookings;
    }

    public void setCompletedBookings(int v) {
        this.completedBookings = v;
    }

    public int getCancelledBookings() {
        return cancelledBookings;
    }

    public void setCancelledBookings(int v) {
        this.cancelledBookings = v;
    }

    public java.util.List<Long> getMonthlyRevenue() {
        return monthlyRevenue;
    }

    public void setMonthlyRevenue(java.util.List<Long> v) {
        this.monthlyRevenue = v;
    }

    public java.util.List<String> getMonthlyLabels() {
        return monthlyLabels;
    }

    public void setMonthlyLabels(java.util.List<String> v) {
        this.monthlyLabels = v;
    }

    public java.util.List<Integer> getDailyBookings() {
        return dailyBookings;
    }

    public void setDailyBookings(java.util.List<Integer> v) {
        this.dailyBookings = v;
    }

    public java.util.List<String> getDailyLabels() {
        return dailyLabels;
    }

    public void setDailyLabels(java.util.List<String> v) {
        this.dailyLabels = v;
    }

    public java.util.List<Long> getServiceRevenue() {
        return serviceRevenue;
    }

    public void setServiceRevenue(java.util.List<Long> v) {
        this.serviceRevenue = v;
    }

    public java.util.List<String> getServiceLabels() {
        return serviceLabels;
    }

    public void setServiceLabels(java.util.List<String> v) {
        this.serviceLabels = v;
    }

    public java.util.List<Integer> getTierCounts() {
        return tierCounts;
    }

    public void setTierCounts(java.util.List<Integer> v) {
        this.tierCounts = v;
    }

    public java.util.List<String> getTierLabels() {
        return tierLabels;
    }

    public void setTierLabels(java.util.List<String> v) {
        this.tierLabels = v;
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
