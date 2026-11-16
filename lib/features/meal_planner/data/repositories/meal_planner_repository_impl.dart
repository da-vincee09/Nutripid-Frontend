import 'package:meal_recommendation_app/features/meal_planner/data/datasources/meal_planner_remote_datasource.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_model.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_request.dart';
import 'package:meal_recommendation_app/features/meal_planner/domain/repositories/meal_planner_repository.dart';

// Connects the domain repository contract to the remote data source.
class MealPlannerRepositoryImpl implements MealPlannerRepository {
  // Handles the actual communication with the backend API.
  final MealPlannerRemoteDatasource datasource;

  // Receives the remote data source through dependency injection.
  MealPlannerRepositoryImpl({required this.datasource});

  // Sends a request to create a new meal plan entry.
  @override
  Future<MealPlanEntryModel> createMealPlanEntry(MealPlanEntryCreateRequest request) {
    return datasource.createMealPlanEntry(request);
  }

  // Retrieves meal plan entries within the specified date range.
  @override
  Future<WeeklyPlanModel> getMealPlan({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return datasource.getMealPlan(startDate: startDate, endDate: endDate);
  }

  // Retrieves a specific meal plan entry using its ID.
  @override
  Future<MealPlanEntryModel> getMealPlanEntry(String id) {
    return datasource.getMealPlanEntry(id);
  }

  // Sends a request to update an existing meal plan entry.
  @override
  Future<MealPlanEntryModel> updateMealPlanEntry(String id, MealPlanEntryUpdateRequest request) {
    return datasource.updateMealPlanEntry(id, request);
  }

  // Sends a request to delete a meal plan entry using its ID.
  @override
  Future<void> deleteMealPlanEntry(String id) {
    return datasource.deleteMealPlanEntry(id);
  }
}