// Represents the optional data used to update an existing pantry item.
class PantryItemUpdateRequest {
  final String? ingredient;
  final double? quantity;
  final String? unit;

  // Allows users to provide only the fields they want to update.
  const PantryItemUpdateRequest({
    this.ingredient,
    this.quantity,
    this.unit,
  });

  // Converts the request into JSON, including only non-null fields.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (ingredient != null) json['ingredient'] = ingredient;
    if (quantity != null) json['quantity'] = quantity;
    if (unit != null) json['unit'] = unit;
    return json;
  }
}