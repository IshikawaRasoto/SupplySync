import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/auth/domain/use_cases/user_logout.dart';
import '../../../core/common/cubit/user/user_cubit.dart';
import '../../../core/common/entities/user.dart';
import '../../domain/use_cases/user_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserCubit _userCubit;
  // UseCases
  final UserLogin _loginUseCase;
  final UserLogout _logoutUseCase;

  AuthBloc({
    required UserCubit userCubit,
    required UserLogin loginUseCase,
    required UserLogout logoutUseCase,
  })  : _userCubit = userCubit,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    on<AuthLogin>(_onLogin);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _loginUseCase(
        UserLoginParams(username: event.username, password: event.password));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        _userCubit.updateUser(user);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    if (_userCubit.state is! UserLoggedIn) {
      _userCubit.updateUser(null);
      emit(AuthFailure('User is not logged in'));
      return;
    }
    final result =
        await _logoutUseCase((_userCubit.state as UserLoggedIn).user);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthInitial()),
    );
    _userCubit.updateUser(null);
  }
}
