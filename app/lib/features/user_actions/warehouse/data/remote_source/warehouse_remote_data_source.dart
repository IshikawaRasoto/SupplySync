import 'package:supplysync/core/data/api_service.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/server_exception.dart';
import '../models/warehouse_model.dart';
import '../models/warehouse_product_model.dart';

abstract interface class WarehouseRemoteDataSource {
  Future<List<WarehouseModel>> getWarehouses(String jwtToken);
  Future<List<WarehouseProductModel>> getWarehouseProducts({
    required String jwtToken,
    required String warehouseId,
  });
  Future<void> updateWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required WarehouseProductModel product,
  });
  Future<void> addWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required WarehouseProductModel product,
  });
  Future<void> removeWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required String productId,
  });
}

class WarehouseRemoteDataSourceImpl implements WarehouseRemoteDataSource {
  final ApiService apiService;
  WarehouseRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<WarehouseModel>> getWarehouses(
    String jwtToken,
  ) async {
    try {
      final response = await apiService.getData(
        endPoint: ApiEndpoints.warehouses,
        jwtToken: '',
      );
      final List<dynamic> warehousesJson = response['data'];
      return warehousesJson
          .map((json) => WarehouseModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<WarehouseProductModel>> getWarehouseProducts(
      {required String jwtToken, required String warehouseId}) async {
    try {
      final response = await apiService.getData(
        endPoint: ApiEndpoints.warehouseProducts,
        jwtToken: '',
        pathParams: {'warehouseId': warehouseId},
      );
      final List<dynamic> productsJson = response['data'];
      return productsJson
          .map((json) => WarehouseProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> addWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required WarehouseProductModel product,
  }) async {
    try {
      await apiService.postData(
        endPoint: ApiEndpoints.warehouseProducts,
        jwtToken: '',
        body: product.toJson(),
        pathParams: {'warehouseId': warehouseId},
      );
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> removeWarehouseProduct(
      {required String jwtToken,
      required String warehouseId,
      required String productId}) async {
    try {
      await apiService.deleteData(
        endPoint: ApiEndpoints.warehouseProducts,
        jwtToken: '',
        body: {'productId': productId},
        pathParams: {'warehouseId': warehouseId},
      );
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateWarehouseProduct(
      {required String jwtToken,
      required String warehouseId,
      required WarehouseProductModel product}) async {
    try {
      await apiService.updateData(
        endPoint: ApiEndpoints.warehouseProducts,
        jwtToken: '',
        body: product.toJson(),
        pathParams: {'warehouseId': warehouseId},
      );
    } catch (e) {
      throw ServerException();
    }
  }
}
