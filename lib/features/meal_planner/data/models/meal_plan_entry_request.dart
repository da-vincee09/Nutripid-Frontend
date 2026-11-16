import 'package:meal_recommendation_app/core/utils/date_utils.dart';

// Holds the information required when creating a new meal plan entry.
class MealPlanEntryCreateRequest {
  final String mealId;
  final DateTime plannedDate;
  final String? mealSlot;

  const MealPlanEntryCreateRequest({
    required this.mealId,
    required this.plannedDate,
    this.mealSlot,
  });

  // Converts the creation request into JSON format for the API.
  Map<String, dynamic> toJson() {
    return {
      'meal_id': mealId,
      'planned_date': formatDate(plannedDate),
      'meal_slot': mealSlot,
    };
  }
}

// Holds the optional information that can be changed in an existing meal plan entry.
class MealPlanEntryUpdateRequest {
  final DateTime? plannedDate;
  final String? mealSlot;

  const MealPlanEntryUpdateRequest({
    this.plannedDate,
    this.mealSlot,
  });

  // Converts the update request into JSON format.
  Map<String, dynamic> toJson() {
    return {
      if (plannedDate != null) 'planned_date': formatDate(plannedDate!),
      'meal_slot': mealSlot,
    };
  }
}