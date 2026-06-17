package dto;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private int rating; // Khớp với CHECK (rating BETWEEN 1 AND 5)
    private String comment;
    private Timestamp createdAt;
    private int bookingId;     // UNIQUE
    private int customerId;

    public Feedback() {}

    public Feedback(int feedbackId, int rating, String comment, Timestamp createdAt, int bookingId, int customerId) {
        this.feedbackId = feedbackId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.bookingId = bookingId;
        this.customerId = customerId;
    }

    // Getters and Setters
    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
}