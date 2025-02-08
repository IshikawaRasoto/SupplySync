import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../features/cart/domain/entities/cart.dart';

part 'warehouse_transport_event.dart';
part 'warehouse_transport_state.dart';

class WarehouseTransportBloc
    extends Bloc<WarehouseTransportEvent, WarehouseTransportState> {
  final UserCubit _userCubit;

  WarehouseTransportBloc({
    required UserCubit userCubit,
  })  : _userCubit = userCubit,
        super(const WarehouseTransportInitial()) {
    on<FetchIncomingDrones>(_onFetchIncomingDrones);
  }

  Future<void> _onFetchIncomingDrones(
    FetchIncomingDrones event,
    Emitter<WarehouseTransportState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehouseTransportFailure(error: 'Usuário não autenticado'));
      return;
    }
    emit(const WarehouseTransportLoading());
    // TODO: Implement API call to fetch incoming drones
    await Future.delayed(const Duration(seconds: 1));
    final mockDrones = [
      Cart(
        id: '1',
        battery: '85%',
        destination: 'Warehouse A',
        load: 'Medical Supplies',
      ),
      Cart(
        id: '2',
        battery: '92%',
        destination: 'Warehouse A',
        load: 'Emergency Supplies',
      ),
    ];

    emit(WarehouseTransportSuccess(incomingDrones: mockDrones));
  }
}
