import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class ReleaseDroneParams {
  final String jwtToken;
  final String droneId;

  ReleaseDroneParams({
    required this.jwtToken,
    required this.droneId,
  });
}

class ReleaseDrone implements UseCase<void, ReleaseDroneParams> {
  final CartRepository repository;

  ReleaseDrone(this.repository);

  @override
  Future<Either<Failure, void>> call(ReleaseDroneParams params) async {
    return await repository.releaseDrone(
      jwtToken: params.jwtToken,
      droneId: params.droneId,
    );
  }
}
