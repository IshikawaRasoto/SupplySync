import 'package:fpdart/fpdart.dart';
import '../entities/warehouse.dart';
import '../entities/warehouse_product.dart';
import '../../../../../core/error/failure.dart';

abstract class WarehouseRepository {
  Future<Either<Failure, List<Warehouse>>> getWarehouses(String jwtToken);
  Future<Either<Failure, List<WarehouseProduct>>> getWarehouseProducts({
    required String jwtToken,
    required String warehouseId,
  });
  Future<Either<Failure, Unit>> updateWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required WarehouseProduct product,
  });
  Future<Either<Failure, Unit>> addWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required WarehouseProduct product,
  });
  Future<Either<Failure, Unit>> removeWarehouseProduct({
    required String jwtToken,
    required String warehouseId,
    required String productId,
  });
}
