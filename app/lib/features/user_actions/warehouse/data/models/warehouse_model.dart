import '../../domain/entities/warehouse.dart';

class WarehouseModel extends Warehouse {
  WarehouseModel({
    required super.id,
    required super.name,
    required super.location,
    required super.status,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'status': status,
    };
  }
}
