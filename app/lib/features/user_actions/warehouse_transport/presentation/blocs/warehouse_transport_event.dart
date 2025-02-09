part of 'warehouse_transport_bloc.dart';

@immutable
sealed class WarehouseTransportEvent {
  const WarehouseTransportEvent();
}

class FetchWarehousesEvent extends WarehouseTransportEvent {
  const FetchWarehousesEvent();
}

class FetchIncomingDronesEvent extends WarehouseTransportEvent {
  final String location;

  const FetchIncomingDronesEvent({required this.location});
}
