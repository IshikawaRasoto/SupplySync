import '../../../../../features/cart/domain/entities/cart.dart';

class CartModel extends Cart {
  CartModel({
    required String id,
    required String battery,
    String? destination,
    String? load,
  }) : super(
          id: id,
          battery: battery,
          destination: destination,
          load: load,
        );

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'].toString(),
      battery: json['battery'].toString(),
      destination: json['destination'],
      load: json['load'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'battery': battery,
      'destination': destination,
      'load': load,
    };
  }
}
