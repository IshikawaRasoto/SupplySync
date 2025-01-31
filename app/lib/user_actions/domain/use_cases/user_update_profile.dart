import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/usecase/usecase.dart';
import 'package:supplysync/core/error/failure.dart';

import '../repositories/user_actions_repository.dart';

class UserUpdateProfile implements UseCase<Unit, UserUpdateProfileParams> {
  final UserActionsRepository repository;
  UserUpdateProfile(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UserUpdateProfileParams param) async {
    return await repository.updateUserProfile(
      jwtToken: param.jwtToken,
      targetUserName: param.targetUserName,
      newName: param.newName,
      newEmail: param.newEmail,
      password: param.password,
      newPassword: param.newPassword,
    );
  }
}

class UserUpdateProfileParams {
  final String jwtToken;
  final String? targetUserName;
  final String? newName;
  final String? password;
  final String? newPassword;
  final String? newEmail;

  UserUpdateProfileParams({
    required this.jwtToken,
    this.targetUserName,
    this.newName,
    this.password,
    this.newPassword,
    this.newEmail,
  }) : assert(password != null && newPassword != null,
            'Para alterar a senha, é necessário informar a senha atual e a nova senha');
}
