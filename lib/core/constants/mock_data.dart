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
