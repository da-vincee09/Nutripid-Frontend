import 'package:meal_recommendation_app/features/favorites/domain/entities/favorite.dart';

// Defines the contract for favorite-related operations in the domain layer.
abstract class FavoritesRepository {
  // Defines the method for adding a meal to the user's favorites.
  Future<Favorite> addFavorite(String mealId);

  // Defines the method for retrieving the user's favorite meals.
  Future<List<Favorite>> getFavorites();

  // Defines the method for removing a meal from the user's favorites.
  Future<void> removeFavorite(String mealId);
}