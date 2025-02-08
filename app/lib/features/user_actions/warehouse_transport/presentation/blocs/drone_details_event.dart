part of 'drone_details_bloc.dart';

@immutable
abstract class DroneDetailsEvent {}

class LoadDroneDetails extends DroneDetailsEvent {
  final String droneId;

  LoadDroneDetails({required this.droneId});
}

class ConfirmDroneArrival extends DroneDetailsEvent {}

class CaptureDronePhoto extends DroneDetailsEvent {
  final XFile photo;

  CaptureDronePhoto({required this.photo});
}

class ReleaseDrone extends DroneDetailsEvent {}
