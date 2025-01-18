part of 'password_generate_bloc.dart';

class PasswordGenerateEvent {
  final int length;
  final bool useSymbols;
  final bool useNumbers;
  final bool useLowercase;
  final bool useUppercase;

  PasswordGenerateEvent({
    this.length = 12,
    this.useSymbols = true,
    this.useNumbers = true,
    this.useLowercase = true,
    this.useUppercase = true,
  });
}
