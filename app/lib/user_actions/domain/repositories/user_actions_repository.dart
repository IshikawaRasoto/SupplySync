import 'package:fpdart/fpdart.dart';

import '../../../core/common/entities/user.dart';
import '../../../core/error/failure.dart';

abstract interface class UserActionsRepository {
  Future<Either<Failure, Unit>> updateUserProfile({
    required String jwtToken,
    String? targetUserName,
    String? newName,
    String? password,
    String? newPassword,
    String? newEmail,
  });

  Future<Either<Failure, User>> getUserByUserName({
    required String jwtToken,
    required String userName,
  });
}
