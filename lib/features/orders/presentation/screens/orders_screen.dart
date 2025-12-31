import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';
import 'package:mrpos/features/orders/presentation/widgets/orders_header.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_filter_tabs.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_card.dart';
import 'package:mrpos/features/orders/presentation/widgets/orders_shimmer.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        final isDark = context.isDarkMode;
        return Container(
          color: isDark
              ? const Color(0xFF1A1A1A)
              : Theme.of(context).scaffoldBackgroundColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(responsive.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OrdersHeader(),
                24.h,
                const OrderFilterTabs(),
                24.h,
                BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoading) {
                      return const OrdersShimmer();
                    }

                    if (state is OrdersError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is OrdersLoaded) {
                      if (state.filteredOrders.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.black.withOpacity(0.1),
                                ),
                                16.h,
                                Text(
                                  'Ready for your next order!',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                8.h,
                                Text(
                                  'New orders will appear here in real-time.',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.black38,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = responsive.responsive(
                            mobile: 1,
                            tablet: 2,
                            desktop: 3,
                          );

                          // Calculate card width based on available space
                          final spacing = responsive.isMobile ? 12.0 : 16.0;
                          final totalSpacing = spacing * (crossAxisCount - 1);
                          final cardWidth =
                              (constraints.maxWidth - totalSpacing) /
                              crossAxisCount;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: responsive.isMobile ? 12.0 : 15.0,
                            children: List.generate(
                              state.filteredOrders.length,
                              (index) => SizedBox(
                                width: cardWidth,
                                child: OrderCard(
                                  order: state.filteredOrders[index],
                                  orderIndex: index + 1,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
