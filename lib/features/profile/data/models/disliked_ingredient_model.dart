import 'package:meal_recommendation_app/core/utils/ingredient_display.dart';

// Represents one ingredient that the user has marked as disliked.
class DislikedIngredientModel {
  final String id;
  final String ingredient;

  DislikedIngredientModel({
    required this.id, 
    required this.ingredient
  });

  // Converts backend JSON data into a DislikedIngredientModel object.
  factory DislikedIngredientModel.fromJson(Map<String, dynamic> json) {
    return DislikedIngredientModel(
      id: json['id'] as String, 
      ingredient: json['ingredient'] as String,
    );
  }

  // Converts the canonical ingredient name into a user-friendly display name.
  // Example: "soy_sauce" becomes "Soy Sauce".
  String get displayName => formatIngredientName(ingredient);

  // Converts the model into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredient': ingredient,
    };
  }

  // Creates a copy of the model with selected fields changed.
  DislikedIngredientModel copyWith({
    String? id,
    String? ingredient,
  }) {
    return DislikedIngredientModel(
      id: id ?? this.id, 
      ingredient: ingredient ?? this.ingredient,
    );
  }

  // Returns a readable string representation of the model.
  @override
  String toString() => 'DislikedIngredientModel(id: $id, ingredient: $ingredient)';
 
  // Checks whether two models have the same ID and ingredient.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DislikedIngredientModel &&
        other.id == id &&
        other.ingredient == ingredient;
  }
 
  // Generates a hash code based on the ID and ingredient.
  @override
  int get hashCode => Object.hash(id, ingredient);
  
}