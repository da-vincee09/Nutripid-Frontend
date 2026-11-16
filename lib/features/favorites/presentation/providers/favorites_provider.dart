import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/favorites/data/favorites_dependencies.dart';
import 'package:meal_recommendation_app/features/favorites/domain/entities/favorite.dart';

// Provides the favorites controller and exposes the asynchronous favorites list state.
final favoritesControllerProvider =
    NotifierProvider<FavoritesController, AsyncValue<List<Favorite>>>(
  FavoritesController.new,
);

// Handles favorite operations and manages the favorites list state.
class FavoritesController extends Notifier<AsyncValue<List<Favorite>>> {
  // Initializes the favorites list with an empty list.
  @override
  AsyncValue<List<Favorite>> build() => const AsyncData([]);

  // Retrieves the user's favorite meals from the repository.
  Future<void> loadFavorites() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(favoritesRepositoryProvider);
      final favorites = await repository.getFavorites();
      state = AsyncData(favorites);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Checks whether a specific meal is already in the favorites list.
  bool isFavorite(String mealId) {
    return state.value?.any((f) => f.meal.id == mealId) ?? false;
  }

  // Optimistically adds a meal to the list before confirming with the server.
  // Restores the previous state if the request fails.
  Future<void> addFavorite({
    required String mealId,
    required String mealName,
    required double estimatedCost,
    String? imageUrl,
  }) async {
    final previousState = state;
    final current = state.value ?? [];

    if (current.any((f) => f.meal.id == mealId)) return;

    // Creates a temporary favorite entry using the meal's available details.
    final optimisticEntry = Favorite(
      id: 'optimistic-$mealId',
      meal: FavoriteMealSummary(
        id: mealId,
        name: mealName,
        estimatedCost: estimatedCost,
        imageUrl: imageUrl,
      ),
      createdAt: DateTime.now(),
    );

    // Immediately updates the UI before waiting for the server response.
    state = AsyncData([optimisticEntry, ...current]);

    try {
      final repository = ref.read(favoritesRepositoryProvider);
      final confirmed = await repository.addFavorite(mealId);

      // Replaces the temporary entry with the confirmed server response.
      final updated = (state.value ?? [])
          .map((f) => f.id == optimisticEntry.id ? confirmed : f)
          .toList();
      state = AsyncData(updated);
    } catch (e) {
      // Rolls back the favorites list if the request fails.
      state = previousState;
      rethrow;
    }
  }

  // Removes a meal from the list immediately and synchronizes the change with the server.
  Future<void> removeFavorite(String mealId) async {
    final previousState = state;
    final current = state.value ?? [];

    // Immediately removes the selected meal from the displayed favorites list.
    state = AsyncData(current.where((f) => f.meal.id != mealId).toList());

    try {
      final repository = ref.read(favoritesRepositoryProvider);
      await repository.removeFavorite(mealId);
    } catch (e) {
      // Restores the previous favorites list if removal fails.
      state = previousState;
      rethrow;
    }
  }
}