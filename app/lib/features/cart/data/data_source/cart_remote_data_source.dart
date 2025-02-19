import '../../../../core/constants/api_constants.dart';
import '../../../../core/data/api_service.dart';
import '../../../../core/error/conversion_exception.dart';
import '../../../../core/error/server_exception.dart';
import '../../domain/entities/cart.dart';
import '../models/cart_request_model.dart';

abstract interface class CartRemoteDataSource {
  Future<List<Cart>> getAllCarts(String jwtToken);
  Future<Cart> getCartDetails({
    required String jwtToken,
    required String id,
  });
  Future<void> requestCartUse({
    required String jwtToken,
    required String id,
  });
  Future<String> requestAnyCartUse({
    required String jwtToken,
    required CartRequestModel cartRequest,
  });
  Future<void> requestShutdown({
    required String jwtToken,
    required String id,
  });
  Future<void> requestCartMaintenance({
    required String jwtToken,
    required String id,
  });
  Future<void> releaseDrone({
    required String jwtToken,
    required String droneId,
  });
  Future<void> reportProblem({
    required String jwtToken,
    required String cartId,
    required String problemDescription,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;

  CartRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<Cart>> getAllCarts(String jwtToken) async {
    try {
      final response = await apiService.getData(
        endPoint: ApiEndpoints.getCarts,
        jwtToken: jwtToken,
      );
      return (response['carts'] as List)
          .map((json) => Cart.fromJson(json))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<Cart> getCartDetails({
    required String jwtToken,
    required String id,
  }) async {
    try {
      final response = await apiService.getData(
        endPoint: ApiEndpoints.cartDetails,
        jwtToken: jwtToken,
        pathParams: {'cartId': id},
      );
      return Cart.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<void> requestCartUse({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await apiService.postData(
        endPoint: ApiEndpoints.cartUse,
        jwtToken: jwtToken,
        body: {'id': id},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<String> requestAnyCartUse({
    required String jwtToken,
    required CartRequestModel cartRequest,
  }) async {
    try {
      final response = await apiService.postData(
        endPoint: ApiEndpoints.cartRequest,
        jwtToken: jwtToken,
        body: cartRequest.toJson(),
      );
      if (response['id'] is! String) {
        throw ConversionException('Failed to convert response to string');
      }
      return response['id'] as String;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<void> requestShutdown({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await apiService.postData(
        endPoint: ApiEndpoints.cartShutdown,
        jwtToken: jwtToken,
        pathParams: {'cartId': id},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<void> requestCartMaintenance({
    required String jwtToken,
    required String id,
  }) async {
    try {
      await apiService.postData(
        endPoint: ApiEndpoints.cartMaintenance,
        jwtToken: jwtToken,
        pathParams: {'cartId': id},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<void> releaseDrone({
    required String jwtToken,
    required String droneId,
  }) async {
    try {
      await apiService.postData(
        endPoint: ApiEndpoints.releaseDrone,
        jwtToken: jwtToken,
        pathParams: {
          'cartId': droneId,
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to release drone: ${e.toString()}');
    }
  }

  @override
  Future<void> reportProblem({
    required String jwtToken,
    required String cartId,
    required String problemDescription,
  }) async {
    try {
      await apiService.postData(
        endPoint: ApiEndpoints.cartProblem,
        jwtToken: jwtToken,
        pathParams: {'cartId': cartId},
        body: {
          'problem': problemDescription,
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }
}
