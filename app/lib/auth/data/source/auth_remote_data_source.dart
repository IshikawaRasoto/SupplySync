import 'dart:io';

import '../../../core/api/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/common/entities/user.dart';

abstract interface class AuthRemoteDataSource {
  Future<User> login({required String username, required String password});
  Future<void> logout({required String jwtToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;
  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<User> login(
      {required String username, required String password}) async {
    try {
      final response = await _apiService.postData(
        endPoint: ApiEndpoints.login,
        body: {'username': username, 'password': password},
      );
      if (response['jwt_token'] == null) {
        throw const HttpException('User is NULL');
      }
      return User.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout({required String jwtToken}) async {
    try {
      await _apiService.postData(
        endPoint: ApiEndpoints.logout,
        jwtToken: jwtToken,
      );
    } catch (e) {
      rethrow;
    }
  }
}
