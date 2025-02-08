part of 'drone_details_bloc.dart';

@immutable
abstract class DroneDetailsState {}

class DroneDetailsInitial extends DroneDetailsState {}

class DroneDetailsLoading extends DroneDetailsState {}

class DroneDetailsLoaded extends DroneDetailsState {
  final Cart cart;

  DroneDetailsLoaded(this.cart);
}

class DroneDetailsFailure extends DroneDetailsState {
  final String message;

  DroneDetailsFailure(this.message);
}

class DroneDetailsArrivalConfirmed extends DroneDetailsState {}

class DroneDetailsPhotoTaken extends DroneDetailsState {}

class DroneDetailsReleased extends DroneDetailsState {}
