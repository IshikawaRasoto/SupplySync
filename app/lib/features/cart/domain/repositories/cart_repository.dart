import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, List<Cart>>> getAllCarts();
  Future<Either<Failure, Cart>> getCartDetails(String id);
  Future<Either<Failure, Unit>> requestCartUse(String id);
  Future<Either<Failure, Unit>> requestShutdown(String id);
  Future<Either<Failure, Unit>> requestCartMaintenance(String id);
}
