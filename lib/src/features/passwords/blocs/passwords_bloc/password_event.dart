part of 'password_bloc.dart';

@immutable
sealed class PasswordEvent {}

class FetchPasswordsEvent extends PasswordEvent {}

class SearchPassword extends PasswordEvent {
  final String query;

  SearchPassword(this.query);
}

class FetchFavouritePasswordsEvent extends PasswordEvent {}

class AddPasswordEvent extends PasswordEvent {
  final String title;
  final PasswordEntry entry;

  AddPasswordEvent({
    required this.title,
    required this.entry,
  });
}

class ImportPasswordsEvent extends PasswordEvent {}

// New event to toggle favorite status
class ToggleFavoriteStatusEvent extends PasswordEvent {
  final String passwordId; // Use the unique ID of the password

  ToggleFavoriteStatusEvent(this.passwordId);
}
