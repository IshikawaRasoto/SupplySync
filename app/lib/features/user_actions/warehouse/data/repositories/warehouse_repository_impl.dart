import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/error/server_failure.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/entities/warehouse_product.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../models/warehouse_product_model.dart';
import '../remote_source/warehouse_remote_data_source.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseRemoteDataSource remoteDataSource;

  WarehouseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Warehouse>>> getWarehouses(
      String jwtToken) async {
    try {
      final warehouses = await remoteDataSource.getWarehouses(jwtToken);
      return Right(warehouses);
    } catch (e) {
      return Left(ServerFailure('Failed to get warehouses'));
    }
  }

  @override
  Future<Either<Failure, List<WarehouseProduct>>> getWarehouseProducts({
    required String jwtToken,
    required String warehouseId,
  }) async {
    try {
      final products = await remoteDataSource.getWarehouseProducts(
        jwtToken: jwtToken,
        warehouseId: warehouseId,
      );
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Failed to get warehouse products'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required WarehouseProduct product,
  }) async {
    try {
      await remoteDataSource.updateWarehouseProduct(
        jwtToken: jwtToken,
        warehouseId: warehouseId,
        product: WarehouseProductModel(
          id: product.id,
          productId: product.productId,
          name: product.name,
          description: product.description,
          quantity: product.quantity,
          unit: product.unit,
        ),
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Failed to update product'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required WarehouseProduct product,
  }) async {
    try {
      await remoteDataSource.addWarehouseProduct(
        jwtToken: jwtToken,
        warehouseId: warehouseId,
        product: WarehouseProductModel(
          id: product.id,
          productId: product.productId,
          name: product.name,
          description: product.description,
          quantity: product.quantity,
          unit: product.unit,
        ),
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Failed to add product'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required String productId,
  }) async {
    try {
      await remoteDataSource.removeWarehouseProduct(
        jwtToken: jwtToken,
        warehouseId: warehouseId,
        productId: productId,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Failed to remove product'));
    }
  }
}
