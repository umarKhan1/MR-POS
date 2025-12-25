import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/core/router/route_names.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/stats_section.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/popular_dishes_card.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/overview_chart.dart';
import 'package:mrpos/shared/widgets/sidebar_nav.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;
    final isMobile = size.width <= 600;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: isMobile
          ? Drawer(
              child: SidebarNav(
                currentRoute: RouteNames.dashboard,
                isDrawer: true,
              ),
            )
          : null,
      body: Container(
        color: context.theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(
                onMenuTap: isMobile
                    ? () => scaffoldKey.currentState?.openDrawer()
                    : null,
              ),
              24.h,
              const StatsSection(),
              24.h,
              _buildPopularDishesSection(isDesktop, isTablet),
              24.h,
              const OverviewChart(),
              24.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularDishesSection(bool isDesktop, bool isTablet) {
    if (isDesktop || isTablet) {
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
