import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepository implements IOrdersRepository {
  final FirebaseFirestore _firestore;

  OrdersRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Order>> getOrders() {
    return _firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
        });
  }

  @override
  Future<void> addOrder(Order order) async {
    final data = {
      'orderNumber': order.orderNumber,
      'customerName': order.customerName,
      'orderDate': Timestamp.fromDate(order.orderDate),
      'status': order.status.name,
      'statusDetail': order.statusDetail,
      'items': order.items.map((item) => item.toJson()).toList(),
      'tax': order.tax,
      'charges': order.charges,
    };

    await _firestore
        .collection('orders')
        .doc(order.id)
        .set(data)
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> updateOrder(Order order) async {
    final data = {
      'orderNumber': order.orderNumber,
      'customerName': order.customerName,
      'orderDate': Timestamp.fromDate(order.orderDate),
      'status': order.status.name,
      'statusDetail': order.statusDetail,
      'items': order.items.map((item) => item.toJson()).toList(),
      'tax': order.tax,
      'charges': order.charges,
    };

    await _firestore
        .collection('orders')
        .doc(order.id)
        .update(data)
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> updateOrderStatus(
    String id,
    OrderStatus status,
    String statusDetail,
  ) async {
    await _firestore
        .collection('orders')
        .doc(id)
        .update({'status': status.name, 'statusDetail': statusDetail})
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> cancelOrder(String id) async {
    await _firestore
        .collection('orders')
        .doc(id)
        .update({
          'status': OrderStatus.cancelled.name,
          'statusDetail': 'Order Cancelled',
        })
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> deleteOrder(String id) {
    return _firestore.collection('orders').doc(id).delete();
  }

  @override
  Future<List<Order>> getOrdersByDateRange(DateTime start, DateTime end) async {
    final querySnapshot = await _firestore
        .collection('orders')
        .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('orderDate', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    return querySnapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
  }
}
