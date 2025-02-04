import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_source/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Cart>>> getAllCarts() async {
    try {
      final carts = await remoteDataSource.getAllCarts();
      return right(carts);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> getCartDetails(String id) async {
    try {
      final cart = await remoteDataSource.getCartDetails(id);
      return right(cart);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestCartUse(String id) async {
    try {
      await remoteDataSource.requestCartUse(id);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestShutdown(String id) async {
    try {
      await remoteDataSource.requestShutdown(id);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestCartMaintenance(String id) async {
    try {
      await remoteDataSource.requestCartMaintenance(id);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
