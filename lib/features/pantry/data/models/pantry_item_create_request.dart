// Represents the data required when creating a new pantry item.
class PantryItemCreateRequest {
  final String ingredient;
  final double quantity;
  final String unit;

  // Requires all necessary information to create a pantry item.
  const PantryItemCreateRequest({
    required this.ingredient,
    required this.quantity,
    required this.unit,
  });

  // Converts the request object into JSON for the backend API.
  Map<String, dynamic> toJson() {
    return {
      'ingredient': ingredient,
      'quantity': quantity,
      'unit': unit,
    };
  }
}