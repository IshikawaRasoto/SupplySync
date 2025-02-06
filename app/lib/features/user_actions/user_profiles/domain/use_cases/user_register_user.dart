import 'package:fpdart/fpdart.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/user_actions_repository.dart';

class UserRegisterUser implements UseCase<Unit, UserRegisterUserParams> {
  final UserActionsRepository repository;
  UserRegisterUser(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UserRegisterUserParams param) async {
    return await repository.registerUser(
      jwtToken: param.jwtToken,
      userName: param.userName,
      name: param.name,
      email: param.email,
      password: param.password,
      roles: param.roles,
    );
  }
}

class UserRegisterUserParams {
  final String jwtToken;
  final String userName;
  final String name;
  final String email;
  final String password;
  List<UserRoles> roles;

  UserRegisterUserParams({
    required this.jwtToken,
    required this.userName,
    required this.name,
    required this.email,
    required this.password,
    required this.roles,
  });
}
