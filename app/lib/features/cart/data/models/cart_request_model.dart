class CartRequestModel {
  const CartRequestModel({
    required this.load,
    required this.loadQuantity,
    required this.destination,
    required this.origin,
  });

  final String destination;
  final String load;
  final String loadQuantity;
  final String origin;

  Map<String, String> toJson() => {
        'destination': destination,
        'load': load,
        'loadQuantity': loadQuantity,
        'origin': origin,
      };
}
