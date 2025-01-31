import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/core/common/cubit/user/user_cubit.dart';

import '../../domain/use_cases/user_update_profile.dart';

part 'user_actions_event.dart';
part 'user_actions_state.dart';

class UserActionsBloc extends Bloc<UserActionsEvent, UserActionsState> {
  final UserCubit _userCubit;
  final UserUpdateProfile _updateUseCase;

  UserActionsBloc({
    required UserCubit userCubit,
    required UserUpdateProfile updateUseCase,
  })  : _userCubit = userCubit,
        _updateUseCase = updateUseCase,
        super(UserInitial()) {
    on<ChangeUserProfile>(_onUpdateUserProfile);
    on<ChangeUserPassword>(_onChangeUserPassword);
  }

  Future<void> _onUpdateUserProfile(
      ChangeUserProfile event, Emitter<UserActionsState> emit) async {
    emit(UserLoading());
    _userCubit.getUser().fold(
      (failure) => emit(UserFailure(failure.message)),
      (user) async {
        final result = await _updateUseCase(
          UserUpdateProfileParams(
            jwtToken: user.jwtToken,
            targetUserName: event.targetUserName,
            newName: event.newName,
            newEmail: event.newEmail,
          ),
        );
        result.fold(
          (failure) => emit(UserFailure(failure.message)),
          (_) => emit(UserActionsSuccess('Dados alterados com sucesso!')),
        );
      },
    );
  }

  Future<void> _onChangeUserPassword(
      ChangeUserPassword event, Emitter<UserActionsState> emit) async {
    emit(UserLoading());
    _userCubit.getUser().fold(
      (failure) => emit(UserFailure(failure.message)),
      (user) async {
        final result = await _updateUseCase(
          UserUpdateProfileParams(
            jwtToken: user.jwtToken,
            targetUserName: event.targetUserName,
            password: event.oldPassword,
            newPassword: event.newPassword,
          ),
        );
        result.fold(
          (failure) => emit(UserFailure(failure.message)),
          (_) => emit(UserActionsSuccess('Senha alterada com sucesso!')),
        );
      },
    );
  }
}
