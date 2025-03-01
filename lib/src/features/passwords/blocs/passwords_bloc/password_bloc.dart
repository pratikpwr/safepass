import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../models/password.dart';
import '../../models/password_entry.dart';
import '../../repository/password_repository.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository repository;

  PasswordBloc(this.repository) : super(PasswordInitialState()) {
    on<FetchPasswordsEvent>(_onFetchPasswords);
    on<FetchFavouritePasswordsEvent>(_onFetchFavouritePasswords);
    on<AddPasswordEvent>(_onAddPassword);
    on<SearchPassword>(_onSearchPassword);
  }

  Future<void> _onSearchPassword(
    SearchPassword event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordLoading());
    final result = await repository.searchPassword(event.query);

    result.fold((failure) {
      emit(PasswordErrorState(failure));
    }, (results) {
      results.sort((a, b) =>
          a.title.toLowerCase().compareTo(b.title.toLowerCase()) ?? 0);
      emit(PasswordLoaded(results));
    });
  }

  Future<void> _onFetchPasswords(
    FetchPasswordsEvent event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordLoading());

    final result = await repository.getPasswords();

    result.fold((failure) {
      emit(PasswordErrorState(failure));
    }, (results) {
      results.sort((a, b) =>
          a.title.toLowerCase().compareTo(b.title.toLowerCase()) ?? 0);
      emit(PasswordLoaded(results));
    });
  }

  Future<void> _onAddPassword(
    AddPasswordEvent event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordLoading());

    final result = await repository.addPassword(
      title: event.title,
      entry: event.entry,
    );

    result.fold((failure) {
      emit(PasswordErrorState(failure));
    }, (_) {
      add(FetchPasswordsEvent());
    });
  }

  FutureOr<void> _onFetchFavouritePasswords(
      FetchFavouritePasswordsEvent event, Emitter<PasswordState> emit) async {
    emit(PasswordLoading());

    final result = await repository.getFavouritePasswords();

    result.fold((failure) {
      emit(PasswordErrorState(failure));
    }, (results) {
      emit(PasswordLoaded(
        results,
        isFavourites: true,
      ));
    });
  }
}
