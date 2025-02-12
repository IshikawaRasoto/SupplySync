import 'package:fpdart/fpdart.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/data/api_service.dart';
import '../../../../../core/error/server_exception.dart';
import '../../../log/data/models/log_model.dart';
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

  Future<List<LogModel>> getLogs({
    required String jwtToken,
    DateTime? startDate,
    DateTime? endDate,
    String? level,
    String? source,
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
      final response = await _apiService.getData(
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
      final response = await _apiService.getData(
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

  @override
  Future<List<LogModel>> getLogs({
    required String jwtToken,
    DateTime? startDate,
    DateTime? endDate,
    String? level,
    String? source,
  }) async {
    try {
      Map<String, String>? queryParams;

      if (startDate != null ||
          endDate != null ||
          level != null ||
          source != null) {
        queryParams = {};
        if (startDate != null) {
          queryParams['startDate'] = startDate.toIso8601String();
        }
        if (endDate != null) {
          queryParams['endDate'] = endDate.toIso8601String();
        }
        if (level != null) {
          queryParams['level'] = level;
        }
        if (source != null) {
          queryParams['source'] = source;
        }
      }

      final result = await _apiService.getData(
        endPoint: ApiEndpoints.records,
        jwtToken: jwtToken,
        pathParams: queryParams,
      );

      final List<dynamic> logList = result['logs'] as List<dynamic>;
      return logList
          .map((log) => LogModel.fromJson(log as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
