import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../models/password_entry.dart';
import '../../repository/password_entry_repository.dart';

part 'password_entry_event.dart';
part 'password_entry_state.dart';

class PasswordEntryBloc extends Bloc<PasswordEntryEvent, PasswordEntryState> {
  final PasswordEntryRepository repository;

  PasswordEntryBloc(this.repository) : super(PasswordEntryInitial()) {
    on<GetPasswordEntries>(_onGetPasswordEntries);
    on<AddPasswordEntry>(_onAddPasswordEntry);
    on<UpdatePasswordEntry>(_onUpdatePasswordEntry);
    on<DeletePasswordEntry>(_onDeletePasswordEntry);
  }

  FutureOr<void> _onGetPasswordEntries(
      GetPasswordEntries event, Emitter<PasswordEntryState> emit) async {
    emit(PasswordEntryLoading());

    final result = await repository.getPasswordEntries(passId: event.passId);

    result.fold((failure) {
      emit(PasswordEntryErrorState(failure));
    }, (results) {
      emit(PasswordEntryLoaded(results));
    });
  }

  FutureOr<void> _onAddPasswordEntry(
      AddPasswordEntry event, Emitter<PasswordEntryState> emit) async {
    emit(PasswordEntryLoading());

    final result = await repository.addPasswordEntry(entry: event.entry);

    result.fold((failure) {
      emit(PasswordEntryErrorState(failure));
    }, (results) {
      add(GetPasswordEntries(event.entry.parentId));
    });
  }

  FutureOr<void> _onUpdatePasswordEntry(
      UpdatePasswordEntry event, Emitter<PasswordEntryState> emit) async {
    emit(PasswordEntryLoading());

    final result = await repository.editPasswordEntry(entry: event.entry);

    result.fold((failure) {
      emit(PasswordEntryErrorState(failure));
    }, (results) {
      add(GetPasswordEntries(event.entry.parentId));
    });
  }

  FutureOr<void> _onDeletePasswordEntry(
      DeletePasswordEntry event, Emitter<PasswordEntryState> emit) async {
    emit(PasswordEntryLoading());

    final result = await repository.deletePasswordEntry(entry: event.entry);

    result.fold((failure) {
      emit(PasswordEntryErrorState(failure));
    }, (results) {
      add(GetPasswordEntries(event.entry.parentId));
    });
  }
}
