import 'package:mrpos/core/models/order.dart';

class CartItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String image;

  CartItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  double get total => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      menuItemId: menuItemId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      image: image,
    );
  }
}

abstract class CreateOrderState {
  const CreateOrderState();
}

class CreateOrderInitial extends CreateOrderState {
  final List<CartItem> cartItems;
  final double tax;
  final double charges;

  const CreateOrderInitial({
    this.cartItems = const [],
    this.tax = 0.0,
    this.charges = 0.0, // Changed from 24.0 to 0.0
  });

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + tax + charges;
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  CreateOrderInitial copyWith({
    List<CartItem>? cartItems,
    double? tax,
    double? charges,
  }) {
    return CreateOrderInitial(
      cartItems: cartItems ?? this.cartItems,
      tax: tax ?? this.tax,
      charges: charges ?? this.charges,
    );
  }
}

class CreateOrderLoading extends CreateOrderState {
  const CreateOrderLoading();
}

class CreateOrderSuccess extends CreateOrderState {
  final Order order;

  const CreateOrderSuccess(this.order);
}

class CreateOrderError extends CreateOrderState {
  final String message;

  const CreateOrderError(this.message);
}
