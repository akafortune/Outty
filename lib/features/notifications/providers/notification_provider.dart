import 'package:flutter/foundation.dart';
import 'package:outty/features/chat/models/chat_room.dart';
import 'package:outty/features/matching/models/match_result.dart';
import 'package:outty/features/notifications/models/notification_model.dart';
import 'package:outty/features/notifications/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  NotificationProvider({required NotificationRepository repository})
    : _repository = repository {
    fetchNotifications();
  }

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _repository.getNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);

      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index].isRead = true;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.markAllAsRead();

      for (var notification in _notifications) {
        notification.isRead = true;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repository.deleteNotification(notificationId);

      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<MatchResult?> getMatchForNotification(String notificationId) async {
    try {
      return await _repository.getMatchForNotification(notificationId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<ChatRoom?> getChatRoomForNotification(String notificationId) async {
    try {
      return await _repository.getChatRoomForNotification(notificationId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
