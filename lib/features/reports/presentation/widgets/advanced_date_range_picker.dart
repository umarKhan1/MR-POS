import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class AdvancedDateRangePicker extends StatefulWidget {
  final DateTimeRange initialRange;

  const AdvancedDateRangePicker({super.key, required this.initialRange});

  @override
  State<AdvancedDateRangePicker> createState() =>
      _AdvancedDateRangePickerState();
}

class _AdvancedDateRangePickerState extends State<AdvancedDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _viewMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialRange.start;
    _endDate = widget.initialRange.end;
    _viewMonth = DateTime(_startDate!.year, _startDate!.month);
  }

  void _onDateTapped(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (date.isBefore(_startDate!)) {
        _startDate = date;
        _endDate = null;
      } else if (date.isAtSameMomentAs(_startDate!)) {
        // Deselect if tapping same date? Booking.com usually keeps it as start.
        _startDate = date;
        _endDate = null;
      } else {
        _endDate = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final surfaceColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor = isDark ? Colors.white : Colors.black;

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 760,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthNavigation(textColor),
            32.h,
            _buildDualMonthView(textColor),
            40.h,
            _buildBottomActions(textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigation(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => setState(() {
            _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
          }),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.chevron_left, color: textColor, size: 28),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: Text(
                DateFormat('MMMM yyyy').format(_viewMonth),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            40.w, // Match the gap between calendars
            SizedBox(
              width: 300,
              child: Text(
                DateFormat(
                  'MMMM yyyy',
                ).format(DateTime(_viewMonth.year, _viewMonth.month + 1)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => setState(() {
            _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
          }),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.chevron_right, color: textColor, size: 28),
        ),
      ],
    );
  }

  Widget _buildDualMonthView(Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthCalendar(_viewMonth, textColor),
        40.w,
        _buildMonthCalendar(
          DateTime(_viewMonth.year, _viewMonth.month + 1),
          textColor,
        ),
      ],
    );
  }

  Widget _buildMonthCalendar(DateTime month, Color textColor) {
    // Weekday headers
    final weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOffset = DateTime(month.year, month.month, 1).weekday % 7;

    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays
                .map(
                  (d) => SizedBox(
                    width: 40,
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          16.h,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: firstDayOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) return const SizedBox();

              final day = index - firstDayOffset + 1;
              final date = DateTime(month.year, month.month, day);
              return _buildDayCell(date, textColor);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime date, Color textColor) {
    final isSelectedStart =
        _startDate != null && _startDate!.isAtSameMomentAs(date);
    final isSelectedEnd = _endDate != null && _endDate!.isAtSameMomentAs(date);
    final isInRange =
        _startDate != null &&
        _endDate != null &&
        date.isAfter(_startDate!) &&
        date.isBefore(_endDate!);

    final isToday =
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => _onDateTapped(date),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (isSelectedStart || isSelectedEnd)
              ? AppColors.primaryRed
              : isInRange
              ? AppColors.primaryRed.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: isSelectedStart
              ? const BorderRadius.horizontal(left: Radius.circular(8))
              : isSelectedEnd
              ? const BorderRadius.horizontal(right: Radius.circular(8))
              : (isInRange ? BorderRadius.zero : BorderRadius.circular(8)),
        ),
        child: Text(
          date.day.toString(),
          style: TextStyle(
            color: (isSelectedStart || isSelectedEnd)
                ? Colors.white
                : isToday
                ? AppColors.primaryRed
                : textColor,
            fontWeight: (isSelectedStart || isSelectedEnd || isToday)
                ? FontWeight.bold
                : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: textColor.withValues(alpha: 0.6),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        16.w,
        ElevatedButton(
          onPressed: (_startDate != null && _endDate != null)
              ? () => Navigator.pop(
                  context,
                  DateTimeRange(start: _startDate!, end: _endDate!),
                )
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Apply',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Color get textColor => context.isDarkMode ? Colors.white : Colors.black;
}
