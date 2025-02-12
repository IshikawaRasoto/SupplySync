import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/warehouse_transport_repository.dart';

class UploadDronePhotoParams {
  final String jwtToken;
  final String droneId;
  final XFile photo;

  UploadDronePhotoParams({
    required this.jwtToken,
    required this.droneId,
    required this.photo,
  });
}

class UploadDronePhoto implements UseCase<void, UploadDronePhotoParams> {
  final WarehouseTransportRepository repository;

  UploadDronePhoto(this.repository);

  @override
  Future<Either<Failure, void>> call(UploadDronePhotoParams params) async {
    return await repository.uploadDronePhoto(
      jwtToken: params.jwtToken,
      droneId: params.droneId,
      photo: params.photo,
    );
  }
}
