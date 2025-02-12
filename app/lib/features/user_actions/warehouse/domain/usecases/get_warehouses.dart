import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/warehouse.dart';
import '../repositories/warehouse_repository.dart';

class GetWarehouses implements UseCase<List<Warehouse>, String> {
  final WarehouseRepository repository;

  GetWarehouses(
    this.repository,
  );

  @override
  Future<Either<Failure, List<Warehouse>>> call(String jwtToken) async {
    return await repository.getWarehouses(
      jwtToken,
    );
  }
}
