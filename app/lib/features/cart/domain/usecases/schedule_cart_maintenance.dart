import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class ScheduleCartMaintenance implements UseCase<Unit, String> {
  final CartRepository repository;

  ScheduleCartMaintenance(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.requestCartMaintenance(id);
  }
}
