import '../../domain/entities/warehouse_product.dart';

class WarehouseProductModel extends WarehouseProduct {
  WarehouseProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.quantity,
    required super.unit,
  });

  factory WarehouseProductModel.fromJson(Map<String, dynamic> json) {
    return WarehouseProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unit': unit,
    };
  }
}
