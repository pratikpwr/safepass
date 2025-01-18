import 'package:dartz/dartz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:safepass/src/core/errors/exception.dart';
import 'package:safepass/src/core/errors/failures.dart';

Future<Either<Failure, T>> returnRightOrLeft<T>(
    Future<T> Function() callback) async {
  try {
    return Right(await callback());
  } on NoDataException {
    return Left(NoDataFailure());
  } on DatabaseException {
    return Left(DatabaseFailure());
  } on InternalException {
    return Left(InternalFailure());
  } on NotFoundException {
    return Left(NotFoundFailure());
  }
}

Future<bool> authenticateUser() async {
  final LocalAuthentication auth = LocalAuthentication();
  try {
    bool authenticated = await auth.authenticate(
      localizedReason: 'Please authenticate to see passwords',
      options: const AuthenticationOptions(
        biometricOnly: false,
        stickyAuth: true,
      ),
    );
    return authenticated;
  } catch (e) {
    print("Authentication error: $e");
    return false;
  }
}
