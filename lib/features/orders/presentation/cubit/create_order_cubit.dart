import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/core/constants/orders_mock_data.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  CreateOrderCubit() : super(const CreateOrderInitial());

  void loadOrderForEdit(String? orderId) {
    if (orderId == null) return;

    // Find the order
    final order = OrdersMockData.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => OrdersMockData.orders.first,
    );

    // Convert order items to cart items
    final cartItems = order.items.map((item) {
      return CartItem(
        menuItemId: item.menuItemId,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        image: '', // Will be filled from menu data if needed
      );
    }).toList();

    // Load into cart with order's tax and charges
    emit(
      CreateOrderInitial(
        cartItems: cartItems,
        tax: order.tax,
        charges: order.charges,
      ),
    );
  }

  void addItem(MenuItem menuItem) {
    if (state is CreateOrderInitial) {
      final currentState = state as CreateOrderInitial;
      final existingIndex = currentState.cartItems.indexWhere(
        (item) => item.menuItemId == menuItem.id,
      );

      List<CartItem> updatedCart;
      if (existingIndex != -1) {
        // Item exists, check if we can increase quantity
        final currentQuantity = currentState.cartItems[existingIndex].quantity;
        final newQuantity = currentQuantity + 1;

        // Check stock availability
        if (newQuantity > menuItem.quantity) {
          emit(
            CreateOrderError(
              'Cannot add more ${menuItem.name}. Only ${menuItem.quantity} available in stock.',
            ),
          );
          // Reset to initial state after showing error
          Future.delayed(const Duration(milliseconds: 100), () {
            emit(currentState);
          });
          return;
        }

        updatedCart = List.from(currentState.cartItems);
        updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
          quantity: newQuantity,
        );
      } else {
        // New item - check if available
        if (menuItem.quantity < 1) {
          emit(const CreateOrderError('Item is out of stock.'));
          Future.delayed(const Duration(milliseconds: 100), () {
            emit(currentState);
          });
          return;
        }

        updatedCart = [
          ...currentState.cartItems,
          CartItem(
            menuItemId: menuItem.id,
            name: menuItem.name,
            price: menuItem.price,
            quantity: 1,
            image: menuItem.image,
          ),
        ];
      }

      emit(currentState.copyWith(cartItems: updatedCart));
    }
  }

  void removeItem(String menuItemId) {
    if (state is CreateOrderInitial) {
      final currentState = state as CreateOrderInitial;
      final updatedCart = currentState.cartItems
          .where((item) => item.menuItemId != menuItemId)
          .toList();
      emit(currentState.copyWith(cartItems: updatedCart));
    }
  }

  void updateQuantity(String menuItemId, int quantity) {
    if (state is CreateOrderInitial) {
      final currentState = state as CreateOrderInitial;
      if (quantity <= 0) {
        removeItem(menuItemId);
        return;
      }

      // Find the menu item to check stock
      final menuItem = MenuMockData.menuItems.firstWhere(
        (item) => item.id == menuItemId,
        orElse: () => MenuMockData.menuItems.first,
      );

      // Check if requested quantity exceeds available stock
      if (quantity > menuItem.quantity) {
        emit(
          CreateOrderError(
            'Cannot set quantity to $quantity. Only ${menuItem.quantity} available in stock.',
          ),
        );
        // Reset to current state after showing error
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(currentState);
        });
        return;
      }

      final updatedCart = currentState.cartItems.map((item) {
        if (item.menuItemId == menuItemId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList();

      emit(currentState.copyWith(cartItems: updatedCart));
    }
  }

  void clearCart() {
    emit(const CreateOrderInitial());
  }

  void placeOrder(String customerName) {
    if (state is CreateOrderInitial) {
      final currentState = state as CreateOrderInitial;
      if (currentState.cartItems.isEmpty) {
        emit(const CreateOrderError('Cart is empty'));
        return;
      }

      emit(const CreateOrderLoading());

      try {
        // Create order
        final order = Order(
          id: 'order_${DateTime.now().millisecondsSinceEpoch}',
          orderNumber: '#${990 + OrdersMockData.orders.length + 1}',
          customerName: customerName,
          orderDate: DateTime.now(),
          status: OrderStatus.inProcess,
          statusDetail: 'Cooking Now',
          items: currentState.cartItems
              .map(
                (item) => OrderItem(
                  menuItemId: item.menuItemId,
                  name: item.name,
                  quantity: item.quantity,
                  price: item.price,
                ),
              )
              .toList(),
          tax: currentState.tax,
          charges: currentState.charges,
        );

        // Add to orders
        OrdersMockData.orders.insert(0, order);

        // Decrease stock for each item
        for (final cartItem in currentState.cartItems) {
          final menuItemIndex = MenuMockData.menuItems.indexWhere(
            (item) => item.id == cartItem.menuItemId,
          );

          if (menuItemIndex != -1) {
            final menuItem = MenuMockData.menuItems[menuItemIndex];
            final newQuantity = menuItem.quantity - cartItem.quantity;

            // Update quantity and status
            String newStatus = 'instock';
            if (newQuantity <= 0) {
              newStatus = 'outofstock';
            } else if (newQuantity <= 10) {
              newStatus = 'lowstock';
            }

            MenuMockData.menuItems[menuItemIndex] = MenuItem(
              id: menuItem.id,
              name: menuItem.name,
              description: menuItem.description,
              itemId: menuItem.itemId,
              image: menuItem.image,
              quantity: newQuantity > 0 ? newQuantity : 0,
              stockStatus: newStatus,
              isPerishable: menuItem.isPerishable,
              category: menuItem.category,
              price: menuItem.price,
              costPrice: menuItem.costPrice,
              isAvailable: newQuantity > 0,
              menuType: menuItem.menuType,
            );
          }
        }

        emit(CreateOrderSuccess(order));
      } catch (e) {
        emit(CreateOrderError(e.toString()));
      }
    }
  }
}
