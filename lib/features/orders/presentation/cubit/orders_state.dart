import 'package:mrpos/core/models/order.dart';

abstract class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  final List<Order> filteredOrders;
  final OrderStatus? selectedFilter;

  const OrdersLoaded({
    required this.orders,
    required this.filteredOrders,
    this.selectedFilter,
  });

  int get totalOrders => orders.length;
  int get readyCount =>
      orders.where((o) => o.status == OrderStatus.ready).length;
  int get inProcessCount =>
      orders.where((o) => o.status == OrderStatus.inProcess).length;
  int get completedCount =>
      orders.where((o) => o.status == OrderStatus.completed).length;
  int get cancelledCount =>
      orders.where((o) => o.status == OrderStatus.cancelled).length;

  OrdersLoaded copyWith({
    List<Order>? orders,
    List<Order>? filteredOrders,
    OrderStatus? selectedFilter,
    bool clearFilter = false,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      selectedFilter: clearFilter
          ? null
          : (selectedFilter ?? this.selectedFilter),
    );
  }
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);
}
