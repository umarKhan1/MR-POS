import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  final DateTimeRange dateRange;

  const ReportsInitial({required this.dateRange});

  @override
  List<Object?> get props => [dateRange];
}

class ReportsLoading extends ReportsState {
  final DateTimeRange dateRange;

  const ReportsLoading({required this.dateRange});

  @override
  List<Object?> get props => [dateRange];
}

class ReportsLoaded extends ReportsState {
  final RevenueReportData data;
  final DateTimeRange dateRange;

  const ReportsLoaded({required this.data, required this.dateRange});

  @override
  List<Object?> get props => [data, dateRange];
}

class ReportsError extends ReportsState {
  final String message;
  final DateTimeRange dateRange;

  const ReportsError(this.message, {required this.dateRange});

  @override
  List<Object?> get props => [message, dateRange];
}
