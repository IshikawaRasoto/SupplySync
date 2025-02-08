import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failure.dart';

abstract class DockTransportRepository {
  Future<Either<Failure, void>> uploadCartPhoto({
    required String jwtToken,
    required String cartId,
    required XFile photo,
  });
}
