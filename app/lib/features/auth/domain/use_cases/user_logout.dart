import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/common/entities/user.dart';

class UserLogout implements UseCase<Unit, User> {
  final AuthRepository repository;
  UserLogout(this.repository);

  @override
  Future<Either<Failure, Unit>> call(User user) async {
    return await repository.logout(jwtToken: user.jwtToken);
  }
}
