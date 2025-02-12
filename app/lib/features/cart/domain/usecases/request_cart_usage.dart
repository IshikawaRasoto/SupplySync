import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class RequestCartUsage implements UseCase<Unit, RequestCartUsageParams> {
  final CartRepository repository;

  RequestCartUsage(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RequestCartUsageParams param) async {
    return await repository.requestCartUse(
      jwtToken: param.jwtToken,
      id: param.id,
    );
  }
}

class RequestCartUsageParams {
  final String jwtToken;
  final String id;

  RequestCartUsageParams({
    required this.jwtToken,
    required this.id,
  });
}
