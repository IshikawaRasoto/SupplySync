import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/server_exception.dart';
import 'dock_transport_remote_data_source.dart';

class DockTransportRemoteDataSourceImplMock
    implements DockTransportRemoteDataSource {
  DockTransportRemoteDataSourceImplMock();

  @override
  Future<void> uploadCartPhoto({
    required String jwtToken,
    required String cartId,
    required XFile photo,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upload cart photo: ${e.toString()}');
    }
  }
}
