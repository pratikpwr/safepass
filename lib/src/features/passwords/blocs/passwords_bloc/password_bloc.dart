import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    on<ImportPasswordsEvent>(_onImportPasswordsEvent);
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

  Future<void> _onImportPasswordsEvent(
    ImportPasswordsEvent event,
    Emitter<PasswordState> emit,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        final result = await repository.importDataFromExcel(filePath);

        result.fold(
          (l) => Fluttertoast.showToast(msg: "Failed to import data"),
          (r) {
            add(FetchPasswordsEvent());
            Fluttertoast.showToast(msg: "Imported Successfully!!");
          },
        );
      } else {
        Fluttertoast.showToast(msg: "Failed to get file");
      }
    }
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
