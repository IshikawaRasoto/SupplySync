import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/dock_transport_repository.dart';

class UploadCartPhotoParams {
  final String jwtToken;
  final String cartId;
  final XFile photo;

  UploadCartPhotoParams({
    required this.jwtToken,
    required this.cartId,
    required this.photo,
  });
}

class UploadCartPhoto implements UseCase<void, UploadCartPhotoParams> {
  final DockTransportRepository repository;

  UploadCartPhoto(this.repository);

  @override
  Future<Either<Failure, void>> call(UploadCartPhotoParams params) async {
    return await repository.uploadCartPhoto(
      jwtToken: params.jwtToken,
      cartId: params.cartId,
      photo: params.photo,
    );
  }
}
