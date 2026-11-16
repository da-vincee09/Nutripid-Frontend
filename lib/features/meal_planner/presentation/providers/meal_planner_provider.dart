import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/meal_planner_dependencies.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_model.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_request.dart';

// Provides the MealPlanController and its asynchronous weekly plan state.
final mealPlanControllerProvider =
    NotifierProvider<MealPlanController, AsyncValue<WeeklyPlanModel?>>(
  MealPlanController.new,
);

// Manages meal plan operations and keeps the weekly plan state updated.
class MealPlanController extends Notifier<AsyncValue<WeeklyPlanModel?>> {
  // Stores the date range of the currently displayed week for later reloads.
  DateTime? _lastStartDate;
  DateTime? _lastEndDate;

  // Sets the initial state to indicate that no weekly plan has been loaded yet.
  @override
  AsyncValue<WeeklyPlanModel?> build() {
    return const AsyncData(null);
  }

  // Loads a week and displays a loading state while waiting for the API response.
  Future<void> loadWeek({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _lastStartDate = startDate;
    _lastEndDate = endDate;
    state = const AsyncLoading();
    try {
      final repository = ref.read(mealPlannerRepositoryProvider);
      final plan = await repository.getMealPlan(
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncData(plan);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Reloads the current week without clearing the existing data or showing a loading spinner.
  Future<void> _silentReloadCurrentWeek() async {
    if (_lastStartDate == null || _lastEndDate == null) return;
    try {
      final repository = ref.read(mealPlannerRepositoryProvider);
      final plan = await repository.getMealPlan(
        startDate: _lastStartDate!,
        endDate: _lastEndDate!,
      );
      state = AsyncData(plan);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Creates a meal plan entry, then reloads the current week to get updated server data.
  Future<void> addEntry(MealPlanEntryCreateRequest request) async {
    final repository = ref.read(mealPlannerRepositoryProvider);
    await repository.createMealPlanEntry(request);
    await _silentReloadCurrentWeek();
  }

  // Updates a meal plan entry, then reloads the current week to reflect the server response.
  Future<void> updateEntry(String id, MealPlanEntryUpdateRequest request) async {
    final repository = ref.read(mealPlannerRepositoryProvider);
    await repository.updateMealPlanEntry(id, request);
    await _silentReloadCurrentWeek();
  }

  // Removes an entry from the UI immediately and restores it if the server deletion fails.
  Future<void> removeEntry(String id) async {
    final previousState = state;
    final currentPlan = state.value;

    if (currentPlan != null) {
      MealPlanEntryModel? removed;
      final remainingEntries = <MealPlanEntryModel>[];
      for (final entry in currentPlan.entries) {
        if (entry.id == id) {
          removed = entry;
        } else {
          remainingEntries.add(entry);
        }
      }

      // Adjusts the total estimated cost if the entry was found.
      final adjustedTotal = removed == null
          ? currentPlan.estimatedCostTotal
          : currentPlan.estimatedCostTotal - removed.meal.estimatedCost;

      // Updates the UI immediately using the remaining entries.
      state = AsyncData(
        WeeklyPlanModel(
          startDate: currentPlan.startDate,
          endDate: currentPlan.endDate,
          entries: remainingEntries,
          estimatedCostTotal: adjustedTotal,
        ),
      );
    }

    try {
      final repository = ref.read(mealPlannerRepositoryProvider);
      await repository.deleteMealPlanEntry(id);
    } catch (e) {
      // Restores the previous state if the deletion fails.
      state = previousState;
      rethrow;
    }
  }
}