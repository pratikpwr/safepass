import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties = const <dynamic>[];

  const Failure([properties]);

  @override
  List<Object?> get props => properties;
}

class DatabaseFailure extends Failure {
  final String? message;

  const DatabaseFailure([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return "Database Failure!";
  }
}

class InternalFailure extends Failure {
  final String? message;

  const InternalFailure([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return "Internal Failure!";
  }
}

class NoDataFailure extends Failure {
  final String? message;

  const NoDataFailure([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return "Password Data Found!";
  }
}

class NotFoundFailure extends Failure {
  final String? message;

  const NotFoundFailure([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return "No Data Found!";
  }
}
