import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_state.dart';
import 'package:mrpos/features/notifications/presentation/widgets/notification_side_modal.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class NotificationBell extends StatelessWidget {
  final Color? color;
  const NotificationBell({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final iconColor =
        color ?? (context.isDarkMode ? Colors.white : Colors.black);
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final unreadCount = state.unreadCount;

        return Stack(
          children: [
            IconButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, anim1, anim2) =>
                      const NotificationSideModal(),
                );
              },
              icon: Icon(Icons.notifications_none, color: iconColor, size: 24),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
