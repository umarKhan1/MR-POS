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
    return Column(
      children: data.records.asMap().entries.map((entry) {
        final index = entry.key;
        final record = entry.value;
        final bool isEven = index % 2 == 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: isEven ? const Color(0xFF262626) : const Color(0xFF1E1E1E),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCell('S.No', record.sNo, width: 70),
                _buildDivider(),
                _buildCell('Top Selling Food', record.foodName, width: 220),
                _buildDivider(),
                _buildCell(
                  'Revenue By Date',
                  DateFormat('dd. MM. yyyy').format(record.date),
                  width: 180,
                ),
                _buildDivider(),
                _buildCell(
                  'Sell Price',
                  '\$${record.sellPrice.toStringAsFixed(2)}',
                  width: 110,
                ),
                _buildDivider(),
                _buildCell(
                  'Profit',
                  '\$${record.profit.toStringAsFixed(2)}',
                  width: 110,
                ),
                _buildDivider(),
                _buildCell(
                  'Profit Margin',
                  '${record.profitMargin.toStringAsFixed(2)}%',
                  width: 130,
                ),
                _buildDivider(),
                _buildCell(
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

  Widget _buildDivider() {
    return Container(
      height: 44,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white.withValues(alpha: 0.08),
    );
  }

  Widget _buildCell(String label, String value, {required double width}) {
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
