import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../features/cart/domain/entities/cart.dart';

abstract class WarehouseTransportRepository {
  Future<Either<Failure, List<Cart>>> fetchIncomingDrones({
    required String jwtToken,
    required int warehouseId,
  });

  Future<Either<Failure, void>> uploadDronePhoto({
    required String jwtToken,
    required String droneId,
    required XFile photo,
  });
}
