import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<double>? chartData;
  final Color? iconColor;
  final String? dateRange;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.chartData,
    this.iconColor,
    this.dateRange,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: responsive.responsive(
                      mobile: 13.0,
                      tablet: 14.0,
                      desktop: 14.0,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(responsive.isMobile ? 8 : 10),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primaryRed).withValues(
                    alpha: 0.15,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primaryRed,
                  size: responsive.isMobile ? 18 : 20,
                ),
              ),
            ],
          ),
          responsive.isMobile ? 12.h : 16.h,
          // Stack chart below value on mobile, side-by-side on larger screens
          if (responsive.isMobile && chartData != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildValueSection(context, isDark, responsive),
                12.h,
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _buildMiniChart(),
                ),
              ],
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildValueSection(context, isDark, responsive),
                ),
                if (chartData != null) ...[
                  16.w,
                  SizedBox(
                    width: responsive.isTablet ? 100 : 120,
                    height: 60,
                    child: _buildMiniChart(),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildValueSection(
    BuildContext context,
    bool isDark,
    ResponsiveUtils responsive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontSize: responsive.responsive(
              mobile: 24.0,
              tablet: 26.0,
              desktop: 28.0,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        if (dateRange != null) ...[
          8.h,
          Text(
            dateRange!,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark.withValues(alpha: 0.6)
                  : AppColors.textSecondaryLight.withValues(alpha: 0.6),
              fontSize: responsive.responsive(
                mobile: 11.0,
                tablet: 12.0,
                desktop: 12.0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMiniChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: chartData!.reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: chartData!
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value,
                    color: AppColors.primaryRed,
                    width: 6,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
