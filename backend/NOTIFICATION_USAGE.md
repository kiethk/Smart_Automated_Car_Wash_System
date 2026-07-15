# Notification Module Usage

This module owns notification display, read status, unread badge counts, and the DAO helper that other modules can call to send notifications.

## Customer page

Customers can view their notifications at:

```text
/NotificationController
```

The controller only loads notifications for the currently logged-in user.

## Admin page

Admins can view and filter all system notifications at:

```text
/admin/notifications
```

Only users with `role_id = 1` can access this page.
The old route `/NotificationController?action=admin-list` still works for backward compatibility.
Admin filters support keyword search, recipient type, read status, and created date range.

Admins can also use `Create Notifications` on this page to send notifications to:

- All Customers
- All Admins
- All active users

The system creates one `Notifications` row per recipient user.
Recipient groups passed to `createNotifications(...)` are `customers`, `admins`, or `all`.
Notifications sent to all active users use notification type `System`.

## Sending a notification from another module

Other modules should call `NotificationDAO.createNotification(...)` after their own business action succeeds.

Example:

```java
new NotificationDAO().createNotification(
    userId,
    "Booking confirmed",
    "Your booking has been accepted.",
    "Customer",
    bookingId
);
```

## Parameters

- `userId`: The recipient user ID from the `[User]` table. Do not pass `customer_id`.
- `title`: Short notification title.
- `content`: Notification detail text.
- `type`: Recipient/category label. Use `Customer`, `Admin`, or `System` so the admin filters stay consistent.
- `referenceId`: Related entity ID, such as `booking_id`. Pass `null` when there is no related record.

## Available DAO methods

```java
createNotification(Notifications noti)
createNotification(int userId, String title, String content, String type, Integer referenceId)
createNotifications(String title, String content, String recipientGroup)
getNotificationsByUserId(int userId)
countUnreadNotifications(int userId)
markAsRead(int notificationId, int userId)
markAllAsRead(int userId)
getNotificationsForAdmin(String searchKeyword, String type, Integer isRead)
getNotificationsForAdmin(String searchKeyword, String type, Integer isRead, Date fromDate, Date toDate)
deleteNotification(int notificationId)
```

## Security notes

- Customers can only view notifications with their own `user_id`.
- Marking a notification as read is scoped by both `notification_id` and `user_id`.
- The admin list is blocked for non-admin users.
