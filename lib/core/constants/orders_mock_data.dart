import 'package:mrpos/core/models/order.dart';

class OrdersMockData {
  OrdersMockData._();

  static final List<Order> orders = [
    // Order 1 - Ready
    Order(
      id: '1',
      orderNumber: '#990',
      customerName: 'Watson Joyce',
      orderDate: DateTime(2024, 12, 28, 16, 48),
      status: OrderStatus.ready,
      statusDetail: 'Ready to serve',
      tax: 0.0,
      charges: 0.0,
      items: [
        OrderItem(
          menuItemId: '1',
          name: 'Scrambled eggs with toast',
          quantity: 1,
          price: 199.0,
        ),
        OrderItem(
          menuItemId: '6',
          name: 'Smoked Salmon Bagel',
          quantity: 1,
          price: 120.0,
        ),
        OrderItem(
          menuItemId: '4',
          name: 'Belgian Waffles',
          quantity: 2,
          price: 220.0,
        ),
        OrderItem(
          menuItemId: '12',
          name: 'Classi Lemonade',
          quantity: 1,
          price: 110.0,
        ),
      ],
    ),

    // Order 2 - In Process
    Order(
      id: '2',
      orderNumber: '#990',
      customerName: 'Watson Joyce',
      orderDate: DateTime(2024, 12, 28, 16, 48),
      status: OrderStatus.inProcess,
      statusDetail: 'Cooking Now',
      tax: 0.0,
      charges: 0.0,
      items: [
        OrderItem(
          menuItemId: '1',
          name: 'Scrambled eggs with toast',
          quantity: 1,
          price: 199.0,
        ),
        OrderItem(
          menuItemId: '6',
          name: 'Smoked Salmon Bagel',
          quantity: 1,
          price: 120.0,
        ),
        OrderItem(
          menuItemId: '4',
          name: 'Belgian Waffles',
          quantity: 2,
          price: 220.0,
        ),
        OrderItem(
          menuItemId: '12',
          name: 'Classi Lemonade',
          quantity: 1,
          price: 110.0,
        ),
      ],
    ),

    // Order 3 - In Process
    Order(
      id: '3',
      orderNumber: '#990',
      customerName: 'Watson Joyce',
      orderDate: DateTime(2024, 12, 28, 16, 48),
      status: OrderStatus.inProcess,
      statusDetail: 'In the kitchen',
      tax: 0.0,
      charges: 0.0,
      items: [
        OrderItem(
          menuItemId: '1',
          name: 'Scrambled eggs with toast',
          quantity: 1,
          price: 199.0,
        ),
        OrderItem(
          menuItemId: '6',
          name: 'Smoked Salmon Bagel',
          quantity: 1,
          price: 120.0,
        ),
        OrderItem(
          menuItemId: '4',
          name: 'Belgian Waffles',
          quantity: 2,
          price: 220.0,
        ),
        OrderItem(
          menuItemId: '12',
          name: 'Classi Lemonade',
          quantity: 1,
          price: 110.0,
        ),
      ],
    ),

    // Order 4 - Completed
    Order(
      id: '4',
      orderNumber: '#990',
      customerName: 'Watson Joyce',
      orderDate: DateTime(2024, 12, 28, 16, 48),
      status: OrderStatus.completed,
      statusDetail: 'Completed',
      tax: 0.0,
      charges: 0.0,
      items: [
        OrderItem(
          menuItemId: '1',
          name: 'Scrambled eggs with toast',
          quantity: 1,
          price: 199.0,
        ),
        OrderItem(
          menuItemId: '6',
          name: 'Smoked Salmon Bagel',
          quantity: 1,
          price: 120.0,
        ),
        OrderItem(
          menuItemId: '4',
          name: 'Belgian Waffles',
          quantity: 2,
          price: 220.0,
        ),
        OrderItem(
          menuItemId: '12',
          name: 'Classi Lemonade',
          quantity: 1,
          price: 110.0,
        ),
      ],
    ),

    // Order 5 - Ready
    Order(
      id: '5',
      orderNumber: '#990',
      customerName: 'Watson Joyce',
      orderDate: DateTime(2024, 12, 28, 16, 48),
      status: OrderStatus.ready,
      statusDetail: 'Ready to serve',
      tax: 0.0,
      charges: 0.0,
      items: [
        OrderItem(
          menuItemId: '1',
          name: 'Scrambled eggs with toast',
          quantity: 1,
          price: 199.0,
        ),
        OrderItem(
          menuItemId: '6',
          name: 'Smoked Salmon Bagel',
          quantity: 1,
          price: 120.0,
        ),
        OrderItem(
          menuItemId: '4',
          name: 'Belgian Waffles',
          quantity: 2,
          price: 220.0,
        ),
        OrderItem(
          menuItemId: '12',
          name: 'Classi Lemonade',
          quantity: 1,
          price: 110.0,
        ),
      ],
    ),

    // Order 6 - In Process
    Order(
      id: '6',
      orderNumber: '#990',
      customerName: 'Watson Joyce',
      orderDate: DateTime(2024, 12, 28, 16, 48),
      status: OrderStatus.inProcess,
      statusDetail: 'Cooking Now',
      tax: 0.0,
      charges: 0.0,
      items: [
        OrderItem(
          menuItemId: '1',
          name: 'Scrambled eggs with toast',
          quantity: 1,
          price: 199.0,
        ),
        OrderItem(
          menuItemId: '6',
          name: 'Smoked Salmon Bagel',
          quantity: 1,
          price: 120.0,
        ),
        OrderItem(
          menuItemId: '4',
          name: 'Belgian Waffles',
          quantity: 2,
          price: 220.0,
        ),
        OrderItem(
          menuItemId: '12',
          name: 'Classi Lemonade',
          quantity: 1,
          price: 110.0,
        ),
      ],
    ),
  ];

  static int get totalOrders => orders.length;
  static int get readyOrders =>
      orders.where((o) => o.status == OrderStatus.ready).length;
  static int get inProcessOrders =>
      orders.where((o) => o.status == OrderStatus.inProcess).length;
  static int get completedOrders =>
      orders.where((o) => o.status == OrderStatus.completed).length;
  static int get cancelledOrders =>
      orders.where((o) => o.status == OrderStatus.cancelled).length;
}
