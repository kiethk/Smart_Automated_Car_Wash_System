package dto;

public class BookingService {
    private int bookingServiceId;
    private int quantity; // DEFAULT 1
    private long price;   // BIGINT -> long (Giá tại thời điểm đặt để làm hóa đơn)
    private int bookingId;
    private int serviceId;

    public BookingService() {}

    public BookingService(int bookingServiceId, int quantity, long price, int bookingId, int serviceId) {
        this.bookingServiceId = bookingServiceId;
        this.quantity = quantity;
        this.price = price;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
    }
    
    

    // Getters and Setters
    public int getBookingServiceId() { return bookingServiceId; }
    public void setBookingServiceId(int bookingServiceId) { this.bookingServiceId = bookingServiceId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
}