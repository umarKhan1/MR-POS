import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mrpos/core/services/excel_export_service.dart';
import 'package:mrpos/features/notifications/presentation/widgets/notification_bell.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';
import 'package:mrpos/features/reports/domain/repositories/reports_repository.dart';
import 'package:mrpos/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:mrpos/features/reports/presentation/cubit/reports_state.dart';
import 'package:mrpos/features/reports/presentation/widgets/advanced_date_range_picker.dart';
import 'package:mrpos/features/reports/presentation/widgets/reports_table.dart';
import 'package:mrpos/features/reports/presentation/widgets/revenue_doughnut_chart.dart';
import 'package:mrpos/features/reports/presentation/widgets/revenue_line_chart.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

import 'package:mrpos/features/menu/data/repositories/firestore_menu_repository.dart';
import 'package:mrpos/features/orders/data/repositories/orders_repository.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsCubit(
        repository: ReportsRepository(
          OrdersRepository(),
          FirestoreMenuRepository(),
        ),
        exportService: ExcelExportService(),
      )..loadReport(),
      child: const _ReportsScreenContent(),
    );
  }
}

class _ReportsScreenContent extends StatelessWidget {
  const _ReportsScreenContent();

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isDark = context.isDarkMode;

    return Material(
      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      child: Column(
        children: [
          _buildHeader(context, responsive),
          _buildTabs(context, responsive),
          Expanded(
            child: BlocConsumer<ReportsCubit, ReportsState>(
              listener: (context, state) {
                if (state is ReportsLoaded && state.data.records.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No data found for the selected range'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                if (state is ReportsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ReportsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  );
                }

                if (state is ReportsLoaded) {
                  return _buildReportContent(context, state.data, responsive);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveUtils responsive) {
    final isMobile = responsive.isMobile;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.responsive(mobile: 16, tablet: 24, desktop: 24),
        vertical: 16,
      ),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile) ...[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            8.w,
          ],
          Text(
            'Reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          // Notification with red dot
          NotificationBell(color: isDark ? Colors.white : Colors.black),
          20.w,
          // Profile Icon (Red Circle with Person)
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context, ResponsiveUtils responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.responsive(mobile: 16, tablet: 24, desktop: 32),
        vertical: 8,
      ),
      child: responsive.isMobile
          ? Column(
              children: [
                Row(
                  children: [
                    _buildTabItem('Revenue Report', true),
                    const Spacer(),
                    _buildGenerateButton(context, responsive),
                  ],
                ),
                12.h,
                _buildDatePicker(context, responsive),
              ],
            )
          : Row(
              children: [
                _buildTabItem('Revenue Report', true),
                const Spacer(),
                _buildDatePicker(context, responsive),
                16.w,
                _buildGenerateButton(context, responsive),
              ],
            ),
    );
  }

  Widget _buildTabItem(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? AppColors.primaryRed.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: active ? Border.all(color: AppColors.primaryRed) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? AppColors.primaryRed : Colors.grey,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, ResponsiveUtils responsive) {
    final isDark = context.isDarkMode;
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        DateTimeRange range;
        if (state is ReportsInitial) {
          range = state.dateRange;
        } else if (state is ReportsLoading) {
          range = state.dateRange;
        } else if (state is ReportsLoaded) {
          range = state.dateRange;
        } else if (state is ReportsError) {
          range = state.dateRange;
        } else {
          range = DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now(),
          );
        }
        final rangeText =
            '${DateFormat('dd/MM/yyyy').format(range.start)} — ${DateFormat('dd/MM/yyyy').format(range.end)}';

        return GestureDetector(
          onTap: () async {
            final picked = await showDialog<DateTimeRange>(
              context: context,
              builder: (context) =>
                  AdvancedDateRangePicker(initialRange: range),
            );
            if (picked != null) {
              if (context.mounted) {
                context.read<ReportsCubit>().updateDateRange(picked);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            width: responsive.isMobile ? double.infinity : null,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                10.w,
                Text(
                  rangeText,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                10.w,
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenerateButton(
    BuildContext context,
    ResponsiveUtils responsive,
  ) {
    return ElevatedButton(
      onPressed: () => context.read<ReportsCubit>().exportToExcel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed.withValues(alpha: 0.3),
        foregroundColor: AppColors.primaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.primaryRed),
        ),
      ),
      child: Text(
        responsive.isMobile ? 'Export' : 'Export Report',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildReportContent(
    BuildContext context,
    RevenueReportData data,
    ResponsiveUtils responsive,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.responsive(mobile: 16, tablet: 24, desktop: 32),
        vertical: 16,
      ),
      child: Column(
        children: [
          if (responsive.isMobile) ...[
            RevenueDoughnutChart(data: data),
            16.h,
            RevenueLineChart(data: data),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: RevenueDoughnutChart(data: data)),
                24.w,
                Expanded(flex: 3, child: RevenueLineChart(data: data)),
              ],
            ),
          ],
          24.h,
          ReportsTable(data: data),
        ],
      ),
    );
  }
}
