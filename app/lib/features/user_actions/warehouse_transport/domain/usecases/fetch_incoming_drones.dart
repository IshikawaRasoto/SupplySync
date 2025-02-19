import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../repositories/warehouse_transport_repository.dart';

class FetchIncomingDrones
    implements UseCase<List<Cart>, FetchIncomingDronesParams> {
  final WarehouseTransportRepository repository;

  FetchIncomingDrones(this.repository);

  @override
  Future<Either<Failure, List<Cart>>> call(
      FetchIncomingDronesParams params) async {
    return await repository.fetchIncomingDrones(
      jwtToken: params.jwtToken,
      warehouseId: params.warehouseId,
    );
  }
}

class FetchIncomingDronesParams {
  final String jwtToken;
  final int warehouseId;

  FetchIncomingDronesParams({
    required this.jwtToken,
    required this.warehouseId,
  });
}
