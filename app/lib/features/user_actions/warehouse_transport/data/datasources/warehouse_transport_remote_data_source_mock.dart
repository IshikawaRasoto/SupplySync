import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/server_exception.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../models/cart_model.dart';
import 'warehouse_transport_remote_data_source.dart';

class WarehouseTransportRemoteDataSourceImplMock
    implements WarehouseTransportRemoteDataSource {
  WarehouseTransportRemoteDataSourceImplMock();

  // Mock data
  final List<Cart> _incomingDrones = [
    CartModel(
      id: '1',
      battery: '100',
      destination: 'Warehouse 2',
      load: 'Steel Pipes',
      status: 'Free',
    ),
    CartModel(
      id: '2',
      battery: '65',
      destination: 'Warehouse 3',
      load: 'Copper Wire',
      status: 'In Use',
    ),
    CartModel(
      id: '3',
      battery: '25',
      destination: 'Warehouse 2',
      load: 'Safety Helmets',
      status: 'Free',
    ),
  ];

  @override
  Future<List<Cart>> fetchIncomingDrones({
    required String jwtToken,
    required int warehouseId,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      List<Cart> incomingDrones = [];
      for (final drone in _incomingDrones) {
        if (drone.id == warehouseId.toString()) {
          incomingDrones.add(drone);
        }
      }
      if (incomingDrones.isEmpty) {
        throw ServerException('Location not found');
      }
      return incomingDrones;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch incoming drones: ${e.toString()}');
    }
  }

  @override
  Future<void> uploadDronePhoto({
    required String jwtToken,
    required String droneId,
    required XFile photo,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
