import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class OrderFilterTabs extends StatelessWidget {
  const OrderFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
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
                label: 'All',
                count: counts?.totalOrders ?? 0,
                isSelected: selectedFilter == null,
                onTap: () => cubit.filterOrders(null),
              ),
              12.w,
              _buildTab(
                label: 'In Process',
                count: counts?.inProcessCount ?? 0,
                isSelected: selectedFilter == OrderStatus.inProcess,
                onTap: () => cubit.filterOrders(OrderStatus.inProcess),
              ),
              12.w,
              _buildTab(
                label: 'Completed',
                count: counts?.completedCount ?? 0,
                isSelected: selectedFilter == OrderStatus.completed,
                onTap: () => cubit.filterOrders(OrderStatus.completed),
              ),
              12.w,
              _buildTab(
                label: 'Cancelled',
                count: counts?.cancelledCount ?? 0,
                isSelected: selectedFilter == OrderStatus.cancelled,
                onTap: () => cubit.filterOrders(OrderStatus.cancelled),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryRed : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (count > 0) ...[
                8.w,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
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
