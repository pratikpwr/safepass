part of 'password_bloc.dart';

@immutable
sealed class PasswordEvent {}

class FetchPasswordsEvent extends PasswordEvent {}

class AddPasswordEvent extends PasswordEvent {
  final Password password;

  AddPasswordEvent(this.password);
}

class UpdatePasswordEvent extends PasswordEvent {
  final Password password;

  UpdatePasswordEvent(this.password);
}

class DeletePasswordEvent extends PasswordEvent {
  final String id;

  DeletePasswordEvent(this.id);
}
