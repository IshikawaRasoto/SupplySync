import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/warehouse_product.dart';
import '../repositories/warehouse_repository.dart';

class GetWarehouseProductsParams {
  final String jwtToken;
  final String warehouseId;

  const GetWarehouseProductsParams({
    required this.jwtToken,
    required this.warehouseId,
  });
}

class GetWarehouseProducts
    implements UseCase<List<WarehouseProduct>, GetWarehouseProductsParams> {
  final WarehouseRepository repository;

  GetWarehouseProducts(this.repository);

  @override
  Future<Either<Failure, List<WarehouseProduct>>> call(
      GetWarehouseProductsParams params) async {
    return await repository.getWarehouseProducts(
      jwtToken: params.jwtToken,
      warehouseId: params.warehouseId,
    );
  }
}
