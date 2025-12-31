import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/domain/repositories/orders_repository.dart';
import 'package:mrpos/features/menu/domain/repositories/menu_repository.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';
import 'package:intl/intl.dart';

class ReportsRepository {
  final IOrdersRepository _ordersRepository;
  final MenuRepository _menuRepository;

  ReportsRepository(this._ordersRepository, this._menuRepository);

  Future<RevenueReportData> getRevenueReport(DateTimeRange range) async {
    // 1. Fetch orders from repository
    final filteredOrders = await _ordersRepository.getOrdersByDateRange(
      range.start,
      range.end,
    );

    // 2. Fetch all menu items to get cost prices
    final List<MenuItem> menuItems = await _menuRepository.getMenuItems().first;

    final List<RevenueReportRecord> records = [];
    final Map<OrderStatus, double> revenueByStatus = {
      OrderStatus.awaited: 0.0,
      OrderStatus.confirmed: 0.0,
      OrderStatus.cancelled: 0.0,
      OrderStatus.failed: 0.0,
    };

    int sNoCounter = 1;

    for (final order in filteredOrders) {
      // Add to status breakdown (All orders counted for breakdown)
      revenueByStatus[order.status] =
          (revenueByStatus[order.status] ?? 0) + order.total;

      // Only add CONFIRMED orders to the detailed records table and total revenue
      if (order.status == OrderStatus.confirmed) {
        for (final item in order.items) {
          // Find cost price from menu items
          final menuItem = menuItems
              .where((m) => m.id == item.menuItemId)
              .firstOrNull;
          final costPrice =
              menuItem?.costPrice ??
              (item.price * 0.7); // Fallback to 70% if unknown

          records.add(
            RevenueReportRecord(
              sNo: sNoCounter.toString().padLeft(2, '0'),
              foodName: item.name,
              date: order.orderDate,
              sellPrice: item.price,
              costPrice: costPrice,
              quantity: item.quantity,
            ),
          );
          sNoCounter++;
        }
      }
    }

    // Calculate monthly trends for ALL statuses
    final Map<OrderStatus, List<MonthlyRevenue>> trendsByStatus = {
      OrderStatus.awaited: _calculateMonthlyTrend(
        filteredOrders,
        OrderStatus.awaited,
      ),
      OrderStatus.confirmed: _calculateMonthlyTrend(
        filteredOrders,
        OrderStatus.confirmed,
      ),
      OrderStatus.cancelled: _calculateMonthlyTrend(
        filteredOrders,
        OrderStatus.cancelled,
      ),
      OrderStatus.failed: _calculateMonthlyTrend(
        filteredOrders,
        OrderStatus.failed,
      ),
    };

    // Gross revenue (including tax/charges) for Confirmed orders
    final double totalOrdersRevenue = filteredOrders
        .where((o) => o.status == OrderStatus.confirmed)
        .fold(0, (sum, order) => sum + order.total);

    return RevenueReportData(
      records: records,
      revenueByStatus: revenueByStatus,
      monthlyTrend: trendsByStatus[OrderStatus.confirmed]!,
      trendsByStatus: trendsByStatus,
      totalOrdersRevenue: totalOrdersRevenue,
    );
  }

  List<MonthlyRevenue> _calculateMonthlyTrend(
    List<Order> orders,
    OrderStatus status,
  ) {
    final Map<String, double> monthlyData = {};
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    // Initialize with zeros for all months
    for (final month in months) {
      monthlyData[month] = 0.0;
    }

    // Sum revenue by month for the specific status
    for (final order in orders) {
      if (order.status == status) {
        final monthName = DateFormat('MMM').format(order.orderDate);
        if (monthlyData.containsKey(monthName)) {
          monthlyData[monthName] = monthlyData[monthName]! + order.total;
        }
      }
    }

    return months
        .map((m) => MonthlyRevenue(month: m, revenue: monthlyData[m]!))
        .toList();
  }

  Stream<List<Order>> getOrdersStream() {
    return _ordersRepository.getOrders();
  }
}
