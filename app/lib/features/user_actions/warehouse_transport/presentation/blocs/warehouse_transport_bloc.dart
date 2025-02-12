import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../../../warehouse/domain/entities/warehouse.dart';
import '../../../warehouse/domain/usecases/get_warehouses.dart';
import '../../domain/usecases/fetch_incoming_drones.dart';

part 'warehouse_transport_event.dart';
part 'warehouse_transport_state.dart';

class WarehouseTransportBloc
    extends Bloc<WarehouseTransportEvent, WarehouseTransportState> {
  final UserCubit _userCubit;
  final FetchIncomingDrones _fetchIncomingDrones;
  final GetWarehouses _getWarehouses;

  WarehouseTransportBloc({
    required UserCubit userCubit,
    required FetchIncomingDrones fetchIncomingDrones,
    required GetWarehouses getWarehouses,
  })  : _userCubit = userCubit,
        _fetchIncomingDrones = fetchIncomingDrones,
        _getWarehouses = getWarehouses,
        super(const WarehouseTransportInitial()) {
    on<FetchWarehousesEvent>(_onFetchWarehouses);
    on<FetchIncomingDronesEvent>(_onFetchIncomingDrones);
  }

  Future<void> _onFetchWarehouses(
    FetchWarehousesEvent event,
    Emitter<WarehouseTransportState> emit,
  ) async {
    final token = _userCubit.getToken();
    if (token == null) {
      emit(const WarehouseTransportFailure(error: 'User not authenticated'));
      return;
    }

    emit(const WarehouseTransportLoading());

    final result = await _getWarehouses(token);

    result.fold(
      (failure) => emit(WarehouseTransportFailure(error: failure.message)),
      (warehouses) {
        emit(WarehouseTransportSuccess(
          incomingDrones: const [],
          warehouses: warehouses,
        ));
      },
    );
  }

  Future<void> _onFetchIncomingDrones(
    FetchIncomingDronesEvent event,
    Emitter<WarehouseTransportState> emit,
  ) async {
    final List<Warehouse> warehouses = state is WarehouseTransportSuccess
        ? (state as WarehouseTransportSuccess).warehouses
        : [];
    final token = _userCubit.getToken();
    if (token == null) {
      emit(const WarehouseTransportFailure(error: 'User not authenticated'));
      return;
    }

    emit(const WarehouseTransportLoading());

    final result = await _fetchIncomingDrones(
      FetchIncomingDronesParams(
        jwtToken: token,
        warehouseId: event.warehouseId,
      ),
    );

    result.fold(
      (failure) => emit(WarehouseTransportFailure(error: failure.message)),
      (drones) {
        emit(WarehouseTransportSuccess(
          incomingDrones: drones,
          warehouses: warehouses,
        ));
      },
    );
  }
}
