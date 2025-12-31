import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final double dailySales;
  final double monthlyRevenue;
  final int tableOccupancy;
  final List<double> dailySalesChart;
  final List<double> dailyRevenueChart;
  final List<double> monthlySalesChart;
  final List<double> monthlyRevenueChart;
  final List<double> tableOccupancyChart;
  final List<DishData> popularDishesServing;
  final List<DishData> famousDishesOrders;

  const DashboardLoaded({
    required this.dailySales,
    required this.monthlyRevenue,
    required this.tableOccupancy,
    required this.dailySalesChart,
    required this.dailyRevenueChart,
    required this.monthlySalesChart,
    required this.monthlyRevenueChart,
    required this.tableOccupancyChart,
    required this.popularDishesServing,
    required this.famousDishesOrders,
  });

  @override
  List<Object?> get props => [
    dailySales,
    monthlyRevenue,
    tableOccupancy,
    dailySalesChart,
    dailyRevenueChart,
    monthlySalesChart,
    monthlyRevenueChart,
    tableOccupancyChart,
    popularDishesServing,
    famousDishesOrders,
  ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DishData extends Equatable {
  final String name;
  final String image;
  final String metadata;
  final double price;
  final double? orderPrice;
  final bool inStock;
  final int quantity;
  final String? category;

  const DishData({
    required this.name,
    required this.image,
    required this.metadata,
    required this.price,
    this.orderPrice,
    this.inStock = true,
    required this.quantity,
    this.category,
  });

  @override
  List<Object?> get props => [
    name,
    image,
    metadata,
    price,
    orderPrice,
    inStock,
    quantity,
    category,
  ];
}
