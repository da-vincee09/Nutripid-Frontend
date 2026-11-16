import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_create_request.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_model.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_update_request.dart';
import 'package:meal_recommendation_app/features/pantry/data/pantry_dependencies.dart';
import 'package:meal_recommendation_app/features/recommendations/presentation/providers/recommendation_provider.dart';

// Exposes PantryController and its asynchronous pantry item state.
final pantryControllerProvider =
    NotifierProvider<PantryController, AsyncValue<List<PantryItemModel>>>(
  PantryController.new,
);

// Manages pantry operations and updates the pantry state.
class PantryController extends Notifier<AsyncValue<List<PantryItemModel>>> {
  // Initializes the controller with an empty list without fetching data.
  @override
  AsyncValue<List<PantryItemModel>> build() {
    return const AsyncData([]);
  }

  // Retrieves all pantry items from the repository.
  Future<void> loadItems() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(pantryRepositoryProvider);
      final items = await repository.getPantryItems();
      state = AsyncData(items);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Creates a pantry item and refreshes meal recommendations.
  Future<bool> addItem(PantryItemCreateRequest request) async {
    final currentItems = state.value ?? [];

    try {
      final repository = ref.read(pantryRepositoryProvider);
      final newItem = await repository.createPantryItem(request);
      state = AsyncData([...currentItems, newItem]);

      // Refreshes recommendations because they depend on pantry contents.
      ref.read(recommendationControllerProvider.notifier).loadRecommendations();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  // Updates a pantry item and refreshes meal recommendations.
  Future<bool> updateItem(String id, PantryItemUpdateRequest request) async {
    final currentItems = state.value ?? [];

    try {
      final repository = ref.read(pantryRepositoryProvider);
      final updated = await repository.updatePantryItem(id, request);
      
      // Replaces the matching pantry item with the updated version.
      state = AsyncData([
        for (final item in currentItems)
          if (item.id == id) updated else item,
      ]);

      ref.read(recommendationControllerProvider.notifier).loadRecommendations();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  // Deletes a pantry item and refreshes meal recommendations.
  Future<bool> deleteItem(String id) async {
    final currentItems = state.value ?? [];

    try {
      final repository = ref.read(pantryRepositoryProvider);
      await repository.deletePantryItem(id);
      
      // Removes the deleted item from the local pantry list.
      state = AsyncData(
        currentItems.where((item) => item.id != id).toList(),
      );

      ref.read(recommendationControllerProvider.notifier).loadRecommendations();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}