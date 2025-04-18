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

  Future<List<Password>> searchPasswords(String query) async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');
    final passwords = passwordBox.values.cast<Password>().toList();
    await passwordBox.close();
    return passwords
        .where((pass) => pass.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
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

  Future<void> addAll(List<Password> passwords) async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');
    await passwordBox.addAll(passwords);
    await passwordBox.close();
  }

  Future<void> markFavourite(String passId) async {
    final Box<Password> passwordBox = await Hive.openBox('passwordBox');

    // Retrieve the password by its ID
    Password? password = passwordBox.values.firstWhereOrNull((item) => item.id == passId);

    if (password != null) {
      // Create a new password with toggled isFavourite property
      Password updatedPassword = password.copyWith(
        isFavourite: !password.isFavourite,
      );

      // Save the updated password back to the box
      await passwordBox.put(password.id, updatedPassword);
    } else {
      throw NotFoundException();
    }

    await passwordBox.close();
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
