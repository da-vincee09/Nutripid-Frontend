import 'package:meal_recommendation_app/features/grocery_list/data/models/grocery_list_model.dart';

// Defines the contract for retrieving grocery list information.
abstract class GroceryListRepository {
  // Retrieves the grocery list with optional start and end date filters.
  Future<GroceryListResponseModel> getGroceryList({
    DateTime? startDate,
    DateTime? endDate,
  });
}