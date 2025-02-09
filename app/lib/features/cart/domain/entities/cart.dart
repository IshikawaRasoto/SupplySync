class Cart {
  final String id;
  final String battery;
  final String? destination;
  final String? origin;
  final String? load;
  final String? status;

  Cart({
    required this.id,
    required this.battery,
    this.destination,
    this.origin,
    this.load,
    this.status,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String,
      battery: json['battery'] as String,
      destination: json['destination'] as String?,
      origin: json['origin'] as String?,
      load: json['load'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'battery': battery,
      'destination': destination,
      'origin': origin,
      'load': load,
      'status': status,
    };
  }
}
