import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    required String firebaseToken,
  });
  Future<Either<Failure, Unit>> logout({required String jwtToken});
  Future<Either<Failure, User>> getUser({required String jwtToken});
}
