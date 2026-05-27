package dto;

import java.sql.Timestamp;

public class Notifications {
    private int notificationId;
    private String title;
    private String content;
    private String type;
    private int isRead; // DEFAULT 0
    private Integer referenceId; // Có thể NULL (ID của Booking hoặc Promotion liên quan)
    private Timestamp createdAt;
    private int userId;

    public Notifications() {}

    public Notifications(int notificationId, String title, String content, String type, int isRead, Integer referenceId, Timestamp createdAt, int userId) {
        this.notificationId = notificationId;
        this.title = title;
        this.content = content;
        this.type = type;
        this.isRead = isRead;
        this.referenceId = referenceId;
        this.createdAt = createdAt;
        this.userId = userId;
    }

    // Getters and Setters
    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getIsRead() { return isRead; }
    public void setIsRead(int isRead) { this.isRead = isRead; }
    public Integer getReferenceId() { return referenceId; }
    public void setReferenceId(Integer referenceId) { this.referenceId = referenceId; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
}