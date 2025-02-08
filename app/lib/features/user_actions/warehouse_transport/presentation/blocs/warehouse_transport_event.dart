part of 'warehouse_transport_bloc.dart';

@immutable
sealed class WarehouseTransportEvent {
  const WarehouseTransportEvent();
}

class FetchIncomingDronesEvent extends WarehouseTransportEvent {
  final String location;

  const FetchIncomingDronesEvent({required this.location});
}
