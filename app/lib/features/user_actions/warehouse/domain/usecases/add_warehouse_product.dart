import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/warehouse_product.dart';
import '../repositories/warehouse_repository.dart';

class AddWarehouseProductParams {
  final String jwtToken;
  final String warehouseId;
  final WarehouseProduct product;

  const AddWarehouseProductParams({
    required this.jwtToken,
    required this.warehouseId,
    required this.product,
  });
}

class AddWarehouseProduct implements UseCase<Unit, AddWarehouseProductParams> {
  final WarehouseRepository repository;

  AddWarehouseProduct(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddWarehouseProductParams params) async {
    return await repository.addWarehouseProduct(
      jwtToken: params.jwtToken,
      warehouseId: params.warehouseId,
      product: params.product,
    );
  }
}
