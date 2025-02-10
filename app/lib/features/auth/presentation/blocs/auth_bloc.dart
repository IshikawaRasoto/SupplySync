import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supplysync/features/auth/domain/use_cases/user_logout.dart';
import '../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../domain/use_cases/user_get_user.dart';
import '../../domain/use_cases/user_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserCubit _userCubit;
  final Logger _loger = Logger();
  // UseCases
  final UserLogin _loginUseCase;
  final UserLogout _logoutUseCase;
  final UserGetUser _getCurrentUseCase;

  AuthBloc({
    required UserCubit userCubit,
    required UserLogin loginUseCase,
    required UserLogout logoutUseCase,
    required UserGetUser getCurrentUseCase,
  })  : _userCubit = userCubit,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUseCase = getCurrentUseCase,
        super(AuthInitial()) {
    on<AuthLogin>(_onLogin);
    on<AuthLogout>(_onLogout);
    on<AuthGetCurrentUser>(_getCurrentUser);
    on<AuthResetEvent>(_onReset);
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _loginUseCase(
        UserLoginParams(username: event.username, password: event.password));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        _loger.i('User Logged in: ${user.toJson()}');
        _userCubit.updateUser(user);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> _getCurrentUser(
      AuthGetCurrentUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    emit(AuthLoading());
    final token = _userCubit.getToken();
    if (token == null) {
      emit(AuthFailure('User not authenticated'));
      return;
    }
    final result = await _getCurrentUseCase(token);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        _loger.i('User retrieved: ${user.toJson()}');
        _userCubit.updateUser(user);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _logoutUseCase((_userCubit.state as UserLoggedIn).user);
    _userCubit.updateUser(null);
    emit(AuthInitial());
  }

  void _onReset(AuthResetEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }
}
