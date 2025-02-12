import '../../../domain/entities/warehouse_product.dart';

sealed class WarehouseProductsEvent {
  const WarehouseProductsEvent();
}

class GetWarehouseProductsEvent extends WarehouseProductsEvent {
  final String warehouseId;

  const GetWarehouseProductsEvent(this.warehouseId);
}

class RefreshWarehouseProductsEvent extends WarehouseProductsEvent {
  final String warehouseId;

  const RefreshWarehouseProductsEvent(this.warehouseId);
}

class UpdateWarehouseProductEvent extends WarehouseProductsEvent {
  final String warehouseId;
  final WarehouseProduct product;

  const UpdateWarehouseProductEvent({
    required this.warehouseId,
    required this.product,
  });
}

class AddWarehouseProductEvent extends WarehouseProductsEvent {
  final String warehouseId;
  final WarehouseProduct product;

  const AddWarehouseProductEvent({
    required this.warehouseId,
    required this.product,
  });
}

class RemoveWarehouseProductEvent extends WarehouseProductsEvent {
  final String warehouseId;
  final int productId;

  const RemoveWarehouseProductEvent({
    required this.warehouseId,
    required this.productId,
  });
}
