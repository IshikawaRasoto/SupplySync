import 'package:supplysync/core/common/cubit/user/user_cubit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/data/api_service.dart';
import '../../../../core/error/conversion_exception.dart';
import '../../../../core/error/server_exception.dart';
import '../../domain/entities/cart.dart';

abstract interface class CartRemoteDataSource {
  Future<List<Cart>> getAllCarts();
  Future<Cart> getCartDetails(String id);
  Future<void> requestCartUse(String id);
  Future<void> requestShutdown(String id);
  Future<void> requestCartMaintenance(String id);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;
  final UserCubit userCubit;

  CartRemoteDataSourceImpl(this.apiService, this.userCubit);

  @override
  Future<List<Cart>> getAllCarts() async {
    try {
      final token = (userCubit.state as UserLoggedIn).user.jwtToken;
      final response = await apiService.fetchData(
        endPoint: ApiEndpoints.carts,
        jwtToken: token,
      );
      return (response['data'] as List)
          .map((json) => Cart.fromJson(json))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<Cart> getCartDetails(String id) async {
    try {
      final token = (userCubit.state as UserLoggedIn).user.jwtToken;
      final response = await apiService.fetchData(
        endPoint: ApiEndpoints.cartDetails,
        jwtToken: token,
        pathParams: {'id': id},
      );
      return Cart.fromJson(response['data']);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<void> requestCartUse(String id) async {
    try {
      final token = (userCubit.state as UserLoggedIn).user.jwtToken;
      await apiService.postData(
        endPoint: ApiEndpoints.cartUse,
        jwtToken: token,
        pathParams: {'id': id},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<void> requestShutdown(String id) async {
    try {
      final token = (userCubit.state as UserLoggedIn).user.jwtToken;
      await apiService.postData(
        endPoint: ApiEndpoints.cartShutdown,
        jwtToken: token,
        pathParams: {'id': id},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }

  @override
  Future<void> requestCartMaintenance(String id) async {
    try {
      final token = (userCubit.state as UserLoggedIn).user.jwtToken;
      await apiService.postData(
        endPoint: ApiEndpoints.cartMaintenance,
        jwtToken: token,
        pathParams: {'id': id},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ConversionException(e.toString());
    }
  }
}
