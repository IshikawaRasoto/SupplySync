import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../domain/use_cases/user_get_all_users.dart';
import '../../domain/use_cases/user_get_user_by_user_name.dart';

part 'user_request_event.dart';
part 'user_request_state.dart';

class UserRequestBloc extends Bloc<UserRequestEvent, UserRequestState> {
  final UserCubit _userCubit;
  final UserGetUserByUserName _userGetUserByUserName;
  final UserGetAllUsers _userGetAllUsers;

  UserRequestBloc({
    required UserCubit userCubit,
    required UserGetUserByUserName userGetUserByUserName,
    required UserGetAllUsers userGetAllUsers,
  })  : _userCubit = userCubit,
        _userGetUserByUserName = userGetUserByUserName,
        _userGetAllUsers = userGetAllUsers,
        super(UserRequestInitial()) {
    on<GetUserByUserName>(_getUserByUserName);
    on<GetAllUsers>(_getAllUsers);
  }

  Future<void> _getUserByUserName(
      GetUserByUserName event, Emitter<UserRequestState> emit) async {
    emit(UserRequestLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(UserRequestFailure('User not authenticated'));
      return;
    }
    final result = await _userGetUserByUserName(
      UserGetUserByUserNameParams(
        jwtToken: currentUser.jwtToken,
        userName: event.userName,
      ),
    );
    result.fold(
      (failure) => emit(UserRequestFailure(failure.message)),
      (user) => emit(UserRequestUserSuccess(user)),
    );
  }

  Future<void> _getAllUsers(
      GetAllUsers event, Emitter<UserRequestState> emit) async {
    emit(UserRequestLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(UserRequestFailure('User not authenticated'));
      return;
    }
    final result = await _userGetAllUsers(
      currentUser.jwtToken,
    );
    result.fold(
      (failure) => emit(UserRequestFailure(failure.message)),
      (users) => emit(UserRequestAllUsersSuccess(users)),
    );
  }
}
