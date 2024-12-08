import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/utils.dart';
import '../data_sources/password_data_source.dart';
import '../data_sources/password_entry_data_source.dart';
import '../models/password.dart';
import '../models/password_entry.dart';

abstract class PasswordRepository {
  Future<Either<Failure, List<Password>>> getPasswords();

  Future<Either<Failure, List<Password>>> getFavouritePasswords();

  Future<Either<Failure, void>> addPassword({
    required String title,
    required PasswordEntry entry,
  });

  Future<Either<Failure, void>> markFavourite({
    required String passId,
  });
}

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordDataSource passwordDataSource;
  final PasswordEntryDataSource passwordEntryDataSource;

  PasswordRepositoryImpl(
    this.passwordDataSource,
    this.passwordEntryDataSource,
  );

  @override
  Future<Either<Failure, void>> addPassword({
    required String title,
    required PasswordEntry entry,
  }) =>
      returnRightOrLeft(
        () async {
          final password = Password(
            id: entry.parentId,
            title: title,
            entries: [entry.id],
          );

          await Future.wait([
            passwordDataSource.addPassword(password),
            passwordEntryDataSource.addPasswordEntry(entry)
          ]);
        },
      );

  @override
  Future<Either<Failure, List<Password>>> getFavouritePasswords() =>
      returnRightOrLeft(() => passwordDataSource.getFavouritePasswords());

  @override
  Future<Either<Failure, List<Password>>> getPasswords() =>
      returnRightOrLeft(() => passwordDataSource.getAllPasswords());

  @override
  Future<Either<Failure, void>> markFavourite({required String passId}) =>
      returnRightOrLeft(() => passwordDataSource.markFavourite(passId));
}
