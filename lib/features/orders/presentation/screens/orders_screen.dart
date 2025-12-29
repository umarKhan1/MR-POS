import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';
import 'package:mrpos/features/orders/presentation/widgets/orders_header.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_filter_tabs.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_card.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        return Container(
          color: const Color(0xFF1A1A1A),
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
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFB3C1),
                        ),
                      );
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
                            padding: const EdgeInsets.all(48),
                            child: Text(
                              'No orders found',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 16,
                              ),
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
