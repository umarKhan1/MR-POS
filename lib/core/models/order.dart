enum OrderStatus {
  awaited,
  confirmed,
  cancelled,
  failed;

  String get displayName {
    switch (this) {
      case OrderStatus.awaited:
        return 'Awaited';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.failed:
        return 'Failed';
    }
  }

  String get color {
    switch (this) {
      case OrderStatus.awaited:
        return '0xFFE57373'; // Light Red/Coral
      case OrderStatus.confirmed:
        return '0xFFD32F2F'; // Strong Red
      case OrderStatus.cancelled:
        return '0xFFEF9A9A'; // Soft Pink/Red
      case OrderStatus.failed:
        return '0xFFFFCDD2'; // Very Light Pink
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
    menuItemId: json['menuItemId'] ?? '',
    name: json['name'] ?? '',
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
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
    tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
    charges: (json['charges'] as num?)?.toDouble() ?? 0.0,
  );

  factory Order.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawDate = data['orderDate'];
    DateTime date;
    try {
      if (rawDate is String) {
        date = DateTime.parse(rawDate);
      } else if (rawDate != null) {
        try {
          date = (rawDate as dynamic).toDate();
        } catch (_) {
          if (rawDate is DateTime) {
            date = rawDate;
          } else {
            date = DateTime.tryParse(rawDate.toString()) ?? DateTime.now();
          }
        }
      } else {
        date = DateTime.now();
      }
    } catch (_) {
      date = DateTime.now();
    }

    return Order(
      id: doc.id,
      orderNumber: data['orderNumber'] ?? '',
      customerName: data['customerName'] ?? '',
      orderDate: date,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => OrderStatus.awaited,
      ),
      statusDetail: data['statusDetail'] ?? '',
      items:
          (data['items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      tax: (data['tax'] as num?)?.toDouble() ?? 0.0,
      charges: (data['charges'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
