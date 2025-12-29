import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

enum TimeFilter { monthly, daily, weekly }

class OverviewChart extends StatefulWidget {
  const OverviewChart({super.key});

  @override
  State<OverviewChart> createState() => _OverviewChartState();
}

class _OverviewChartState extends State<OverviewChart> {
  TimeFilter selectedFilter = TimeFilter.monthly;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final responsive = ResponsiveUtils(context);

    return Container(
      padding: EdgeInsets.all(responsive.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark, responsive),
          responsive.isMobile ? 16.h : 24.h,
          _buildLegend(isDark, responsive),
          responsive.isMobile ? 16.h : 24.h,
          SizedBox(
            height: responsive.responsive(
              mobile: 200.0,
              tablet: 250.0,
              desktop: 300.0,
            ),
            child: _buildChart(isDark, responsive),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, ResponsiveUtils responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.overview,
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontSize: responsive.responsive(
              mobile: 18.0,
              tablet: 20.0,
              desktop: 20.0,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        responsive.isMobile ? 12.h : 16.h,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterButton(
              TimeFilter.monthly,
              AppStrings.monthly,
              isDark,
              responsive,
            ),
            _buildFilterButton(
              TimeFilter.daily,
              AppStrings.daily,
              isDark,
              responsive,
            ),
            _buildFilterButton(
              TimeFilter.weekly,
              AppStrings.weekly,
              isDark,
              responsive,
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: FaIcon(
                FontAwesomeIcons.download,
                size: responsive.isMobile ? 12 : 14,
              ),
              label: Text(AppStrings.export),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                side: BorderSide(
                  color: isDark ? AppColors.greyDark : AppColors.greyLight,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.isMobile ? 12 : 16,
                  vertical: responsive.isMobile ? 10 : 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(
    TimeFilter filter,
    String label,
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    final isSelected = selectedFilter == filter;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filter),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.isMobile ? 12 : 16,
          vertical: responsive.isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontSize: responsive.responsive(
              mobile: 13.0,
              tablet: 14.0,
              desktop: 14.0,
            ),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDark, ResponsiveUtils responsive) {
    return Row(
      children: [
        _buildLegendItem(
          AppStrings.sales,
          AppColors.primaryRed,
          isDark,
          responsive,
        ),
        responsive.isMobile ? 16.w : 24.w,
        _buildLegendItem(
          AppStrings.revenue,
          AppColors.grey,
          isDark,
          responsive,
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    String label,
    Color color,
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    return Row(
      children: [
        Container(
          width: responsive.isMobile ? 10 : 12,
          height: responsive.isMobile ? 10 : 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        8.w,
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            fontSize: responsive.responsive(
              mobile: 13.0,
              tablet: 14.0,
              desktop: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(bool isDark, ResponsiveUtils responsive) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1000,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: responsive.isMobile ? 25 : 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < MockData.chartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      MockData.chartData[value.toInt()].month,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontSize: responsive.responsive(
                          mobile: 10.0,
                          tablet: 12.0,
                          desktop: 12.0,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1000,
              reservedSize: responsive.isMobile ? 35 : 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${(value / 1000).toInt()}k',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: responsive.responsive(
                      mobile: 10.0,
                      tablet: 12.0,
                      desktop: 12.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (MockData.chartData.length - 1).toDouble(),
        minY: 0,
        maxY: 6000,
        lineBarsData: [
          // Sales line
          LineChartBarData(
            spots: MockData.chartData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.sales))
                .toList(),
            isCurved: true,
            color: AppColors.primaryRed,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Revenue line
          LineChartBarData(
            spots: MockData.chartData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.revenue))
                .toList(),
            isCurved: true,
            color: AppColors.grey,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                isDark ? const Color(0xFF3A3A3A) : Colors.white,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${spot.y.toStringAsFixed(0)}',
                  TextStyle(color: spot.bar.color, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
