import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mrpos/core/models/reservation.dart';
import 'package:mrpos/features/reservations/presentation/cubit/reservations_cubit.dart';
import 'package:mrpos/features/reservations/presentation/cubit/reservations_state.dart';
import 'package:mrpos/features/reservations/presentation/widgets/add_reservation_modal.dart';
import 'package:mrpos/features/reservations/presentation/widgets/reservation_card.dart';
import 'package:mrpos/features/notifications/presentation/widgets/notification_bell.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ReservationsContent();
  }
}

class _ReservationsContent extends StatelessWidget {
  const _ReservationsContent();

  Future<void> _selectDate(BuildContext context) async {
    final cubit = context.read<ReservationsCubit>();
    final state = cubit.state;
    final currentDate = state is ReservationsInitial
        ? state.selectedDate
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(), // Only allow today and future dates
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final isDark = context.isDarkMode;
        return Theme(
          data: (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryRed,
              primary: AppColors.primaryRed,
              onPrimary: Colors.white,
              surface: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black87,
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      cubit.selectDate(picked);
    }
  }

  void _showAddReservationModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Reservation',
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
              child: BlocProvider.value(
                value: context.read<ReservationsCubit>(),
                child: const AddReservationModal(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isMobile = responsive.isMobile;
    final isDark = context.isDarkMode;

    return Material(
      color: isDark
          ? const Color(0xFF1A1A1A)
          : Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.responsive(
                mobile: 16.0,
                tablet: 20.0,
                desktop: 24.0,
              ),
              vertical: responsive.responsive(
                mobile: 12.0,
                tablet: 14.0,
                desktop: 16.0,
              ),
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            ),
            child: Row(
              children: [
                if (isMobile) ...[
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  8.w,
                ],
                Text(
                  'Reservation',
                  style: TextStyle(
                    fontSize: responsive.responsive(
                      mobile: 18.0,
                      tablet: 19.0,
                      desktop: 20.0,
                    ),
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                // Date selector
                BlocBuilder<ReservationsCubit, ReservationsState>(
                  builder: (context, state) {
                    final selectedDate = state is ReservationsInitial
                        ? state.selectedDate
                        : DateTime.now();

                    final isToday =
                        selectedDate.year == DateTime.now().year &&
                        selectedDate.month == DateTime.now().month &&
                        selectedDate.day == DateTime.now().day;

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.responsive(
                              mobile: 10.0,
                              tablet: 14.0,
                              desktop: 16.0,
                            ),
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2A2A)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                isToday
                                    ? 'Today'
                                    : DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(selectedDate),
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: responsive.responsive(
                                    mobile: 12.0,
                                    tablet: 13.0,
                                    desktop: 14.0,
                                  ),
                                ),
                              ),
                              responsive.responsive(
                                mobile: 4.w,
                                tablet: 6.w,
                                desktop: 8.w,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: isDark ? Colors.white : Colors.black54,
                                size: responsive.responsive(
                                  mobile: 14.0,
                                  tablet: 15.0,
                                  desktop: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                responsive.responsive(mobile: 8.w, tablet: 12.w, desktop: 16.w),
                // Add New Reservation button
                ElevatedButton(
                  onPressed: () => _showAddReservationModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.responsive(
                        mobile: 12.0,
                        tablet: 16.0,
                        desktop: 20.0,
                      ),
                      vertical: responsive.responsive(
                        mobile: 10.0,
                        tablet: 11.0,
                        desktop: 12.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isMobile ? '+ Add' : 'Add New Reservation',
                    style: TextStyle(
                      fontSize: responsive.responsive(
                        mobile: 12.0,
                        tablet: 13.0,
                        desktop: 14.0,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!isMobile) ...[
                  const NotificationBell(),
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
              ],
            ),
          ),
          // Calendar grid
          Expanded(
            child: BlocBuilder<ReservationsCubit, ReservationsState>(
              builder: (context, state) {
                if (state is ReservationsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  );
                }

                if (state is ReservationsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is ReservationsInitial) {
                  final reservations = state.reservationsForSelectedDate;

                  // Show empty state if no reservations
                  if (reservations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          16.h,
                          Text(
                            'No Reservation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                          8.h,
                          Text(
                            'Click "Add New Reservation" to create one',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _CalendarGrid(reservations: reservations);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final List<Reservation> reservations;

  const _CalendarGrid({required this.reservations});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isDark = context.isDarkMode;
    // Time slots from 10:00 to 20:00 (11 hourly slots)
    final timeSlots = List.generate(11, (index) => 10 + index);

    // Set a minimum width for the calendar grid to ensure readability on small screens
    const minGridWidth = 1200.0;
    final gridPadding = responsive.responsive(
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(gridPadding),
        child: SizedBox(
          width: minGridWidth,
          child: Column(
            children: [
              // Time header with ranges
              Row(
                children: [
                  ...timeSlots.map(
                    (hour) => Expanded(
                      child: Center(
                        child: Text(
                          '${hour.toString().padLeft(2, '0')}:00',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              16.h,
              // Calendar grid - 8 rows of time slots
              ...List.generate(
                8,
                (rowIndex) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: timeSlots.map((hour) {
                      // Find reservations for this time slot
                      final slotReservations = reservations.where((r) {
                        return r.reservationTime.hour == hour;
                      }).toList();

                      // Get reservation for this specific row if multiple exist
                      final reservation = slotReservations.length > rowIndex
                          ? slotReservations[rowIndex]
                          : null;

                      return Expanded(
                        child: Container(
                          height: 70,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2A2A)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[200])!,
                              width: 1,
                            ),
                          ),
                          child: reservation != null
                              ? ReservationCard(reservation: reservation)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
