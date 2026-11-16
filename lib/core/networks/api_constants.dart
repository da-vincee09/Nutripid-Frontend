// Centralizes the backend URL and API endpoint paths.
class ApiConstants {
  // Private constructor prevents creating an ApiConstants object.
  ApiConstants._();

  // Base URL of the TipidMeal backend API.
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';  // https://tipidmeal-backend-1.onrender.com/api/v1 http://127.0.0.1:8000/api/v1

  // Profile endpoints.
  static const String profiles = '/profiles';
  static const String profileMe = '/profiles/me';

  // Pantry endpoint.
  static const String pantry = '/pantry';

  // Meal endpoints.
  static const String meals = '/meals';
  static String mealDetail(String id) => '/meals/$id';
  static String get mealUnits => '${ApiConstants.meals}/units';
  static String mealNutritionAdequacy(String id) => '/meals/$id/nutrition-adequacy';

  // Recommendation endpoint.
  static const String recommendations = '/recommendations';

  // Meal planner endpoints.
  static const String mealPlanner = '/meal-planner';
  static String mealPlanEntryDetail(String id) => '/meal-planner/$id';

  // Weekly Plan endpoints
  static const String weeklyPlanGenerate = '/weekly-plan/generate';
  static const String weeklyPlanAccept = '/weekly-plan/accept';

  // Grocery list endpoint.
  static const String groceryList = '/grocery-list';

  // Savings endpoint.
  static const String savingsSummary = '/savings/summary';

  // Favorite endpoints.
  static const String favorites = '/favorites';
  static String favoriteDetail(String mealId) => '/favorites/$mealId';
}