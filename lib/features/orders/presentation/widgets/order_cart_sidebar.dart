import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_state.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class OrderCartSidebar extends StatefulWidget {
  const OrderCartSidebar({super.key});

  @override
  State<OrderCartSidebar> createState() => _OrderCartSidebarState();
}

class _OrderCartSidebarState extends State<OrderCartSidebar> {
  final _customerNameController = TextEditingController(text: 'Watson Joyce');

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateOrderCubit, CreateOrderState>(
      listener: (context, state) {
        if (state is CreateOrderSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );

          // Navigate back immediately
          context.go('/order-table');

          // Reload orders after navigation
          Future.delayed(const Duration(milliseconds: 100), () {
            if (context.mounted) {
              context.read<OrdersCubit>().loadOrders();
            }
          });
        } else if (state is CreateOrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is CreateOrderLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        final currentState = state is CreateOrderInitial
            ? state
            : const CreateOrderInitial();

        final orderNumber = '#256482';

        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order $orderNumber',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => GoRouter.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Cart items
            Expanded(
              child: currentState.cartItems.isEmpty
                  ? Center(
                      child: Text(
                        'No items in cart',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: currentState.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = currentState.cartItems[index];
                        return _CartItemWidget(item: item);
                      },
                    ),
            ),
            // Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                border: Border(top: BorderSide(color: Colors.grey[800]!)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', currentState.subtotal),
                  8.h,
                  _buildSummaryRow('Tax', currentState.tax),
                  8.h,
                  _buildSummaryRow('Charges', currentState.charges),
                  16.h,
                  Divider(color: Colors.grey[700]),
                  12.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$${currentState.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  20.h,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: currentState.cartItems.isEmpty
                          ? null
                          : () {
                              context.read<CreateOrderCubit>().placeOrder(
                                _customerNameController.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _CartItemWidget extends StatelessWidget {
  final CartItem item;

  const _CartItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.restaurant, color: Colors.grey[600]),
          ),
          12.w,
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.h,
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls
          Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: () {
                  context.read<CreateOrderCubit>().updateQuantity(
                    item.menuItemId,
                    item.quantity - 1,
                  );
                },
              ),
              12.w,
              Text(
                item.quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              12.w,
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: () {
                  context.read<CreateOrderCubit>().updateQuantity(
                    item.menuItemId,
                    item.quantity + 1,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
