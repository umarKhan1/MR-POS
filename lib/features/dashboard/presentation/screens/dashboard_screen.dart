import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/stats_section.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/popular_dishes_card.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/overview_chart.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        return Container(
          color: context.theme.scaffoldBackgroundColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(responsive.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHeader(),
                24.h,
                const StatsSection(),
                24.h,
                _buildPopularDishesSection(responsive),
                24.h,
                const OverviewChart(),
                24.h,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularDishesSection(ResponsiveUtils responsive) {
    if (responsive.isDesktop || responsive.isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PopularDishesCard(
              title: AppStrings.popularDishes,
              dishes: MockData.popularDishesServing,
            ),
          ),
          16.w,
          Expanded(
            child: PopularDishesCard(
              title: AppStrings.mostFamous,
              dishes: MockData.popularDishesOrders,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          PopularDishesCard(
            title: AppStrings.popularDishes,
            dishes: MockData.popularDishesServing,
          ),
          16.h,
          PopularDishesCard(
            title: AppStrings.mostFamous,
            dishes: MockData.popularDishesOrders,
          ),
        ],
      );
    }
  }
}
