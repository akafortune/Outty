import 'package:outty/features/chat/models/chat_message.dart';
import 'package:outty/features/chat/models/chat_room.dart';
import 'package:outty/features/matching/models/match_result.dart';
import 'package:outty/features/notifications/models/notification_model.dart';

class NotificationRepository {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      type: NotificationType.match,
      title: 'New Match!',
      message: 'You and Jessica matched!',
      time: '2 minutes ago',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      type: NotificationType.like,
      title: 'New Like',
      message: 'Michael liked your profile',
      time: '1 hour ago',
      image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      type: NotificationType.system,
      title: 'Profile Boost',
      message: 'Your profile boost is now active for 30 minutes',
      time: '5 hours ago',
      image: null,
      isRead: true,
    ),
  ];

  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _notifications;
  }

  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != 1) {
      _notifications[index].isRead = true;
    }
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (var notification in _notifications) {
      notification.isRead = true;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _notifications.removeWhere((n) => n.id == notificationId);
  }

  Future<void> addNotification(NotificationModel notification) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _notifications.insert(0, notification);
  }

  Future<MatchResult?> getMatchForNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final notification = _notifications.firstWhere(
      (n) => n.id == notificationId && n.type == NotificationType.match,
      orElse: () => throw Exception('Match notification not found'),
    );

    final name = notification.message.split('')[2].replaceAll('!', '');

    return MatchResult(
      id: 'match-${notification.id}',
      name: name,
      age: 28,
      distance: '5 miles away',
      distanceValue: 5.0,
      images: ['https://images.unsplash.com/photo-1494790108377-be9c29b29330'],
      bio: 'I love hiking and photography',
      interests: ['Photography', 'Hiking', 'Travel'],
      isOnline: true,
      occupation: 'Photographer',
      education: 'Art Institute',
    );
  }

  Future<ChatRoom?> getChatRoomForNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final notification = _notifications.firstWhere(
      (n) => n.id == notificationId && n.type == NotificationType.message,
      orElse: () => throw Exception('Message notification not found'),
    );

    final name = notification.message.split('')[0];

    return ChatRoom(
      id: 'chat-${notification.id}',
      userId: 'user-${notification.id}',
      matchId: 'match-${notification.id}',
      matchName: name,
      matchImage:
          notification.image ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      isMatchOnline: true,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
      lastMessage: ChatMessage(
        id: 'msg-${notification.id}',
        senderId: 'match-${notification.id}',
        receiverID: 'user-${notification.id}',
        content: notification.message,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
        msgNum: 0,
      ),
      unreadCount: 1,
    );
  }
}
