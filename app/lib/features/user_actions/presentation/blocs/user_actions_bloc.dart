import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/core/common/cubit/user/user_cubit.dart';
import 'package:supplysync/features/user_actions/domain/use_cases/user_register_user.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/use_cases/change_user_roles.dart';
import '../../domain/use_cases/user_update_profile.dart';

part 'user_actions_event.dart';
part 'user_actions_state.dart';

class UserActionsBloc extends Bloc<UserActionsEvent, UserActionsState> {
  final UserCubit _userCubit;
  final UserUpdateProfile _updateUseCase;
  final UserRegisterUser _registerUseCase;
  final ChangeUserRoles _changeRolesUseCase;

  UserActionsBloc({
    required UserCubit userCubit,
    required UserUpdateProfile updateUseCase,
    required UserRegisterUser registerUseCase,
    required ChangeUserRoles changeRolesUseCase,
  })  : _userCubit = userCubit,
        _updateUseCase = updateUseCase,
        _registerUseCase = registerUseCase,
        _changeRolesUseCase = changeRolesUseCase,
        super(UserInitial()) {
    on<ChangeUserProfile>(_onUpdateUserProfile);
    on<ChangeUserPassword>(_onChangeUserPassword);
    on<RegisterNewUser>(_onRegisterNewUser);
    on<UserChangeRolesRequest>(_onChangeUserRoles);
  }

  Future<void> _onUpdateUserProfile(
      ChangeUserProfile event, Emitter<UserActionsState> emit) async {
    emit(UserLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(UserActionsFailure('User not authenticated'));
      return;
    }
    final result = await _updateUseCase(
      UserUpdateProfileParams(
        jwtToken: currentUser.jwtToken,
        targetUserName: event.targetUserName,
        newName: event.newName,
        newEmail: event.newEmail,
      ),
    );
    result.fold(
      (failure) => emit(UserActionsFailure(failure.message)),
      (_) => emit(UserActionsSuccess('Dados alterados com sucesso!')),
    );
  }

  Future<void> _onChangeUserPassword(
      ChangeUserPassword event, Emitter<UserActionsState> emit) async {
    emit(UserLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(UserActionsFailure('User not authenticated'));
      return;
    }
    final result = await _updateUseCase(
      UserUpdateProfileParams(
        jwtToken: currentUser.jwtToken,
        targetUserName: event.targetUserName,
        password: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(UserActionsFailure(failure.message)),
      (_) => emit(UserActionsSuccess('Senha alterada com sucesso!')),
    );
  }

  Future<void> _onChangeUserRoles(
      UserChangeRolesRequest event, Emitter<UserActionsState> emit) async {
    emit(UserLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(UserActionsFailure('User not authenticated'));
      return;
    }
    final result = await _changeRolesUseCase(
      ChangeUserRolesParams(
        jwtToken: currentUser.jwtToken,
        targetUserName: event.targetUserName,
        userRoles: event.newRoles,
      ),
    );
    result.fold(
      (failure) => emit(UserActionsFailure(failure.message)),
      (_) => emit(UserActionsSuccess('Permissões alteradas com sucesso!')),
    );
  }

  Future<void> _onRegisterNewUser(
      RegisterNewUser event, Emitter<UserActionsState> emit) async {
    emit(UserLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(UserActionsFailure('User not authenticated'));
      return;
    }
    final result = await _registerUseCase(
      UserRegisterUserParams(
        jwtToken: currentUser.jwtToken,
        userName: event.userName,
        name: event.name,
        email: event.email,
        password: event.password,
        roles: event.roles,
      ),
    );
    result.fold(
      (failure) => emit(UserActionsFailure(failure.message)),
      (_) => emit(UserActionsSuccess('Usuário cadastrado com sucesso!')),
    );
  }
}
