import 'failures.dart';

enum FailureType {
  notFound,
  noData,
  database,
  internal,
  unknown;

  static FailureType fromFailure(Failure failure) {
    switch (failure.runtimeType) {
      case DatabaseFailure:
        return FailureType.database;
      case NoDataFailure:
        return FailureType.noData;
      case NotFoundFailure:
        return FailureType.noData;
      case InternalFailure:
        return FailureType.internal;
      default:
        return FailureType.unknown;
    }
  }

  String get message {
    switch (this) {
      case FailureType.database:
        return 'Database Failure';
      case FailureType.notFound:
        return 'Not Found';
      case FailureType.noData:
        return 'No Data Found';
      case FailureType.internal:
        return 'Internal Failure';
      default:
        return 'Unknown Failure';
    }
  }
}
