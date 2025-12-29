import 'package:equatable/equatable.dart';
import 'package:mrpos/features/notifications/domain/models/app_notification.dart';

class NotificationState extends Equatable {
  final List<AppNotification> notifications;

  const NotificationState({this.notifications = const []});

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({List<AppNotification>? notifications}) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [notifications];
}
