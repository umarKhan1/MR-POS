import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_cubit.dart';
import 'package:mrpos/features/orders/presentation/widgets/menu_items_grid_for_order.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_cart_sidebar.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class CreateOrderScreen extends StatelessWidget {
  final String? orderId; // Optional order ID for edit mode

  const CreateOrderScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateOrderCubit()..loadOrderForEdit(orderId),
      child: _CreateOrderContent(orderId: orderId),
    );
  }
}

class _CreateOrderContent extends StatelessWidget {
  final String? orderId;

  const _CreateOrderContent({this.orderId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 600; // Changed from 900 to 600

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark theme background
      body: Row(
        children: [
          // Left side - Menu items
          Expanded(
            flex: isMobile ? 1 : 2,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => GoRouter.of(context).pop(),
                      ),
                      16.w,
                      Text(
                        orderId != null ? 'Edit Order' : 'Create Order',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu items grid
                const Expanded(child: MenuItemsGridForOrder()),
              ],
            ),
          ),
          // Right side - Cart - Always show on desktop
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: const OrderCartSidebar(),
          ),
        ],
      ),
    );
  }
}
