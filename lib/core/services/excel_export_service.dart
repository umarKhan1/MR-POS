import 'dart:io';
import 'package:excel/excel.dart';
import 'package:mrpos/features/reports/domain/models/revenue_report_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';

class ExcelExportService {
  Future<void> exportRevenueReport(RevenueReportData data) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Header styling
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#1A1A1A'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    // Headers
    sheet.appendRow([
      TextCellValue('S.No'),
      TextCellValue('Food Name'),
      TextCellValue('Date'),
      TextCellValue('Sell Price'),
      TextCellValue('Cost Price'),
      TextCellValue('Quantity'),
      TextCellValue('Revenue'),
      TextCellValue('Profit'),
      TextCellValue('Profit Margin (%)'),
    ]);

    // Apply header style
    for (var i = 0; i < 9; i++) {
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
              .cellStyle =
          headerStyle;
    }

    // Records
    for (final record in data.records) {
      sheet.appendRow([
        TextCellValue(record.sNo),
        TextCellValue(record.foodName),
        TextCellValue(DateFormat('yyyy-MM-dd HH:mm').format(record.date)),
        DoubleCellValue(record.sellPrice),
        DoubleCellValue(record.costPrice),
        IntCellValue(record.quantity),
        DoubleCellValue(record.revenue),
        DoubleCellValue(record.profit),
        TextCellValue(record.profitMargin.toStringAsFixed(2)),
      ]);
    }

    // Save file
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'Revenue_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
    final filePath = '${directory.path}/$fileName';

    final fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // Open the file
      await OpenFilex.open(filePath);
    }
  }
}
