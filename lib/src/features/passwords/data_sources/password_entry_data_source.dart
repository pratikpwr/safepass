import 'package:hive/hive.dart';

import '../models/password_entry.dart';

class PasswordEntryDataSource {
  PasswordEntryDataSource();

  Future<List<PasswordEntry>> getAllPasswordEntries() async {
    final Box<PasswordEntry> passwordEntryBox =
        await Hive.openBox('passwordEntryBox');
    final passwordEntries =
        passwordEntryBox.values.cast<PasswordEntry>().toList();
    await passwordEntryBox.close();
    return passwordEntries;
  }

  Future<List<PasswordEntry>> getPasswordEntries(String passId) async {
    final Box<PasswordEntry> passwordEntryBox =
        await Hive.openBox('passwordEntryBox');

    final passwordEntries = passwordEntryBox.values
        .where((item) => item.parentId == passId)
        .toList();

    await passwordEntryBox.close();

    return passwordEntries;
  }

  Future<void> addPasswordEntry(PasswordEntry passwordEntry) async {
    final Box<PasswordEntry> passwordEntryBox =
        await Hive.openBox('passwordEntryBox');
    await passwordEntryBox.put(passwordEntry.id, passwordEntry);
    await passwordEntryBox.close();
  }

  Future<void> addAll(List<PasswordEntry> entries) async {
    final Box<PasswordEntry> passwordEntryBox =
        await Hive.openBox('passwordEntryBox');
    await passwordEntryBox.addAll(entries);
    await passwordEntryBox.close();
  }

  Future<void> updatePasswordEntry(PasswordEntry passwordEntry) async {
    final Box<PasswordEntry> passwordEntryBox =
        await Hive.openBox('passwordEntryBox');
    await passwordEntryBox.put(passwordEntry.id, passwordEntry);
    await passwordEntryBox.close();
  }

  Future<void> deletePasswordEntry(String id) async {
    final Box<PasswordEntry> passwordEntryBox =
        await Hive.openBox('passwordEntryBox');
    await passwordEntryBox.delete(id);
    await passwordEntryBox.close();
  }
}
