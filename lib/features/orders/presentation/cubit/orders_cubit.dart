import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/notifications/domain/models/app_notification.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:mrpos/features/orders/domain/repositories/orders_repository.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final IOrdersRepository _repository;
  final NotificationCubit? _notificationCubit;
  StreamSubscription? _ordersSubscription;

  OrdersCubit({
    required IOrdersRepository repository,
    NotificationCubit? notificationCubit,
  }) : _repository = repository,
       _notificationCubit = notificationCubit,
       super(const OrdersInitial());

  void loadOrders() {
    emit(const OrdersLoading());
    _ordersSubscription?.cancel();
    _ordersSubscription = _repository.getOrders().listen((orders) {
      if (state is OrdersLoaded) {
        final currentState = state as OrdersLoaded;
        final updatedFiltered = currentState.selectedFilter == null
            ? orders
            : orders
                  .where((o) => o.status == currentState.selectedFilter)
                  .toList();

        emit(
          currentState.copyWith(
            orders: orders,
            filteredOrders: updatedFiltered,
          ),
        );
      } else {
        emit(OrdersLoaded(orders: orders, filteredOrders: orders));
      }
    }, onError: (e) => emit(OrdersError(e.toString())));
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

  Future<void> addOrder(Order order) async {
    try {
      await _repository.addOrder(order);
      _notificationCubit?.addNotification(
        title: 'New Order Created',
        message: 'Order #${order.orderNumber} has been successfully placed.',
        type: NotificationType.orderCreated,
      );
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
    String statusDetail,
  ) async {
    try {
      await _repository.updateOrderStatus(orderId, newStatus, statusDetail);

      if (newStatus == OrderStatus.confirmed) {
        // Find the order number for notification
        if (state is OrdersLoaded) {
          final order = (state as OrdersLoaded).orders.firstWhere(
            (o) => o.id == orderId,
          );
          _notificationCubit?.addNotification(
            title: 'Order Completed',
            message: 'Order #${order.orderNumber} has been finalized.',
            type: NotificationType.orderCompleted,
          );
        }
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _repository.cancelOrder(orderId);
      if (state is OrdersLoaded) {
        final order = (state as OrdersLoaded).orders.firstWhere(
          (o) => o.id == orderId,
        );
        _notificationCubit?.addNotification(
          title: 'Order Cancelled',
          message: 'Order #${order.orderNumber} has been cancelled.',
          type: NotificationType.orderDeleted,
        );
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      // For notifications, find the order first
      Order? order;
      if (state is OrdersLoaded) {
        order = (state as OrdersLoaded).orders.firstWhere(
          (o) => o.id == orderId,
        );
      }

      await _repository.deleteOrder(orderId);

      _notificationCubit?.addNotification(
        title: 'Order Deleted',
        message:
            'Order #${order?.orderNumber ?? orderId} was removed from the system.',
        type: NotificationType.orderDeleted,
      );
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void refresh() {
    loadOrders();
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
