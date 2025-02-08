import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../../features/cart/domain/entities/cart.dart';
import '../../../../../features/cart/domain/usecases/get_cart_details.dart';
import '../../domain/usecases/upload_drone_photo.dart';
import '../../../../cart/domain/usecases/release_drone.dart';

part 'drone_details_event.dart';
part 'drone_details_state.dart';

class DroneDetailsBloc extends Bloc<DroneDetailsEvent, DroneDetailsState> {
  final UserCubit _userCubit;
  final GetCartDetails _getCartDetails;
  final UploadDronePhoto _uploadDronePhoto;
  final ReleaseDrone _releaseDrone;
  XFile? dronePhoto;

  DroneDetailsBloc({
    required UserCubit userCubit,
    required GetCartDetails getCartDetails,
    required UploadDronePhoto uploadDronePhoto,
    required ReleaseDrone releaseDrone,
  })  : _userCubit = userCubit,
        _getCartDetails = getCartDetails,
        _uploadDronePhoto = uploadDronePhoto,
        _releaseDrone = releaseDrone,
        super(DroneDetailsInitial()) {
    on<LoadDroneDetails>(_onLoadDroneDetails);
    on<ConfirmDroneArrival>(_onConfirmDroneArrival);
    on<CaptureDronePhoto>(_onCaptureDronePhoto);
    on<ReleaseDroneEvent>(_onReleaseDrone);
  }

  bool get hasPhoto => dronePhoto != null;

  Future<void> _onLoadDroneDetails(
    LoadDroneDetails event,
    Emitter<DroneDetailsState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(DroneDetailsFailure('User not authenticated'));
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
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(DroneDetailsFailure('User not authenticated'));
      return;
    }

    emit(DroneDetailsLoading());

    final result = await _uploadDronePhoto(UploadDronePhotoParams(
      jwtToken: currentUser.jwtToken,
      droneId: event.droneId,
      photo: event.photo,
    ));

    result.fold(
      (failure) => emit(DroneDetailsFailure(failure.message)),
      (_) {
        dronePhoto = event.photo;
        emit(DroneDetailsPhotoTaken());
      },
    );
  }

  Future<void> _onReleaseDrone(
    ReleaseDroneEvent event,
    Emitter<DroneDetailsState> emit,
  ) async {
    if (!hasPhoto) {
      emit(DroneDetailsFailure('A photo of the empty drone is required'));
      return;
    }

    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(DroneDetailsFailure('User not authenticated'));
      return;
    }

    emit(DroneDetailsLoading());

    final result = await _releaseDrone(ReleaseDroneParams(
      jwtToken: currentUser.jwtToken,
      droneId: event.droneId,
    ));

    result.fold(
      (failure) => emit(DroneDetailsFailure(failure.message)),
      (_) => emit(DroneDetailsReleased()),
    );
  }
}
