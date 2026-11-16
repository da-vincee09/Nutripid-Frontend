import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_model.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_request.dart';

// Defines the contract for all Meal Planner data operations.
abstract class MealPlannerRepository {
  // Defines the operation for creating a new meal plan entry.
  Future<MealPlanEntryModel> createMealPlanEntry(MealPlanEntryCreateRequest request);
  
  // Defines the operation for retrieving a weekly meal plan by date range.
  Future<WeeklyPlanModel> getMealPlan({required DateTime startDate, required DateTime endDate});
  
  // Defines the operation for retrieving one meal plan entry by its ID.
  Future<MealPlanEntryModel> getMealPlanEntry(String id);
  
  // Defines the operation for updating an existing meal plan entry.
  Future<MealPlanEntryModel> updateMealPlanEntry(String id, MealPlanEntryUpdateRequest request);
  
  // Defines the operation for deleting a meal plan entry by its ID.
  Future<void> deleteMealPlanEntry(String id);
}