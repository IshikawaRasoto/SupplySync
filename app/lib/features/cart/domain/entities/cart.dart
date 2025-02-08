class Cart {
  final String id;
  final String battery;
  final String? destination;
  final String? load;

  Cart({
    required this.id,
    required this.battery,
    this.destination,
    this.load,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String,
      battery: json['battery'] as String,
      destination: json['destination'] as String?,
      load: json['load'] as String?,
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
