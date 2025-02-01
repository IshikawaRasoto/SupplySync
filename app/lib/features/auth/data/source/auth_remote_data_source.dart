import 'package:supplysync/core/error/server_exception.dart';

import '../../../../core/data/api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/common/entities/user.dart';

abstract interface class AuthRemoteDataSource {
  Future<User> login({required String username, required String password});
  Future<void> logout({required String jwtToken});
  Future<User> getUser({required String jwtToken});
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
        throw const ServerException('User is NULL');
      }
      response['username'] = username;
      response['password'] = password;
      return User.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout({required String jwtToken}) async {
    try {
      await _apiService.postData(
        endPoint: ApiEndpoints.logout,
        jwtToken: jwtToken,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<User> getUser({required String jwtToken}) async {
    try {
      final response = await _apiService.fetchData(
        endPoint: ApiEndpoints.getUser,
        jwtToken: jwtToken,
      );
      response['jwt_token'] = jwtToken;
      return User.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
