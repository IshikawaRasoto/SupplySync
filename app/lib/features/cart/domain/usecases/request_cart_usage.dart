import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class RequestCartUsage implements UseCase<Unit, String> {
  final CartRepository repository;

  RequestCartUsage(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.requestCartUse(id);
  }
}
