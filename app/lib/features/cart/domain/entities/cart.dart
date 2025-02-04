class Cart {
  final String id;
  final String battery;
  final String? destination;
  final String? load;
  final String? attendance;

  Cart({
    required this.id,
    required this.battery,
    this.destination,
    this.load,
    this.attendance,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      battery: json['battery'],
      destination: json['destination'],
      load: json['load'],
      attendance: json['attendance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'battery': battery,
      'destination': destination,
      'load': load,
      'attendance': attendance,
    };
  }
}
