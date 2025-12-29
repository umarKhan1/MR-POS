import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/notifications/domain/models/app_notification.dart';
import 'package:mrpos/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription? _subscription;

  NotificationCubit({required NotificationRepository repository})
    : _repository = repository,
      super(const NotificationState()) {
    _subscription = _repository.notificationsStream.listen((notifications) {
      emit(state.copyWith(notifications: notifications));
    });
  }

  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );
    _repository.addNotification(notification);
  }

  void markAsRead(String id) => _repository.markAsRead(id);

  void markAllAsRead() => _repository.markAllAsRead();

  void clearAll() => _repository.clearAll();

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
