import 'package:mrpos/core/models/order.dart';

class RevenueReportRecord {
  final String sNo;
  final String foodName;
  final DateTime date;
  final double sellPrice;
  final double costPrice;
  final int quantity;

  RevenueReportRecord({
    required this.sNo,
    required this.foodName,
    required this.date,
    required this.sellPrice,
    required this.costPrice,
    required this.quantity,
  });

  double get revenue => sellPrice * quantity;
  double get profit => (sellPrice - costPrice) * quantity;
  double get profitMargin => revenue > 0 ? (profit / revenue) * 100 : 0.0;
}

class RevenueReportData {
  final List<RevenueReportRecord> records;
  final Map<OrderStatus, double> revenueByStatus;
  final List<MonthlyRevenue> monthlyTrend; // Default trend (Confirmed)
  final Map<OrderStatus, List<MonthlyRevenue>> trendsByStatus;
  final double totalOrdersRevenue; // Gross revenue including tax/charges

  RevenueReportData({
    required this.records,
    required this.revenueByStatus,
    required this.monthlyTrend,
    required this.trendsByStatus,
    required this.totalOrdersRevenue,
  });

  double get totalItemsRevenue =>
      records.fold(0, (sum, record) => sum + record.revenue);
  double get totalProfit =>
      records.fold(0, (sum, record) => sum + record.profit);
}

class MonthlyRevenue {
  final String month;
  final double revenue;

  MonthlyRevenue({required this.month, required this.revenue});
}
