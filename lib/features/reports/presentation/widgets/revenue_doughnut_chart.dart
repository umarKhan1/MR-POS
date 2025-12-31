import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class RevenueDoughnutChart extends StatelessWidget {
  final RevenueReportData data;

  const RevenueDoughnutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final statusLabels = {
      OrderStatus.confirmed: 'Confirmed',
      OrderStatus.awaited: 'Awaited',
      OrderStatus.cancelled: 'Cancelled',
      OrderStatus.failed: 'Failed',
    };

    final statusColors = {
      OrderStatus.confirmed: AppColors.primaryRed,
      OrderStatus.awaited: AppColors.primaryRed.withValues(alpha: 0.7),
      OrderStatus.cancelled: AppColors.primaryRed.withValues(alpha: 0.4),
      OrderStatus.failed: AppColors.primaryRed.withValues(alpha: 0.2),
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Revenue',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          32.h,
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 400;
              return Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: isSmall ? 55 : 75,
                              sections: data.revenueByStatus.entries.map((
                                entry,
                              ) {
                                return PieChartSectionData(
                                  color: statusColors[entry.key],
                                  value: entry.value,
                                  title: '',
                                  radius: isSmall ? 25 : 35,
                                );
                              }).toList(),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${data.totalOrdersRevenue.toInt()}\$',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: isSmall ? 24 : 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.w,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.revenueByStatus.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32,
                              height: 12,
                              decoration: BoxDecoration(
                                color: statusColors[entry.key],
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            12.w,
                            Text(
                              statusLabels[entry.key]!,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
