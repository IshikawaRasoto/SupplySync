import '../../../../core/error/server_exception.dart';
import '../../domain/entities/cart.dart';
import '../models/cart_request_model.dart';
import 'cart_remote_data_source.dart';

class CartRemoteDataSourceImplMock implements CartRemoteDataSource {
  CartRemoteDataSourceImplMock();

  final List<Cart> _mockCarts = [
    Cart(
      id: '1',
      battery: '100',
      destination: 'Warehouse 1',
      load: 'Steel Pipes',
      status: 'Free',
    ),
    Cart(
      id: '2',
      battery: '50',
      destination: 'Warehouse 2',
      load: 'Copper Wire',
      status: 'Free',
    ),
    Cart(
      id: '3',
      battery: '75',
      destination: 'Warehouse 3',
      load: 'Safety Helmets',
      status: 'In Use',
    ),
    Cart(
      id: '4',
      battery: '25',
      destination: 'Warehouse 4',
      load: 'Safety Shoes',
      status: 'In Use',
    ),
  ];

  @override
  Future<List<Cart>> getAllCarts(String jwtToken) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockCarts;
  }

  @override
  Future<Cart> getCartDetails({
    required String jwtToken,
    required String id,
  }) async {
    try {
      return _mockCarts.firstWhere((element) => element.id == id);
    } catch (e) {
      throw ServerException('Cart not found');
    }
  }

  @override
  Future<void> requestCartUse({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (id as int > _mockCarts.length) {
        throw ServerException('Cart not found');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to request cart use');
    }
  }

  @override
  Future<String> requestAnyCartUse({
    required String jwtToken,
    required CartRequestModel cartRequest,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return '1';
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to request cart use');
    }
  }

  @override
  Future<void> requestShutdown({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (id as int > _mockCarts.length) {
        throw ServerException('Cart not found');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to request shutdown');
    }
  }

  @override
  Future<void> requestCartMaintenance({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (id as int > _mockCarts.length) {
        throw ServerException('Cart not found');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to request maintenance');
    }
  }

  @override
  Future<void> releaseDrone({
    required String jwtToken,
    required String droneId,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to release drone');
    }
  }
}
