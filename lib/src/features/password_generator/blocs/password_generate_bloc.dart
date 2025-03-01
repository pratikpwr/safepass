import 'package:bloc/bloc.dart';
import 'package:safepass/src/core/utils/password_generator.dart';

part 'password_generate_event.dart';
part 'password_generate_state.dart';

class PasswordGenerateBloc
    extends Bloc<PasswordGenerateEvent, PasswordGenerateState> {
  PasswordGenerateBloc() : super(PasswordGenerateState()) {
    on<PasswordGenerateEvent>(_onGeneratePassword);
  }

  void _onGeneratePassword(
      PasswordGenerateEvent event, Emitter<PasswordGenerateState> emit) {
    if (!event.useSymbols &&
        !event.useNumbers &&
        !event.useLowercase &&
        !event.useUppercase) {
      emit(state.copyWith(password: 'Select at least one option'));
      return;
    }

    final result = PasswordGenerator.generatePassword(
      includeNumbers: event.useNumbers,
      includeSymbols: event.useSymbols,
      includeUpperCase: event.useUppercase,
    );

    emit(state.copyWith(
      password: result,
      isSaved: false,
    ));
  }
}
