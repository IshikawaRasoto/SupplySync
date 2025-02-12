import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/server_failure.dart';
import '../../../../../core/error/server_exception.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../../domain/repositories/warehouse_transport_repository.dart';
import '../datasources/warehouse_transport_remote_data_source.dart';

class WarehouseTransportRepositoryImpl implements WarehouseTransportRepository {
  final WarehouseTransportRemoteDataSource remoteDataSource;

  WarehouseTransportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Cart>>> fetchIncomingDrones({
    required String jwtToken,
    required int warehouseId,
  }) async {
    try {
      final drones = await remoteDataSource.fetchIncomingDrones(
        jwtToken: jwtToken,
        warehouseId: warehouseId,
      );
      return Right(drones);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadDronePhoto({
    required String jwtToken,
    required String droneId,
    required XFile photo,
  }) async {
    try {
      await remoteDataSource.uploadDronePhoto(
        jwtToken: jwtToken,
        droneId: droneId,
        photo: photo,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('Failed to upload drone photo: ${e.toString()}'));
    }
  }
}
