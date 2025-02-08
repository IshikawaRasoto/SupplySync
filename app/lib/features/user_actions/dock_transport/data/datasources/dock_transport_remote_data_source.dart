import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/data/api_service.dart';
import '../../../../../core/error/server_exception.dart';

abstract class DockTransportRemoteDataSource {
  Future<void> uploadCartPhoto({
    required String jwtToken,
    required String cartId,
    required XFile photo,
  });
}

class DockTransportRemoteDataSourceImpl
    implements DockTransportRemoteDataSource {
  final ApiService apiService;

  DockTransportRemoteDataSourceImpl({required this.apiService});

  @override
  Future<void> uploadCartPhoto({
    required String jwtToken,
    required String cartId,
    required XFile photo,
  }) async {
    try {
      await apiService.sendImage(
        endPoint: ApiEndpoints.uploadDronePhoto,
        jwtToken: jwtToken,
        image: photo,
        pathParams: {
          'cartId': cartId,
        },
      );
      return;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upload cart photo: ${e.toString()}');
    }
  }
}
