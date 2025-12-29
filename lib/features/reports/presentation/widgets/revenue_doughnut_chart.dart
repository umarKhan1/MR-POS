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
    final statusLabels = {
      OrderStatus.completed: 'Confirmed',
      OrderStatus.ready: 'Awaited',
      OrderStatus.cancelled: 'Cancelled',
      OrderStatus.inProcess: 'Failed',
    };

    final statusColors = {
      OrderStatus.completed: AppColors.primaryRed,
      OrderStatus.ready: AppColors.primaryRed.withValues(alpha: 0.7),
      OrderStatus.cancelled: AppColors.primaryRed.withValues(alpha: 0.4),
      OrderStatus.inProcess: AppColors.primaryRed.withValues(alpha: 0.2),
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Revenue',
            style: TextStyle(
              color: Colors.white,
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
                              const Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${data.totalRevenue.toInt()}\$',
                                style: TextStyle(
                                  color: Colors.white,
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
                              style: const TextStyle(
                                color: Colors.white,
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
