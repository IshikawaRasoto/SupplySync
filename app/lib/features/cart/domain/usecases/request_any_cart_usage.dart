import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class RequestAnyCartUsage
    implements UseCase<String, RequestAnyCartUsageParams> {
  final CartRepository repository;

  RequestAnyCartUsage(this.repository);

  @override
  Future<Either<Failure, String>> call(RequestAnyCartUsageParams param) async {
    return await repository.requestAnyCartUse(
      jwtToken: param.jwtToken,
      load: param.load,
      loadQuantity: param.loadQuantity,
      destination: param.destination,
      origin: param.origin,
    );
  }
}

class RequestAnyCartUsageParams {
  final String jwtToken;
  final String load;
  final String loadQuantity;
  final String destination;
  final String origin;

  RequestAnyCartUsageParams({
    required this.jwtToken,
    required this.load,
    required this.loadQuantity,
    required this.destination,
    required this.origin,
  });
}
