import 'package:meal_recommendation_app/features/meals/data/models/meal_model.dart';
import 'package:meal_recommendation_app/features/nutrition/data/models/nutrition_adequacy_model.dart';

// Defines the contract for meal-related data operations.
abstract class MealRepository {
  // Retrieves all available meals.
  Future<List<MealModel>> getMeals();
  
  // Retrieves a specific meal using its ID.
  Future<MealModel> getMeal(String id);
  
  // Retrieves nutrition adequacy information for a specific meal.
  Future<NutritionAdequacyModel> getNutritionAdequacy(String mealId);
}