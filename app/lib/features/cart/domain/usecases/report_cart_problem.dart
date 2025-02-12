import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class ReportCartProblem implements UseCase<Unit, ReportCartProblemParams> {
  final CartRepository repository;

  ReportCartProblem(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ReportCartProblemParams params) async {
    return await repository.reportProblem(
      jwtToken: params.jwtToken,
      cartId: params.cartId,
      problemDescription: params.problemDescription,
    );
  }
}

class ReportCartProblemParams {
  final String jwtToken;
  final String cartId;
  final String problemDescription;

  ReportCartProblemParams({
    required this.jwtToken,
    required this.cartId,
    required this.problemDescription,
  });
}
