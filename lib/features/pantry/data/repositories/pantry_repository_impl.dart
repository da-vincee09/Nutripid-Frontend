import 'package:meal_recommendation_app/features/pantry/data/datasources/pantry_remote_datasource.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_create_request.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_model.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_update_request.dart';
import 'package:meal_recommendation_app/features/pantry/domain/repositories/pantry_repository.dart';

// Implements the pantry repository contract and connects it to the remote datasource.
class PantryRepositoryImpl implements PantryRepository {
  // Holds the datasource responsible for communicating with the backend.
  final PantryRemoteDatasource datasource;

  // Receives the datasource through dependency injection.
  PantryRepositoryImpl({required this.datasource});

  // Delegates the creation of a pantry item to the datasource.
  @override
  Future<PantryItemModel> createPantryItem(PantryItemCreateRequest request) {
    return datasource.createPantryItem(request);
  }

  // Delegates the retrieval of all pantry items to the datasource.
  @override
  Future<List<PantryItemModel>> getPantryItems() {
    return datasource.getPantryItems();
  }

  // Delegates the retrieval of a specific pantry item using its ID.
  @override
  Future<PantryItemModel> getPantryItem(String id) {
    return datasource.getPantryItem(id);
  }

  // Delegates the updating of a pantry item to the datasource.
  @override
  Future<PantryItemModel> updatePantryItem(
    String id,
    PantryItemUpdateRequest request,
  ) {
    return datasource.updatePantryItem(id, request);
  }

  // Delegates the deletion of a pantry item using its ID.
  @override
  Future<void> deletePantryItem(String id) {
    return datasource.deletePantryItem(id);
  }
}