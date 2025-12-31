import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:mrpos/shared/utils/icon_detector.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String itemId;
  final String image;
  final int quantity;
  final String stockStatus;
  final bool isPerishable;
  final String category;
  final double price;
  final double costPrice;
  final bool isAvailable;
  final String menuType;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.itemId,
    required this.image,
    required this.quantity,
    required this.stockStatus,
    required this.isPerishable,
    required this.category,
    required this.price,
    required this.costPrice,
    required this.isAvailable,
    required this.menuType,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    itemId,
    image,
    quantity,
    stockStatus,
    isPerishable,
    category,
    price,
    costPrice,
    isAvailable,
    menuType,
  ];

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    String? itemId,
    String? image,
    int? quantity,
    String? stockStatus,
    bool? isPerishable,
    String? category,
    double? price,
    double? costPrice,
    bool? isAvailable,
    String? menuType,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      itemId: itemId ?? this.itemId,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      stockStatus: stockStatus ?? this.stockStatus,
      isPerishable: isPerishable ?? this.isPerishable,
      category: category ?? this.category,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      isAvailable: isAvailable ?? this.isAvailable,
      menuType: menuType ?? this.menuType,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'itemId': itemId,
      'image': image,
      'quantity': quantity,
      'stockStatus': stockStatus,
      'isPerishable': isPerishable,
      'category': category,
      'price': price,
      'costPrice': costPrice,
      'isAvailable': isAvailable,
      'menuType': menuType,
    };
  }

  factory MenuItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      itemId: data['itemId'] ?? '',
      image: data['image'] ?? '',
      quantity: data['quantity'] ?? 0,
      stockStatus: data['stockStatus'] ?? 'instock',
      isPerishable: data['isPerishable'] ?? false,
      category: data['category'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      costPrice: (data['costPrice'] ?? 0.0).toDouble(),
      isAvailable: data['isAvailable'] ?? true,
      menuType: data['menuType'] ?? 'Normal Menu',
    );
  }

  // Getters
  String get stockStatusDisplay {
    switch (stockStatus) {
      case 'instock':
        return '$quantity In Stock';
      case 'lowstock':
        return '$quantity Low Stock';
      case 'outofstock':
        return 'Out of Stock';
      default:
        return '$quantity In Stock';
    }
  }

  bool get isInStock => stockStatus == 'instock' && quantity > 0;

  bool get needsReorder => stockStatus == 'lowstock';
}

class MenuCategory extends Equatable {
  final String id;
  final String name;
  final String? iconAsset;
  final String iconKey;
  final int itemCount;
  final String description;

  const MenuCategory({
    required this.id,
    required this.name,
    this.iconAsset,
    required this.iconKey,
    required this.itemCount,
    this.description = '',
  });

  IconData get iconData => IconDetector.getIcon(iconKey);

  @override
  List<Object?> get props => [
    id,
    name,
    iconAsset,
    iconKey,
    itemCount,
    description,
  ];

  MenuCategory copyWith({
    String? id,
    String? name,
    String? iconAsset,
    String? iconKey,
    int? itemCount,
    String? description,
  }) {
    return MenuCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      iconAsset: iconAsset ?? this.iconAsset,
      iconKey: iconKey ?? this.iconKey,
      itemCount: itemCount ?? this.itemCount,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'iconAsset': iconAsset,
      'iconKey': iconKey,
      'itemCount': itemCount,
      'description': description,
    };
  }

  factory MenuCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuCategory(
      id: doc.id,
      name: data['name'] ?? '',
      iconAsset: data['iconAsset'],
      iconKey: data['iconKey'] ?? 'all',
      itemCount: data['itemCount'] ?? 0,
      description: data['description'] ?? '',
    );
  }
}

class MenuType extends Equatable {
  final String id;
  final String name;
  final int displayOrder;

  const MenuType({
    required this.id,
    required this.name,
    required this.displayOrder,
  });

  @override
  List<Object?> get props => [id, name, displayOrder];

  MenuType copyWith({String? id, String? name, int? displayOrder}) {
    return MenuType(
      id: id ?? this.id,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'displayOrder': displayOrder};
  }

  factory MenuType.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuType(
      id: doc.id,
      name: data['name'] ?? '',
      displayOrder: data['displayOrder'] ?? 0,
    );
  }
}
