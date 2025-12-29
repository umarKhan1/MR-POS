import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrpos/core/models/reservation.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigate to reservation details screen
          GoRouter.of(context).push('/reservation-details', extra: reservation);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: reservation.status == ReservationStatus.confirmed
                ? AppColors.primaryRed.withValues(alpha: isDark ? 0.2 : 0.1)
                : (isDark ? Colors.grey : Colors.grey[300])!.withValues(
                    alpha: 0.2,
                  ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: reservation.status == ReservationStatus.confirmed
                  ? AppColors.primaryRed
                  : (isDark ? Colors.grey : Colors.grey[400])!,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reservation.fullName,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.h,
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: isDark ? Colors.white70 : Colors.black54,
                    size: 12,
                  ),
                  4.w,
                  Text(
                    '${reservation.numberOfGuests}',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
