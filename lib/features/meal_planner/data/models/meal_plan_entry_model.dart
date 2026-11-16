import 'package:meal_recommendation_app/core/utils/date_utils.dart';

// Represents basic meal information included in a meal plan entry.
class MealPlanMealSummaryModel {
  final String id;
  final String name;
  final double estimatedCost;
  final String? imageUrl;

  const MealPlanMealSummaryModel({
    required this.id,
    required this.name,
    required this.estimatedCost,
    this.imageUrl,
  });

  // Converts meal summary JSON data into a Dart model.
  factory MealPlanMealSummaryModel.fromJson(Map<String, dynamic> json) {
    return MealPlanMealSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      estimatedCost: _parseDecimal(json['estimated_cost']),
      imageUrl: json['image_url'] as String?,
    );
  }

  // Converts a numeric value or numeric string into double.
  static double _parseDecimal(dynamic value) {
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Unexpected estimated_cost type: ${value.runtimeType}');
  }

  // Converts the meal summary model into JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'estimated_cost': estimatedCost,
      'image_url': imageUrl,
    };
  }

  // Compares meal summary objects based on their field values.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlanMealSummaryModel &&
        other.id == id &&
        other.name == name &&
        other.estimatedCost == estimatedCost &&
        other.imageUrl == imageUrl;
  }

  // Generates a hash code using the same fields used in equality comparison.
  @override
  int get hashCode => Object.hash(id, name, estimatedCost, imageUrl);
}

// Represents an individual meal scheduled on a specific date.
class MealPlanEntryModel {
  final String id;
  final MealPlanMealSummaryModel meal;
  final DateTime plannedDate;
  final String? mealSlot;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MealPlanEntryModel({
    required this.id,
    required this.meal,
    required this.plannedDate,
    this.mealSlot,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converts meal plan entry JSON data into a Dart model.
  factory MealPlanEntryModel.fromJson(Map<String, dynamic> json) {
    return MealPlanEntryModel(
      id: json['id'] as String,
      meal: MealPlanMealSummaryModel.fromJson(
        json['meal'] as Map<String, dynamic>,
      ),
      plannedDate: DateTime.parse(json['planned_date'] as String),
      mealSlot: json['meal_slot'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Converts the meal plan entry model into JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal': meal.toJson(),
      'planned_date': formatDate(plannedDate),
      'meal_slot': mealSlot,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'MealPlanEntryModel(id: $id, meal: ${meal.name}, '
      'plannedDate: $plannedDate, mealSlot: $mealSlot)';

  // Compares meal plan entries based on all their field values.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlanEntryModel &&
        other.id == id &&
        other.meal == meal &&
        other.plannedDate == plannedDate &&
        other.mealSlot == mealSlot &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  // Generates a hash code using the same fields used in equality comparison.
  @override
  int get hashCode =>
      Object.hash(id, meal, plannedDate, mealSlot, createdAt, updatedAt);
}

// Represents the complete weekly meal plan and its scheduled entries.
class WeeklyPlanModel {
  final DateTime startDate;
  final DateTime endDate;
  final List<MealPlanEntryModel> entries;
  final double estimatedCostTotal;

  const WeeklyPlanModel({
    required this.startDate,
    required this.endDate,
    required this.entries,
    required this.estimatedCostTotal,
  });

  // Converts the weekly meal plan JSON response into a Dart model.
  factory WeeklyPlanModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanModel(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => MealPlanEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      estimatedCostTotal: _parseDecimal(json['estimated_cost_total']),
    );
  }

  // Converts the total estimated cost into a double.
  static double _parseDecimal(dynamic value) {
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException(
      'Unexpected estimated_cost_total type: ${value.runtimeType}',
    );
  }

  // Groups meal plan entries by their calendar date, ignoring the time.
  Map<DateTime, List<MealPlanEntryModel>> get entriesByDay {
    final map = <DateTime, List<MealPlanEntryModel>>{};
    for (final entry in entries) {
      final day = DateTime(
        entry.plannedDate.year,
        entry.plannedDate.month,
        entry.plannedDate.day,
      );
      map.putIfAbsent(day, () => []).add(entry);
    }
    return map;
  }
}

