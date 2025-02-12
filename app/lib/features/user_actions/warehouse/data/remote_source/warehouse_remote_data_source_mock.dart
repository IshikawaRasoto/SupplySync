import '../../../../../core/error/server_exception.dart';
import '../models/warehouse_model.dart';
import '../models/warehouse_product_model.dart';
import 'warehouse_remote_data_source.dart';

class WarehouseRemoteDataSourceImplMock implements WarehouseRemoteDataSource {
  WarehouseRemoteDataSourceImplMock();

  final List<WarehouseModel> _mockWarehouses = [
    WarehouseModel(
      id: 1,
      name: 'Warehouse 2',
    ),
    WarehouseModel(
      id: 2,
      name: 'Warehouse 3',
    ),
    WarehouseModel(
      id: 3,
      name: 'South Storage',
    ),
  ];

  final Map<String, List<WarehouseProductModel>> _mockWarehouseProducts = {
    '1': [
      WarehouseProductModel(
        id: 1,
        name: 'Steel Pipes',
        description: 'Steel Pipes 1 inch',
        quantity: 100,
        unit: 'pcs',
      ),
      WarehouseProductModel(
        id: 2,
        name: 'Copper Wire',
        description: 'Copper Wire 1mm',
        quantity: 200,
        unit: 'm',
      ),
      WarehouseProductModel(
        id: 3,
        name: 'Safety Helmets',
        description: 'Safety Helmets Yellow',
        quantity: 50,
        unit: 'pcs',
      ),
    ],
    '2': [
      WarehouseProductModel(
        id: 4,
        name: 'Steel Pipes',
        description: 'Steel Pipes 1 inch',
        quantity: 100,
        unit: 'pcs',
      ),
      WarehouseProductModel(
        id: 5,
        name: 'Copper Wire',
        description: 'Copper Wire 1mm',
        quantity: 200,
        unit: 'm',
      ),
      WarehouseProductModel(
        id: 6,
        name: 'Safety Helmets',
        description: 'Safety Helmets Yellow',
        quantity: 50,
        unit: 'pcs',
      ),
    ],
    '3': [
      WarehouseProductModel(
        id: 7,
        name: 'Steel Pipes',
        description: 'Steel Pipes 1 inch',
        quantity: 100,
        unit: 'pcs',
      ),
      WarehouseProductModel(
        id: 8,
        name: 'Copper Wire',
        description: 'Copper Wire 1mm',
        quantity: 200,
        unit: 'm',
      ),
      WarehouseProductModel(
        id: 9,
        name: 'Safety Helmets',
        description: 'Safety Helmets Yellow',
        quantity: 50,
        unit: 'pcs',
      ),
    ],
  };

  @override
  Future<List<WarehouseModel>> getWarehouses(
    String jwtToken,
  ) async {
    try {
      return _mockWarehouses;
    } catch (e) {
      throw ServerException('Failed to get warehouses');
    }
  }

  @override
  Future<List<WarehouseProductModel>> getWarehouseProducts(
      {required String jwtToken, required String warehouseId}) async {
    try {
      if (!_mockWarehouseProducts.containsKey(warehouseId)) {
        throw ServerException('Warehouse not found');
      }
      return _mockWarehouseProducts[warehouseId] ?? [];
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
      if (!_mockWarehouseProducts.containsKey(warehouseId)) {
        throw ServerException('Warehouse not found');
      }
      _mockWarehouseProducts[warehouseId]!.add(product);
    } catch (e) {
      throw ServerException('Failed to add product');
    }
  }

  @override
  Future<void> removeWarehouseProduct(
      {required String jwtToken,
      required String warehouseId,
      required int productId}) async {
    try {
      if (!_mockWarehouseProducts.containsKey(warehouseId)) {
        throw ServerException('Warehouse not found');
      }
      _mockWarehouseProducts[warehouseId]!
          .removeWhere((product) => product.id == productId);
    } catch (e) {
      throw ServerException('Failed to remove product');
    }
  }

  @override
  Future<void> updateWarehouseProduct(
      {required String jwtToken,
      required String warehouseId,
      required WarehouseProductModel product}) async {
    try {
      if (!_mockWarehouseProducts.containsKey(warehouseId)) {
        throw ServerException('Warehouse not found');
      }
      final index = _mockWarehouseProducts[warehouseId]!
          .indexWhere((element) => element.id == product.id);
      if (index == -1) {
        throw ServerException('Product not found');
      }
      _mockWarehouseProducts[warehouseId]![index] = product;
    } catch (e) {
      throw ServerException('Failed to update product');
    }
  }
}
