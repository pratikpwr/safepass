part of 'password_bloc.dart';

@immutable
sealed class PasswordState {}

class PasswordInitialState extends PasswordState {}

class PasswordLoadingState extends PasswordState {}

class PasswordLoadedState extends PasswordState {
  final List<Password> passwords;

  PasswordLoadedState(this.passwords);
}

class PasswordErrorState extends PasswordState {
  final String message;

  PasswordErrorState(this.message);
}
