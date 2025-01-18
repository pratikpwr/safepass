import 'dart:io';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:safepass/src/core/utils/secure_storage.dart';
import 'package:safepass/src/features/passwords/models/password.dart';
import 'package:safepass/src/features/passwords/models/password_entry.dart';

class PasswordExporter {
  final List<Password> passwords;
  final List<PasswordEntry> passwordEntries;

  PasswordExporter({
    required this.passwords,
    required this.passwordEntries,
  });

  Future<void> exportToExcel() async {
    // Create a new Excel workbook
    var excel = Excel.createExcel();

    // // Create overview sheet
    // var overviewSheet = excel['Categories'];
    //
    // // Add headers for overview
    // _addHeaders(overviewSheet,
    //     ['Category ID', 'Category Title', 'Number of Entries', 'Is Favorite']);
    //
    // // Add category data
    // int row = 1;
    // for (Password password in passwords) {
    //   overviewSheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
    //       .value = TextCellValue(password.id);
    //   overviewSheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
    //       .value = TextCellValue(password.title);
    //   overviewSheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
    //       .value = IntCellValue(password.entries.length);
    //   overviewSheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
    //       .value = BoolCellValue(password.isFavourite);
    //   row++;
    // }

    // Create passwords sheet
    var passwordsSheet = excel['Passwords'];

    // Add headers for passwords
    _addHeaders(
        passwordsSheet, ['Title', 'Username', 'Password', 'Site', 'Notes']);

    // Add password entries
    int row = 1;
    for (var entry in passwordEntries) {
      var parentPassword = passwords.singleWhereOrNull((el) {
        return el.id == entry.parentId;
      });
      if (parentPassword == null) continue;

      passwordsSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(parentPassword.title);
      passwordsSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = TextCellValue(entry.username);
      passwordsSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = TextCellValue(SecureStorage().decryptData(entry.password));
      passwordsSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = TextCellValue(entry.site);
      passwordsSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = TextCellValue(entry.note ?? '');
      row++;
    }

    // Auto-fit columns in both sheets
    // _autoFitColumns(overviewSheet);
    _autoFitColumns(passwordsSheet);

    // Get the documents directory
    final documentsDir = await getExternalStorageDirectory();
    final appDocPath = await getApplicationDocumentsDirectory();

    // Create filename with timestamp
    final timestamp =
        DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
    final fileName = 'passwords_export_$timestamp.xlsx';

    // Create the full file path
    final filePath = path.join("/storage/emulated/0/Download", fileName);

    // Remove the default sheet
    excel.delete('Sheet1');

    // Save the excel file
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }

  void _addHeaders(Sheet sheet, List<String> headers) {
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        ..value = TextCellValue(headers[i])
        ..cellStyle = CellStyle(
          bold: true,
        );
    }
  }

  void _autoFitColumns(Sheet sheet) {
    var maxColumns = sheet.maxColumns;
    for (var i = 0; i < maxColumns; i++) {
      sheet.setColumnWidth(i, 15.0);
    }
  }
}
