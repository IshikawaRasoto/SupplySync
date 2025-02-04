import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetAllCarts implements UseCase<List<Cart>, Unit> {
  final CartRepository repository;

  GetAllCarts(this.repository);

  @override
  Future<Either<Failure, List<Cart>>> call(Unit params) async {
    return await repository.getAllCarts();
  }
}
