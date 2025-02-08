import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../../../../../features/cart/domain/usecases/get_cart_details.dart';

part 'drone_details_event.dart';
part 'drone_details_state.dart';

class DroneDetailsBloc extends Bloc<DroneDetailsEvent, DroneDetailsState> {
  final UserCubit _userCubit;
  final GetCartDetails _getCartDetails;
  XFile? dronePhoto;

  DroneDetailsBloc({
    required UserCubit userCubit,
    required GetCartDetails getCartDetails,
  })  : _userCubit = userCubit,
        _getCartDetails = getCartDetails,
        super(DroneDetailsInitial()) {
    on<LoadDroneDetails>(_onLoadDroneDetails);
    on<ConfirmDroneArrival>(_onConfirmDroneArrival);
    on<CaptureDronePhoto>(_onCaptureDronePhoto);
    on<ReleaseDrone>(_onReleaseDrone);
  }

  bool get hasPhoto => dronePhoto != null;

  Future<void> _onLoadDroneDetails(
    LoadDroneDetails event,
    Emitter<DroneDetailsState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(DroneDetailsFailure('Usuário não autenticado'));
      return;
    }

    emit(DroneDetailsLoading());

    final result = await _getCartDetails(GetCartDetailsParams(
      jwtToken: currentUser.jwtToken,
      id: event.droneId,
    ));

    result.fold(
      (failure) => emit(DroneDetailsFailure(failure.message)),
      (cart) => emit(DroneDetailsLoaded(cart)),
    );
  }

  Future<void> _onConfirmDroneArrival(
    ConfirmDroneArrival event,
    Emitter<DroneDetailsState> emit,
  ) async {
    // TODO: Implement API call to confirm drone arrival
    await Future.delayed(const Duration(seconds: 1));
    emit(DroneDetailsArrivalConfirmed());
  }

  Future<void> _onCaptureDronePhoto(
    CaptureDronePhoto event,
    Emitter<DroneDetailsState> emit,
  ) async {
    dronePhoto = event.photo;
    // TODO: Implement API call to upload photo
    await Future.delayed(const Duration(seconds: 1));
    emit(DroneDetailsPhotoTaken());
  }

  Future<void> _onReleaseDrone(
    ReleaseDrone event,
    Emitter<DroneDetailsState> emit,
  ) async {
    if (!hasPhoto) {
      emit(DroneDetailsFailure('É necessário tirar uma foto do drone vazio'));
      return;
    }

    // TODO: Implement API call to release drone
    await Future.delayed(const Duration(seconds: 1));
    emit(DroneDetailsReleased());
  }
}
