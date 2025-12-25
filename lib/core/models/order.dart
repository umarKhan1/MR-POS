enum OrderStatus {
  ready,
  inProcess,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.inProcess:
        return 'In Process';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get color {
    switch (this) {
      case OrderStatus.ready:
        return '0xFF4CAF50'; // Green
      case OrderStatus.inProcess:
        return '0xFFFFB3C1'; // Pink
      case OrderStatus.completed:
        return '0xFF2196F3'; // Blue
      case OrderStatus.cancelled:
        return '0xFFF44336'; // Red
    }
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get total => quantity * price;

  Map<String, dynamic> toJson() => {
    'menuItemId': menuItemId,
    'name': name,
    'quantity': quantity,
    'price': price,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    menuItemId: json['menuItemId'],
    name: json['name'],
    quantity: json['quantity'],
    price: json['price'],
  );
}

class Order {
  final String id;
  final String orderNumber;
  final String customerName;
  final DateTime orderDate;
  final OrderStatus status;
  final String statusDetail;
  final List<OrderItem> items;
  final double tax;
  final double charges;

  Order({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.orderDate,
    required this.status,
    required this.statusDetail,
    required this.items,
    this.tax = 0.0,
    this.charges = 0.0,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + tax + charges;

  Order copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    DateTime? orderDate,
    OrderStatus? status,
    String? statusDetail,
    List<OrderItem>? items,
    double? tax,
    double? charges,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      statusDetail: statusDetail ?? this.statusDetail,
      items: items ?? this.items,
      tax: tax ?? this.tax,
      charges: charges ?? this.charges,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderNumber': orderNumber,
    'customerName': customerName,
    'orderDate': orderDate.toIso8601String(),
    'status': status.name,
    'statusDetail': statusDetail,
    'items': items.map((item) => item.toJson()).toList(),
    'tax': tax,
    'charges': charges,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    orderNumber: json['orderNumber'],
    customerName: json['customerName'],
    orderDate: DateTime.parse(json['orderDate']),
    status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
    statusDetail: json['statusDetail'],
    items: (json['items'] as List)
        .map((item) => OrderItem.fromJson(item))
        .toList(),
    tax: json['tax'] ?? 0.0,
    charges: json['charges'] ?? 0.0,
  );
}
