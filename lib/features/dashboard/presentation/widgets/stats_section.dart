import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/shared/widgets/stat_card.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return Row(
            children: [
              Expanded(child: _buildDailySales()),
              16.w,
              Expanded(child: _buildMonthlyRevenue()),
              16.w,
              Expanded(child: _buildTableOccupancy()),
            ],
          );
        } else if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildDailySales()),
                  16.w,
                  Expanded(child: _buildMonthlyRevenue()),
                ],
              ),
              16.h,
              _buildTableOccupancy(),
            ],
          );
        } else {
          return Column(
            children: [
              _buildDailySales(),
              16.h,
              _buildMonthlyRevenue(),
              16.h,
              _buildTableOccupancy(),
            ],
          );
        }
      },
    );
  }

  Widget _buildDailySales() {
    return StatCard(
      title: AppStrings.dailySales,
      value: '\$${(MockData.dailySalesValue / 1000).toStringAsFixed(0)}k',
      icon: FontAwesomeIcons.dollarSign,
      chartData: MockData.dailySalesData,
      dateRange: '9 February 2024',
    );
  }

  Widget _buildMonthlyRevenue() {
    return StatCard(
      title: AppStrings.monthlyRevenue,
      value: '\$${(MockData.monthlyRevenueValue / 1000).toStringAsFixed(0)}k',
      icon: FontAwesomeIcons.chartLine,
      chartData: MockData.monthlyRevenueData,
      dateRange: '1 Jan - 1 Feb',
    );
  }

  Widget _buildTableOccupancy() {
    return StatCard(
      title: AppStrings.tableOccupancy,
      value: '${MockData.tableOccupancyValue} ${AppStrings.tables}',
      icon: FontAwesomeIcons.tableCellsLarge,
      chartData: MockData.tableOccupancyData,
    );
  }
}
