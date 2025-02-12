import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class ShutdownCart implements UseCase<Unit, ShutdownCartParams> {
  final CartRepository repository;

  ShutdownCart(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ShutdownCartParams params) async {
    return await repository.requestShutdown(
      jwtToken: params.jwtToken,
      id: params.id,
    );
  }
}

class ShutdownCartParams {
  final String jwtToken;
  final String id;

  ShutdownCartParams({
    required this.jwtToken,
    required this.id,
  });
}
