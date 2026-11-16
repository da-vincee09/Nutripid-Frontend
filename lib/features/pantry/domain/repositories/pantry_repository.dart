import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_create_request.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_model.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_update_request.dart';

// Defines the required operations for accessing pantry data.
abstract class PantryRepository {
  // Defines the operation for creating a pantry item.
  Future<PantryItemModel> createPantryItem(PantryItemCreateRequest request);
  
  // Defines the operation for retrieving all pantry items.
  Future<List<PantryItemModel>> getPantryItems();
  
  // Defines the operation for retrieving a specific pantry item by ID.
  Future<PantryItemModel> getPantryItem(String id);
  
  // Defines the operation for updating an existing pantry item.
  Future<PantryItemModel> updatePantryItem(
    String id,
    PantryItemUpdateRequest request,
  );

  // Defines the operation for deleting a pantry item by ID.
  Future<void> deletePantryItem(String id);
}