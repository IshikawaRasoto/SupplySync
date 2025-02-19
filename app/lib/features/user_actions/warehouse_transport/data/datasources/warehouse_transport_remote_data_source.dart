import 'package:image_picker/image_picker.dart';
import 'package:supplysync/core/data/api_service.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/server_exception.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../models/cart_model.dart';

abstract class WarehouseTransportRemoteDataSource {
  Future<List<Cart>> fetchIncomingDrones({
    required String jwtToken,
    required int warehouseId,
  });

  Future<void> uploadDronePhoto({
    required String jwtToken,
    required String droneId,
    required XFile photo,
  });
}

class WarehouseTransportRemoteDataSourceImpl
    implements WarehouseTransportRemoteDataSource {
  final ApiService apiService;
  WarehouseTransportRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Cart>> fetchIncomingDrones({
    required String jwtToken,
    required int warehouseId,
  }) async {
    try {
      final response = await apiService.getData(
        endPoint: ApiEndpoints.fetchIncomingDrones,
        pathParams: {
          'warehouseId': warehouseId.toString(),
        },
        jwtToken: jwtToken,
      );
      if (response['carts'] == null || response['carts'].isEmpty) {
        return [];
      }
      final List<dynamic> carts = response['carts'];
      return carts
          .map((json) => CartModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch incoming drones: ${e.toString()}');
    }
  }

  @override
  Future<void> uploadDronePhoto({
    required String jwtToken,
    required String droneId,
    required XFile photo,
  }) async {
    try {
      await apiService.sendImage(
        endPoint: ApiEndpoints.uploadDronePhoto,
        jwtToken: jwtToken,
        image: photo,
        pathParams: {
          'cartId': droneId,
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upload drone photo: ${e.toString()}');
    }
  }
}
