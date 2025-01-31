import '../../../core/api/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../models/target_user.dart';
import '../models/target_user_update_model.dart';

abstract interface class UserActionsRemoteDataSource {
  Future<void> updateUserProfile({
    required String jwtToken,
    required TargetUserUpdateModel targetUser,
  });

  Future<TargetUser> getUserByUserName({
    required String jwtToken,
    required String userName,
  });
}

class UserActionsRemoteDataSourceImpl implements UserActionsRemoteDataSource {
  final ApiService _apiService;

  UserActionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<void> updateUserProfile({
    required String jwtToken,
    required TargetUserUpdateModel targetUser,
  }) async {
    final data = targetUser.toJson();
    await _apiService.updateData(
      endPoint: ApiEndpoints.update_login,
      jwtToken: jwtToken,
      body: data,
    );
  }

  @override
  Future<TargetUser> getUserByUserName(
      {required String jwtToken, required String userName}) async {
    try {
      final response = await _apiService.fetchData(
        endPoint: ApiEndpoints.get_user,
        jwtToken: jwtToken,
        pathParams: {'userName': userName},
      );
      return TargetUser.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
