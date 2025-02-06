import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/error/server_exception.dart';

import '../../../../../core/common/entities/user.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/repositories/user_actions_repository.dart';
import '../models/new_user_model.dart';
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
    } on ServerException catch (e) {
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
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> changeUserRoles({
    required List<UserRoles> userRoles,
    required String jwtToken,
    required String targetUserName,
  }) async {
    try {
      await _remoteDataSource.changeUserRoles(
        userRoles: userRoles,
        jwtToken: jwtToken,
        targetUserName: targetUserName,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> registerUser({
    required String jwtToken,
    required String userName,
    required String name,
    required String email,
    required String password,
    required List<UserRoles> roles,
  }) async {
    try {
      final newUser = NewUserModel(
        userName: userName,
        name: name,
        email: email,
        password: password,
        roles: roles.map((e) => e.name).toList(),
      );
      await _remoteDataSource.registerUser(
        jwtToken: jwtToken,
        newUser: newUser,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers({
    required String jwtToken,
  }) async {
    try {
      final users = await _remoteDataSource.getAllUsers(jwtToken: jwtToken);
      return right(users);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
