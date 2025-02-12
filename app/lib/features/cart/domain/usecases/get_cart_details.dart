import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartDetails implements UseCase<Cart, GetCartDetailsParams> {
  final CartRepository repository;

  GetCartDetails(this.repository);

  @override
  Future<Either<Failure, Cart>> call(GetCartDetailsParams params) async {
    return await repository.getCartDetails(
      jwtToken: params.jwtToken,
      id: params.id,
    );
  }
}

class GetCartDetailsParams {
  final String id;
  final String jwtToken;

  GetCartDetailsParams({
    required this.id,
    required this.jwtToken,
  });
}
