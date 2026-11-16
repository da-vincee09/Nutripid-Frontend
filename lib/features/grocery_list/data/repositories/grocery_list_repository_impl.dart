import 'package:meal_recommendation_app/features/grocery_list/data/datasources/grocery_list_remote_datasource.dart';
import 'package:meal_recommendation_app/features/grocery_list/data/models/grocery_list_model.dart';
import 'package:meal_recommendation_app/features/grocery_list/domain/repositories/grocery_list_repository.dart';

// Implements the grocery list repository and connects the domain layer to the remote datasource.
class GroceryListRepositoryImpl implements GroceryListRepository {
  final GroceryListRemoteDatasource datasource;

  // Receives the remote datasource through dependency injection.
  GroceryListRepositoryImpl({required this.datasource});

  // Retrieves the grocery list and forwards the optional date filters to the datasource.
  @override
  Future<GroceryListResponseModel> getGroceryList({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return datasource.getGroceryList(startDate: startDate, endDate: endDate);
  }
}