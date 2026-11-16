import 'package:meal_recommendation_app/core/utils/ingredient_display.dart';

// Represents a pantry item and its information received from the backend.
class PantryItemModel {
  final String id;
  final String ingredient;
  final double quantity;
  final String unit;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Initializes a pantry item with all required properties.
  const PantryItemModel({
    required this.id,
    required this.ingredient,
    required this.quantity,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converts backend JSON data into a PantryItemModel object.
  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['id'] as String,
      ingredient: json['ingredient'] as String,
      quantity: _parseDecimal(json['quantity']),
      unit: json['unit'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Handles quantity values returned as either String or num.
  static double _parseDecimal(dynamic value) {
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Unexpected quantity type: ${value.runtimeType}');
  }

  // Converts the pantry item object into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredient': ingredient,
      'quantity': quantity,
      'unit': unit,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Creates a copy of the pantry item with selected properties changed.
  PantryItemModel copyWith({
    String? id,
    String? ingredient,
    double? quantity,
    String? unit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PantryItemModel(
      id: id ?? this.id,
      ingredient: ingredient ?? this.ingredient,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Formats whole-number quantities without unnecessary decimal zeros.
  String get displayQuantity {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }
    return quantity.toString();
  }

  // Converts the ingredient name into a readable format for the UI.
  String get displayName => formatIngredientName(ingredient);

  // Provides a readable string representation for debugging.
  @override
  String toString() =>
      'PantryItemModel(id: $id, ingredient: $ingredient, '
      'quantity: $quantity, unit: $unit)';

  // Compares pantry items based on all their property values.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PantryItemModel &&
        other.id == id &&
        other.ingredient == ingredient &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  // Generates a hash code using the same properties used in equality.
  @override
  int get hashCode =>
      Object.hash(id, ingredient, quantity, unit, createdAt, updatedAt);
}