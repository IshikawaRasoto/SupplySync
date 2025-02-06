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
      load: param.load,
      loadQuantity: param.loadQuantity,
      destination: param.destination,
      origin: param.origin,
    );
  }
}

class RequestCartUsageParams {
  final String jwtToken;
  final String load;
  final String loadQuantity;
  final String destination;
  final String origin;

  RequestCartUsageParams({
    required this.jwtToken,
    required this.load,
    required this.loadQuantity,
    required this.destination,
    required this.origin,
  });
}
