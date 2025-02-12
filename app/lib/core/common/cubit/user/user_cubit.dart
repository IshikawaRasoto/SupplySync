import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/core/common/entities/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(UserInitial());
    } else {
      emit(UserLoggedIn(user));
    }
  }

  String? getToken() {
    final state = this.state;
    if (state is UserLoggedIn) {
      return state.user.jwtToken;
    }
    return null;
  }

  User? getCurrentUser() {
    final state = this.state;
    return state is UserLoggedIn ? state.user : null;
  }
}
