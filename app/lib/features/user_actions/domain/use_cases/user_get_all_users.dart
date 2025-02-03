import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/user_actions_repository.dart';

class UserGetAllUsers implements UseCase<List<User>, String> {
  final UserActionsRepository repository;
  UserGetAllUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(String jwtToken) async {
    return await repository.getAllUsers(
      jwtToken: jwtToken,
    );
  }
}
