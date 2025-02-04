import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/error/server_exception.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/data/api_service.dart';
import '../models/new_user_model.dart';
import '../models/target_user_model.dart';
import '../models/target_user_update_model.dart';

abstract interface class UserActionsRemoteDataSource {
  Future<Unit> updateUserProfile({
    required String jwtToken,
    required TargetUserUpdateModel targetUser,
  });

  Future<TargetUserModel> getUserByUserName({
    required String jwtToken,
    required String userName,
  });

  Future<Unit> changeUserRoles({
    required String jwtToken,
    required List<UserRoles> userRoles,
    required String targetUserName,
  });

  Future<Unit> registerUser({
    required String jwtToken,
    required NewUserModel newUser,
  });

  Future<List<TargetUserModel>> getAllUsers({
    required String jwtToken,
  });
}

class UserActionsRemoteDataSourceImpl implements UserActionsRemoteDataSource {
  final ApiService _apiService;
  UserActionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<Unit> updateUserProfile({
    required String jwtToken,
    required TargetUserUpdateModel targetUser,
  }) async {
    try {
      final data = targetUser.toJson();
      await _apiService.updateData(
        endPoint: ApiEndpoints.updateLogin,
        jwtToken: jwtToken,
        body: data,
      );
      return unit;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TargetUserModel> getUserByUserName(
      {required String jwtToken, required String userName}) async {
    try {
      final response = await _apiService.fetchData(
        endPoint: ApiEndpoints.getOtherUser,
        jwtToken: jwtToken,
        pathParams: {'userName': userName},
      );
      return TargetUserModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> changeUserRoles({
    required String jwtToken,
    required List<UserRoles> userRoles,
    required String targetUserName,
  }) async {
    try {
      // final data = {'roles': userRoles.map((e) => e.toString()).toList()};
      final data = {'username': targetUserName, 'roles': userRoles.first.name};
      await _apiService.updateData(
        endPoint: ApiEndpoints.updateLogin,
        jwtToken: jwtToken,
        body: data,
      );
      return unit;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> registerUser({
    required String jwtToken,
    required NewUserModel newUser,
  }) async {
    try {
      final data = newUser.toJson();
      await _apiService.postData(
        endPoint: ApiEndpoints.createLogin,
        jwtToken: jwtToken,
        body: data,
      );
      return unit;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TargetUserModel>> getAllUsers({required String jwtToken}) async {
    try {
      final response = await _apiService.fetchData(
        endPoint: ApiEndpoints.getAllUsers,
        jwtToken: jwtToken,
      );
      final List<dynamic> usersList = response['users'] as List<dynamic>;
      return usersList
          .map((userData) => TargetUserModel(
                name: userData['name'],
                userName: userData['username'],
                email: '',
                roles: [],
              ))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
