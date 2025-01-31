import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../core/common/entities/user.dart';
import '../../../core/error/failure.dart';
import '../../domain/repositories/user_actions_repository.dart';
import '../models/target_user_update_model.dart';
import '../source/user_actions_remote_data_source.dart';

class UserActionsRepositoryImpl implements UserActionsRepository {
  final UserActionsRemoteDataSource _remoteDataSource;

  UserActionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> updateUserProfile({
    required String jwtToken,
    String? targetUserName,
    String? newName,
    String? password,
    String? newPassword,
    String? newEmail,
  }) async {
    try {
      final targetUser = TargetUserUpdateModel(
        targetUserName: targetUserName,
        newName: newName,
        password: password,
        newPassword: newPassword,
        newEmail: newEmail,
      );
      await _remoteDataSource.updateUserProfile(
          jwtToken: jwtToken, targetUser: targetUser);
      return right(unit);
    } on HttpException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByUserName({
    required String jwtToken,
    required String userName,
  }) async {
    try {
      final User user = await _remoteDataSource.getUserByUserName(
        jwtToken: jwtToken,
        userName: userName,
      );
      return right(user);
    } on HttpException catch (e) {
      return left(Failure(e.message));
    }
  }
}
