import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/services/excel_export_service.dart';
import 'package:mrpos/features/reports/domain/repositories/reports_repository.dart';
import 'package:mrpos/features/reports/presentation/cubit/reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _repository;
  final ExcelExportService _exportService;

  ReportsCubit({
    required ReportsRepository repository,
    required ExcelExportService exportService,
  }) : _repository = repository,
       _exportService = exportService,
       super(
         ReportsInitial(
           dateRange: DateTimeRange(
             start: DateTime(
               DateTime.now().year,
               DateTime.now().month,
               DateTime.now().day,
             ),
             end: DateTime(
               DateTime.now().year,
               DateTime.now().month,
               DateTime.now().day,
             ),
           ),
         ),
       );

  Future<void> loadReport({DateTimeRange? range}) async {
    final currentRange = range ?? _getCurrentRange();

    emit(ReportsLoading(dateRange: currentRange));

    try {
      final data = await _repository.getRevenueReport(currentRange);

      if (data.records.isEmpty) {
        emit(ReportsLoaded(data: data, dateRange: currentRange));
        // Error state will be handled by UI showing snackbar or empty state
      } else {
        emit(ReportsLoaded(data: data, dateRange: currentRange));
      }
    } catch (e) {
      emit(ReportsError(e.toString(), dateRange: currentRange));
    }
  }

  DateTimeRange _getCurrentRange() {
    if (state is ReportsInitial) return (state as ReportsInitial).dateRange;
    if (state is ReportsLoading) return (state as ReportsLoading).dateRange;
    if (state is ReportsLoaded) return (state as ReportsLoaded).dateRange;
    if (state is ReportsError) return (state as ReportsError).dateRange;
    return DateTimeRange(
      start: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      end: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
  }

  void updateDateRange(DateTimeRange range) {
    loadReport(range: range);
  }

  Future<void> exportToExcel() async {
    if (state is ReportsLoaded) {
      final currentState = state as ReportsLoaded;
      try {
        await _exportService.exportRevenueReport(currentState.data);
      } catch (e) {
        emit(
          ReportsError(
            'Failed to export: ${e.toString()}',
            dateRange: currentState.dateRange,
          ),
        );
        // Re-emit loaded state after error
        emit(currentState);
      }
    }
  }
}
