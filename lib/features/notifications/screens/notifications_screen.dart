import 'package:flutter/material.dart';
import 'package:outty/app.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/features/notifications/models/notification_model.dart';
import 'package:outty/features/notifications/providers/notification_provider.dart';
import 'package:outty/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;
    final isLoading = provider.isLoading;
    final error = provider.error;

    return MainLayout(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.textSecondaryLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            if (provider.unreadCount > 0)
              TextButton(
                onPressed: () {
                  provider.markAllAsRead();
                },
                child: Text(
                  'Mark all as read',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => provider.fetchNotifications(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
            : notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 80,
                      color: isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                      key: Key(notification.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        provider.deleteNotification(notification.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notification deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: notification.isRead
                              ? (isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.white)
                              : (isDarkMode
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : AppColors.primary.withValues(
                                        alpha: 0.05,
                                      )),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: _getNotificationIcon(
                            notification,
                            isDarkMode,
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                notification.message,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          trailing: !notification.isRead
                              ? Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                          onTap: () {
                            if (!notification.isRead) {
                              provider.markAsRead(notification.id);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                onRefresh: () => provider.fetchNotifications(),
              ),
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      switch (notification.type) {
        case NotificationType.match:
          final match = await provider.getMatchForNotification(notification.id);
          if (context.mounted) {
            Navigator.pop(context);
            if (match != null) {
            } else {
              Navigator.pushNamed(context, RouteNames.discover);
            }
          }

          break;

        case NotificationType.like:
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteNames.discover);
          }

          break;

        case NotificationType.message:
          final chatRoom = await provider.getChatRoomForNotification(
            notification.id,
          );

          if (context.mounted) {
            Navigator.pop(context);

            if (chatRoom != null) {
            } else {
              Navigator.pushNamed(context, RouteNames.chatList);
            }
          }
          break;

        case NotificationType.system:
          if (context.mounted) {
            Navigator.pop(context);
            _showSystemNotificationDetails(context, notification);
          }

          break;
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSystemNotificationDetails(
    BuildContext context,
    NotificationModel notification,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        title: Text(
          notification.title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _getNotificationIcon(NotificationModel notification, bool isDarkMode) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.match:
        iconData = Icons.favorite;
        iconColor = Colors.red;
        break;

      case NotificationType.like:
        iconData = Icons.thumb_up;
        iconColor = Colors.blue;
        break;

      case NotificationType.message:
        iconData = Icons.chat_bubble;
        iconColor = Colors.green;
        break;

      case NotificationType.system:
        iconData = Icons.notifications;
        iconColor = Colors.amber;
        break;
    }

    if (notification.image != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(notification.image!),
        backgroundColor: isDarkMode
            ? Colors.grey.shade800
            : Colors.grey.shade200,
      );
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: iconColor.withValues(alpha: 0.2),
      child: Icon(iconData, color: iconColor),
    );
  }
}
