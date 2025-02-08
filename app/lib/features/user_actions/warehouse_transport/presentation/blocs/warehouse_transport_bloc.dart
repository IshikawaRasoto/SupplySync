import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../../domain/usecases/fetch_incoming_drones.dart';

part 'warehouse_transport_event.dart';
part 'warehouse_transport_state.dart';

class WarehouseTransportBloc
    extends Bloc<WarehouseTransportEvent, WarehouseTransportState> {
  final UserCubit _userCubit;
  final FetchIncomingDrones _fetchIncomingDrones;

  WarehouseTransportBloc({
    required UserCubit userCubit,
    required FetchIncomingDrones fetchIncomingDrones,
  })  : _userCubit = userCubit,
        _fetchIncomingDrones = fetchIncomingDrones,
        super(const WarehouseTransportInitial()) {
    on<FetchIncomingDronesEvent>(_onFetchIncomingDrones);
  }

  Future<void> _onFetchIncomingDrones(
    FetchIncomingDronesEvent event,
    Emitter<WarehouseTransportState> emit,
  ) async {
    final token = _userCubit.getToken();
    if (token == null) {
      emit(const WarehouseTransportFailure(error: 'User not authenticated'));
      return;
    }

    emit(const WarehouseTransportLoading());

    final result = await _fetchIncomingDrones(
      FetchIncomingDronesParams(
        jwtToken: token,
        location: event.location,
      ),
    );

    result.fold(
      (failure) => emit(WarehouseTransportFailure(error: failure.message)),
      (drones) => emit(WarehouseTransportSuccess(incomingDrones: drones)),
    );
  }
}
