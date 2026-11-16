import 'package:meal_recommendation_app/core/utils/ingredient_display.dart';

// Represents one grocery list item and provides helpers for parsing and displaying its values.
class GroceryListItemModel {
  final String ingredient;
  final String unit;
  final double requiredQuantity;
  final double pantryQuantity;
  final double quantityToBuy;
  final double? estimatedCost;

  const GroceryListItemModel({
    required this.ingredient,
    required this.unit,
    required this.requiredQuantity,
    required this.pantryQuantity,
    required this.quantityToBuy,
    this.estimatedCost,
  });

  // Converts grocery item JSON data into a GroceryListItemModel object.
  factory GroceryListItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryListItemModel(
      ingredient: json['ingredient'] as String,
      unit: json['unit'] as String,
      requiredQuantity: _parseDecimal(json['required_quantity']),
      pantryQuantity: _parseDecimal(json['pantry_quantity']),
      quantityToBuy: _parseDecimal(json['quantity_to_buy']),
      estimatedCost: _parseNullableDecimal(json['estimated_cost']),
    );
  }

  // Converts numeric values from either String or num into double.
  static double _parseDecimal(dynamic value) {
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Unexpected quantity type: ${value.runtimeType}');
  }

  // Converts a numeric value into double while allowing null.
  static double? _parseNullableDecimal(dynamic value) {
    if (value == null) return null;
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Unexpected quantity type: ${value.runtimeType}');
  }

  // Removes unnecessary trailing zeros when displaying quantities.
  static String _trim(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  // Converts the ingredient name into a user-friendly display format.
  // Keep the original ingredient value for API calls and comparisons.
  String get displayName => formatIngredientName(ingredient);

  // Provides formatted quantity values for display.
  String get displayQuantityToBuy => _trim(quantityToBuy);
  String get displayRequiredQuantity => _trim(requiredQuantity);
  String get displayPantryQuantity => _trim(pantryQuantity);

  // Formats the estimated cost as Philippine pesos with two decimal places.
  String? get displayEstimatedCost {
    if (estimatedCost == null) return null;
    return '₱${estimatedCost!.toStringAsFixed(2)}';
  }

  // Checks whether the ingredient is completely absent from the pantry.
  bool get hasNoneInPantry => pantryQuantity == 0;

 
  @override
  String toString() =>
      'GroceryListItemModel(ingredient: $ingredient, quantityToBuy: '
      '$quantityToBuy $unit, estimatedCost: $estimatedCost)';

  // Compares grocery items based on all their field values.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroceryListItemModel &&
        other.ingredient == ingredient &&
        other.unit == unit &&
        other.requiredQuantity == requiredQuantity &&
        other.pantryQuantity == pantryQuantity &&
        other.quantityToBuy == quantityToBuy &&
        other.estimatedCost == estimatedCost;
  }

  // Generates a hash code using the same fields used in equality comparison.
  @override
  int get hashCode => Object.hash(
        ingredient,
        unit,
        requiredQuantity,
        pantryQuantity,
        quantityToBuy,
        estimatedCost,
      );
}

// Represents the complete grocery list response returned by the backend.
class GroceryListResponseModel {
  final DateTime startDate;
  final DateTime endDate;
  final List<GroceryListItemModel> items;
  final double? totalEstimatedCost;

  const GroceryListResponseModel({
    required this.startDate,
    required this.endDate,
    required this.items,
    this.totalEstimatedCost,
  });

  // Converts the complete grocery list JSON response into a Dart model.
  factory GroceryListResponseModel.fromJson(Map<String, dynamic> json) {
    return GroceryListResponseModel(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => GroceryListItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalEstimatedCost: GroceryListItemModel._parseNullableDecimal(
        json['total_estimated_cost'],
      ),
    );
  }

  // Formats the total estimated cost as Philippine pesos.
  // Returns null when the backend does not provide a total cost.
  String? get displayTotalEstimatedCost {
    if (totalEstimatedCost == null) return null;
    return '₱${totalEstimatedCost!.toStringAsFixed(2)}';
  }
}