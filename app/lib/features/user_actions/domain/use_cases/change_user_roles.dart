import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/user_actions_repository.dart';

class ChangeUserRoles implements UseCase<Unit, ChangeUserRolesParams> {
  final UserActionsRepository repository;
  ChangeUserRoles(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ChangeUserRolesParams param) async {
    return await repository.changeUserRoles(
      userRoles: param.userRoles,
      jwtToken: param.jwtToken,
      targetUserName: param.targetUserName,
    );
  }
}

class ChangeUserRolesParams {
  final List<UserRoles> userRoles;
  final String jwtToken;
  final String targetUserName;

  ChangeUserRolesParams({
    required this.userRoles,
    required this.targetUserName,
    required this.jwtToken,
  });
}
