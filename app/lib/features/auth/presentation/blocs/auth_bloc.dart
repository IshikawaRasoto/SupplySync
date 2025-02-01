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
    await _userCubit.getUser().fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async {
        final result = await _getCurrentUseCase(user.jwtToken);
        result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (user) {
            _loger.i('User getted in: ${user.toJson()}');
            _userCubit.updateUser(user);
            emit(AuthSuccess(user));
          },
        );
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
