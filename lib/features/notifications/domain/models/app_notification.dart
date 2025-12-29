import 'package:flutter/material.dart';

enum NotificationType { orderCreated, orderDeleted, orderCompleted, general }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? actionUrl;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.actionUrl,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.orderCreated:
        return Icons.add_shopping_cart;
      case NotificationType.orderDeleted:
        return Icons.delete_outline;
      case NotificationType.orderCompleted:
        return Icons.check_circle_outline;
      case NotificationType.general:
        return Icons.notifications_none;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.orderCreated:
        return Colors.blue;
      case NotificationType.orderDeleted:
        return Colors.red;
      case NotificationType.orderCompleted:
        return Colors.green;
      case NotificationType.general:
        return Colors.orange;
    }
  }
}
