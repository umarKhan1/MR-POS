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
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Reservation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to cancel this reservation?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No', style: TextStyle(color: Colors.grey[400])),
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
      ),
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                12.w,
                const Text(
                  'Reservation Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                // Notification icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
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
                          AppColors.primaryRed.withOpacity(0.8),
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
                        _buildSectionTitle('Reservation Details'),
                        16.h,
                        _buildDetailsCard([
                          _buildDetailRow(
                            'Pax Number',
                            '${reservation.numberOfGuests} persons',
                          ),
                          _buildDetailRow(
                            'Reservation Date',
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(reservation.reservationDate),
                          ),
                          _buildDetailRow(
                            'Reservation Time',
                            reservation.reservationTime.format(context),
                          ),
                          _buildDetailRow(
                            'Status',
                            reservation.status.displayName,
                            statusColor: reservation.status.color,
                          ),
                        ]),
                        32.h,
                        // Customer Details Section
                        _buildSectionTitle('Customer Details'),
                        16.h,
                        _buildDetailsCard([
                          _buildDetailRow('Full Name', reservation.fullName),
                          _buildDetailRow(
                            'Phone Number',
                            reservation.phoneNumber,
                          ),
                          _buildDetailRow(
                            'Email Address',
                            reservation.emailAddress,
                          ),
                        ]),
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
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.grey[700]!,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDetailsCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          statusColor != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}
