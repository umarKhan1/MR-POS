import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/menu_type.dart';

class DishData {
  final String name;
  final String image;
  final String metadata;
  final double price;
  final double? orderPrice;
  final bool inStock;

  const DishData({
    required this.name,
    required this.image,
    required this.metadata,
    required this.price,
    this.orderPrice,
    this.inStock = true,
  });
}

class ChartDataPoint {
  final String month;
  final double sales;
  final double revenue;

  const ChartDataPoint({
    required this.month,
    required this.sales,
    required this.revenue,
  });
}

class MockData {
  MockData._();

  // Popular Dishes (Serving-based)
  static const List<DishData> popularDishesServing = [
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Serving: 01 person',
      price: 55.00,
      inStock: true,
    ),
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Serving: 01 person',
      price: 55.00,
      inStock: true,
    ),
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Serving: 01 person',
      price: 55.00,
      inStock: false,
    ),
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Serving: 01 person',
      price: 55.00,
      inStock: true,
    ),
  ];

  // Popular Dishes (Order-based)
  static const List<DishData> popularDishesOrders = [
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Order: x2',
      price: 55.00,
      orderPrice: 55.00,
      inStock: true,
    ),
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Order: x2',
      price: 55.00,
      orderPrice: 110.00,
      inStock: true,
    ),
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Order: x2',
      price: 55.00,
      orderPrice: 55.00,
      inStock: false,
    ),
    DishData(
      name: 'Chicken Parmesan',
      image: 'assets/images/dasboardsimage.png',
      metadata: 'Order: x2',
      price: 55.00,
      orderPrice: 95.00,
      inStock: true,
    ),
  ];

  // Chart Data (Monthly)
  static const List<ChartDataPoint> chartData = [
    ChartDataPoint(month: 'JAN', sales: 2500, revenue: 3200),
    ChartDataPoint(month: 'FEB', sales: 3200, revenue: 2800),
    ChartDataPoint(month: 'MAR', sales: 2800, revenue: 3500),
    ChartDataPoint(month: 'APR', sales: 3800, revenue: 3000),
    ChartDataPoint(month: 'MAY', sales: 4500, revenue: 3800),
    ChartDataPoint(month: 'JUN', sales: 3500, revenue: 3200),
    ChartDataPoint(month: 'JUL', sales: 4200, revenue: 3600),
    ChartDataPoint(month: 'AUG', sales: 4800, revenue: 4200),
    ChartDataPoint(month: 'SEP', sales: 4000, revenue: 3500),
    ChartDataPoint(month: 'OCT', sales: 3800, revenue: 3300),
    ChartDataPoint(month: 'NOV', sales: 4500, revenue: 4000),
    ChartDataPoint(month: 'DEC', sales: 5000, revenue: 4500),
  ];

  // Daily Sales Mini Chart Data
  static const List<double> dailySalesData = [
    1.5,
    2.0,
    1.8,
    2.5,
    2.2,
    3.0,
    2.8,
    3.5,
    3.2,
    4.0,
  ];

  // Monthly Revenue Mini Chart Data
  static const List<double> monthlyRevenueData = [
    30,
    35,
    32,
    40,
    38,
    45,
    42,
    50,
    48,
    55,
    52,
    60,
  ];

  // Table Occupancy Mini Chart Data
  static const List<double> tableOccupancyData = [
    15,
    18,
    20,
    22,
    25,
    23,
    28,
    26,
    30,
    28,
  ];

  // Stats Values
  static const double dailySalesValue = 2000;
  static const double monthlyRevenueValue = 55000;
  static const int tableOccupancyValue = 25;
}

// Menu Categories
class MenuCategory {
  final String id;
  final String name;
  final String? iconAsset;
  final IconData? iconData;
  final int itemCount;
  final String iconKey;
  final String description;

  MenuCategory({
    required this.id,
    required this.name,
    this.iconAsset,
    this.iconData,
    required this.itemCount,
    required this.iconKey,
    this.description = '',
  });
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final String itemId;
  final String image;
  final int quantity; // Renamed from stock for clarity
  final String stockStatus; // 'instock', 'lowstock', 'outofstock'
  final bool isPerishable; // Whether item expires/perishes
  final String category;
  final double price;
  final bool isAvailable;
  final String menuType; // Menu type (Normal Menu, Special Deals, etc.)

  MenuItem({
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
    required this.isAvailable,
    required this.menuType,
  });

  /// Get stock status display text
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

  /// Check if item is in stock
  bool get isInStock => stockStatus == 'instock' && quantity > 0;

  /// Check if item needs reorder (low stock)
  bool get needsReorder => stockStatus == 'lowstock';
}

class MenuMockData {
  MenuMockData._();

  // Menu Types - can be modified at runtime
  static final List<MenuType> menuTypes = [
    const MenuType(id: '1', name: 'Normal Menu', displayOrder: 1),
    const MenuType(id: '2', name: 'Special Deals', displayOrder: 2),
    const MenuType(id: '3', name: 'New Year Special', displayOrder: 3),
    const MenuType(id: '4', name: 'Deserts and Drinks', displayOrder: 4),
  ];

  static final List<MenuCategory> categories = [
    MenuCategory(
      id: '1',
      name: 'All',
      iconAsset: AppAssets.category,
      itemCount: 116,
      iconKey: 'all',
      description: 'All menu items',
    ),
    MenuCategory(
      id: '2',
      name: 'Pizza',
      iconAsset: AppAssets.pizzaIcon,
      itemCount: 20,
      iconKey: 'pizza',
      description: 'Delicious Italian pizzas',
    ),
    MenuCategory(
      id: '3',
      name: 'Burger',
      iconAsset: AppAssets.burgerIcon,
      itemCount: 15,
      iconKey: 'burger',
      description: 'Juicy burgers and sandwiches',
    ),
    MenuCategory(
      id: '4',
      name: 'Chicken',
      iconAsset: AppAssets.chickenIcon,
      itemCount: 10,
      iconKey: 'chicken',
      description: 'Crispy and tender chicken dishes',
    ),
    MenuCategory(
      id: '5',
      name: 'Bakery',
      iconData: FontAwesomeIcons.breadSlice,
      itemCount: 18,
      iconKey: 'bakery',
      description: 'Fresh baked goods',
    ),
    MenuCategory(
      id: '6',
      name: 'Beverage',
      iconData: FontAwesomeIcons.wineGlass,
      itemCount: 12,
      iconKey: 'beverage',
      description: 'Refreshing drinks',
    ),
    MenuCategory(
      id: '7',
      name: 'Seafood',
      iconAsset: AppAssets.seafoodIcon,
      itemCount: 16,
      iconKey: 'seafood',
      description: 'Fresh seafood dishes',
    ),
  ];

  static final List<MenuItem> menuItems = [
    // Chicken items
    MenuItem(
      id: '1',
      name: 'Chicken Parmesan',
      description:
          'Breaded chicken breast topped with marinara sauce and melted cheese',
      itemId: '#22314644',
      image: AppAssets.dashboardImage,
      quantity: 45,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Chicken',
      price: 15.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    MenuItem(
      id: '2',
      name: 'Grilled Chicken',
      description: 'Perfectly grilled chicken breast with herbs and spices',
      itemId: '#22314645',
      image: AppAssets.dashboardImage,
      quantity: 30,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Chicken',
      price: 13.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    MenuItem(
      id: '3',
      name: 'Chicken Wings',
      description: 'Crispy chicken wings with your choice of sauce',
      itemId: '#22314646',
      image: AppAssets.dashboardImage,
      quantity: 8,
      stockStatus: 'lowstock',
      isPerishable: true,
      category: 'Chicken',
      price: 11.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    // Beef items
    MenuItem(
      id: '4',
      name: 'Beef Burger',
      description: 'Juicy beef patty with lettuce, tomato, and special sauce',
      itemId: '#22314647',
      image: AppAssets.dashboardImage,
      quantity: 50,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Beef',
      price: 12.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    MenuItem(
      id: '5',
      name: 'Beef Steak',
      description: 'Premium cut beef steak cooked to perfection',
      itemId: '#22314648',
      image: AppAssets.dashboardImage,
      quantity: 25,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Beef',
      price: 24.99,
      isAvailable: true,
      menuType: 'Special Deals',
    ),
    // Seafood items
    MenuItem(
      id: '6',
      name: 'Grilled Salmon',
      description: 'Fresh Atlantic salmon grilled with lemon butter',
      itemId: '#22314649',
      image: AppAssets.dashboardImage,
      quantity: 20,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Seafood',
      price: 19.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    MenuItem(
      id: '7',
      name: 'Shrimp Scampi',
      description: 'Succulent shrimp in garlic butter sauce',
      itemId: '#22314650',
      image: AppAssets.dashboardImage,
      quantity: 15,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Seafood',
      price: 17.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    // Vegetarian items
    MenuItem(
      id: '8',
      name: 'Veggie Burger',
      description: 'Plant-based patty with fresh vegetables',
      itemId: '#22314651',
      image: AppAssets.dashboardImage,
      quantity: 35,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Vegetarian',
      price: 9.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    MenuItem(
      id: '9',
      name: 'Garden Salad',
      description: 'Fresh mixed greens with house dressing',
      itemId: '#22314652',
      image: AppAssets.dashboardImage,
      quantity: 40,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Vegetarian',
      price: 7.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    // Desserts
    MenuItem(
      id: '10',
      name: 'Chocolate Cake',
      description: 'Rich chocolate cake with chocolate frosting',
      itemId: '#22314653',
      image: AppAssets.dashboardImage,
      quantity: 12,
      stockStatus: 'lowstock',
      isPerishable: true,
      category: 'Desserts',
      price: 11.99,
      isAvailable: true,
      menuType: 'Deserts and Drinks',
    ),
    MenuItem(
      id: '11',
      name: 'Ice Cream',
      description: 'Creamy vanilla ice cream',
      itemId: '#22314654',
      image: AppAssets.dashboardImage,
      quantity: 0,
      stockStatus: 'outofstock',
      isPerishable: true,
      category: 'Desserts',
      price: 5.99,
      isAvailable: false,
      menuType: 'Deserts and Drinks',
    ),
    // Beverages
    MenuItem(
      id: '12',
      name: 'Fresh Orange Juice',
      description: 'Freshly squeezed orange juice',
      itemId: '#22314655',
      image: AppAssets.dashboardImage,
      quantity: 25,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Beverages',
      price: 3.99,
      isAvailable: true,
      menuType: 'Deserts and Drinks',
    ),
    MenuItem(
      id: '13',
      name: 'Coffee',
      description: 'Premium roasted coffee',
      itemId: '#22314656',
      image: AppAssets.dashboardImage,
      quantity: 60,
      stockStatus: 'instock',
      isPerishable: false,
      category: 'Beverages',
      price: 2.99,
      isAvailable: true,
      menuType: 'Deserts and Drinks',
    ),
    // Pizza
    MenuItem(
      id: '14',
      name: 'Margherita Pizza',
      description: 'Classic pizza with tomato, mozzarella, and basil',
      itemId: '#22314657',
      image: AppAssets.dashboardImage,
      quantity: 30,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Pizza',
      price: 14.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
    MenuItem(
      id: '15',
      name: 'Pepperoni Pizza',
      description: 'Loaded with pepperoni and cheese',
      itemId: '#22314658',
      image: AppAssets.dashboardImage,
      quantity: 28,
      stockStatus: 'instock',
      isPerishable: true,
      category: 'Pizza',
      price: 16.99,
      isAvailable: true,
      menuType: 'Normal Menu',
    ),
  ];
}
