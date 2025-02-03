import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_credentials_repository.dart';

part 'auth_credentials_state.dart';

class AuthCredentialsCubit extends Cubit<AuthCredentialsState> {
  final AuthCredentialsRepository _repository;

  AuthCredentialsCubit(this._repository) : super(AuthCredentialsInitial());

  Future<void> loadCredentials() async {
    final username = await _repository.getSavedUsername();
    final password = await _repository.getSavedPassword();
    final savePassword = await _repository.getSavePassword();
    emit(AuthCredentialsLoaded(
        username: username, password: password, savePassword: savePassword));
  }

  Future<void> saveCredentials({
    required String username,
    String password = '',
    bool savePassword = false,
  }) async {
    await _repository.setSavedUsername(username);
    await _repository.setSavePassword(savePassword);
    await _repository.setSavedPassword(savePassword ? password : '');
    emit(AuthCredentialsSaved());
  }

  Future<void> clearCredentials() async {
    await _repository.clearCredentials();
    emit(AuthCredentialsLoaded());
  }
}
