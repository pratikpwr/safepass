import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:safepass/src/core/errors/exception.dart';

import '../models/password.dart';

class PasswordDataSource {
  PasswordDataSource();

  Future<List<Password>> getAllPasswords() async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');
    final passwords = passwordBox.values.cast<Password>().toList();
    await passwordBox.close();
    return passwords;
  }

  Future<Password> getPasswordById(String id) async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');
    final password =
        passwordBox.values.singleWhereOrNull((item) => item.id == id);
    await passwordBox.close();
    if (password != null) {
      return password;
    } else {
      throw NotFoundException();
    }
  }

  Future<List<Password>> getFavouritePasswords() async {
    Box<Password> passwordBox = await Hive.openBox('passwordBox');
    final passwords =
        passwordBox.values.where((item) => item.isFavourite).toList();
    await passwordBox.close();
    return passwords;
  }

  Future<void> addPassword(Password password) async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');
    await passwordBox.put(password.id, password);
    await passwordBox.close();
  }

  Future<void> markFavourite(String passId) async {
    throw UnimplementedError();
  }

  Future<void> updatePassword(Password password) async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');
    await passwordBox.put(password.id, password);
    await passwordBox.close();
  }

  Future<void> deletePassword(String id) async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');
    await passwordBox.delete(id);
    await passwordBox.close();
  }
}
