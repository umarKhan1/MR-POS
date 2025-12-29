import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class ReportsTable extends StatelessWidget {
  final RevenueReportData data;

  const ReportsTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Column(
      children: data.records.asMap().entries.map((entry) {
        final index = entry.key;
        final record = entry.value;
        final bool isEven = index % 2 == 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: isEven
                ? (isDark ? const Color(0xFF262626) : Colors.grey[100])
                : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCell(context, 'S.No', record.sNo, width: 70),
                _buildDivider(isDark),
                _buildCell(
                  context,
                  'Top Selling Food',
                  record.foodName,
                  width: 220,
                ),
                _buildDivider(isDark),
                _buildCell(
                  context,
                  'Revenue By Date',
                  DateFormat('dd. MM. yyyy').format(record.date),
                  width: 180,
                ),
                _buildDivider(isDark),
                _buildCell(
                  context,
                  'Sell Price',
                  '\$${record.sellPrice.toStringAsFixed(2)}',
                  width: 110,
                ),
                _buildDivider(isDark),
                _buildCell(
                  context,
                  'Profit',
                  '\$${record.profit.toStringAsFixed(2)}',
                  width: 110,
                ),
                _buildDivider(isDark),
                _buildCell(
                  context,
                  'Profit Margin',
                  '${record.profitMargin.toStringAsFixed(2)}%',
                  width: 130,
                ),
                _buildDivider(isDark),
                _buildCell(
                  context,
                  'Total Revenue',
                  '\$${record.revenue.toStringAsFixed(2)}',
                  width: 140,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 44,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
    );
  }

  Widget _buildCell(
    BuildContext context,
    String label,
    String value, {
    required double width,
  }) {
    final isDark = context.isDarkMode;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.primaryRed.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          6.h,
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
