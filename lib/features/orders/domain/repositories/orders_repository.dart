import 'package:mrpos/core/models/order.dart';

abstract class IOrdersRepository {
  Stream<List<Order>> getOrders();
  Future<void> addOrder(Order order);
  Future<void> updateOrderStatus(
    String id,
    OrderStatus status,
    String statusDetail,
  );
  Future<void> cancelOrder(String id);
  Future<void> deleteOrder(String id);
  Future<void> updateOrder(Order order);
  Future<List<Order>> getOrdersByDateRange(DateTime start, DateTime end);
}
