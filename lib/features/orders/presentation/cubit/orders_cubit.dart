import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/orders_mock_data.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersInitial());

  void loadOrders() {
    emit(const OrdersLoading());
    try {
      final orders = List<Order>.from(OrdersMockData.orders);
      emit(OrdersLoaded(orders: orders, filteredOrders: orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void filterOrders(OrderStatus? status) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      final filtered = status == null
          ? currentState.orders
          : currentState.orders.where((o) => o.status == status).toList();

      emit(
        currentState.copyWith(
          filteredOrders: filtered,
          selectedFilter: status,
          clearFilter: status == null,
        ),
      );
    }
  }

  void addOrder(Order order) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      OrdersMockData.orders.add(order);
      final updatedOrders = List<Order>.from(OrdersMockData.orders);

      emit(
        currentState.copyWith(
          orders: updatedOrders,
          filteredOrders: currentState.selectedFilter == null
              ? updatedOrders
              : updatedOrders
                    .where((o) => o.status == currentState.selectedFilter)
                    .toList(),
        ),
      );
    }
  }

  void updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
    String statusDetail,
  ) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      final index = OrdersMockData.orders.indexWhere((o) => o.id == orderId);

      if (index != -1) {
        OrdersMockData.orders[index] = OrdersMockData.orders[index].copyWith(
          status: newStatus,
          statusDetail: statusDetail,
        );

        final updatedOrders = List<Order>.from(OrdersMockData.orders);
        emit(
          currentState.copyWith(
            orders: updatedOrders,
            filteredOrders: currentState.selectedFilter == null
                ? updatedOrders
                : updatedOrders
                      .where((o) => o.status == currentState.selectedFilter)
                      .toList(),
          ),
        );
      }
    }
  }

  void deleteOrder(String orderId) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      OrdersMockData.orders.removeWhere((o) => o.id == orderId);
      final updatedOrders = List<Order>.from(OrdersMockData.orders);

      emit(
        currentState.copyWith(
          orders: updatedOrders,
          filteredOrders: currentState.selectedFilter == null
              ? updatedOrders
              : updatedOrders
                    .where((o) => o.status == currentState.selectedFilter)
                    .toList(),
        ),
      );
    }
  }

  void refresh() {
    loadOrders();
  }
}
