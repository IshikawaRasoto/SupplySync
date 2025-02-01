import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/user_actions_repository.dart';

class UserGetUserByUserName
    implements UseCase<User, UserGetUserByUserNameParams> {
  final UserActionsRepository repository;
  UserGetUserByUserName(this.repository);

  @override
  Future<Either<Failure, User>> call(UserGetUserByUserNameParams param) async {
    return await repository.getUserByUserName(
      jwtToken: param.jwtToken,
      userName: param.userName,
    );
  }
}

class UserGetUserByUserNameParams {
  final String jwtToken;
  final String userName;

  UserGetUserByUserNameParams({
    required this.jwtToken,
    required this.userName,
  });
}
