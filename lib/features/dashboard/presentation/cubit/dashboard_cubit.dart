import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:mrpos/features/orders/domain/repositories/orders_repository.dart';
import 'package:mrpos/features/menu/domain/repositories/menu_repository.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/core/models/order.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final IOrdersRepository _ordersRepository;
  final MenuRepository _menuRepository;
  StreamSubscription? _combinedSubscription;

  List<Order> _latestOrders = [];
  List<MenuItem> _latestMenuItems = [];

  DashboardCubit(this._ordersRepository, this._menuRepository)
    : super(DashboardInitial()) {
    _init();
  }

  void _init() {
    emit(DashboardLoading());

    // Listen to both streams
    _combinedSubscription = _ordersRepository.getOrders().listen((orders) {
      _latestOrders = orders;
      _updateDashboard();
    }, onError: (e) => emit(DashboardError(e.toString())));

    _menuRepository.getMenuItems().listen((items) {
      _latestMenuItems = items;
      _updateDashboard();
    }, onError: (e) => emit(DashboardError(e.toString())));
  }

  void _updateDashboard() {
    if (_latestOrders.isNotEmpty || _latestMenuItems.isNotEmpty) {
      _processDashboardData(_latestOrders, _latestMenuItems);
    }
  }

  void _processDashboardData(List<Order> orders, List<MenuItem> menuItems) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisMonthStart = DateTime(now.year, now.month, 1);

    // 1. Daily Sales
    double dailySales = 0;
    for (final order in orders) {
      if (order.status == OrderStatus.confirmed) {
        final orderDate = DateTime(
          order.orderDate.year,
          order.orderDate.month,
          order.orderDate.day,
        );
        if (orderDate.isAtSameMomentAs(today)) {
          dailySales += order.total;
        }
      }
    }

    // 2. Monthly Revenue
    double monthlyRevenue = 0;
    for (final order in orders) {
      if (order.status == OrderStatus.confirmed &&
          order.orderDate.isAfter(
            thisMonthStart.subtract(const Duration(seconds: 1)),
          )) {
        monthlyRevenue += order.total;
      }
    }

    // 3. Table Occupancy
    final occupiedTables = orders
        .where((o) => o.status == OrderStatus.awaited)
        .length;

    // 4. Popular Dishes (by quantity sold in confirmed orders)
    final Map<String, _DishStats> dishStats = {};
    for (final order in orders) {
      if (order.status == OrderStatus.confirmed) {
        for (final item in order.items) {
          if (!dishStats.containsKey(item.name)) {
            dishStats[item.name] = _DishStats(
              item.name,
              item.price,
              item.menuItemId,
            );
          }
          dishStats[item.name]!.quantity += item.quantity;
          dishStats[item.name]!.orderCount += 1;
        }
      }
    }

    // Helper to enrich DishData with latest Menu Items (for stock and category)
    List<DishData> enrichDishStats(List<_DishStats> sortedStats) {
      return sortedStats.take(5).map((s) {
        final menuItem = menuItems.cast<MenuItem?>().firstWhere(
          (m) => m?.id == s.menuItemId,
          orElse: () => null,
        );

        return DishData(
          name: s.name,
          image: menuItem?.image ?? 'assets/images/dasboardsimage.png',
          metadata: sortedStats.first == s
              ? 'Serving: ${s.quantity} items'
              : 'Order: x${s.orderCount}',
          price: s.price,
          orderPrice: s.price * s.quantity,
          quantity: menuItem?.quantity ?? 0,
          inStock:
              menuItem?.isInStock ??
              (menuItem != null ? menuItem.quantity > 0 : true),
          category: menuItem?.category,
        );
      }).toList();
    }

    // Top dishes by total quantity sold
    final popularDishesServing = List<_DishStats>.from(dishStats.values)
      ..sort((a, b) => b.quantity.compareTo(a.quantity));
    final popularDishesServingData = enrichDishStats(popularDishesServing);

    // Top dishes by number of orders
    final famousDishesOrders = List<_DishStats>.from(dishStats.values)
      ..sort((a, b) => b.orderCount.compareTo(a.orderCount));
    final famousDishesOrdersData = enrichDishStats(famousDishesOrders);

    // 5. Chart Data Calculation
    // Daily Charts (Last 7 days)
    final List<double> dailySalesChart = [];
    final List<double> dailyRevenueChart = [];

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: 6 - i));
      double dailyTotal = 0;
      double dailyProfit = 0;

      final dailyOrders = orders.where(
        (o) =>
            o.status == OrderStatus.confirmed &&
            DateTime(
              o.orderDate.year,
              o.orderDate.month,
              o.orderDate.day,
            ).isAtSameMomentAs(date),
      );

      for (final order in dailyOrders) {
        dailyTotal += order.total;
        for (final item in order.items) {
          final menuItem = menuItems.cast<MenuItem?>().firstWhere(
            (m) => m?.id == item.menuItemId,
            orElse: () => null,
          );
          if (menuItem != null) {
            dailyProfit += (item.price - menuItem.costPrice) * item.quantity;
          } else {
            // fallback to 30% margin if item not found
            dailyProfit += item.total * 0.3;
          }
        }
      }
      dailySalesChart.add(dailyTotal);
      dailyRevenueChart.add(dailyProfit);
    }

    // Monthly Charts (Last 7 months)
    final List<double> monthlySalesChart = [];
    final List<double> monthlyRevenueChart = [];

    for (int i = 0; i < 7; i++) {
      final monthStart = DateTime(now.year, now.month - (6 - i), 1);
      final monthEnd = DateTime(now.year, now.month - (5 - i), 1);

      double monthTotal = 0;
      double monthProfit = 0;

      final monthOrders = orders.where(
        (o) =>
            o.status == OrderStatus.confirmed &&
            o.orderDate.isAfter(
              monthStart.subtract(const Duration(seconds: 1)),
            ) &&
            o.orderDate.isBefore(monthEnd),
      );

      for (final order in monthOrders) {
        monthTotal += order.total;
        for (final item in order.items) {
          final menuItem = menuItems.cast<MenuItem?>().firstWhere(
            (m) => m?.id == item.menuItemId,
            orElse: () => null,
          );
          if (menuItem != null) {
            monthProfit += (item.price - menuItem.costPrice) * item.quantity;
          } else {
            monthProfit += item.total * 0.3;
          }
        }
      }
      monthlySalesChart.add(monthTotal);
      monthlyRevenueChart.add(monthProfit);
    }

    // Table Occupancy Chart (Last 7 days - simplified)
    final List<double> tableOccupancyChart = List.generate(
      7,
      (index) => occupiedTables.toDouble(),
    );

    emit(
      DashboardLoaded(
        dailySales: dailySales,
        monthlyRevenue: monthlyRevenue,
        tableOccupancy: occupiedTables,
        dailySalesChart: dailySalesChart,
        dailyRevenueChart: dailyRevenueChart,
        monthlySalesChart: monthlySalesChart,
        monthlyRevenueChart: monthlyRevenueChart,
        tableOccupancyChart: tableOccupancyChart,
        popularDishesServing: popularDishesServingData,
        famousDishesOrders: famousDishesOrdersData,
      ),
    );
  }

  @override
  Future<void> close() {
    _combinedSubscription?.cancel();
    return super.close();
  }
}

class _DishStats {
  final String name;
  final double price;
  final String menuItemId;
  int quantity = 0;
  int orderCount = 0;

  _DishStats(this.name, this.price, this.menuItemId);
}
