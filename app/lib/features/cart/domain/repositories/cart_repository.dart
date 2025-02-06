import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, List<Cart>>> getAllCarts(String jwtToken);
  Future<Either<Failure, Cart>> getCartDetails({
    required String jwtToken,
    required String id,
  });
  Future<Either<Failure, Unit>> requestCartUse({
    required String jwtToken,
    required String load,
    required String loadQuantity,
    required String destination,
    required String origin,
  });
  Future<Either<Failure, Unit>> requestShutdown({
    required String jwtToken,
    required String id,
  });
  Future<Either<Failure, Unit>> requestCartMaintenance({
    required String jwtToken,
    required String id,
  });
}
