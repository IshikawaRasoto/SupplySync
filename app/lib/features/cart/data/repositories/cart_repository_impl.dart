import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/error/server_exception.dart';
import '../../../../core/error/conversion_exception.dart';
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
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
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
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestCartUse({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await remoteDataSource.requestCartUse(
        jwtToken: jwtToken,
        id: id,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> requestAnyCartUse({
    required String jwtToken,
    required String load,
    required String loadQuantity,
    required String destination,
    required String origin,
  }) async {
    try {
      final cartId = await remoteDataSource.requestAnyCartUse(
        jwtToken: jwtToken,
        cartRequest: CartRequestModel(
          load: load,
          loadQuantity: loadQuantity,
          destination: destination,
          origin: origin,
        ),
      );
      return right(cartId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
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
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
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
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> releaseDrone({
    required String jwtToken,
    required String droneId,
  }) async {
    try {
      await remoteDataSource.releaseDrone(
        jwtToken: jwtToken,
        droneId: droneId,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> reportProblem({
    required String jwtToken,
    required String cartId,
    required String problemDescription,
  }) async {
    try {
      remoteDataSource.reportProblem(
          jwtToken: jwtToken,
          cartId: cartId,
          problemDescription: problemDescription);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on ConversionException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
