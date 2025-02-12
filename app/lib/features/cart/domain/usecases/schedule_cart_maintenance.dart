import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class ScheduleCartMaintenance
    implements UseCase<Unit, ScheduleCartMaintenanceParams> {
  final CartRepository repository;

  ScheduleCartMaintenance(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
      ScheduleCartMaintenanceParams parms) async {
    return await repository.requestCartMaintenance(
      jwtToken: parms.jwtToken,
      id: parms.id,
    );
  }
}

class ScheduleCartMaintenanceParams {
  final String id;
  final String jwtToken;

  ScheduleCartMaintenanceParams({
    required this.id,
    required this.jwtToken,
  });
}
