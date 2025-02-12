import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../domain/usecases/get_warehouses.dart';
import 'warehouses_event.dart';
import 'warehouses_state.dart';

class WarehousesBloc extends Bloc<WarehousesEvent, WarehousesState> {
  final GetWarehouses _getWarehouses;
  final UserCubit _userCubit;

  WarehousesBloc({
    required GetWarehouses getWarehouses,
    required UserCubit userCubit,
  })  : _getWarehouses = getWarehouses,
        _userCubit = userCubit,
        super(const WarehousesInitial()) {
    on<GetWarehousesEvent>(_onGetWarehouses);
    on<RefreshWarehousesEvent>(_onRefreshWarehouses);
  }

  Future<void> _onGetWarehouses(
    GetWarehousesEvent event,
    Emitter<WarehousesState> emit,
  ) async {
    emit(const WarehousesLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehousesError('User not authenticated'));
      return;
    }
    final result = await _getWarehouses(currentUser.jwtToken);

    result.fold(
      (failure) => emit(WarehousesError(failure.message)),
      (warehouses) => emit(WarehousesLoaded(warehouses)),
    );
  }

  Future<void> _onRefreshWarehouses(
    RefreshWarehousesEvent event,
    Emitter<WarehousesState> emit,
  ) async {
    emit(const WarehousesLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehousesError('User not authenticated'));
      return;
    }
    final result = await _getWarehouses(currentUser.jwtToken);
    result.fold(
      (failure) => emit(WarehousesError(failure.message)),
      (warehouses) => emit(WarehousesLoaded(warehouses)),
    );
  }
}
