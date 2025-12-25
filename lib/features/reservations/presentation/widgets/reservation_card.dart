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
                ? AppColors.primaryRed.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: reservation.status == ReservationStatus.confirmed
                  ? AppColors.primaryRed
                  : Colors.grey,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reservation.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.h,
              Row(
                children: [
                  const Icon(Icons.people, color: Colors.white70, size: 12),
                  4.w,
                  Text(
                    '${reservation.numberOfGuests}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
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
