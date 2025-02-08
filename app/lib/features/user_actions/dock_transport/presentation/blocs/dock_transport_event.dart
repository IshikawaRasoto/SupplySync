part of 'dock_transport_bloc.dart';

@immutable
sealed class DockTransportEvent {}

class ScanItemQRCodeEvent extends DockTransportEvent {
  final String rawValue;
  ScanItemQRCodeEvent({required this.rawValue});
}

class ScanLocationQRCodeEvent extends DockTransportEvent {
  final String rawValue;
  ScanLocationQRCodeEvent({required this.rawValue});
}

class UpdateLocationManuallyEvent extends DockTransportEvent {
  final String location;
  UpdateLocationManuallyEvent({required this.location});
}

class UpdateDestinationEvent extends DockTransportEvent {
  final String destination;
  UpdateDestinationEvent({required this.destination});
}

class ResetTransportEvent extends DockTransportEvent {}

class DockTransportRequested extends DockTransportEvent {
  final String item;
  final int quantity;
  final String origin;
  final String destination;

  DockTransportRequested({
    required this.item,
    required this.quantity,
    required this.origin,
    required this.destination,
  });
}
