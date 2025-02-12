import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/warehouse_repository.dart';

class RemoveWarehouseProductParams {
  final String jwtToken;
  final String warehouseId;
  final int productId;

  const RemoveWarehouseProductParams({
    required this.jwtToken,
    required this.warehouseId,
    required this.productId,
  });
}

class RemoveWarehouseProduct
    implements UseCase<Unit, RemoveWarehouseProductParams> {
  final WarehouseRepository repository;

  RemoveWarehouseProduct(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
      RemoveWarehouseProductParams params) async {
    return await repository.removeWarehouseProduct(
      jwtToken: params.jwtToken,
      warehouseId: params.warehouseId,
      productId: params.productId,
    );
  }
}
