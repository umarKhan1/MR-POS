import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_state.dart';
import 'package:mrpos/features/orders/presentation/widgets/menu_items_grid_for_order.dart';
import 'package:mrpos/features/orders/presentation/widgets/order_cart_sidebar.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

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

class _CreateOrderContent extends StatefulWidget {
  final String? orderId;

  const _CreateOrderContent({this.orderId});

  @override
  State<_CreateOrderContent> createState() => _CreateOrderContentState();
}

class _CreateOrderContentState extends State<_CreateOrderContent> {
  final ValueNotifier<bool> _isCartVisible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isCartVisible.dispose();
    super.dispose();
  }

  void _toggleCart() {
    _isCartVisible.value = !_isCartVisible.value;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(
                  responsive.responsive(
                    mobile: 16.0,
                    tablet: 18.0,
                    desktop: 20.0,
                  ),
                ),
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
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => GoRouter.of(context).pop(),
                      tooltip: 'Back',
                    ),
                    responsive.responsive(
                      mobile: 8.w,
                      tablet: 12.w,
                      desktop: 16.w,
                    ),
                    // Title
                    Expanded(
                      child: Text(
                        widget.orderId != null ? 'Edit Order' : 'Create Order',
                        style: TextStyle(
                          fontSize: responsive.responsive(
                            mobile: 18.0,
                            tablet: 19.0,
                            desktop: 20.0,
                          ),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Cart button (mobile/tablet only)
                    if (responsive.isMobileOrTablet)
                      BlocBuilder<CreateOrderCubit, CreateOrderState>(
                        builder: (context, state) {
                          final itemCount = state is CreateOrderInitial
                              ? state.cartItems.length
                              : 0;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.cartShopping,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleCart,
                                tooltip: 'View Cart',
                              ),
                              if (itemCount > 0)
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryRed,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        itemCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
              // Menu items grid
              Expanded(
                child: Row(
                  children: [
                    // Menu items (always visible)
                    Expanded(child: const MenuItemsGridForOrder()),
                    // Cart sidebar (desktop only - always visible)
                    if (responsive.isDesktop)
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
              ),
            ],
          ),
          // Cart overlay (mobile/tablet only)
          if (responsive.isMobileOrTablet)
            ValueListenableBuilder<bool>(
              valueListenable: _isCartVisible,
              builder: (context, isVisible, child) {
                if (!isVisible) return const SizedBox.shrink();

                return Stack(
                  children: [
                    // Backdrop
                    GestureDetector(
                      onTap: _toggleCart,
                      child: Container(color: Colors.black54),
                    ),
                    // Cart sidebar
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: responsive.isMobile ? responsive.width : 380,
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
                        child: OrderCartSidebar(onClose: _toggleCart),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
