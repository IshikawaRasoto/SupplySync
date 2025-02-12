import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/common/entities/user.dart';
import '../repositories/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository repository;
  UserLogin(this.repository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await repository.login(
      username: params.username,
      password: params.password,
      firebaseToken: params.firebaseToken,
    );
  }
}

class UserLoginParams {
  final String username;
  final String password;
  final String firebaseToken;

  UserLoginParams({
    required this.username,
    required this.password,
    required this.firebaseToken,
  });
}
