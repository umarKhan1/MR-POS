import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:mrpos/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:mrpos/shared/widgets/stat_card.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is DashboardLoaded) {
          final size = MediaQuery.of(context).size;
          final isDesktop = size.width > 900;
          final isTablet = size.width > 600 && size.width <= 900;

          return LayoutBuilder(
            builder: (context, constraints) {
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildDailySales(state)),
                    16.w,
                    Expanded(child: _buildMonthlyRevenue(state)),
                    16.w,
                    Expanded(child: _buildTableOccupancy(state)),
                  ],
                );
              } else if (isTablet) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildDailySales(state)),
                        16.w,
                        Expanded(child: _buildMonthlyRevenue(state)),
                      ],
                    ),
                    16.h,
                    _buildTableOccupancy(state),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildDailySales(state),
                    16.h,
                    _buildMonthlyRevenue(state),
                    16.h,
                    _buildTableOccupancy(state),
                  ],
                );
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDailySales(DashboardLoaded state) {
    return StatCard(
      title: AppStrings.dailySales,
      value:
          '\$${state.dailySales >= 1000 ? '${(state.dailySales / 1000).toStringAsFixed(1)}k' : state.dailySales.toStringAsFixed(0)}',
      icon: FontAwesomeIcons.dollarSign,
      chartData: state.dailySalesChart,
      dateRange: DateFormat('d MMMM yyyy').format(DateTime.now()),
    );
  }

  Widget _buildMonthlyRevenue(DashboardLoaded state) {
    return StatCard(
      title: AppStrings.monthlyRevenue,
      value:
          '\$${state.monthlyRevenue >= 1000 ? '${(state.monthlyRevenue / 1000).toStringAsFixed(1)}k' : state.monthlyRevenue.toStringAsFixed(0)}',
      icon: FontAwesomeIcons.chartLine,
      chartData: state.monthlyRevenueChart,
      dateRange:
          '1 ${DateFormat('MMM').format(DateTime.now())} - ${DateFormat('d MMM').format(DateTime.now())}',
    );
  }

  Widget _buildTableOccupancy(DashboardLoaded state) {
    return StatCard(
      title: AppStrings.tableOccupancy,
      value: '${state.tableOccupancy} ${AppStrings.tables}',
      icon: FontAwesomeIcons.tableCellsLarge,
      chartData: state.tableOccupancyChart,
    );
  }
}
