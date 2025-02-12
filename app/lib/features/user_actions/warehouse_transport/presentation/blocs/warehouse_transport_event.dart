part of 'warehouse_transport_bloc.dart';

@immutable
sealed class WarehouseTransportEvent {
  const WarehouseTransportEvent();
}

class FetchWarehousesEvent extends WarehouseTransportEvent {
  const FetchWarehousesEvent();
}

class FetchIncomingDronesEvent extends WarehouseTransportEvent {
  final int warehouseId;

  const FetchIncomingDronesEvent({required this.warehouseId});
}
