import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:safepass/src/features/passwords/models/password.dart';

import '../repository/password_repository_impl.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository repository = PasswordRepository();

  PasswordBloc() : super(PasswordInitialState()) {
    on<FetchPasswordsEvent>(_onFetchPasswords);
    on<AddPasswordEvent>(_onAddPassword);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<DeletePasswordEvent>(_onDeletePassword);
  }

  Future<void> _onFetchPasswords(
    FetchPasswordsEvent event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordLoadingState());
    try {
      final passwords = await repository.getAllPasswords();
      emit(PasswordLoadedState(passwords));
    } catch (e) {
      emit(PasswordErrorState(e.toString()));
    }
  }

  Future<void> _onAddPassword(
    AddPasswordEvent event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      await repository.addPassword(event.password);
      final passwords = await repository.getAllPasswords();
      emit(PasswordLoadedState(passwords));
    } catch (e) {
      emit(PasswordErrorState(e.toString()));
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      await repository.updatePassword(event.password);
      final passwords = await repository.getAllPasswords();
      emit(PasswordLoadedState(passwords));
    } catch (e) {
      emit(PasswordErrorState(e.toString()));
    }
  }

  Future<void> _onDeletePassword(
    DeletePasswordEvent event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      await repository.deletePassword(event.id);
      final passwords = await repository.getAllPasswords();
      emit(PasswordLoadedState(passwords));
    } catch (e) {
      emit(PasswordErrorState(e.toString()));
    }
  }
}
