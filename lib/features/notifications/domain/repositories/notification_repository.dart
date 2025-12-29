import 'dart:async';
import 'package:mrpos/features/notifications/domain/models/app_notification.dart';

class NotificationRepository {
  final List<AppNotification> _notifications = [];
  final _controller = StreamController<List<AppNotification>>.broadcast();

  Stream<List<AppNotification>> get notificationsStream => _controller.stream;

  List<AppNotification> get currentNotifications =>
      List.unmodifiable(_notifications);

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _controller.add(List.unmodifiable(_notifications));
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _controller.add(List.unmodifiable(_notifications));
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    _controller.add(List.unmodifiable(_notifications));
  }

  void clearAll() {
    _notifications.clear();
    _controller.add(List.unmodifiable(_notifications));
  }

  void dispose() {
    _controller.close();
  }
}
