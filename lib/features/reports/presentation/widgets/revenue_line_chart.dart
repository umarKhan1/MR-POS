import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class RevenueLineChart extends StatefulWidget {
  final RevenueReportData data;

  const RevenueLineChart({super.key, required this.data});

  @override
  State<RevenueLineChart> createState() => _RevenueLineChartState();
}

class _RevenueLineChartState extends State<RevenueLineChart> {
  String _activeTab = 'Confirmed';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChartTab('Confirmed', isDark),
                8.w,
                _buildChartTab('Awaited', isDark),
                8.w,
                _buildChartTab('Cancelled', isDark),
                8.w,
                _buildChartTab('Failed', isDark),
              ],
            ),
          ),
          40.h,
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: textColor.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 1000,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text(
                            '${(value / 1000).toInt()}k',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Crucial to prevent duplication
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'JAN',
                          'FEB',
                          'MAR',
                          'APR',
                          'MAY',
                          'JUN',
                          'JUL',
                          'AUG',
                          'SEP',
                          'OCT',
                          'NOV',
                          'DEC',
                        ];
                        final index = value.toInt();
                        if (index >= 0 && index < months.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 12,
                            child: Text(
                              months[index],
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.5),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.data.monthlyTrend.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.revenue);
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primaryRed,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 5,
                            color: AppColors.primaryRed,
                            strokeWidth: 2,
                            strokeColor: isDark ? Colors.white : Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryRed.withValues(alpha: 0.3),
                          AppColors.primaryRed.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: widget.data.monthlyTrend.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.revenue * 0.65);
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.15,
                    color: textColor.withValues(alpha: 0.15),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()}\$',
                          TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: AppColors.primaryRed.withValues(
                                alpha: 0.3,
                              ),
                              strokeWidth: 2,
                            ),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                    radius: 7,
                                    color: AppColors.primaryRed,
                                    strokeWidth: 2,
                                    strokeColor: isDark
                                        ? Colors.white
                                        : Colors.white,
                                  ),
                            ),
                          );
                        }).toList();
                      },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab(String label, bool isDark) {
    final active = _activeTab == label;
    final textColor = isDark ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primaryRed.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primaryRed : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? AppColors.primaryRed
                : textColor.withValues(alpha: 0.6),
            fontSize: 15,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
