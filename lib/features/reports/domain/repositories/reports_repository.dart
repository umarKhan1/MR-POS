import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/core/constants/orders_mock_data.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';
import 'package:intl/intl.dart';

class ReportsRepository {
  Future<RevenueReportData> getRevenueReport(DateTimeRange range) async {
    // Filter orders by date range (ignoring time)
    final filteredOrders = OrdersMockData.orders.where((order) {
      final orderDate = DateTime(
        order.orderDate.year,
        order.orderDate.month,
        order.orderDate.day,
      );
      final startDate = DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
      );
      final endDate = DateTime(range.end.year, range.end.month, range.end.day);

      return (orderDate.isAtSameMomentAs(startDate) ||
              orderDate.isAfter(startDate)) &&
          (orderDate.isAtSameMomentAs(endDate) || orderDate.isBefore(endDate));
    }).toList();

    final List<RevenueReportRecord> records = [];
    final Map<OrderStatus, double> revenueByStatus = {
      OrderStatus.ready: 0,
      OrderStatus.inProcess: 0,
      OrderStatus.completed: 0,
      OrderStatus.cancelled: 0,
    };

    int sNoCounter = 1;

    for (final order in filteredOrders) {
      // Add to status breakdown
      revenueByStatus[order.status] =
          (revenueByStatus[order.status] ?? 0) + order.total;

      // Create individual records for the table
      for (final item in order.items) {
        // Look up menu item for cost price
        final menuItem = MenuMockData.menuItems.firstWhere(
          (m) => m.id == item.menuItemId,
          orElse: () => MenuItem(
            id: '',
            name: item.name,
            description: '',
            itemId: '',
            image: '',
            quantity: 0,
            stockStatus: '',
            isPerishable: false,
            category: '',
            price: item.price,
            costPrice: item.price * 0.6, // Fallback cost
            isAvailable: true,
            menuType: '',
          ),
        );

        records.add(
          RevenueReportRecord(
            sNo: sNoCounter.toString().padLeft(2, '0'),
            foodName: item.name,
            date: order.orderDate,
            sellPrice: item.price,
            costPrice: menuItem.costPrice,
            quantity: item.quantity,
          ),
        );
        sNoCounter++;
      }
    }

    // Calculate monthly trend (last 12 months)
    final List<MonthlyRevenue> monthlyTrend = _calculateMonthlyTrend(
      filteredOrders,
    );

    return RevenueReportData(
      records: records,
      revenueByStatus: revenueByStatus,
      monthlyTrend: monthlyTrend,
    );
  }

  List<MonthlyRevenue> _calculateMonthlyTrend(List<Order> orders) {
    final Map<String, double> monthlyData = {};
    final months = [
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

    // Sum revenue by month
    for (final order in orders) {
      final monthName = DateFormat('MMM').format(order.orderDate);
      if (monthlyData.containsKey(monthName)) {
        monthlyData[monthName] = monthlyData[monthName]! + order.total;
      }
    }

    return months
        .map((m) => MonthlyRevenue(month: m, revenue: monthlyData[m]!))
        .toList();
  }
}
