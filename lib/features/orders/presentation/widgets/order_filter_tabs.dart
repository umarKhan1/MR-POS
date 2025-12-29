import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class OrderFilterTabs extends StatelessWidget {
  const OrderFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final selectedFilter = state is OrdersLoaded
            ? state.selectedFilter
            : null;
        final counts = state is OrdersLoaded ? state : null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTab(
                context: context,
                label: 'All',
                count: counts?.totalOrders ?? 0,
                isSelected: selectedFilter == null,
                onTap: () => cubit.filterOrders(null),
                responsive: responsive,
              ),
              responsive.isMobile ? 8.w : 12.w,
              _buildTab(
                context: context,
                label: 'In Process',
                count: counts?.inProcessCount ?? 0,
                isSelected: selectedFilter == OrderStatus.inProcess,
                onTap: () => cubit.filterOrders(OrderStatus.inProcess),
                responsive: responsive,
              ),
              responsive.isMobile ? 8.w : 12.w,
              _buildTab(
                context: context,
                label: 'Completed',
                count: counts?.completedCount ?? 0,
                isSelected: selectedFilter == OrderStatus.completed,
                onTap: () => cubit.filterOrders(OrderStatus.completed),
                responsive: responsive,
              ),
              responsive.isMobile ? 8.w : 12.w,
              _buildTab(
                context: context,
                label: 'Cancelled',
                count: counts?.cancelledCount ?? 0,
                isSelected: selectedFilter == OrderStatus.cancelled,
                onTap: () => cubit.filterOrders(OrderStatus.cancelled),
                responsive: responsive,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    required ResponsiveUtils responsive,
  }) {
    final isDark = context.isDarkMode;
    final unselectedBg = isDark ? const Color(0xFF2A2A2A) : Colors.grey[200];
    final unselectedTextColor = isDark
        ? Colors.white.withValues(alpha: 0.7)
        : Colors.black54;
    final countBgPrimary = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.4);
    final countBgSecondary = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.isMobile ? 14 : 20,
            vertical: responsive.isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryRed : unselectedBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : unselectedTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.responsive(
                    mobile: 12.0,
                    tablet: 13.0,
                    desktop: 13.0,
                  ),
                ),
              ),
              if (count > 0) ...[
                responsive.isMobile ? 6.w : 8.w,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.isMobile ? 6 : 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? countBgPrimary : countBgSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black87),
                      fontSize: responsive.responsive(
                        mobile: 10.0,
                        tablet: 11.0,
                        desktop: 11.0,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
