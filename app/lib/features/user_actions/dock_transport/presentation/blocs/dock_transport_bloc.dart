import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../cart/domain/usecases/request_any_cart_usage.dart';

part 'dock_transport_event.dart';
part 'dock_transport_state.dart';

class DockTransportBloc extends Bloc<DockTransportEvent, DockTransportState> {
  final UserCubit _userCubit;
  final RequestAnyCartUsage _requestCartUsage;

  DockTransportBloc({
    required UserCubit userCubit,
    required RequestAnyCartUsage requestCartUsage,
  })  : _userCubit = userCubit,
        _requestCartUsage = requestCartUsage,
        super(const DockTransportInitial()) {
    on<ScanItemQRCodeEvent>(_onItemQRCodeScanned);
    on<ScanLocationQRCodeEvent>(_onLocationQRCodeScanned);
    on<UpdateLocationManuallyEvent>(_onLocationManuallyUpdated);
    on<UpdateDestinationEvent>(_onDestinationUpdated);
    on<DockTransportRequested>(_dockTransportRequested);
    on<ResetTransportEvent>(_onResetTransport);
    on<ResetTransportLocationEvent>(_onResetTransportLocation);
    on<ResetTransportItemEvent>(_onResetTransportItem);
  }

  void _onItemQRCodeScanned(
    ScanItemQRCodeEvent event,
    Emitter<DockTransportState> emit,
  ) {
    if (!state.hasLocation) {
      _emitFailure(emit, 'Selecione um local antes de escanear o item');
      return;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(event.rawValue);
      if (data['item'] == null ||
          data['quantity'] == null ||
          data['item'].isEmpty ||
          (data['quantity'] as int) <= 0) {
        _emitFailure(emit, 'QR Code do item inválido');
        return;
      }
      emit(DockTransportInProgress(
        item: data['item'] as String,
        quantity: data['quantity'] as int,
        location: state.location,
        destination: data['destination'] as String?,
      ));
    } catch (e) {
      _emitFailure(emit, 'QR Code do item inválido: ${e.toString()}');
    }
  }

  void _onLocationQRCodeScanned(
    ScanLocationQRCodeEvent event,
    Emitter<DockTransportState> emit,
  ) {
    try {
      final Map<String, dynamic> data = jsonDecode(event.rawValue);
      if (data['location'] == null || data['location'].isEmpty) {
        _emitFailure(emit, 'QR Code do local inválido');
        return;
      }
      emit(DockTransportInProgress(
        item: state.item,
        quantity: state.quantity,
        location: data['location'] as String,
        destination: state.destination,
      ));
    } catch (e) {
      _emitFailure(emit, 'QR Code do local inválido: ${e.toString()}');
    }
  }

  void _onLocationManuallyUpdated(
    UpdateLocationManuallyEvent event,
    Emitter<DockTransportState> emit,
  ) {
    emit(DockTransportInProgress(
      item: state.item,
      quantity: state.quantity,
      location: event.location,
      destination: state.destination,
    ));
  }

  void _onDestinationUpdated(
    UpdateDestinationEvent event,
    Emitter<DockTransportState> emit,
  ) {
    emit(DockTransportInProgress(
      item: state.item,
      quantity: state.quantity,
      location: state.location,
      destination: event.destination,
    ));
  }

  void _onResetTransport(
    ResetTransportEvent event,
    Emitter<DockTransportState> emit,
  ) {
    emit(DockTransportLoading(
      item: null,
      quantity: null,
      location: null,
      destination: null,
    ));
    emit(const DockTransportInitial());
  }

  void _onResetTransportLocation(
    ResetTransportLocationEvent event,
    Emitter<DockTransportState> emit,
  ) {
    emit(DockTransportLoading(
      item: state.item,
      quantity: state.quantity,
      location: null,
      destination: state.destination,
    ));
  }

  void _onResetTransportItem(
    ResetTransportItemEvent event,
    Emitter<DockTransportState> emit,
  ) {
    emit(DockTransportLoading(
      item: null,
      quantity: null,
      location: state.location,
      destination: state.destination,
    ));
  }

  Future<void> _dockTransportRequested(
    DockTransportRequested event,
    Emitter<DockTransportState> emit,
  ) async {
    if (!state.hasAllInfo) {
      emit(DockTransportFailure('Preencha todas as informações'));
      return;
    }

    emit(DockTransportLoading(
      item: state.item,
      quantity: state.quantity,
      location: state.location,
      destination: state.destination,
    ));

    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      _emitFailure(emit, 'Usuário não autenticado');
      return;
    }

    try {
      final result = await _requestCartUsage(RequestAnyCartUsageParams(
        jwtToken: currentUser.jwtToken,
        load: event.item,
        loadQuantity: event.quantity.toString(),
        destination: event.destination,
        origin: event.origin,
      ));

      result.fold(
        (failure) => _emitFailure(emit, failure.message),
        (cartId) => emit(DockTransportSuccess(cartId)),
      );
    } catch (e) {
      _emitFailure(emit, e.toString());
    }
  }

  void _emitFailure(Emitter<DockTransportState> emit, String error) {
    emit(DockTransportFailure(error,
        item: state.item,
        quantity: state.quantity,
        location: state.location,
        destination: state.destination));
  }
}
