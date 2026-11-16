import 'package:meal_recommendation_app/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:meal_recommendation_app/features/favorites/domain/entities/favorite.dart';
import 'package:meal_recommendation_app/features/favorites/domain/repositories/favorites_repository.dart';

// Implements the favorites repository and connects the domain layer to the remote data source.
class FavoritesRepositoryImpl implements FavoritesRepository {
  // Holds the remote data source responsible for communicating with the backend.
  final FavoritesRemoteDatasource datasource;

  // Receives the remote data source through dependency injection.
  FavoritesRepositoryImpl({required this.datasource});

  // Adds a meal to the user's favorites.
  @override
  Future<Favorite> addFavorite(String mealId) {
    return datasource.addFavorite(mealId);
  }

  // Retrieves the user's list of favorite meals.
  @override
  Future<List<Favorite>> getFavorites() {
    return datasource.getFavorites();
  }

  // Removes a meal from the user's favorites.
  @override
  Future<void> removeFavorite(String mealId) {
    return datasource.removeFavorite(mealId);
  }
}