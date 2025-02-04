import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/cart.dart';
import '../../domain/usecases/get_all_carts.dart';
import '../../domain/usecases/get_cart_details.dart';
import '../../domain/usecases/schedule_cart_maintenance.dart';
import '../../domain/usecases/request_cart_usage.dart';
import '../../domain/usecases/shutdown_cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final RequestCartUsage _requestCartUse;
  final ShutdownCart _requestShutdown;
  final ScheduleCartMaintenance _requestCartMaintenance;
  final GetCartDetails _getCartDetails;
  final GetAllCarts _getAllCarts;

  CartBloc({
    required RequestCartUsage requestCartUse,
    required ShutdownCart requestShutdown,
    required ScheduleCartMaintenance requestCartMaintenance,
    required GetCartDetails getCartDetails,
    required GetAllCarts getAllCarts,
  })  : _requestCartUse = requestCartUse,
        _requestCartMaintenance = requestCartMaintenance,
        _requestShutdown = requestShutdown,
        _getCartDetails = getCartDetails,
        _getAllCarts = getAllCarts,
        super(CartInitial()) {
    on<CartUseRequested>(_onRequestCart);
    on<CartShutdownRequested>(_onRequestShutdown);
    on<CartMaintenanceRequested>(_onRequestCartMaintenance);
    on<CartDetailsRequested>(_onGetCartDetails);
    on<CartLoadAllRequested>(_onGetAllCarts);
  }

  Future<void> _onRequestCart(
      CartUseRequested event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _requestCartUse(event.id);
    result.fold(
      (failure) => emit(CartRequestFailure(failure)),
      (_) => emit(CartRequestSuccess()),
    );
  }

  Future<void> _onRequestShutdown(
      CartShutdownRequested event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _requestShutdown(event.id);
    result.fold(
      (failure) => emit(CartRequestFailure(failure)),
      (_) => emit(CartRequestSuccess()),
    );
  }

  Future<void> _onRequestCartMaintenance(
      CartMaintenanceRequested event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _requestCartMaintenance(event.id);
    result.fold(
      (failure) => emit(CartRequestFailure(failure)),
      (_) => emit(CartRequestSuccess()),
    );
  }

  Future<void> _onGetCartDetails(
      CartDetailsRequested event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _getCartDetails(event.id);
    result.fold(
      (failure) => emit(CartRequestFailure(failure)),
      (cart) => emit(CartDetailsSuccess(cart)),
    );
  }

  Future<void> _onGetAllCarts(
      CartLoadAllRequested event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _getAllCarts(unit);
    result.fold(
      (failure) => emit(CartRequestFailure(failure)),
      (carts) => emit(AllCartsSuccess(carts)),
    );
  }
}
