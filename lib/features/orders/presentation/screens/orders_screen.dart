import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/router/route_names.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';
import 'package:mrpos/features/orders/presentation/widgets/orders_header.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_filter_tabs.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_card.dart';
import 'package:mrpos/shared/widgets/sidebar_nav.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 600;

    return Scaffold(
      key: scaffoldKey,
      drawer: isMobile
          ? Drawer(
              child: SidebarNav(
                currentRoute: RouteNames.orderTable,
                isDrawer: true,
              ),
            )
          : null,
      backgroundColor: const Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrdersHeader(
              onMenuTap: isMobile
                  ? () => scaffoldKey.currentState?.openDrawer()
                  : null,
            ),
            24.h,
            const OrderFilterTabs(),
            24.h,
            BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFB3C1)),
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
                      final crossAxisCount = constraints.maxWidth > 1400
                          ? 3
                          : constraints.maxWidth > 900
                          ? 2
                          : 1;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.6, // Increased for shorter cards
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: state.filteredOrders.length,
                        itemBuilder: (context, index) {
                          return OrderCard(
                            order: state.filteredOrders[index],
                            orderIndex: index + 1,
                          );
                        },
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
  }
}
