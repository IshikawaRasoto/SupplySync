import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/warehouse_product.dart';
import '../repositories/warehouse_repository.dart';

class UpdateWarehouseProductParams {
  final String jwtToken;
  final String warehouseId;
  final WarehouseProduct product;

  const UpdateWarehouseProductParams({
    required this.jwtToken,
    required this.warehouseId,
    required this.product,
  });
}

class UpdateWarehouseProduct
    implements UseCase<Unit, UpdateWarehouseProductParams> {
  final WarehouseRepository repository;

  UpdateWarehouseProduct(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
      UpdateWarehouseProductParams params) async {
    return await repository.updateWarehouseProduct(
      jwtToken: params.jwtToken,
      warehouseId: params.warehouseId,
      product: params.product,
    );
  }
}
