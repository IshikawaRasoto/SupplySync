import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/server_exception.dart';
import '../../../../../core/error/server_failure.dart';
import '../../domain/repositories/dock_transport_repository.dart';
import '../datasources/dock_transport_remote_data_source.dart';

class DockTransportRepositoryImpl implements DockTransportRepository {
  final DockTransportRemoteDataSource remoteDataSource;

  DockTransportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> uploadCartPhoto({
    required String jwtToken,
    required String cartId,
    required XFile photo,
  }) async {
    try {
      await remoteDataSource.uploadCartPhoto(
        jwtToken: jwtToken,
        cartId: cartId,
        photo: photo,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
