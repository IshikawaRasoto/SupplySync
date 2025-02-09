sealed class WarehousesEvent {
  const WarehousesEvent();
}

class GetWarehousesEvent extends WarehousesEvent {
  const GetWarehousesEvent();
}

class RefreshWarehousesEvent extends WarehousesEvent {
  const RefreshWarehousesEvent();
}
