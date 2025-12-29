import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/models/reservation.dart';
import 'package:mrpos/features/reservations/presentation/cubit/reservations_cubit.dart';
import 'package:mrpos/features/reservations/presentation/widgets/add_reservation_modal.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final Reservation reservation;

  const ReservationDetailsScreen({super.key, required this.reservation});

  void _showEditModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit Reservation',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: AddReservationModal(reservation: reservation),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = context.isDarkMode;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Cancel Reservation',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel this reservation?',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'No',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      // Update reservation status to cancelled
      final updatedReservation = reservation.copyWith(
        status: ReservationStatus.cancelled,
      );
      context.read<ReservationsCubit>().updateReservation(updatedReservation);
      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                12.w,
                Text(
                  'Reservation Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                // Notification icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: isDark ? Colors.white : Colors.black87,
                      size: 20,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
                12.w,
                // Profile icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section with Logo - Full Width
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryRed,
                          AppColors.primaryRed.withValues(
                            alpha: isDark ? 0.8 : 0.9,
                          ),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Logo/Name
                        Text(
                          AppConstants.appName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        12.h,
                        Container(
                          width: 60,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        16.h,
                        Text(
                          'Reservation for ${reservation.fullName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        6.h,
                        Text(
                          '${reservation.numberOfGuests} ${reservation.numberOfGuests == 1 ? 'person' : 'persons'} • ${reservation.reservationTime.format(context)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Details Section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reservation Details Section
                        _buildSectionTitle(context, 'Reservation Details'),
                        16.h,
                        _buildDetailsCard([
                          _buildDetailRow(
                            context,
                            'Pax Number',
                            '${reservation.numberOfGuests} persons',
                          ),
                          _buildDetailRow(
                            context,
                            'Reservation Date',
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(reservation.reservationDate),
                          ),
                          _buildDetailRow(
                            context,
                            'Reservation Time',
                            reservation.reservationTime.format(context),
                          ),
                          _buildDetailRow(
                            context,
                            'Status',
                            reservation.status.displayName,
                            statusColor: reservation.status.color,
                          ),
                        ], context),
                        32.h,
                        // Customer Details Section
                        _buildSectionTitle(context, 'Customer Details'),
                        16.h,
                        _buildDetailsCard([
                          _buildDetailRow(
                            context,
                            'Full Name',
                            reservation.fullName,
                          ),
                          _buildDetailRow(
                            context,
                            'Phone Number',
                            reservation.phoneNumber,
                          ),
                          _buildDetailRow(
                            context,
                            'Email Address',
                            reservation.emailAddress,
                          ),
                        ], context),
                        32.h,
                        // Action Buttons - Centered
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _showCancelDialog(context),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      side: BorderSide(
                                        color: (isDark
                                            ? Colors.grey[700]
                                            : Colors.grey[300])!,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Cancel Reservation'),
                                  ),
                                ),
                                16.w,
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _showEditModal(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryRed,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Edit Reservation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        24.h,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = context.isDarkMode;
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildDetailsCard(List<Widget> children, BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? Colors.grey[800] : Colors.grey[200])!,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? statusColor,
  }) {
    final isDark = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 13,
            ),
          ),
          statusColor != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}
