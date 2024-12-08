part of 'password_entry_bloc.dart';

@immutable
sealed class PasswordEntryEvent {}

final class GetPasswordEntries extends PasswordEntryEvent {
  final String passId;

  GetPasswordEntries(this.passId);
}

final class AddPasswordEntry extends PasswordEntryEvent {
  final PasswordEntry entry;

  AddPasswordEntry(this.entry);
}

final class UpdatePasswordEntry extends PasswordEntryEvent {
  final PasswordEntry entry;

  UpdatePasswordEntry(this.entry);
}

final class DeletePasswordEntry extends PasswordEntryEvent {
  final PasswordEntry entry;

  DeletePasswordEntry(this.entry);
}
