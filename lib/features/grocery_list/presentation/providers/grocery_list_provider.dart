import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/grocery_list/data/grocery_list_dependencies.dart';
import 'package:meal_recommendation_app/features/grocery_list/data/models/grocery_list_model.dart';

// Provides access to the grocery list controller and its asynchronous state.
final groceryListControllerProvider = NotifierProvider<GroceryListController,
    AsyncValue<GroceryListResponseModel?>>(
  GroceryListController.new,
);

// Manages grocery list retrieval and updates the state based on the result.
class GroceryListController
    extends Notifier<AsyncValue<GroceryListResponseModel?>> {
  @override
  // Initializes the controller with no grocery list loaded.
  AsyncValue<GroceryListResponseModel?> build() {
    return const AsyncData(null);
  }

  // Loads the grocery list using optional start and end dates.
  // If both dates are omitted, the backend uses its default current week.
  Future<void> loadGroceryList({DateTime? startDate, DateTime? endDate}) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(groceryListRepositoryProvider);
      final list = await repository.getGroceryList(
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncData(list);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}