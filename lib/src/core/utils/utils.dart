import 'package:dartz/dartz.dart';
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