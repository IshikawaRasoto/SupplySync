import '../../domain/entities/warehouse_product.dart';

class WarehouseProductModel extends WarehouseProduct {
  WarehouseProductModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.description,
    required super.quantity,
    required super.unit,
  });

  factory WarehouseProductModel.fromJson(Map<String, dynamic> json) {
    return WarehouseProductModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unit': unit,
    };
  }
}
