import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../cart/domain/usecases/request_cart_usage.dart';

part 'dock_transport_event.dart';
part 'dock_transport_state.dart';

class DockTransportBloc extends Bloc<DockTransportEvent, DockTransportState> {
  final UserCubit _userCubit;
  final RequestCartUsage _requestCartUsage;

  DockTransportBloc({
    required UserCubit userCubit,
    required RequestCartUsage requestCartUsage,
  })  : _userCubit = userCubit,
        _requestCartUsage = requestCartUsage,
        super(DockTransportInitial()) {
    on<DockTransportRequested>(_onQRCodeTransportRequested);
  }

  Future<void> _onQRCodeTransportRequested(
      DockTransportRequested event, Emitter<DockTransportState> emit) async {
    emit(DockTransportLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(DockTransportFailure('User not authenticated'));
      return;
    }
    _requestCartUsage(RequestCartUsageParams(
      jwtToken: currentUser.jwtToken,
      load: event.item,
      loadQuantity: event.quantity.toString(),
      destination: event.destination,
      origin: event.origin,
    ));
    // Simulate processing with a delay
    await Future.delayed(Duration(seconds: 2));
    // Return success with mock data
    emit(DockTransportSuccess());
  }
}
