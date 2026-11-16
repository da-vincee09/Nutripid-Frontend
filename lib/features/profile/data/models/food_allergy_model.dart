// Represents one food allergy recorded by the user.
class FoodAllergyModel {
  final String id;
  final String allergy;

  // Creates an immutable FoodAllergyModel object.
  const FoodAllergyModel({
    required this.id, 
    required this.allergy
  });

  // Converts backend JSON data into a FoodAllergyModel object.
  factory FoodAllergyModel.fromJson(Map<String, dynamic> json) {
    return FoodAllergyModel(
      id: json['id'] as String, 
      allergy: json['allergy'] as String,
    );
  }

  // Converts the model into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allergy': allergy,
    };
  }

  // Creates a copy with selected properties changed.
  FoodAllergyModel copyWith({
    String? id,
    String? allergy,
  }) {
    return FoodAllergyModel(
      id: id ?? this.id, 
      allergy: allergy ?? this.allergy,
    );
  }

  // Returns a readable string representation of the object.
  @override
  String toString() => 'FoodAllergyModel(id: $id, allergy: $allergy)';

  // Checks whether two objects have the same ID and allergy.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodAllergyModel &&
    other.id == id &&
    other.allergy == allergy;
  }

  // Generates a hash code based on the ID and allergy.
  @override
  int get hashCode => Object.hash(id, allergy);
}