import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_model.dart';

// Converts a numeric value or numeric string into double.
double _parseDecimal(dynamic value, String field) {
  if (value is String) return double.parse(value);
  if (value is num) return value.toDouble();
  throw FormatException('Unexpected $field type: ${value.runtimeType}');
}

// One suggested meal in one day/slot of the draft plan.
class PlannedSlotModel {
  final DateTime plannedDate;
  final String mealSlot;
  final MealPlanMealSummaryModel meal;
  // "adapt" when the pantry covers the meal, otherwise "fallback".
  final String pantryDecision;

  const PlannedSlotModel({
    required this.plannedDate,
    required this.mealSlot,
    required this.meal,
    required this.pantryDecision,
  });

  bool get usesPantry => pantryDecision == 'adapt';

  factory PlannedSlotModel.fromJson(Map<String, dynamic> json) {
    return PlannedSlotModel(
      plannedDate: DateTime.parse(json['planned_date'] as String),
      mealSlot: json['meal_slot'] as String,
      meal: MealPlanMealSummaryModel.fromJson(
        json['meal'] as Map<String, dynamic>,
      ),
      pantryDecision: json['pantry_decision'] as String,
    );
  }

  PlannedSlotModel withMeal(AlternativeMealModel alternative) {
    return PlannedSlotModel(
      plannedDate: plannedDate,
      mealSlot: mealSlot,
      meal: alternative.meal,
      pantryDecision: alternative.pantryDecision,
    );
  }
}

// A meal the user can swap into a slot.
class AlternativeMealModel {
  final MealPlanMealSummaryModel meal;
  final String pantryDecision;

  const AlternativeMealModel({
    required this.meal,
    required this.pantryDecision,
  });

  factory AlternativeMealModel.fromJson(Map<String, dynamic> json) {
    return AlternativeMealModel(
      meal: MealPlanMealSummaryModel.fromJson(
        json['meal'] as Map<String, dynamic>,
      ),
      pantryDecision: json['pantry_decision'] as String,
    );
  }
}

// The unsaved weekly plan suggested by the backend.
class WeeklyPlanDraftModel {
  final DateTime startDate;
  final DateTime endDate;
  final double budgetPerMeal;
  final List<PlannedSlotModel> slots;
  final List<AlternativeMealModel> alternatives;

  const WeeklyPlanDraftModel({
    required this.startDate,
    required this.endDate,
    required this.budgetPerMeal,
    required this.slots,
    required this.alternatives,
  });

  factory WeeklyPlanDraftModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanDraftModel(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      budgetPerMeal: _parseDecimal(json['budget_per_meal'], 'budget_per_meal'),
      slots: (json['slots'] as List<dynamic>)
          .map((e) => PlannedSlotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      alternatives: (json['alternatives'] as List<dynamic>)
          .map((e) => AlternativeMealModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Totals are computed here so they stay correct after swaps.
  double get estimatedCostTotal =>
      slots.fold(0.0, (sum, slot) => sum + slot.meal.estimatedCost);

  double get budgetTotal => budgetPerMeal * slots.length;

  double get estimatedSavings => budgetTotal - estimatedCostTotal;

  // Groups slots by calendar day.
  Map<DateTime, List<PlannedSlotModel>> get slotsByDay {
    final map = <DateTime, List<PlannedSlotModel>>{};
    for (final slot in slots) {
      final day = DateTime(
        slot.plannedDate.year,
        slot.plannedDate.month,
        slot.plannedDate.day,
      );
      map.putIfAbsent(day, () => []).add(slot);
    }
    return map;
  }

  // Returns a copy with one slot's meal replaced.
  WeeklyPlanDraftModel withSwap(int index, AlternativeMealModel alternative) {
    final updated = [...slots];
    updated[index] = updated[index].withMeal(alternative);
    return WeeklyPlanDraftModel(
      startDate: startDate,
      endDate: endDate,
      budgetPerMeal: budgetPerMeal,
      slots: updated,
      alternatives: alternatives,
    );
  }
}