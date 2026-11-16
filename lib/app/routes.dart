// Centralizes all route addresses used for navigation.
// Static constants prevent repeating route strings throughout the app.
// Dynamic routes, such as mealDetail, accept an ID to identify a specific meal.
// abstract means the class is not intended to be created as an object or instance.
abstract final class AppRoutes {
  static const splash = "/";
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const profileSetup = '/profile-setup';
  static const profile = '/profile';
  static const pantry = '/pantry';
  static const meals = '/meals';
  static const recommendations = '/recommendations';
  static const mealPlanner = '/meal-planner';
  static const weeklyPlanner = '/meal-planner/weekly-plan';
  static const groceryList =  '/grocery-list';
  static const favorites = '/favorites';
  static String mealDetail(String id) => '/meal-detail/$id';
  static const settings = '/settings';
  static const savings = '/meal-planner/savings';
}