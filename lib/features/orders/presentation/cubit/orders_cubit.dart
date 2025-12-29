import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/orders_mock_data.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/notifications/domain/models/app_notification.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final NotificationCubit? _notificationCubit;

  OrdersCubit({NotificationCubit? notificationCubit})
    : _notificationCubit = notificationCubit,
      super(const OrdersInitial());

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

      _notificationCubit?.addNotification(
        title: 'New Order Created',
        message: 'Order #${order.orderNumber} has been successfully placed.',
        type: NotificationType.orderCreated,
      );

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
        final order = OrdersMockData.orders[index];
        OrdersMockData.orders[index] = order.copyWith(
          status: newStatus,
          statusDetail: statusDetail,
        );

        if (newStatus == OrderStatus.completed) {
          _notificationCubit?.addNotification(
            title: 'Order Completed',
            message: 'Order #${order.orderNumber} has been finalized.',
            type: NotificationType.orderCompleted,
          );
        }

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
      final order = OrdersMockData.orders.firstWhere((o) => o.id == orderId);
      OrdersMockData.orders.removeWhere((o) => o.id == orderId);
      final updatedOrders = List<Order>.from(OrdersMockData.orders);

      _notificationCubit?.addNotification(
        title: 'Order Deleted',
        message: 'Order #${order.orderNumber} was removed from the system.',
        type: NotificationType.orderDeleted,
      );

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
