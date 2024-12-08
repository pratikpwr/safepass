part of 'password_entry_bloc.dart';

@immutable
sealed class PasswordEntryState {}

final class PasswordEntryInitial extends PasswordEntryState {}

class PasswordEntryLoading extends PasswordEntryState {}

class PasswordEntryLoaded extends PasswordEntryState {
  final List<PasswordEntry> passwordEntries;

  PasswordEntryLoaded(this.passwordEntries);
}

class PasswordEntryErrorState extends PasswordEntryState {
  final Failure failure;

  PasswordEntryErrorState(this.failure);
}
