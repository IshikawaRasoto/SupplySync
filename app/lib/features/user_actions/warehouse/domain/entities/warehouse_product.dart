class WarehouseProduct {
  final String id;
  final String productId;
  final String name;
  final String description;
  final int quantity;
  final String unit;

  WarehouseProduct({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
  });

  WarehouseProduct copyWith({
    String? id,
    String? productId,
    String? name,
    String? description,
    int? quantity,
    String? unit,
  }) {
    return WarehouseProduct(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
