import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meal_recommendation_app/features/meals/data/meal_dependencies.dart';
import 'package:meal_recommendation_app/features/meals/data/models/meal_model.dart';
import 'package:meal_recommendation_app/features/nutrition/data/models/nutrition_adequacy_model.dart';

// Exposes MealController and its asynchronous list of meals.
final mealControllerProvider =
    NotifierProvider<MealController, AsyncValue<List<MealModel>>>(
  MealController.new,
);

// Manages the loading and state of the meal list.
class MealController extends Notifier<AsyncValue<List<MealModel>>> {
  @override
  AsyncValue<List<MealModel>> build() {
    // Starts with an empty list; meals are loaded when loadMeals() is called.
    return const AsyncData([]);
  }

  // Retrieves all meals and updates the provider state.
  Future<void> loadMeals() async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(mealRepositoryProvider);
      final meals = await repository.getMeals();
      state = AsyncData(meals);
    } catch (e, st) {
      // Stores the error and stack trace if loading fails.
      state = AsyncError(e, st);
    }
  }
}

// Retrieves one meal by ID.
// The family modifier allows different meal IDs to have separate provider instances.
final mealDetailProvider =
    FutureProvider.family<MealModel, String>((ref, id) async {
  final repository = ref.read(mealRepositoryProvider);
  return repository.getMeal(id);
});

// Retrieves nutrition adequacy for a specific meal.
// Kept separate so nutrition can load or fail independently of meal details.
final mealNutritionAdequacyProvider =
    FutureProvider.family<NutritionAdequacyModel, String>((ref, mealId) async {
  final repository = ref.read(mealRepositoryProvider);
  return repository.getNutritionAdequacy(mealId);
});

// Stores the search text entered by the user on the Meals screen.
final mealSearchQueryProvider = StateProvider<String>((ref) => '');

// Filters meals based on the search query.
// Matches both meal names and ingredient names.
final filteredMealsProvider = Provider<List<MealModel>>((ref) {
  final query = ref.watch(mealSearchQueryProvider).toLowerCase().trim();
  final mealsState = ref.watch(mealControllerProvider);

  // Gets the available meal list, or an empty list if no data is available.
  final meals = mealsState.value ?? [];

  // Returns all meals when the search field is empty.
  if (query.isEmpty) return meals;

  // Keeps meals whose names or ingredient names contain the search text.
  return meals.where((meal) {
    final nameMatch = meal.name.toLowerCase().contains(query);
    final ingredientMatch = meal.ingredients
        .any((i) => i.ingredient.toLowerCase().contains(query));
    return nameMatch || ingredientMatch;
  }).toList();
});