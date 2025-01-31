import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/common/entities/user.dart';

import '../../../error/failure.dart';

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

  Either<Failure, User> getUser() {
    final state = this.state;
    if (state is UserLoggedIn) {
      return right(state.user);
    }
    return left(Failure('Usuário não autenticado'));
  }
}
