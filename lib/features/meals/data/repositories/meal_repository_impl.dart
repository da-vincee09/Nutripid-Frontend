import 'package:meal_recommendation_app/features/meals/data/datasources/meals_remote_datasource.dart';
import 'package:meal_recommendation_app/features/meals/data/models/meal_model.dart';
import 'package:meal_recommendation_app/features/meals/domain/repository/meal_repository.dart';
import 'package:meal_recommendation_app/features/nutrition/data/models/nutrition_adequacy_model.dart';

// Implements the meal repository contract and connects it to the remote datasource.
class MealRepositoryImpl implements MealRepository {
  final MealsRemoteDatasource datasource;

  // Receives the datasource through dependency injection.
  MealRepositoryImpl({required this.datasource});

  // Retrieves the list of meals from the datasource.
  @override
  Future<List<MealModel>> getMeals() {
    return datasource.getMeals();
  }

  // Retrieves a specific meal using its ID.
  @override
  Future<MealModel> getMeal(String id) {
    return datasource.getMeal(id);
  }

  // Retrieves nutrition adequacy information for a specific meal.
  @override
  Future<NutritionAdequacyModel> getNutritionAdequacy(String mealId) {
    return datasource.getNutritionAdequacy(mealId);
  }
}