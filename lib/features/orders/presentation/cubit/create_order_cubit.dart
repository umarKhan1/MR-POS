import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/menu/domain/repositories/menu_repository.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/domain/repositories/orders_repository.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final IOrdersRepository _ordersRepository;
  final MenuRepository _menuRepository;

  CreateOrderCubit({
    required IOrdersRepository ordersRepository,
    required MenuRepository menuRepository,
  }) : _ordersRepository = ordersRepository,
       _menuRepository = menuRepository,
       super(const CreateOrderInitial());

  void loadOrderForEdit(Order? order) {
    if (order == null) return;

    // Convert order items to cart items
    final cartItems = order.items.map((item) {
      return CartItem(
        menuItemId: item.menuItemId,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        image: '', // Image isn't strictly needed for cart operations
      );
    }).toList();

    // Load into cart with order's tax and charges and store the source order
    emit(
      CreateOrderInitial(
        cartItems: cartItems,
        tax: order.tax,
        charges: order.charges,
        editingOrder: order,
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

  void updateQuantity(MenuItem menuItem, int quantity) {
    if (state is CreateOrderInitial) {
      final currentState = state as CreateOrderInitial;
      if (quantity <= 0) {
        removeItem(menuItem.id);
        return;
      }

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
        if (item.menuItemId == menuItem.id) {
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

  Future<void> placeOrder(
    String customerName,
    List<MenuItem> currentMenuItems,
  ) async {
    if (state is CreateOrderInitial) {
      final currentState = state as CreateOrderInitial;
      if (currentState.cartItems.isEmpty) {
        emit(const CreateOrderError('Cart is empty'));
        return;
      }

      emit(const CreateOrderLoading());

      try {
        final isEditing = currentState.editingOrder != null;

        // 1. Create/Update order object
        final orderId = isEditing
            ? currentState.editingOrder!.id
            : 'order_${DateTime.now().millisecondsSinceEpoch}';

        final order = Order(
          id: orderId,
          orderNumber: isEditing
              ? currentState.editingOrder!.orderNumber
              : '', // Suffix logic can be here
          customerName: customerName.isEmpty
              ? 'Walk-in Customer'
              : customerName,
          orderDate: isEditing
              ? currentState.editingOrder!.orderDate
              : DateTime.now(),
          status: isEditing
              ? currentState.editingOrder!.status
              : OrderStatus.awaited,
          statusDetail: isEditing
              ? currentState.editingOrder!.statusDetail
              : 'Awaited',
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

        // 2. Persist to Firestore
        if (isEditing) {
          await _ordersRepository.updateOrder(order);

          // 3. Handle stock adjustments for EDITS
          final oldOrder = currentState.editingOrder!;

          // Restore ALL stock from the old order first to simplify logic
          for (final oldItem in oldOrder.items) {
            try {
              final menuItem = currentMenuItems.firstWhere(
                (m) => m.id == oldItem.menuItemId,
              );
              await _menuRepository.updateMenuItem(
                menuItem.copyWith(
                  quantity: menuItem.quantity + oldItem.quantity,
                ),
              );

              // Update our local reference of stock to reflect this restoration
              final index = currentMenuItems.indexOf(menuItem);
              currentMenuItems[index] = menuItem.copyWith(
                quantity: menuItem.quantity + oldItem.quantity,
              );
            } catch (e) {
              // Item might have been deleted from menu, skip
            }
          }
        } else {
          await _ordersRepository.addOrder(order);
        }

        // 4. Decrease stock for the NEW/CURRENT quantities
        for (final cartItem in currentState.cartItems) {
          try {
            final menuItem = currentMenuItems.firstWhere(
              (m) => m.id == cartItem.menuItemId,
            );

            await _menuRepository.updateMenuItem(
              menuItem.copyWith(
                quantity: menuItem.quantity - cartItem.quantity,
              ),
            );
          } catch (e) {
            // Item not found in currentMenuItems... should not happen but handle anyway
          }
        }

        emit(CreateOrderSuccess(order));
      } catch (e) {
        emit(CreateOrderError(e.toString()));
      }
    }
  }
}
