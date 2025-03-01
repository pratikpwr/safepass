part of 'password_generate_bloc.dart';

class PasswordGenerateState {
  final String password;

  final bool isSaved;

  const PasswordGenerateState({
    this.password = '',
    this.isSaved = false,
  });

  PasswordGenerateState copyWith({
    String? password,
    int? length,
    bool? useSymbols,
    bool? useNumbers,
    bool? useLowercase,
    bool? useUppercase,
    bool? isSaved,
  }) {
    return PasswordGenerateState(
      password: password ?? this.password,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
