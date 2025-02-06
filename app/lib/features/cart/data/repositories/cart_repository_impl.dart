import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_source/cart_remote_data_source.dart';
import '../models/cart_request_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Cart>>> getAllCarts(String jwtToken) async {
    try {
      final carts = await remoteDataSource.getAllCarts(jwtToken);
      return right(carts);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> getCartDetails({
    required String jwtToken,
    required String id,
  }) async {
    try {
      final cart = await remoteDataSource.getCartDetails(
        jwtToken: jwtToken,
        id: id,
      );
      return right(cart);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestCartUse({
    required String jwtToken,
    required String load,
    required String loadQuantity,
    required String destination,
    required String origin,
  }) async {
    try {
      await remoteDataSource.requestCartUse(
        jwtToken: jwtToken,
        cartRequest: CartRequestModel(
          load: load,
          loadQuantity: loadQuantity,
          destination: destination,
          origin: origin,
        ),
      );
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestShutdown({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await remoteDataSource.requestShutdown(
        jwtToken: jwtToken,
        id: id,
      );
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestCartMaintenance({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await remoteDataSource.requestCartMaintenance(
        jwtToken: jwtToken,
        id: id,
      );
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
