part of 'password_bloc.dart';

@immutable
sealed class PasswordState {}

class PasswordInitialState extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordLoaded extends PasswordState {
  final List<Password> passwords;
  final bool isFavourites;

  PasswordLoaded(
    this.passwords, {
    this.isFavourites = false,
  });
}

class PasswordErrorState extends PasswordState {
  final Failure failure;

  PasswordErrorState(this.failure);
}
