import 'package:dartz/dartz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safepass/src/core/utils/password_exporter.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/utils.dart';
import '../data_sources/password_data_source.dart';
import '../data_sources/password_entry_data_source.dart';
import '../models/password.dart';
import '../models/password_entry.dart';

abstract class PasswordRepository {
  Future<Either<Failure, List<Password>>> getPasswords();

  Future<Either<Failure, List<Password>>> searchPassword(String query);

  Future<Either<Failure, List<Password>>> getFavouritePasswords();

  Future<Either<Failure, void>> addPassword({
    required String title,
    required PasswordEntry entry,
  });

  Future<Either<Failure, void>> markFavourite({
    required String passId,
  });

  Future<Either<Failure, void>> exportDataToExcel();

  Future<Either<Failure, bool>> importDataFromExcel(String filePath);
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
  Future<Either<Failure, List<Password>>> searchPassword(String query) =>
      returnRightOrLeft(() => passwordDataSource.searchPasswords(query));

  @override
  Future<Either<Failure, void>> markFavourite({required String passId}) =>
      returnRightOrLeft(() => passwordDataSource.markFavourite(passId));

  @override
  Future<Either<Failure, dynamic>> exportDataToExcel() =>
      returnRightOrLeft(() async {
        final passes = await passwordDataSource.getAllPasswords();
        final entries = await passwordEntryDataSource.getAllPasswordEntries();

        await PasswordExporter()
            .exportToExcel(passwords: passes, passwordEntries: entries);
        Fluttertoast.showToast(msg: "Exported!!");
      });

  @override
  Future<Either<Failure, bool>> importDataFromExcel(String filePath) =>
      returnRightOrLeft(() async {
        final importedData = await PasswordExporter().importFromExcel(filePath);
        final data = await PasswordExporter().processImportedData(importedData);

        await passwordDataSource.addAll(data['passwords'] as List<Password>);
        await passwordEntryDataSource
            .addAll(data['entries'] as List<PasswordEntry>);

        return true;
      });
}
