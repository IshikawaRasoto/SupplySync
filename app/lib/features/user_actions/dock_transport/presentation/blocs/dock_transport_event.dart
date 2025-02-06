part of 'dock_transport_bloc.dart';

@immutable
sealed class DockTransportEvent {}

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
