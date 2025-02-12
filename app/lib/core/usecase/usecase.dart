import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

abstract interface class UseCase<SucessType, Param> {
  Future<Either<Failure, SucessType>> call(Param param);
}

class NoParams {
  const NoParams();
}
