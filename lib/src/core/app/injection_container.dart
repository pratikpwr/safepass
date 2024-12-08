import 'package:get_it/get_it.dart';
import 'package:safepass/src/features/passwords/data_sources/password_data_source.dart';
import 'package:safepass/src/features/passwords/data_sources/password_entry_data_source.dart';
import 'package:safepass/src/features/passwords/repository/password_entry_repository.dart';
import 'package:safepass/src/features/passwords/repository/password_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<PasswordDataSource>(
    () => PasswordDataSource(),
  );

  sl.registerLazySingleton<PasswordEntryDataSource>(
    () => PasswordEntryDataSource(),
  );

  sl.registerLazySingleton<PasswordRepository>(
    () => PasswordRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<PasswordEntryRepository>(
    () => PasswordEntryRepositoryImpl(sl(), sl()),
  );
}
