import '../../../../../features/cart/domain/entities/cart.dart';

class CartModel extends Cart {
  CartModel({
    required super.id,
    required super.battery,
    super.destination = '',
    super.origin = '',
    super.load = '',
    super.status = 'Free',
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      battery: json['battery'] as String,
      destination: json['destination'] as String,
      origin: json['origin'] as String,
      load: json['load'] as String,
      status: json['status'] as String,
    );
  }
}
