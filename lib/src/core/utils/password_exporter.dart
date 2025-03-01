import 'dart:io';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:safepass/src/core/utils/secure_storage.dart';
import 'package:safepass/src/features/passwords/models/password.dart';
import 'package:safepass/src/features/passwords/models/password_entry.dart';
import 'package:uuid/uuid.dart';

class PasswordExporter {
  Future<List<Map<String, dynamic>>> importFromExcel(String filePath) async {
    try {
      // Read the file
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      // Load bytes from file
      final bytes = await file.readAsBytes();

      // Decode Excel file
      final excel = Excel.decodeBytes(bytes);

      // Look for the Passwords sheet
      if (!excel.tables.containsKey('Passwords')) {
        throw Exception('Excel file does not contain a "Passwords" sheet');
      }

      final sheet = excel.tables['Passwords']!;

      // Extract headers from the first row
      final headers = <String>[];
      for (var i = 0; i < sheet.maxColumns; i++) {
        final cell =
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        if (cell.value == null) break;
        headers.add(cell.value.toString().toLowerCase());
      }

      // Verify required columns exist
      final requiredColumns = [
        'Title',
        'Username',
        'Password',
        'Site',
        'Notes'
      ];
      for (final column in requiredColumns) {
        if (!headers.contains(column.toLowerCase())) {
          throw Exception('Required column "$column" not found in Excel file');
        }
      }

      // Extract data rows
      final results = <Map<String, dynamic>>[];

      for (var rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        // Skip empty rows
        var isEmpty = true;
        for (var i = 0; i < headers.length; i++) {
          final cellValue = sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: i, rowIndex: rowIndex))
              .value;
          if (cellValue != null && cellValue.toString().isNotEmpty) {
            isEmpty = false;
            break;
          }
        }
        if (isEmpty) continue;

        // Extract row data
        final rowData = <String, dynamic>{};
        for (var i = 0; i < headers.length; i++) {
          final cell = sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex));
          rowData[headers[i]] = cell.value?.toString() ?? '';
        }

        results.add(rowData);
      }

      return results;
    } catch (e) {
      throw Exception('Failed to import passwords: $e');
    }
  }

  Future<Map<String, List<dynamic>>> processImportedData(
    List<Map<String, dynamic>> importedData,
  ) async {
    // Group entries by title to create Password categories
    final groupedByTitle = <String, List<Map<String, dynamic>>>{};

    for (final entry in importedData) {
      final title = entry['title'] ?? 'Uncategorized';
      if (!groupedByTitle.containsKey(title)) {
        groupedByTitle[title] = [];
      }
      groupedByTitle[title]!.add(entry);
    }

    // Create Password and PasswordEntry objects
    final passwords = <Password>[];
    final entries = <PasswordEntry>[];
    var uuid = Uuid();

    for (final title in groupedByTitle.keys) {
      // Create a Password (category) for this title

      final passwordId = uuid.v4();
      final password = Password(
        id: passwordId,
        title: title,
        entries: [], // We'll fill these IDs after creating the entries
        isFavourite: false,
      );

      // Create entries for this password
      final entryIds = <String>[];
      for (final entryData in groupedByTitle[title]!) {
        final entryId = uuid.v4();
        entryIds.add(entryId);

        // Encrypt the password using your secure storage
        final encryptedPassword =
            SecureStorage().encryptData(entryData['password'] ?? '');

        final entry = PasswordEntry(
          id: entryId,
          username: entryData['username'] ?? '',
          password: encryptedPassword,
          site: entryData['site'] ?? '',
          parentId: passwordId,
          note: entryData['notes'],
        );

        entries.add(entry);
      }

      // Update the password with entry IDs
      passwords.add(password.copyWith(entries: entryIds));
    }

    return {
      'passwords': passwords,
      'entries': entries,
    };
  }

  Future<void> exportToExcel({
    required List<Password> passwords,
    required List<PasswordEntry> passwordEntries,
  }) async {
    var excel = Excel.createExcel();

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
