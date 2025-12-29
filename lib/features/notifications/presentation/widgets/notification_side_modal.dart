import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mrpos/features/notifications/domain/models/app_notification.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_state.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class NotificationSideModal extends StatefulWidget {
  const NotificationSideModal({super.key});

  @override
  State<NotificationSideModal> createState() => _NotificationSideModalState();
}

class _NotificationSideModalState extends State<NotificationSideModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _showOnlyUnread = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Stack(
      children: [
        GestureDetector(
          onTap: _close,
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              color: backgroundColor,
              child: Container(
                width: 400,
                height: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(isDark),
                    _buildFilters(isDark),
                    Expanded(child: _buildNotificationList(isDark)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          IconButton(onPressed: _close, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  Widget _buildFilters(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildFilterChip('All', !_showOnlyUnread),
          12.w,
          _buildFilterChip('Unread', _showOnlyUnread),
          const Spacer(),
          TextButton(
            onPressed: () => context.read<NotificationCubit>().markAllAsRead(),
            child: const Text('Mark all as read'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _showOnlyUnread = label == 'Unread'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? AppColors.primaryRed
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(bool isDark) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final filteredList = _showOnlyUnread
            ? state.notifications.where((n) => !n.isRead).toList()
            : state.notifications;

        if (filteredList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                16.h,
                const Text(
                  'No notifications yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final notification = filteredList[index];
            return _buildNotificationCard(notification, isDark);
          },
        );
      },
    );
  }

  Widget _buildNotificationCard(AppNotification notification, bool isDark) {
    return GestureDetector(
      onTap: () =>
          context.read<NotificationCubit>().markAsRead(notification.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.transparent
              : AppColors.primaryRed.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05))
                : AppColors.primaryRed.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notification.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 20,
              ),
            ),
            16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  4.h,
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : Colors.black.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                  8.h,
                  Text(
                    DateFormat(
                      'hh:mm a, dd MMM',
                    ).format(notification.timestamp),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
