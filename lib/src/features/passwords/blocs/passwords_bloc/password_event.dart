part of 'password_bloc.dart';

@immutable
sealed class PasswordEvent {}

class FetchPasswordsEvent extends PasswordEvent {}

class FetchFavouritePasswordsEvent extends PasswordEvent {}

class AddPasswordEvent extends PasswordEvent {
  final String title;
  final PasswordEntry entry;

  AddPasswordEvent({
    required this.title,
    required this.entry,
  });
}
