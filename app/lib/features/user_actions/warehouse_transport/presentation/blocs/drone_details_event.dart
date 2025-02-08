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
  final String droneId;

  CaptureDronePhoto({required this.photo, required this.droneId});
}

class ReleaseDroneEvent extends DroneDetailsEvent {
  final String droneId;

  ReleaseDroneEvent({required this.droneId});
}
