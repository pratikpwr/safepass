import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/utils.dart';
import '../data_sources/password_data_source.dart';
import '../data_sources/password_entry_data_source.dart';
import '../models/password_entry.dart';

abstract class PasswordEntryRepository {
  Future<Either<Failure, List<PasswordEntry>>> getPasswordEntries({
    required String passId,
  });

  Future<Either<Failure, void>> addPasswordEntry({
    required PasswordEntry entry,
  });

  Future<Either<Failure, void>> editPasswordEntry({
    required PasswordEntry entry,
  });

  Future<Either<Failure, void>> deletePasswordEntry({
    required PasswordEntry entry,
  });
}

class PasswordEntryRepositoryImpl implements PasswordEntryRepository {
  final PasswordDataSource passwordDataSource;
  final PasswordEntryDataSource passwordEntryDataSource;

  PasswordEntryRepositoryImpl(
    this.passwordDataSource,
    this.passwordEntryDataSource,
  );

  @override
  Future<Either<Failure, void>> addPasswordEntry(
          {required PasswordEntry entry}) =>
      returnRightOrLeft(() async {
        final password =
            await passwordDataSource.getPasswordById(entry.parentId);
        password.copyWith(entries: [...password.entries, entry.id]);
        await passwordDataSource.updatePassword(password);
        await passwordEntryDataSource.addPasswordEntry(entry);
      });

  @override
  Future<Either<Failure, void>> deletePasswordEntry(
          {required PasswordEntry entry}) =>
      returnRightOrLeft(() async {
        await passwordEntryDataSource.deletePasswordEntry(entry.id);

        final password =
            await passwordDataSource.getPasswordById(entry.parentId);

        password.entries.remove(entry.id);

        // if this is only single entry in password then delete password as well
        if (password.entries.isEmpty) {
          await passwordDataSource.deletePassword(password.id);
        } else {
          final newPass = password.copyWith(entries: password.entries);
          await passwordDataSource.updatePassword(newPass);
        }
      });

  @override
  Future<Either<Failure, void>> editPasswordEntry(
          {required PasswordEntry entry}) =>
      returnRightOrLeft(
          () => passwordEntryDataSource.updatePasswordEntry(entry));

  @override
  Future<Either<Failure, List<PasswordEntry>>> getPasswordEntries(
          {required String passId}) =>
      returnRightOrLeft(
          () => passwordEntryDataSource.getPasswordEntries(passId));
}
