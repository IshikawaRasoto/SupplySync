import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartDetails implements UseCase<Cart, String> {
  final CartRepository repository;

  GetCartDetails(this.repository);

  @override
  Future<Either<Failure, Cart>> call(String id) async {
    return await repository.getCartDetails(id);
  }
}
