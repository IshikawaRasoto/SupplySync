import '../../domain/entities/warehouse.dart';

class WarehouseModel extends Warehouse {
  WarehouseModel({
    required super.id,
    required super.name,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
