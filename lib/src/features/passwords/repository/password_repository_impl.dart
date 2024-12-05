import 'package:hive/hive.dart';

import '../models/password.dart';

// abstract class PasswordRepository {
//   Future<List<Password>> getAllPasswords();
//
//   Future<void> addPassword(Password password);
//
//   Future<void> updatePassword(Password password);
//
//   Future<void> deletePassword(String id);
// }

class PasswordRepository {
  PasswordRepository();

  Future<List<Password>> getAllPasswords() async {
    // Fetch all passwords from the Hive box
    final passwordBox = await Hive.openBox('passwordBox');
    final passwords = passwordBox.values.cast<Password>().toList();
    return passwords;
  }

  Future<void> addPassword(Password password) async {
    // Use the password ID as the key for storage
    final passwordBox = await Hive.openBox('passwordBox');
    await passwordBox.put(password.id, password);
  }

  Future<void> updatePassword(Password password) async {
    // Update an existing password by overwriting its key
    final passwordBox = await Hive.openBox('passwordBox');
    await passwordBox.put(password.id, password);
  }

  Future<void> deletePassword(String id) async {
    // Remove the password by its ID
    final passwordBox = await Hive.openBox('passwordBox');
    await passwordBox.delete(id);
  }
}
