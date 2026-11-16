import 'package:meal_recommendation_app/core/utils/ingredient_display.dart';

// Represents an ingredient suggestion and its available measurement units.
class IngredientSuggestionModel {
  final String ingredient;
  final List<String> units;

  const IngredientSuggestionModel({
    required this.ingredient,
    required this.units,
  });

  // Converts the backend JSON response into an IngredientSuggestionModel.
  factory IngredientSuggestionModel.fromJson(Map<String, dynamic> json) {
    return IngredientSuggestionModel(
      ingredient: json['ingredient'] as String,
      units: (json['units'] as List<dynamic>).cast<String>(),
    );
  }

  // Checks whether the ingredient has exactly one available measurement unit.
  bool get hasSingleUnit => units.length == 1;

  // Converts the ingredient name into a user-friendly display format.
  String get displayName => formatIngredientName(ingredient);
}